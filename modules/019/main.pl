#!/usr/bin/perl

use warnings;
use strict;
use Term::ANSIColor;

use lib '../library';
use System;

System::call({
	command 	=> "pwd",
	delay 		=> 2,
	errorMsg 	=> 'Holly crap!',
	exitFail 	=> 1,
});

exit(0);