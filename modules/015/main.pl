#!/usr/bin/perl

use warnings;
use strict;

use lib '../../library';
use System;
use CliPrint;

my $crontabStatus = System::backticks({
		title 		=> 'Checking for existing crontab status',
		command 	=> "sudo crontab -l",
		delay 		=> 3,
	});

if ( $crontabStatus =~ /.*no crontab for root.*/ ) {

	CliPrint::printGreen("Crontab detected...\n", 1);

	System::call({
		title 		=> 'Accessing crontab...',
		command 	=> "sudo crontab -l > /tmp/mycron",
		delay 		=> 3,
		exitFail 	=> 1,
	});

	my $user = System::whoami();

	System::call({
		title 		=> 'Altering crontab...',
		command 	=> "sudo chown $user.$user /tmp/mycron",
		exitFail 	=> 1,
	});

} else {

	CliPrint::printGreen("No crontab detected. Creating one...\n", 1);
	CliPrint::printGreen("Altering crontab...\n", 1);

}

open my $cronfh, '>>', '/tmp/mycron' or CliPrint::dieRed("$!");
print $cronfh "00 00 * * * /usr/bin/yum -q -y update\n";
close $cronfh;

System::call({
	title 		=> 'Restoring crontab...',
	command 	=> "sudo crontab /tmp/mycron",
	exitFail 	=> 1,
});

System::call({
	title 		=> 'Cleaning junk...',
	command 	=> "rm -rf /tmp/mycron",
	delay 		=> 3,
	exitFail 	=> 1,
});

CliPrint::printGreen("Checking if cron daemon is running...\n", 1);

my $flag = System::checkIfServiceRuns('crond');
if ( $flag == 0 ) {
	System::call({
		title 		=> 'Cron daemon is not running. Initiating...',
		command 	=> "rm -rf /tmp/mycron",
		delay 		=> 3,
		errorMsg 	=> 'Cron daemon could not be initiated. Everything went to hell! :(',
		exitFail 	=> 1,
	});
}

CliPrint::printGreen("Everything went fine...:)\n", 1);

exit(0);