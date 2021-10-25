#!/bin/sh

[ -n "$1" ] && [ -d "$1" ] || exit 1
[ -n "$2" ] || exit 1
[ -n "$3" ] || exit 1
[ -n "$4" ] || exit 1
[ -n "$5" ] || exit 1

virtualEnvDir="$1"
siteFqdn="$2"
email="$3"
pre_hook="$4"
post_hook="$5"

if [ -n "$6" ]; then
    alt_names="$6"
    siteFqdn="$siteFqdn,$alt_names"
fi

cd "$virtualEnvDir" || exit 1

/usr/bin/env pipenv run certbot \
    -c "$virtualEnvDir"/config.ini \
    --quiet \
    certonly \
    --cert-name "$siteFqdn" \
    -d "$siteFqdn" \
    --agree-tos \
    --email "$email" \
    --pre-hook "$pre_hook" \
    --post-hook "$post_hook"
