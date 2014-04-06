package qtc::query; 
use File::Basename; 
use qtc::msg; 
use qtc::misc; 
@ISA=("qtc::misc"); 


# this package provides methods that deliver 
# specific messages.....

sub new { 
	my $class=shift; 
	my %parm=(@_); 
	my $obj=bless \%parm, $class; 
	if ( ! $obj->{path} ) { $obj->{path}=$ENV{HOME}."/.qtc"; }
	return $obj; 
}

sub list_telegrams { 
	my $obj=shift; 
	my $call=shift; 
	my $type=shift; if ( ! $type ) { $type="new"; }
	
	my @msgs;
	foreach my $file ($obj->scan_dir($obj->{path}."/call/$call/telegrams/$type", '.+\.qtc')){
		push @msgs, qtc::msg->new(path=>$obj->{path}."/call/$call/telegrams/$type", filename=>$file); 
	}

	return @msgs; 
}

sub num_telegrams { 
	my $obj=shift; 
	my $call=shift; 
	my $type=shift; if ( ! $type ) { $type="new"; }
	
	my @msgs=$obj->scan_dir($obj->{path}."/call/$call/telegrams/$type", '.+\.qtc');

	return $#msgs+1; 
}

1; 
