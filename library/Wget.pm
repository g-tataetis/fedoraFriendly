package Wget;

use Exporter;
#use Logger;
#use Data::Dumper;
use strict;
use warnings;
use vars qw($VERSION @ISA @EXPORT);

$VERSION	= 1.01;
@ISA		= qw(Exporter);
@EXPORT		= qw(
				);

our @proHeaders = ();
Wget::createRamEnvironment();

#===================================================================================================================================================

sub createRamEnvironment{

	unless ( -d "/tmp/perl-wget" ) {
		mkdir("/tmp/perl-wget/") or logQuery ( 0, "1: ", $! );
	}
}

sub formWgetHeaders{

	my $hashRef = shift;

	logQuery( 0, "1: ", ref($hashRef) ) if ( ref($hashRef) ne 'HASH' );

	my @headers1 = ();

	if ( $hashRef->{'--user-agent'} ) {
		push @headers1, "--user-agent='" . $hashRef->{'--user-agent'} . "'";
	}
	if ( $hashRef->{'--cookies'} ) {
		if ( $hashRef->{'--cookies'} eq 'on' ) {
			push @headers1, "--cookies=on";
		} else {
			push @headers1, "--cookies=off";
		}
	}
	if ( $hashRef->{'--referer'} ) {
		push @headers1, "--referer='" . $hashRef->{'--referer'} . "'";
	}
	if ( $hashRef->{'--keep-session-cookies'} ) {
		push @headers1, "--keep-session-cookies";
	}
	if ( $hashRef->{'--save-cookies'} ) {
		my $cookiesFile = "/tmp/" . $0 . ".txt";
		push @headers1, "--save-cookies='$cookiesFile'";
	}
	if ( $hashRef->{'--load-cookies'} ) {
		my $cookiesFile = "/tmp/" . $0 . ".txt";
		push @headers1, "--load-cookies='$cookiesFile'";
	}
	if ( $hashRef->{'--headers'} ) {
		# foreach my $header (@{$hashRef->{'--headers'}}) {
		# 	push @headers1, ${$hashRef->{'--headers'}}[$header];
		# }
		for ( my $i=0 ; $i<scalar(@{$hashRef->{'--headers'}}) ; $i++ ) {
			push @headers1, "--header='" . ${$hashRef->{'--headers'}}[$i] . "'";
		}
	}

	@proHeaders = ();

	@proHeaders = @headers1;

	return 1;
}

sub returnWgetString{

	my $link = shift;

	my $timestamp = time();

	our $filename = "/tmp/perl-wget" . "/$timestamp";

	my $string = "wget -q " . join(' ', @proHeaders) . " \"$link\" -O $filename";

	logQuery ( 1, "1: ", $string );

	return $string;
}

sub checkServerStatus{

	my $filename = shift;

	open my $filehandle, '<', $filename; # or logQuery ( 0, "1:", $!, $? );
	my @fileConts = <$filehandle>;
	close $filehandle; # or logQuery ( 0, "2:", $!, $? );

	my $status = 0;

	foreach my $line ( @fileConts ) {
		if ( $line =~ /^\s+HTTP\/1\.1 200 OK.*$/ ) {
			$status = 1;
			last;
		}
	}

	return $status;
}

sub checkFileSize{

	my $filename = shift;

	open my $filehandle, '<', $filename; # or logQuery ( 0, "1:", $!, $? );
	my @fileConts = <$filehandle>;
	close $filehandle; # or logQuery ( 0, "2:", $!, $? );

	my $serverSize = 0;

	foreach my $line ( @fileConts ) {
		if ( $line =~ /^\s+Content-Length: (\d+).*$/ ) {
			$serverSize = $1;
			last;
		}
	}

	my $fileSize = -s $filename;

	if ( $fileSize >= $serverSize ) {
		return 1;
	} else {
		return 0;
	}
}

sub fetch{

	my $link = shift;

	my @fileConts = ();

	my $timestamp = time();

	my $filename = "/tmp/perl-wget" . "/$timestamp";

	my $string = "wget -q -S -O- " . join(' ', @proHeaders) . " \"$link\" > $filename 2>&1";

	my $retries = 0;

	my $status = 0;

	my $sizeStatus = 0;

	do {

		$retries++;

		my $receipt = system($string);

#		logQuery ( 0, "1:", $?, $! ) if ( $receipt != 0 );

		$status = Wget::checkServerStatus($filename);

		$sizeStatus = Wget::checkFileSize($filename);

	} while ( ( $status == 0 || $sizeStatus == 0 ) && $retries < 10 );

	# if ( $status == 0 ) {
	# 	logQuery ( 0, "2: ", $status, $link, $filename );
	# }

	# if ( $sizeStatus == 0 ) {
	# 	logQuery ( 0, "3: ", $sizeStatus, $link, $filename );
	# }

	open my $filehandle, '<', $filename; # or logQuery ( 0, "4:", $!, $? );
	@fileConts = <$filehandle>;
	close $filehandle; # or logQuery ( 0, "5:", $!, $? );

	return \@fileConts;
}

1;