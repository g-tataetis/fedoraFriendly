#!/usr/bin/perl

use warnings;
use strict;

use lib '../../library';
use System;
use CliPrint;

my $version = System::backticks({
	title 		=> 'Determining fedora version...',
	command 	=> 'rpm -E %fedora',
	exitFail 	=> 1,
});

System::call({
	title 		=> 'Adding fedora chromium stable repo...',
	command 	=> "sudo yum-config-manager --add-repo=http://copr.fedoraproject.org/coprs/churchyard/chromium-russianfedora/repo/fedora-$version/churchyard-chromium-russianfedora-fedora-$version.repo",
	delay 		=> 3,
	exitFail 	=> 1,
});

System::call({
	title 		=> 'Installing chromium...',
	command 	=> "sudo yum install chromium -y",
	delay 		=> 3,
	exitFail 	=> 1,
});

CliPrint::printGreen("Chromium installed successfully... :)\n", 1);