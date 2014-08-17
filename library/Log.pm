package Log;

use Exporter;
use strict;
use warnings;
use POSIX qw(strftime);
use vars qw($VERSION @ISA @EXPORT);

$VERSION	= 1.01;
@ISA		= qw(Exporter);
@EXPORT		= qw(
				);

our $path;
our $pathFh;

#===================================================================================================================================================

END{

	close $pathFh;
}

sub filePath{

	$Log::path = shift;

	open $Log::pathFh, '>>', $path;

	return 1;
}

sub Die{

	my $string = shift;
	my $logDate = strftime("%Y-%m-%d %H:%M:%S", localtime);

	print $Log::pathFh "$logDate, 1, $string\n";

	exit(1);
}

sub Status{

	my $string = shift;
	my $logDate = strftime("%Y-%m-%d %H:%M:%S", localtime);

	print $Log::pathFh "$logDate, 0, $string\n";

	return 1;
}

1;