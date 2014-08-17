#!/usr/bin/perl

use warnings;
use strict;

use lib '../../library';
use System;
use CliPrint;

System::call({
	title 		=> 'Installing MariaDb...',
	command 	=> "sudo yum install mysql mysql-server -y",
	delay 		=> 3,
	exitFail 	=> 1,
});

System::call({
	title 		=> 'Initiating MariaDb Server...',
	command 	=> "sudo service mysqld start",
	delay 		=> 3,
	exitFail 	=> 1,
});

CliPrint::printGreen("Attempting to locate mysql_secure_installation...\n", 1);

my $secureDest = System::which('mysql_secure_installation');

if ( $secureDest eq 'none' ) {
	CliPrint::dieRed("No mysql_secure_installation binary found. You 'll have to do this manually. Exiting.\n", 1);
}

System::call({
	title 		=> 'Running mysql_secure_installation...',
	command 	=> "sudo $secureDest",
	delay 		=> 3,
	exitFail 	=> 1,
});

System::call({
	title 		=> 'Set MariaDB Server to run automatically when the system boots...',
	command 	=> "sudo systemctl enable mariadb.service",
	delay 		=> 3,
	exitFail 	=> 1,
});

CliPrint::printGreen("Everything went fine...:)\n", 1);

exit(0);