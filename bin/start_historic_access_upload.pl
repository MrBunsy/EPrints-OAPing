#!/usr/bin/perl -w -I/opt/eprints3/perl_lib

# ./start_historic_access_upload [archive id]
# this will schedule in the upload of all access results from $c->{matomo}->{legacy_start_access_id} (default 0) to 
# the end of yesterday.
# Today's results should be sent by the cronjob which will run early tomorrow.

use EPrints;

use strict;

my $repoid = shift @ARGV;

my $session = new EPrints::Session(1, $repoid, 1);
if( !defined $session )
{
  print STDERR "Failed to load repository: $repoid\n";
  exit 1;
}



my $repo   = $session;

my $plugin = $repo->plugin('Event::MatomoEvent');

$plugin->initiate_historic_upload($repo, $repo->config('matomo','legacy_start_access_id'));
