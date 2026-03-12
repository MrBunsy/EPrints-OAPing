# EPrints-Matomo

*Alternative EPrints extension for sending usage pings to the Matomo tracking API (OpenAIRE uses Matomo)*

This is a fork and major refactor of the work by Alex Ball: https://github.com/alex-ballEPrints-OAPing/

Changes from EPrints-OAPing:
 - Only bulk uploads, no live pings
 - Explicit support for any Matomo instance, not just OpenAIRE
 - Minimal setup required to upload historic access data

## Installation

You can install this as an ingredient that you can then load into archives on a flavour-by-flavour basis;

Check out the git repository into into your `~eprints/ingredients` folder, where
`~eprints` is typically something like `/opt/eprints3`.

For EPrints 3.4, edit `flavours/pub_lib/inc` and add the line `ingredients/EPrints-Matomo`

## Configuration

To configure the ingredient for your archive, copy `ingredients/EPrints-Matomo/cfg.d/z_matomo_config.pl.example` to `archives/[YOUR_ARCHIVE_ID]/cfg/cfg.d/z_matomo_config.pl`.

You will want to configure at least `$c->{matomo}->{idsite}` and `$c->{matomo}->{token_auth}`.

Remember to restart both the server and Indexer after changing the
configuration.

## Operation

The matomo plugin works hard to ensure all pings get through to the tracker
safely. Unsent or unsuccessful pings are saved to disk ("stashed") in the
**ARCHIVE_ID/var/matomo/** directory to be retried later, and removed when they
succeed.

The `legacy_notify` job performs bulk requests in batches of configurable size (`$c->{matomo}->{max_payload}`, default 100).
It defaults to sending a ping for each non-trivial Access DataObj in the
database, though when you set it running you can choose how many of the
chronologically earliest ones to skip (using `$c->{matomo}->{legacy_start_access_id}`). If there are stashed pings, it will send
them instead of looking up the next batch from the database.

## Debugging

To help with debugging, the plugin writes one or two dedicated log files:

-   **ARCHIVE_ID/var/matomo-legacy.json**

    This records information about the last run of the `legacy_notify` job. It
    is also used to keep track of how far through the legacy notifications it has progressed.

-   **ARCHIVE_ID/var/matomo-error.json**

    This records when calls to the tracker have failed, and also when previous
    errors have been resolved successfully. As well as a summary message, it
    records Access DataObjs that were stashed; stashed Access DataObjs that were
    later sent successfully; and any error messages sent back by the tracker.
