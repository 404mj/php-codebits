#!/bin/bash
declare -a products
products=(brand vstar official vzixin)
for p in ${products[@]}
do
    if [ "$p"x = "official"x ];then
        echo "this is official"
    else
        echo "not official"
    fi
done
