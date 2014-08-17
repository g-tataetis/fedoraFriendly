#!/usr/bin/perl

use warnings;
use strict;

use lib '../../library';
use System;
use CliPrint;

sub getLocalhostHttpResponse{

	my @outcome = `curl -s http://localhost`;

	my $flag = 0;

	foreach my $line ( @outcome ) {
		if ( $line =~ /^\s*<p>This page is used to test the proper operation of the Apache HTTP server after it has been installed. If you can read this page, it means that the web server installed at this site is working properly, but has not yet been configured.<\/p>.*$/ ) {
			$flag = 1;
		}
	}

	return $flag;
}

sub createHtmlFolderForApacheIfNotExists{

	CliPrint::printGreen("Checking for html folder...\n", 1);

	chdir("/var/www");

	if ( !-d 'html' ) {
		CliPrint::printGreen("Creating html folder...\n", 1);
		System::call({
			command 	=> "sudo mkdir html",
			delay 		=> 3,
			exitFail 	=> 1,
		});
	}
}

sub changeHtmlFolderPermissions{

	CliPrint::printGreen("Changing apache folder permissions...\n", 1);

	my $user = System::whoami();

	System::call({
		command 	=> "sudo chown -R $user.$user html/",
		delay 		=> 3,
		exitFail 	=> 1,
	});
}

#=========================================================================

System::call({
	command 	=> "sudo yum install httpd -y",
	delay 		=> 3,
	exitFail 	=> 1,
});

System::call({
	command 	=> "sudo service httpd start",
	delay 		=> 3,
	exitFail 	=> 1,
});

System::call({
	command 	=> "sudo yum install curl -y",
	delay 		=> 3,
	exitFail 	=> 1,
});

CliPrint::printGreen("Checking for server status...\n", 1);
my $status = getLocalhostHttpResponse();
if ( $status != 1 ) {
	CliPrint::dieRed("Something went horribly wrong. localhost could not be accessed!\n", 1);
}

createHtmlFolderForApacheIfNotExists();

changeHtmlFolderPermissions();

CliPrint::printGreen("Set Apache Server to run automatically when the system boots\n", 1);

System::call({
	command 	=> "sudo systemctl enable httpd.service",
	delay 		=> 3,
	exitFail 	=> 1,
});

CliPrint::printGreen("Everything went fine... :)\n", 1);

exit(0);