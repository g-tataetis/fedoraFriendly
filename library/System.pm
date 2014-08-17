package System;

use Exporter;
use strict;
use vars qw($VERSION @ISA @EXPORT);
use Term::ANSIColor;

$VERSION	= 1.01;
@ISA		= qw(Exporter);
@EXPORT		= qw(
				);

#===================================================================================================================================================

sub call{

	my ($args) = @_;

	if ( $args->{title} ) {
		print color 'bold green';
		print $args->{title} . "\n";
		print color 'reset';
		sleep(1);
	}

	if ( $args->{delay} && $args->{delay} > 0 ) {
		print color 'bold green';
		print "About to execute:\n";
		print color 'bold yellow';
		print "\t" . $args->{command} . "\n";
		print color 'reset';
		sleep ( $args->{delay} );
	}

	my $outcome = system($args->{command});

	if ( $outcome == 0 ) {
		return 1;
	}

	if ( $outcome != 0 ) {
		print color 'bold red';
		if ( $args->{errorMsg} ) {
			print $args->{errorMsg} . "\n";
		} else {
			print "Oops! Something went wrong...\n";
		}
		print "\tError Code: $outcome\n";
		print "\tError string: $?\n";
		print color 'reset';

		if ( $args->{exitFail} && $args->{exitFail} == 1 ) {
			print color 'bold red';
			print "Aborting...\n";
			print color 'reset';
			exit(0);
		} else {
			return 0;
		}
	}
}

sub backticks{

	my ($args) = @_;

	if ( $args->{title} ) {
		print color 'bold green';
		print $args->{title} . "\n";
		print color 'reset';
		sleep(1);
	}

	if ( $args->{delay} && $args->{delay} > 0 ) {
		print color 'bold green';
		print "About to execute:\n";
		print color 'bold yellow';
		print "\t" . $args->{command} . "\n";
		print color 'reset';
		sleep ( $args->{delay} );
	}

	my $command = $args->{command};
	my $outcome = `$command`;
	chomp($outcome);

	return $outcome;
}

sub arch{

	my $output = `uname -m`;

	chomp ($output);

	if ( $output eq "x86_64" ) {
		return "64bit";
	} else {
		return "32bit";
	}
}

sub getPid{

	my $processName = shift;

	return 0 if ( length($processName) <= 0 );

	my @output = `ps aux | grep $processName`;

	return 0 if ( scalar(@output) < 2 );

	my $pid;

	if ( $output[0] =~ /^\w+\s+(\d+)\s+.*$/ ) {
		$pid = $1;
	}

	return $pid;
}

sub whoami{

	my $output = `whoami`;

	chomp($output);

	return $output;
}

sub which{

	my $exec = shift;

	my $outcome = `which $exec 2>&1`;
	chomp($outcome);
	if ( $outcome =~ /^.*which: no.*$/ ) {
		return "none";
	} else {
		return $outcome;
	}
}

sub checkIfServiceRuns{

	my $service = shift;
	my $flag = 0;
	my @output = `sudo service $service status 2>&1`;
	foreach my $line ( @output ) {
		if ( $line =~ /^.*Active: active \(running\).*$/ ) {
			$flag = 1;
		}
	}
	return $flag;
}

1;