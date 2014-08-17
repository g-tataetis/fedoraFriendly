#!/usr/bin/perl

use warnings;
use strict;

use lib '../../library';
use System;
use CliPrint;
use File;

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
	title 		=> 'Installing php...',
	command 	=> "sudo yum install php php-mysql -y",
	delay 		=> 3,
	exitFail 	=> 1,
});

System::call({
	title 		=> 'Restarting Apache Server...',
	command 	=> "sudo service httpd restart",
	delay 		=> 3,
	exitFail 	=> 1,
});

CliPrint::printGreen("Attempting to test php functionality...\n", 1);

createHtmlFolderForApacheIfNotExists();

changeHtmlFolderPermissions();

File::appendLine({
	file 	=> '/var/www/html/test.php',
	line 	=> "<?php phpinfo(); ?>",
});

my @output = `curl -s http://localhost/test.php`;
my $flag = 0;
foreach my $line ( @output ) {
	if ( $line =~ /^<tr><td class="e">System <\/td><td class="v">Linux localhost.localdomain.*$/ ) {
		$flag = 1;
	}
}

if ( $flag == 0 ) {

	CliPrint::printRed("Something went horribly wrong. Could not detect valid php installation! Exiting!\n", 1);

	System::call({
		command 	=> "rm -rf /var/www/html/test.php",
		delay 		=> 3,
		exitFail 	=> 1,
	});

	exit(0);
}

CliPrint::printGreen("Everything went fine...:)\n", 1);

System::call({
	title 		=> 'Removing test file...',
	command 	=> "rm -rf /var/www/html/test.php",
	delay 		=> 3,
	exitFail 	=> 1,
});

exit(0);
