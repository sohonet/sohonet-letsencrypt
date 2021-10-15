#!/bin/sh

[ -n "$1" ] && [ -d "$1" ] || exit 1

virtualEnvDir="$1"

"$virtualEnvDir"/certbot \
    -c "$virtualEnvDir"/config.ini \
    --config-dir "$virtualEnvDir" \
    --keep-until-expiring \
    --quiet \
    renew \
    --rsa-key-size 4096 \
    -a dns-route53 \
    --cert-name '*.internal.sohonet.com' \
    -d '*.internal.sohonet.com' \
    --dns-route53-propagation-seconds 10 \
    --preferred-chain "ISRG Root X1"
