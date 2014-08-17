#!/usr/bin/perl

use warnings;
use strict;

use lib '../../library';
use System;

System::call({
	command 	=> "sudo yum install deja-dup -y",
	delay 		=> 3,
	exitFail 	=> 1,
});