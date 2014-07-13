#!/usr/bin/perl 

use qtc::interface::http; 

if ( $#ARGV == -1 ) { print "Usage: $0 [-d PATH_TO_QTC] url [url2] ...\n"; exit; }

my $path=$ENV{HOME}."/.qtc"; 
if ( $ARGV[0] eq "-d" ) {
	shift(@ARGV); 
	$path=shift(@ARGV); 
}

# url may be http://localhost/qtc_if.cgi
foreach my $url (@ARGV) {
	my $if=qtc::interface::http->new(
		path=>$path, 
		url=>$url,
		debug=>1, 
	); 
	$if->dprint("Sync down\n"); 
	$if->sync("/out"); 
	$if->dprint("Sync up\n"); 
	$if->{use_digest}=1; 
	$if->sync_upload("/out"); 
}

