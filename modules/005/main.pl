#!/usr/bin/perl

use warnings;
use strict;

use lib '../../library';
use System;
use CliPrint;

System::call({
	command 	=> "sudo yum install firefox -y",
	delay 		=> 3,
	exitFail 	=> 1,
});

my $arch = System::arch();
CliPrint::printGreen("Arch detected: $arch\n", 1);

if ( $arch eq "64bit" ) {
	System::call({
		command 	=> "sudo yum install http://linuxdownload.adobe.com/adobe-release/adobe-release-x86_64-1.0-1.noarch.rpm -y",
		delay 		=> 3,
		exitFail 	=> 1,
	});
} else {
	System::call({
		command 	=> "sudo yum -y install http://linuxdownload.adobe.com/adobe-release/adobe-release-i386-1.0-1.noarch.rpm -y",
		delay 		=> 3,
		exitFail 	=> 1,
	});
}

System::call({
	command 	=> "sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux",
	delay 		=> 3,
	exitFail 	=> 1,
});

System::call({
	command 	=> "sudo yum update -y",
	delay 		=> 3,
	exitFail 	=> 1,
});

System::call({
	command 	=> "sudo yum install flash-plugin -y",
	delay 		=> 3,
	exitFail 	=> 1,
});

my $firefoxPid = System::getPid('firefox');

if ( $firefoxPid != 0 ) {
	CliPrint::printGreen("Restarting firefox... Please wait");
	system("kill -9 $firefoxPid");
	sleep (5);
	system("firefox &");
}

exit(0);