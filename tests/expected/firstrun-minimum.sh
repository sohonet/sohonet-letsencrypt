#!/bin/sh
# Managed by Puppet.

cd "/var/foo" || exit 1

/usr/bin/env pipenv run certbot \
    -c "/var/foo/config.ini" \
    --quiet \
    certonly \
    --cert-name "foo.com" \
    -d "foo.com" \
    --agree-tos \
    --email "email@example.com" \
    --pre-hook "/usr/bin/env true" \
    --post-hook "/usr/bin/env true" \
    --authenticator "standalone"
