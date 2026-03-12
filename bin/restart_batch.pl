#!/usr/bin/perl -w -I/opt/eprints3/perl_lib

# ./yesterdays_accesses [archive id]
# this will schedule in the upload of all access results from yesterday, using UTC to avoid clock changing issues 

use EPrints;

use strict;

my $repoid   = $ARGV[0];
my $batch_name = $ARGV[1];

my $session = new EPrints::Session(1, $repoid, 1);
if( !defined $session )
{
  print STDERR "Failed to load repository: $repoid\n";
  exit 1;
}



my $repo   = $session;

my $plugin = $repo->plugin('Event::MatomoEvent');

$plugin->restart_batch($repo, $batch_name);
