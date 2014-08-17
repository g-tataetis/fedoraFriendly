#!/usr/bin/perl

use warnings;
use strict;

use lib '../../library';
use System;

System::call({
	command 	=> 'sudo yum localinstall --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y',
	delay 		=> 3,
	exitFail 	=> 1,
});

System::call({
	command 	=> 'sudo yum update -y',
	delay 		=> 3,
	exitFail 	=> 1,
});