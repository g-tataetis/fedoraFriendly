package File;

use Exporter;
use strict;
use vars qw($VERSION @ISA @EXPORT);
use Term::ANSIColor;

$VERSION	= 1.01;
@ISA		= qw(Exporter);
@EXPORT		= qw(
				);

#===================================================================================================================================================

sub dieRed{

	my $string = shift;
	my $wait = shift;
	print color 'bold red';
	print $string;
	print color 'reset';
	sleep($wait) if ( length($wait) > 0 && $wait > 0 );
	exit(0);
}

sub appendLine{

	my ($args) = @_;

	my $file = $args->{file};
	my $line = $args->{line};

	open my $fh, '>>', $file or dieRed("$file could not be accessed! $!\n", 1);
	print $fh $line;
	close $fh or dieRed("$file could not be closed! $!\n", 1);

	return 1;
}

sub appendContent{

	my ($args) = @_;

	my $file = $args->{file};
	my $conts = $args->{content};

	open my $fh, '>', $file or dieRed("$file could not be accessed! $!\n", 1);
	print $fh @{$conts};
	close $fh or dieRed("$file could not be closed! $!\n", 1);

	return 1;
}

1;