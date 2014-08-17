#!/usr/bin/perl

use warnings;
use strict;

use lib '../../library';
use System;

System::call({
	command 	=> "sudo wget http://negativo17.org/repos/fedora-handbrake.repo -O /etc/yum.repos.d/fedora-handbrake.repo",
	delay 		=> 3,
	exitFail 	=> 1,
});

System::call({
	command 	=> "sudo yum update -y",
	delay 		=> 3,
	exitFail 	=> 1,
});

System::call({
	command 	=> "sudo yum install HandBrake-gui HandBrake-cli -y",
	delay 		=> 3,
	exitFail 	=> 1,
});