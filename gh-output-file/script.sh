#!/bin/bash


function debug() {
    echo "::debug::$@"
}

function error() {
    echo "::error::$@"
    exit 1
}

trap error ERR
set -e
set -E

output="$(cat $FILE)"
debug "raw file contents: $output"

truthy=('true', 'True', 'yes', 'Yes', '1')
if [[ ${truthy[*]} == *"$B64"* ]]; then
    output=$(echo -n $output | base64)
    debug "base64 file contents: $output"
fi

output="${output//'%'/'%25'}"
output="${output//$'\n'/'%0A'}"
output="${output//$'\r'/'%0D'}"
debug "gh output encoded file contents: $output" 
echo "output=$output" >> $GITHUB_OUTPUT
