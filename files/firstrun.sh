#!/bin/sh

[ -n "$1" ] && [ -d "$1" ] || exit 1
[ -n "$2" ] || exit 1
[ -n "$3" ] || exit 1
[ -n "$4" ] || exit 1
[ -n "$5" ] || exit 1
[ -n "$6" ] || exit 1
[ -n "$7" ] || exit 1

virtualEnvDir="$1"
siteFqdn="$2"
email="$3"
pre_hook="$4"
post_hook="$5"
authenticator="$6"
webroot_paths="$7"
alt_names="$8"

actual_webroot_paths=$(printf '%s' "${webroot_paths##-w}")

if [ -z "$actual_webroot_paths" ]; then
    webroot_paths=''
fi

if [ -n "$alt_names" ]; then
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
    --pre-hook "\"$pre_hook\"" \
    --post-hook "\"$post_hook\"" \
    --authenticator "$authenticator" \
    "$webroot_paths"
