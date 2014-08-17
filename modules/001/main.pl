#!/usr/bin/perl

use warnings;
use strict;

use lib '../../library';
use System;

System::call({
	command 	=> "sudo plymouth-set-default-theme details --rebuild-initrd",
	delay 		=> 3,
	exitFail 	=> 1,
});

System::call({
	command 	=> "sudo dracut -f",
	delay 		=> 3,
	exitFail 	=> 1,
});