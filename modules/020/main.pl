#!/usr/bin/perl

use warnings;
use strict;

use lib '../../library';
use System;
use CliPrint;

my $arch = System::arch();

if ( $arch ne '32bit' ) {
	CliPrint::printGreen("You are not running a 32bit system. Skype installation will also install various 32bit libraries on your system\n", 1);
	CliPrint::printGreen("Although this is not dangerous for your system, it is generally frowned upon\n", 1);
	CliPrint::printGreen("If you know what you're doing, or if you just can't live without skype, proceed\n", 1);
	CliPrint::printGreen("Do you want to continue? [y/n]: ");
	chomp( my $dec = <STDIN> );
	if ( $dec eq 'n' ) {
		exit(0);
	}
}

chdir("/tmp/");

System::call({
	title 		=> 'Downloading skype rpm...',
	command 	=> "wget http://www.skype.com/go/getskype-linux-beta-fc10 --trust-server-names",
	delay 		=> 3,
	exitFail 	=> 1,
});

System::call({
	title 		=> 'Installing skype...',
	command 	=> "sudo yum localinstall skype-*.rpm",
	delay 		=> 3,
	exitFail 	=> 1,
});

System::call({
	title 		=> 'Removing rpm file...',
	command 	=> "rm -f skype-*.rpm",
	delay 		=> 3,
	exitFail 	=> 1,
});

CliPrint::printGreen("Skype installed successfully... :)\n", 1);

exit(0);