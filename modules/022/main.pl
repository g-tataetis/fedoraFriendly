#!/usr/bin/perl

use warnings;
use strict;

use lib '../../library';
use System;
use CliPrint;
use File;

CliPrint::printGreen("Google Chrome is a closed source project developed by an infamous company as far as privacy issues are concerned\n", 1);
CliPrint::printGreen("so its installation is greatly discouraged. Nonetheless, if running closed source and insecure software on an\n", 1);
CliPrint::printGreen("open source and security oriented operational system like Fedora, is not something you would lose sleep over, press \"y\"\n", 1);
CliPrint::printGreen("at the prompt. Do you want to continue? [y/n]: ");
chomp( my $prompt = <STDIN> );
if ( $prompt ne "y" ) {
	CliPrint::printGreen("Blessed you be. :)\n", 1);
	exit(0);
}

chdir("/tmp/");

System::call({
		title 		=> 'Downloading the Linux package signing key...',
		command 	=> "wget https://dl-ssl.google.com/linux/linux_signing_key.pub",
		delay 		=> 3,
		exitFail 	=> 1,
	});

System::call({
		title 		=> 'Importing the Linux package signing key...',
		command 	=> "sudo rpm --import linux_signing_key.pub",
		delay 		=> 3,
		exitFail 	=> 1,
	});

CliPrint::printGreen("Creating the repo file...\n", 1);

my $arch = System::arch();

my @conts = ();

if ( $arch eq "32bit" ) {

	@conts = (
			"[google-chrome]\n",
			"name=google-chrome - 32-bit\n",
			"baseurl=http://dl.google.com/linux/chrome/rpm/stable/i386\n",
			"enabled=1\n",
			"gpgcheck=1\n",
			"gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub\n"
		);

} else {

	@conts = (
			"[google-chrome]\n",
			"name=google-chrome - 64-bit\n",
			"baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64\n",
			"enabled=1\n",
			"gpgcheck=1\n",
			"gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub\n"
		);

}

File::appendContent({
		file 		=> 'google-chrome.repo',
		content 	=> \@conts,
	});

System::call({
		title 		=> 'Installing new repo file...',
		command 	=> "sudo cp -rf google-chrome.repo /etc/yum.repos.d/",
		delay 		=> 3,
		exitFail 	=> 1,
	});

System::call({
		title 		=> 'Installing google chrome...',
		command 	=> "sudo yum install google-chrome-stable -y",
		delay 		=> 3,
		exitFail 	=> 1,
	});

System::call({
		title 		=> 'Post installation cleaning...',
		command 	=> "rm -rf linux_signing_key.pub",
		delay 		=> 3,
		exitFail 	=> 1,
	});

System::call({
		command 	=> "rm -rf google-chrome.repo",
		delay 		=> 3,
		exitFail 	=> 1,
	});

CliPrint::printGreen("Google Chrome installed successfully... :)\n", 1);

exit(0);