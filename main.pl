#!/usr/bin/perl

use warnings;
use strict;
use Term::ANSIColor;

sub getCurrentModules{

	chdir("modules/");

	my @list = <*>;

	my @dirlist = ();

	foreach my $element (@list) {
		if ( -d $element && $element =~ /^\d+$/ ) {
			push @dirlist, $element;
		}
	}

	chdir("..");

	return \@dirlist;
}

#=========================================================================

my $dirlist = &getCurrentModules();
MODULES: for ( my $i=0 ; $i<scalar(@{$dirlist}) ; $i++ ) {
	chdir("modules/");
	chdir($dirlist->[$i]);
	if ( !-e 'desc' ) {
		chdir('..');
		next MODULES;
	}
	open my $descFh, '<', 'desc';
	my @descLines = <$descFh>;
	close($descFh);
	my $title;
	foreach my $line (@descLines) {
		if ( $line =~ /^title:\s(.*)$/ ) {
			$title = $1;
			chomp($title);
		}
	}
	print color 'bold green';
	printf("[%2d]\t%s\n", $i, $title);
	print color 'reset';
	chdir('../..');
}

print color 'bold red';
print 'RUN:> ';
print color 'reset';

my $run = <STDIN>;
chomp($run);

my $dir = "modules/" . $dirlist->[$run];
chdir($dir);
system('perl main.pl');