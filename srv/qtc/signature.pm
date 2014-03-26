#Signature abstraction module for qtc net. 
package qtc::signature; 
use Data::Dumper;

use Crypt::OpenSSL::RSA;
use Crypt::OpenSSL::DSA;
use MIME::Base64;

#######################################################
# obviously generic right now
########################################################
sub new { 
	my $class=shift; 
	my %parm=(@_); 
	my $obj=bless \%parm, $class; 
	
	# expect an pubkey hash {} that contains key validated qtc::msg objects for 
	#       signature verification, ordered by their key ID
	# expect a privkey string for object signing 
	# expect a privkey_type = rsa|dsa

	return $obj; 
}

sub sign {
	my $obj=shift; 
	my $signed_content_xml=shift;
	
	if ( ! $obj->{privkey} ) { die "I do not know the key to sign with\n"; }
	if ( 	$obj->{privkey_type} !~ /^(rsa|dsa)$/ ) { die "privkey_type eq $obj->{privkey_type} use rsa|dsa\n"; }
	if ( $obj->{privkey_type} eq "rsa" ) {
		
		my $rsa=Crypt::OpenSSL::RSA->new_private_key($obj->{privkey}) or die "Can't read use private key\n"; 
		$rsa->use_sha256_hash; 
		return unpack("H*", $rsa->sign($signed_content_xml)); 

	} elsif ($obj->{privkey_type} eq "dsa") {
		die "This is possible but not yet implemented \n"; 
	}

}

sub verify {
	my $obj=shift; 
	my $signed_content_xml=shift;
	my $signature=shift;
	my $signature_key_id=shift;
	#print STDERR "$signed_content_xml $signature\n"; 
	$signature=pack("H*", $signature); 
	
	if ( ! $obj->{pubkey}->{$signature_key_id} ) { die "I do not have a key to verify with\n"; }

	my $pubkey=$obj->{pubkey}->{$signature_key_id};

	if ( $pubkey->key_type eq "rsa" ) {
		#print STDERR $obj->prepare_rsa_pubkey($pubkey->key);
 		my $rsa=Crypt::OpenSSL::RSA->new_public_key($obj->prepare_rsa_pubkey($pubkey->key)) or die "Cant load public Key\n";
		#print "foo\n"; 
		$rsa->use_sha256_hash; 
		if ($rsa->verify($signed_content_xml, $signature)) {
			#print STDERR "verification succeeded\n"; 
			return 1;
		}
		#print STDERR Dumper($pubkey); 
	} elsif ($pubkey->key_type eq "dsa" ) {
		die "dsa verification not yet implemented\n"; 
	}
	return 0; 
}

sub prepare_rsa_pubkey {
	my $obj=shift; 
	my $key=shift; 
	return "-----BEGIN RSA PUBLIC KEY-----\n".encode_base64(pack("H*", $key))."-----END RSA PUBLIC KEY-----\n"
}

sub prepare_dsa_pubkey {
	my $obj=shift; 
	my $key=shift; 
	return "-----BEGIN DSA PUBLIC KEY-----\n".encode_base64(pack("H*", $key))."-----END DSA PUBLIC KEY-----\n"
}

1; 
