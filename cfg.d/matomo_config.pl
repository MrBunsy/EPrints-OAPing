=item *

B<matomo_config.pl> - Credentials (not included):

	$c->{matomo}->{idsite} - site identifier
	$c->{matomo}->{token_auth} - authorization token

These are available from the Usage Counts page when managing your repository
at provide.openaire.eu, as MatomoID (site identifier) and AuthenticationToken

=back

=cut

$c->{matomo}->{idsite} = '1234';
$c->{matomo}->{token_auth} = 'abcde';

=item $c->{matomo}->{legacy_start_access_id}

If legacy_catchup is enabled, this is the access id it will start from

=cut

$c->{matomo}->{legacy_start_access_id} = 1;

=item $c->{matomo}->{max_payload}

The maximum number of access pings to send in a single bulk request. OpenAIRE's
official generic solution defaults to 100. As bulk requests are typically made
at least 60 seconds apart, busy repositories might need a higher value.

=cut

$c->{matomo}->{max_payload} = 1000;

=item $c->{matomo}->{bulk_upload_period_s}

Time between bulk pings (in seconds) if the number of accesses exceeds max_payload (for both legacy and end-of-day)

=cut

$c->{matomo}->{bulk_upload_period_s} = 60;

=item $c->{matomo}->{verbosity}

Set to 1 to log each Access ID that is successfully tracked.
Set to 0 for minimal logging.

=cut

$c->{matomo}->{verbosity} = 1;

=head2 Configuration

=over

=item $c->{plugins}->{'Event::MatomoEvent'}->{params}->{disable}

In the normal EPrints fashion, set the plugin's C<disable> parameter to 0 to enable or 1
to disable.

=cut

$c->{plugins}->{'Event::MatomoEvent'}->{params}->{disable} = 0;

=item $c->{matomo}->{tracker}

Change this URL if not targetting OpenAIRE.

=cut

$c->{matomo}->{tracker} = 'https://analytics.openaire.eu/piwik.php';
