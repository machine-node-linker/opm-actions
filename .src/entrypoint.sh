#!/bin/bash -- 

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

### Set input args to variable array for manipulation
IN=($@)

debug "Received Args: ${IN[*]}"

### Set OUT to last item in input args
OUT=${IN[${#IN[@]}-1]}

echo ::debug::Set output variable to $OUT
### Unset last arg from IN, removing it from array
unset 'IN[${#IN[@]}-1]'

declare -a ARGS
COMMAND=${IN[0]}
LAST_ARG=""

function check_file() {
    if [ -f $1 ]; then
        add_args $LAST_ARG $1
    else
        debug "File $1 not found, skipping $LAST_ARG"
        LAST_ARG=""
    fi
}

function add_args() {
    ARGS+=($@)
    LAST_ARG=""
    debug "Updated ARGS: ${ARGS[*]}"
}


for arg in ${IN[*]}
do

    if [[ $arg == @("--"*|-[:alpha:]) ]]; then
        if [ -n $LAST_ARG]; then
            add_args $LAST_ARG
        fi
        # IF an arg is the value attached with =, split them
        if [[ "$arg" == *"="* ]]; then
            LAST_ARG=${arg%=*}
            arg=${arg#*=}
        else
            LAST_ARG=$arg
            continue
        fi
    fi

    # If last arg indicates a filename,  test for its existence before adding them
    case $COMMAND in
        "init")
            case $LAST_ARG in
                "--icon"|"-i")
                    check_file $arg;;
                "--description"|"-d")
                    check_file $arg;;
                *)
                    add_args $LAST_ARG $arg;;
            esac;;
        "validate")
            case $LAST_ARG in
                "validate")
                    check_file $arg;;
                *)
                    add_args $arg;;
            esac;;
        "alpha")
            case $LAST_ARG in
                "semver")
                    check_file $arg;;
                *)
                    add_args $LAST_ARG
                    LAST_ARG=$arg;;
            esac;;
        *)
            add_args $LAST_ARG $arg;;
    esac
done
if [ -n $LAST_ARG ]; then
    add_args $LAST_ARG
fi

debug "Final Args ${ARGS[*]}"

if [ ${#ARGS[@]} -eq 0 ]; then
    echo "No Arguements passed to OPM." 1>&2
    exit 1
fi
### Set OPM output to github output based on name captured earlier

output=$(/bin/opm ${ARGS[*]}|jq -crM)
echo "::set-output name=$OUT::$output"
exit 0
