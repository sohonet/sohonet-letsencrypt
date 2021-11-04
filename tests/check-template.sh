#!/bin/sh

if [ -z "$1" ]; then
    echo "usage: $0 <template-file-name>"
    echo "example: $0 firstrun.sh.epp"
    exit 1
fi

template_name="${1%%.sh.epp}"
export RUBYOPT="-W0"

render_check()
{
    current_check="$1"
    out_file="tests/output/$template_name-${current_check}.txt"

    bundle exec puppet epp render "templates/$template_name.sh.epp" --values_file "tests/input/$template_name-$current_check.pp" > "$out_file"

    if ! diff -u "tests/expected/$template_name-$current_check.sh" "$out_file"; then
        echo "Check: $current_check failed!"
        exit 1
    fi >&2
}

echo "Checking that $template_name.sh.epp renders with minimum parameters"; render_check minimum
echo "Checking that $template_name.sh.epp renders with added hooks"; render_check hooks
