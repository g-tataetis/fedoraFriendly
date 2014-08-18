#!/usr/bin/perl

use warnings;
use strict;

use lib '../../library';
use System;
use CliPrint;

chdir("/tmp/");

System::call({
		title 		=> 'Checking for JDK 7...',
		command 	=> "sudo yum install java -y",
		delay 		=> 3,
		exitFail 	=> 1,
	});

System::call({
		title 		=> 'Downloading netbeans executable...',
		command 	=> "wget http://download.netbeans.org/netbeans/8.0/final/bundles/netbeans-8.0-php-linux.sh",
		delay 		=> 3,
		exitFail 	=> 1,
	});

System::call({
		title 		=> 'Running netbeans executable...',
		command 	=> "bash netbeans-8.0-php-linux.sh",
		delay 		=> 3,
		exitFail 	=> 1,
	});

System::call({
		title 		=> 'Cleaning the mess...',
		command 	=> "rm -rvf netbeans-8.0-php-linux.sh",
		delay 		=> 3,
		exitFail 	=> 1,
	});

exit(0);