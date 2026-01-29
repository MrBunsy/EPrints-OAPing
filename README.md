# EPrints-OAPing

*Alternative EPrints extension for sending usage pings to the OpenAIRE Matomo
tracking API*

This is a fork and major refactor of the work by Alex Ball: https://github.com/alex-ball/EPrints-OAPing/

The refactor was intended to make this easier to deploy with minimal manual intervention required, but preserving the robustness added over the original plugin.

## Installation

You can install this as an ingredient that you can then load into archives on a flavour-by-flavour basis;

Check out the git repository into into your `~eprints/ingredients` folder, where
`~eprints` is typically something like `/opt/eprints3`.

For EPrints 3.4, edit `flavours/pub_lib/inc` and add the line `ingredients/EPrints-OAPing`

## Configuration

To configure the ingredient for your archive, copy `ingredients/EPrints-OAPing/cfg.d/oaping_config.pl` to `archives/[YOUR_ARCHIVE_ID]/cfg/cfg.d/oaping_config.pl`.

You will want to configure at least `$c->{oaping}->{idsite}` and `$c->{oaping}->{token_auth}`.

Create a file to contain your OpenAIRE tracking credentials:

It is also good practice to restrict access to the file so it can only be
read by the user(s) as which the Web server and Indexer run. If they both only
run as `eprints`, this would work:

```bash
chown eprints ~eprints/archives/ARCHIVE_ID/cfg/cfg.d/oaping_config.pl
chmod 600 ~eprints/archives/ARCHIVE_ID/cfg/cfg.d/oaping_config.pl
```

There are a few other configuration options. By default the ingredient will beginning sending all historic access requests, in batches, in the background.

To disabled this set `$c->{oaping}->{legacy_catchup} = 0`. If the legacy catchup has already started and you wish to stop it, delete the `legacy_notify` event from the indexer. 

Remember to restart both the server and Indexer after changing the
configuration.

## Operation

The OAPing plugin works hard to ensure all pings get through to the tracker
safely. Unsent or unsuccessful pings are saved to disk ("stashed") in the
**ARCHIVE_ID/var/oaping/** directory to be retried later, and removed when they
succeed.

The `legacy_notify` job performs bulk requests in batches of configurable size (`$c->{oaping}->{max_payload}`, default 100).
It defaults to sending a ping for each non-trivial Access DataObj in the
database, though when you set it running you can choose how many of the
chronologically earliest ones to skip (using `$c->{oaping}->{legacy_start_access_id}`). If there are stashed pings, it will send
them instead of looking up the next batch from the database.

## Debugging

To help with debugging, the plugin writes one or two dedicated log files:

-   **ARCHIVE_ID/var/oaping-legacy.json**

    This records information about the last run of the `legacy_notify` job. It
    is also used to keep track of how far through the legacy notifications it has progressed.

-   **ARCHIVE_ID/var/oaping-error.json**

    This records when calls to the tracker have failed, and also when previous
    errors have been resolved successfully. As well as a summary message, it
    records Access DataObjs that were stashed; stashed Access DataObjs that were
    later sent successfully; and any error messages sent back by the tracker.
