#!/usr/bin/perl

use warnings;
use strict;

use lib '../../library';
use System;
use CliPrint;

&command('sudo yum install vlc -y');

System::call({
	title 		=> 'Installing vlc...',
	command 	=> "sudo yum install vlc -y",
	delay 		=> 3,
	exitFail 	=> 1,
});

CliPrint::printGreen("Everything went fine...:)\n", 1);

exit(0);