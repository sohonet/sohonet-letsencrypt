#!/bin/sh

die()
{
    echo "$1" >&2; exit 1
}

if [ -z "$1" ]; then
    echo "usage: $0 <template-file-name> [check-name]"
    echo "example: $0 firstrun.sh.epp minimum"
    exit 1
fi >&2

template_name=$(basename -s .epp "$1")
shift

export RUBYOPT="-W0"

render_check()
{
    current_check="$1"
    out_file="tests/output/$template_name-${current_check}.txt"
    values_file="tests/input/$template_name-$current_check.pp"

    [ -r "$values_file" ] || die "$values_file not found or not readable"

    bundle exec puppet epp render "templates/$template_name.epp" --values_file "$values_file"  > "$out_file"

    if ! diff -u "tests/expected/$template_name-$current_check" "$out_file"; then
        echo "Check: $current_check failed!"
        exit 1
    fi >&2
}

if [ -z "$*" ]; then
    echo "Checking that $template_name.epp renders with minimum parameters"; render_check minimum
    echo "Checking that $template_name.epp renders with added hooks"; render_check hooks
    echo "Checking that $template_name.epp renders with added environment"; render_check env
    echo "Checking that $template_name.epp renders with added environment"; render_check webroot
else
    for check_name in "$@"; do
        echo "Checking that $template_name.epp renders for $check_name"; render_check "$check_name"
    done
fi
