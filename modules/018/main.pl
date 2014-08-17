#!/usr/bin/perl

use warnings;
use strict;

use lib '../../library';
use System;
use CliPrint;
use Wget;
use File;

System::call({
	title 		=> "checking for dependencies...",
	command 	=> "sudo yum install gcc gcc-c++ openssl-devel ncurses-devel libcurl-devel -y",
	delay 		=> 3,
	exitFail 	=> 1,
});

my $whichCommand = System::which('rtorrent');

if ( $whichCommand eq "none" ) {
	CliPrint::printGreen("no rtorrent found. preparing for installation...\n", 1);
} else {
	System::call({
		title 		=> "rtorrent found installed. preparing for removal...",
		command 	=> "sudo yum remove rtorrent libtorrent -y",
		delay 		=> 3,
		exitFail 	=> 1,
		errorMsg 	=> "could not remove rtorrent. you 'll have to do this manually and re run this script",
	});
}

CliPrint::printGreen("connecting to rtorrent webpage\n", 1);

my $page = Wget::fetch('https://rakshasa.github.io/rtorrent/');

if ( scalar(@{$page}) < 10 ) {
	CliPrint::dieRed("something went wrong parsing the webpage. this script needs update\n", 1);
}

my $libtorrentLink;
my $rtorrentLink;
for ( my $i=0 ; $i<scalar(@{$page}) ; $i++ ) {
	if ( $page->[$i] =~ /^<li><a href="(http:\/\/libtorrent.rakshasa.no\/downloads\/libtorrent-\S+tar.gz)">http:\/\/libtorrent.rakshasa.no\/downloads\/libtorrent-\S+.tar.gz<\/a><\/li>.*$/ ) {
		$libtorrentLink = $1;
	} elsif ( $page->[$i] =~ /^<li><a href="(http:\/\/libtorrent.rakshasa.no\/downloads\/rtorrent-\S+.tar.gz)">http:\/\/libtorrent.rakshasa.no\/downloads\/rtorrent-\S+.tar.gz<\/a><\/li>.*$/ ) {
		$rtorrentLink = $1;
	}
}

if ( length($libtorrentLink) < 3 ) {
	CliPrint::dieRed("could not locate libtorrent link. this script needs update\n", 1);
} elsif ( length($rtorrentLink) < 3 ) {
	CliPrint::dieRed("could not locate rtorrent link. this script needs update\n", 1);
} else {
	CliPrint::printGreen("rtorrent link: $rtorrentLink\n", 1);
	CliPrint::printGreen("libtorrentLink: $libtorrentLink\n", 1);
}

System::call({
	title 		=> "downloading libtorrent...",
	command 	=> "wget $libtorrentLink",
	delay 		=> 3,
	exitFail 	=> 1,
});

System::call({
	title 		=> "downloading rtorrent...",
	command 	=> "wget $rtorrentLink",
	delay 		=> 3,
	exitFail 	=> 1,
});

my $libtorrentTarballName = System::backticks({
		command 	=> 'ls libtor*',
		exitFail 	=> 1,
	});
CliPrint::printGreen("libtorrent found: $libtorrentTarballName\n", 1);

my $rtorrentTarballName = System::backticks({
		command 	=> 'ls rtor*',
		exitFail 	=> 1,
	});
CliPrint::printGreen("rtorrent found: $rtorrentTarballName\n", 1);

System::call({
	title 		=> "extracting libtorrent...",
	command 	=> "tar -xf $libtorrentTarballName",
	delay 		=> 3,
	exitFail 	=> 1,
	errorMsg 	=> "tarball could not be extracted!",
});

System::call({
	title 		=> "deleting libtorrent tarball...",
	command 	=> "rm -rf $libtorrentTarballName",
	delay 		=> 3,
	exitFail 	=> 1,
	errorMsg 	=> "tarball could not be deleted!",
});

System::call({
	title 		=> "extracting rtorrent...",
	command 	=> "tar -xf $rtorrentTarballName",
	delay 		=> 3,
	exitFail 	=> 1,
	errorMsg 	=> "tarball could not be extracted!",
});

