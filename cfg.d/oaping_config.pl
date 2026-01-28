=item *

B<x_oaping.pl> - Credentials (not included):

	$c->{oaping}->{idsite} - site identifier
	$c->{oaping}->{token_auth} - authorization token

These are available from the Usage Counts page when managing your repository
at provide.openaire.eu, as MatomoID (site identifier) and AuthenticationToken

=back

=cut

$c->{oaping}->{idsite} = '1234';
$c->{oaping}->{token_auth} = 'abcde';

=item $c->{oaping}->{notify_mode}

If you are installing the plugin into a running repository and want to send
tracking information for historic Accesses, leave C<notify_mode> set to 0 and
run the C<legacy_notify> job as your first step. Set C<notify_mode> to 1 once
the C<legacy_notify> job reports it is up to date.

Otherwise, set C<notify_mode> to 1 to start tracking new Accesses immediately.
This setting installs a trigger that activates when a new access event is logged
in the database.

When you are happy that everything is working, you can set C<notify_mode> to 2.
This is more efficient than mode 1 but does not handle the transition from
C<legacy_notify> and, when recovering from errors, new pings will likely be sent
before older failed pings are retried.

=cut

$c->{oaping}->{notify_mode}=2;

=item $c->{oaping}->{max_payload}

The maximum number of access pings to send in a single bulk request. OpenAIRE's
official generic solution defaults to 100. As bulk requests are typically made
at least 60 seconds apart, busy repositories might need a higher value.

=cut

$c->{oaping}->{max_payload} = 100;

=item $c->{oaping}->{verbosity}

Set to 1 to log each Access ID that is successfully tracked.

=cut

$c->{oaping}->{verbosity} = 1;

=head2 Configuration

=over

=item $c->{plugins}->{'Event::OAPingEvent'}->{params}->{disable}

In the normal fashion, set the plugin's C<disable> parameter to 0 to enable or 1
to disable.

=cut

$c->{plugins}->{'Event::OAPingEvent'}->{params}->{disable} = 0;

=item $c->{oaping}->{tracker}

You can change this URL if necessary.

=cut

$c->{oaping}->{tracker} = 'https://analytics.openaire.eu/piwik.php';
