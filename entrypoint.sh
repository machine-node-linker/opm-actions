#!/bin/bash -- 

### Set input args to variable array for manipulation
IN=($@)


### Set OUT to last item in input args
OUT=${IN[${#IN[@]}-1]}

### Unset last arg from IN, removing it from array
unset 'IN[${#IN[@]}-1]'

### Capture stdout of opm
output=$(/bin/opm ${IN[*]})

### Set OPM output to github output based on name captured earlier
echo ::set-output name=$OUT::$output

