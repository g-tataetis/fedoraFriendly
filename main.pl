#!/usr/bin/perl

use warnings;
use strict;
use Term::ANSIColor;

use lib './library';
use System;
use CliPrint;

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

while ( 1 == 1 ) {
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

	exit(0) if ( $run =~ /exit/ );

	if ( $run =~ /^desc\s+(\d+).*/ ) {

		my $toDesc = $1;
		my $dir = "modules/" . $dirlist->[$toDesc];
		chdir($dir);
		open my $fh, '<', 'desc';
		my @conts = <$fh>;
		close $fh;
		foreach my $line ( @conts ) {
			if ( $line =~ /^desc:\s+(.*)/ ) {
				my $description = $1;
				chomp($description);
				CliPrint::printGreen("\n$description\n\n", 2);
			}
		}
		chdir("../..");

	} elsif ( $run =~ /^\d+\,\d+.*/ || $run =~ /^\d+\,\s+\d+.*/ || $run =~ /^\d+\s+\d+.*/ ) {

		$run =~ s/\D+/, /g;
		my @runCommands = split( ', ', $run );
		foreach my $command ( @runCommands ) {
			my $dir = "modules/" . $dirlist->[$command];
			chdir($dir);
			system('perl main.pl');
			chdir("../..");
		}

	} elsif ( $run =~ /^\d+$/ ) {

		my $dir = "modules/" . $dirlist->[$run];
		chdir($dir);
		system('perl main.pl');
		chdir("../..");

	} else {

		CliPrint::printRed("\nUnknown command\n\n", 1);

	}

}