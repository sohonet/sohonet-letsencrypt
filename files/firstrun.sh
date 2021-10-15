#!/bin/sh

[ -n "$1" ] && [ -d "$1" ] || exit 1
[ -n "$2" ] || exit 1

virtualEnvDir="$1"
siteFqdn="$2"

cd "$virtualEnvDir" || exit 1

/usr/bin/env pipenv run certbot \
    -c "$virtualEnvDir"/config.ini \
    --config-dir "$virtualEnvDir" \
    --quiet \
    certonly \
    --cert-name "$siteFqdn" \
    -d "$siteFqdn"
