#!/bin/bash -- 

### Set input args to variable array for manipulation
IN=($@)


### Set OUT to last item in input args
OUT=${IN[${#IN[@]}-1]}

### Unset last arg from IN, removing it from array
unset 'IN[${#IN[@]}-1]'

declare -a ARGS
COMMAND=${IN[0]}
LAST_ARG=""

function check_file() {
    if [ -f $1 ]; then
        add_args $LAST_ARG $1
    else
        LAST_ARG=""
    fi
}

function add_args() {
    ARGS+=($@)
    LAST_ARG=""
}


for arg in ${IN[*]}
do
    if [[ $arg == @("--"*|-[:alpha:]) ]]; then
        if [ -n $LAST_ARG]; then
            add_args $LAST_ARG
            continue
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
                "--icon"|"-d")
                    check_file $arg;;
                "--description|-d")
                    check_file $arg;;
                *)
                    add_args $LAST_ARG $arg;;
            esac;;
        "validate")
            check_file $arg;;
        *)
            add_args $LAST_ARG $args
    esac
done

### Set OPM output to github output based on name captured earlier
echo ::set-output name=$OUT::$(/bin/opm ${ARGS[*]})
exit $?
