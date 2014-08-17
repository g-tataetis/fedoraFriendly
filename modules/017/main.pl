#!/usr/bin/perl

use warnings;
use strict;

use lib '../../library';
use System;
use CliPrint;

System::call({
	title 		=> 'Removing parole media player...',
	command 	=> "sudo yum remove parole -y",
	delay 		=> 3,
	exitFail 	=> 1,
});

System::call({
	title 		=> "Removing unnecessary dependencies. If you don't want to, press \"n\" at the prompt...",
	command 	=> "sudo yum autoremove",
	delay 		=> 3,
	exitFail 	=> 1,
});

CliPrint::printGreen("Everything went fine...:)\n", 1);

exit(0);