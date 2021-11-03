#!/bin/sh
# Managed by Puppet.

cd "/var/foo" || exit 1

/usr/bin/env pipenv run certbot \
    -c "/var/foo/config.ini" \
    --keep-until-expiring \
    --quiet \
    renew \
    --cert-name "foo.com" \
    --pre-hook "/usr/bin/foo" \
    --post-hook "/usr/bin/bar"
