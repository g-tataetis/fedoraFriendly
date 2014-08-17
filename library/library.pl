sub command{

	my $command = shift;

	if ( length($command) <= 0 ) {
		print color 'bold red';
		print "EMPTY COMMAND\n";
		print color 'reset';
		return 0;
	}

	print color 'bold green';
	print "About to execute:\n";
	print color 'reset';
	print color 'green';
	print "\t$command\n";
	print color 'reset';

	sleep(3);

	my $output = system($command);

	if ( $output != 0 ) {
		print color 'red';
		print "Something went horribly wrong:\n";
		print "\tstatus: $output\n";
		print "\tscript: $!\n";
		print color 'reset';
	}

	return $output;
}

sub getProcessId{

	my $processName = shift;

	return 0 if ( length($processName) <= 0 );

	my @output = `ps aux | grep $processName`;

	return 0 if ( scalar(@output) < 2 );

	my $pid;

	if ( $output[0] =~ /^\w+\s+(\d+)\s+.*$/ ) {
		$pid = $1;
	}

	return $pid;
}

sub createHtmlFolderForApacheIfNotExists{

	print "Checking for html folder...\n";
	chdir("/var/www");
	if ( !-d 'html' ) {
		print 'bold green';
		print "Creating html folder...\n";
		system("sudo mkdir html");
		print color 'reset';
	}
}

sub changeHtmlFolderPermissions{

	print color 'bold green';
	print "Changing apache folder permissions...\n";
	my $user = `whoami`;
	chomp($user);
	&command("sudo chown -R $user.$user html/");
}

sub printGreen{

	my $phrase = shift;
	my $wait = shift;
	print color 'bold green';
	print $phrase;
	print color 'reset';
	if ( length($wait) > 0 ) {
		sleep($wait);
	}
	return 1;
}

sub printRed{

	my $phrase = shift;
	my $wait = shift;
	print color 'bold red';
	print $phrase;
	print color 'reset';
	if ( length($wait) > 0 ) {
		sleep($wait);
	}
	return 1;
}

sub checkIfServiceRuns{

	my $service = shift;
	my $flag = 0;
	my @output = `sudo service crond status 2>&1`;
	foreach my $line ( @output ) {
		if ( $line =~ /^.*Active: active \(running\).*$/ ) {
			$flag = 1;
		}
	}
	return $flag;
}

sub exiting{

	my $exitCode = shift;
	print color 'reset';
	if( length($exitCode) > 0 ) {
		exit($exitCode);
	} else {
		exit(0);
	}
}

sub getUserName{

	my $output = `whoami`;
	chomp($output);
	return $output;
}

1;