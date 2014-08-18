#!/usr/bin/perl

use warnings;
use strict;

use lib '../../library';
use System;
use CliPrint;

System::call({
		title 		=> 'Installing thunderbird...',
		command 	=> "sudo yum install thunderbird -y",
		delay 		=> 3,
		exitFail 	=> 1,
	});

CliPrint::printGreen("Thunderbird installed successfully... :)\n", 1);

exit(0);