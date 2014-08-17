#!/usr/bin/perl

use warnings;
use strict;

use lib '../../library';
use System;
use CliPrint;

sub getLatestTorLink{

	my @downs = `wget -q -O- https://www.torproject.org/download/download-easy.html.en`;

	my $link = "https://www.torproject.org";

	foreach my $line (@downs) {
		if ( $line =~ /^\s+<a class="button lin-tbb64" href="..(\S+)"><span class="strong">Download<\/span><span class="normal">GNU\/Linux 64-bit<\/span><\/a>.*$/ ) {
			$link .= $1;
		}
	}

	return $link;
}

sub downloadTarball{

	my $link = shift;

	chdir("/tmp/");

	System::call({
		command 	=> "wget \"$link\"",
		delay 		=> 3,
		exitFail 	=> 1,
	});
}

sub extractTarballInTmp{

	chdir("/tmp/");

	System::call({
		command 	=> "tar -xf tor-browser-linux64-*",
		delay 		=> 3,
		exitFail 	=> 1,
	});

	System::call({
		command 	=> "rm -rf tor-browser-linux64-*.tar.*",
		delay 		=> 3,
		exitFail 	=> 1,
	});
}

sub removeExistingBundle{

	my $user = `whoami`;

	chomp($user);

	chdir("/home/$user/Downloads/");

	if ( -d 'tor-browser_en-US' ) {
		System::call({
			command 	=> "rm -rf tor-browser_en-US",
			delay 		=> 3,
			exitFail 	=> 1,
		});
	} else {
		CliPrint::printRed("\tnothing to remove\n", 1);
	}
}

sub moveExtractedBundle{

	chdir("/tmp/");

	my $user = `whoami`;

	chomp($user);

	System::call({
		command 	=> "mv -f tor-browser_en-US /home/$user/Downloads/",
		delay 		=> 3,
		exitFail 	=> 1,
	});
}


#=========================================================================

CliPrint::printGreen("Accessing Tor Link...\n", 1);
my $link = getLatestTorLink();

CliPrint::printGreen("Downloading: $link...\n", 1);
downloadTarball($link);

CliPrint::printGreen("Extracting tarball...\n", 1);
extractTarballInTmp();

CliPrint::printGreen("Removing existing bundle...\n", 1);
removeExistingBundle();

CliPrint::printGreen("Deploying current bundle...\n", 1);
moveExtractedBundle();

CliPrint::printGreen("Everything went fine... :)\n", 1);

exit(0);