System::call({
	title 		=> "deleting rtorrent tarball...",
	command 	=> "rm -rf $rtorrentTarballName",
	delay 		=> 3,
	exitFail 	=> 1,
	errorMsg 	=> "tarball could not be deleted!",
});

my $libtorrentFolder = $libtorrentTarballName;
$libtorrentFolder =~ s/\.tar\.gz$//g;
my $rtorrentFolder = $rtorrentTarballName;
$rtorrentFolder =~ s/\.tar\.gz$//g;

my $chdirCommand1 = chdir($libtorrentFolder);
if ( $chdirCommand1 == 0 ) {
	CliPrint::dieRed("could not change working directory to $libtorrentFolder. exiting...\n", 1);
}

my $chdirCommand2 = chdir('src/tracker');
if ( $chdirCommand2 == 0 ) {
	CliPrint::dieRed("could not change working directory to src/tracker. exiting...\n", 1);
}

if ( !-e 'tracker_http.cc' ) {
	CliPrint::dieRed("could not find file 'tracker_http.cc'. exiting...\n", 1);
}

CliPrint::printGreen("applying the patch...\n", 1);
open my $trackerFh, '<', 'tracker_http.cc' or CliPrint::dieRed("could not open tracker_http.cc\n$!\n", 1);
my @conts = <$trackerFh>;
close $trackerFh or CliPrint::dieRed("could not disengage tracker_http.cc\n", 1);

my $lineFlag = 0;
foreach my $line ( @conts ) {
	if ( $line =~ /^\s+uint64_t uploaded_adjusted = info->uploaded_adjusted\(\)\;.*$/ ) {
		$line = "  uint64_t uploaded_adjusted = 10*info->uploaded_adjusted();\n";
		$lineFlag = 1;
	}
}
if ( $lineFlag == 0 ) {
	CliPrint::dieRed("patch could not be applied. this is script is out of date. exiting...\n", 1);
}

System::call({
	title 		=> "altering tracker_http.cc file...",
	command 	=> "rm -rf tracker_http.cc",
	exitFail 	=> 1,
	errorMsg 	=> "could not delete tracker_http.cc file!",
});

File::appendContent({
	file 		=> 'tracker_http.cc',
	content 	=> \@conts,
});

my $chdirCommand3 = chdir('../..');
if ( $chdirCommand3 == 0 ) {
	CliPrint::dieRed("could not change working directory to libtorrent main. exiting...\n", 1);
}

System::call({
	title 		=> "configuring libtorrent...",
	command 	=> "./configure",
	delay 		=> 3,
	exitFail 	=> 1,
	errorMsg 	=> "could not go on configuring libtorrent!",
});

System::call({
	title 		=> "compiling libtorrent...",
	command 	=> "make",
	delay 		=> 3,
	exitFail 	=> 1,
	errorMsg 	=> "could not go on compiling libtorrent!",
});

System::call({
	title 		=> "installing libtorrent...",
	command 	=> "sudo make install",
	delay 		=> 3,
	exitFail 	=> 1,
	errorMsg 	=> "could not go on installing libtorrent!",
});

my $chdirCommand4 = chdir("../$rtorrentFolder");
if ( $chdirCommand4 == 0 ) {
	CliPrint::dieRed("could not change working directory to ../$rtorrentFolder. exiting...\n", 1);
}

$ENV{PKG_CONFIG_PATH} = "/usr/local/lib/pkgconfig";

System::call({
	title 		=> "configuring rtorrent...",
	command 	=> "./configure",
	delay 		=> 3,
	exitFail 	=> 1,
	errorMsg 	=> "could not go on configuring rtorrent!",
});

System::call({
	title 		=> "compiling rtorrent...",
	command 	=> "make",
	delay 		=> 3,
	exitFail 	=> 1,
	errorMsg 	=> "could not go on compiling rtorrent!",
});

System::call({
	title 		=> "installing rtorrent...",
	command 	=> "sudo make install",
	delay 		=> 3,
	exitFail 	=> 1,
	errorMsg 	=> "could not go on installing rtorrent!",
});

exit(0);