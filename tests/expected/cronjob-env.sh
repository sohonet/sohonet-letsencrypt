#!/bin/sh
# Managed by Puppet.

cd "/var/foo" || exit 1

FOO=foobar BAZ=bizbazz /usr/bin/env pipenv run certbot \
    -c "/var/foo/config.ini" \
    --keep-until-expiring \
    --quiet \
    renew \
    --cert-name "foo.com" \
    --pre-hook "/usr/bin/env true" \
    --post-hook "/usr/bin/env true"
