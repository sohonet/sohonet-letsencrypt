#!/bin/sh

[ -n "$1" ] && [ -d "$1" ] || exit 1
[ -n "$2" ] || exit 1
[ -n "$3" ] || exit 1
[ -n "$4" ] || exit 1

virtualEnvDir="$1"
siteFqdn="$2"
pre_hook="$3"
post_hook="$4"

cd "$virtualEnvDir" || exit 1

/usr/bin/env pipenv run certbot \
    -c "$virtualEnvDir"/config.ini \
    --keep-until-expiring \
    --quiet \
    renew \
    --cert-name "$siteFqdn" \
    --pre-hook "$pre_hook" \
    --post-host "$post_hook"
