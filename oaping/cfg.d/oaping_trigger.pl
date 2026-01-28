
=head1 OAPing

B<OAPing> - A usage tracking plugin for OpenAIRE's Matomo tracker.

=head2 Manifest

As well as this file, you should also install:

=over

=item *

B<EPrints::Plugin::Event::OAPingEvent> - Indexer jobs that do all the work.

=cut


$c->add_dataset_trigger(
	'access',
	EPrints::Const::EP_TRIGGER_CREATED,
	sub {
		my (%args) = @_;
		my $repo   = $args{repository};
		my $access = $args{dataobj};

		my $notify_mode = $repo->config('oaping', 'notify_mode');

		# Get current request URL as a URI object:
		my $request_url = $repo->current_url( host => 1 );

		

		# Convert to string:
		my $canonical_url = $request_url->canonical()->as_string();
		my $plugin = $repo->plugin('Event::OAPingEvent');
		my $status = $plugin->notify( $access, $canonical_url );

		if ( $status != EPrints::Const::HTTP_OK )
		{
			# Retry 5 mins after last unsuccessful ping:
			my $start_time =
				EPrints::Time::iso_datetime( time() + ( 5 * 60 ) );
			my $event = EPrints::DataObj::EventQueue->create_unique(
				$repo,
				{
					start_time => $start_time,
					pluginid   => $plugin->get_id,
					action     => 'retry',
				}
			);
			if ( $event->get_value('start_time') lt $start_time )
			{
				# Task was already set to run sooner, so delay start time:
				$event->set_value( 'start_time', $start_time );
				$event->commit;
			}
		}
	}
);

=back

=head2 Debugging

To help with debugging, the plugin writes one or two dedicated log files:

=over

=item <archive>/var/oaping-legacy.json

This records information about the last run of the C<legacy_notify> job. It is
also used when transitioning from that job to the normal C<notify> job.

=item <archive>/var/oaping-error.json

This records when calls to the tracker have failed, and also when previous
errors have been resolved successfully. As well as a summary message, it records
Accesses that were stashed (saved for a subsequent call); stashed Accesses that
were later sent successfully; and any error messages sent back by the tracker.

=back

=cut
