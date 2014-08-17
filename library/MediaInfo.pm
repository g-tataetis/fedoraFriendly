package MediaInfo;

use Exporter;
use strict;
use warnings;
use vars qw($VERSION @ISA @EXPORT);

$VERSION	= 1.01;
@ISA		= qw(Exporter);
@EXPORT		= qw(
				);

#===================================================================================================================================================

sub width{

	my $filename = shift;

	my @output = `mediainfo \"$filename\" 2>&1`;

	my $width = 0;

	foreach my $line (@output) {
		if ( $line =~ /^Width\s+\:\s+(.*)pixels.*$/ ) {
			my $widthRaw = $1;
			$widthRaw =~ s/ //g;
			$width = $widthRaw * 1;
		}
	}

	return $width;
}

sub height{

	my $filename = shift;

	my @output = `mediainfo \"$filename\" 2>&1`;

	my $height = 0;

	foreach my $line (@output) {
		if ( $line =~ /^Height\s+\:\s+(.*)pixels.*$/ ) {
			my $heightRaw = $1;
			$heightRaw =~ s/ //g;
			$height = $heightRaw * 1;
		}
	}

	return $height;
}

1;