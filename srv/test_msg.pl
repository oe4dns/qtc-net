#!/usr/bin/perl 

use qtc::msg; 
use Data::Dumper; 

print "hi\n"; 
my $msg=qtc::msg->new(call=>"oe1src", type=>"msg"); 

print "have obj set date \n"; 
$msg->msg_date($msg->rcvd_date); 
print "serial \n"; 
$msg->msg_serial(1); 
print "from \n"; 
$msg->from("oe1xgb"); 
print "to \n"; 
$msg->to("dd5tt"); 
print "msg \n"; 
$msg->msg("hallo zusammen, das ist eine testnachricht."); 

print "here we are \n \n";
print Dumper($msg);  
print $msg->as_xml; 

