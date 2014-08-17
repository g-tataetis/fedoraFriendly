package CliPrint;

use Exporter;
use strict;
use warnings;
use vars qw($VERSION @ISA @EXPORT);
use Term::ANSIColor;

$VERSION	= 1.01;
@ISA		= qw(Exporter);
@EXPORT		= qw(
				);

our $path;
our $pathFh;

#===================================================================================================================================================

sub printGreen{

	my $string = shift;
	my $wait = shift;
	print color 'bold green';
	print $string;
	print color 'reset';
	if ( defined $wait && $wait > 0 ){
		sleep($wait);
	}
	return 1;
}

sub printRed{

	my $string = shift;
	my $wait = shift;
	print color 'bold red';
	print $string;
	print color 'reset';
	sleep($wait) if ( length($wait) > 0 && $wait > 0 );
	return 1;
}

sub dieRed{

	my $string = shift;
	my $wait = shift;
	print color 'bold red';
	print $string;
	print color 'reset';
	sleep($wait) if ( length($wait) > 0 && $wait > 0 );
	exit(0);
}

1;