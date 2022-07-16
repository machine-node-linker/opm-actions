#!/bin/bash -- 

IN=($@)

OUT=${IN[${#IN[@]}-1]}

unset 'IN[${#IN[@]}-1]'

output=$(/bin/opm ${IN[*]})

echo ::set-output name=$OUT::$output

