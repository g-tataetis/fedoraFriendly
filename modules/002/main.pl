#!/usr/bin/perl

use warnings;
use strict;

use lib '../../library';
use System;

System::call({
	command 	=> "sudo yum install youtube-dl -y",
	delay 		=> 3,
	exitFail 	=> 1,
});