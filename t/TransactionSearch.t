use Test::More;
if( ! $ENV{WPP_TEST} || ! -f $ENV{WPP_TEST} ) {
    plan skip_all => 'No WPP_TEST env var set. Please see README to run tests';
}
else {
    plan tests => 2;
}

use_ok( 'Business::PayPal::API::TransactionSearch' );
#########################

require 't/API.pl';

my %args = do_args();
my $resp ='';
my $pp = new Business::PayPal::API::TransactionSearch( %args );

print STDERR <<"_TRANSID_";

Please login to the PayPal Developer's site, and start a sandbox in
the Business account you want to test.

Review the Business accounts transaction history:

    My Account -> History (tab)

Click the 'Details' link for a transaction whose status is
'Completed'. Copy the Transaction ID for that transaction. The
transaction id may appear like this:

    Express Checkout Payment Received (ID # 2DE2563K55B16978M)

_TRANSID_

print STDERR "\nType or paste that Transaction ID here and hit Enter: \n";

my $transid = <STDIN>; chomp $transid;

die "Need a transaction id.\n" unless $transid;

my $startdate = '1998-01-01T00:00:00Z';  ## before PayPal

#$Business::PayPal::API::Debug = 1;
my $resp = $pp->TransactionSearch( StartDate    => $startdate,
                                   TransactionID => $transid, );

ok( scalar @$resp, "matching transaction(s) found" );
