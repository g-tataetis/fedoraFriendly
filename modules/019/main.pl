#!/usr/bin/perl

use warnings;
use strict;

use lib '../../library';
use System;
use CliPrint;

System::call({
	title	 	=> "Installing git",
	command 	=> "sudo yum install git -y",
	delay 		=> 3,
	exitFail 	=> 1,
});

CliPrint::printGreen("Github username: ");
chomp( my $username = <STDIN> );

System::call({
	command 	=> "git config --global user.name \"$username\"",
	delay 		=> 3,
	exitFail 	=> 1,
});

CliPrint::printGreen("Github email: ");
chomp( my $email = <STDIN> );

System::call({
	command 	=> "git config --global user.email \"$email\"",
	delay 		=> 3,
	exitFail 	=> 1,
});

CliPrint::printGreen("Everything went fine... :)\n", 1);

exit(0);