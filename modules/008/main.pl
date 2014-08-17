#!/usr/bin/perl

use warnings;
use strict;

use lib '../../library';
use System;

System::call({
	command 	=> "sudo wget http://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo -O /etc/yum.repos.d/virtualbox.repo",
	delay 		=> 3,
	exitFail 	=> 1,
});

System::call({
	command 	=> "sudo yum update -y",
	delay 		=> 3,
	exitFail 	=> 1,
});

my @output = `sudo yum search virtualbox`;
my @versions = ();
foreach my $line (@output) {
	if ( $line =~ /^VirtualBox-(\d+\.\d+).\S+ : Oracle VM VirtualBox.*$/ ) {
		push @versions, $1;
	}
}

my $maxVersion = 0;
foreach my $version (@versions) {
	if ( $version > $maxVersion ) {
		$maxVersion = $version;
	}
}

System::call({
	command 	=> "sudo yum install kernel-devel gcc dkms -y",
	delay 		=> 3,
	exitFail 	=> 1,
});

System::call({
	command 	=> "sudo yum install VirtualBox-$maxVersion -y",
	delay 		=> 3,
	exitFail 	=> 1,
});

System::call({
	command 	=> "sudo /etc/init.d/vboxdrv setup",
	delay 		=> 3,
	exitFail 	=> 1,
});