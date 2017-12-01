#!/bin/bash

declare -A products
products=(['brandvzixinvstar']="huamnaudit.log" 
        ['official']="audit_callback.log"  
        [filter]="grep Body" 
        [official_filter]="grep AUDITMSG"
        )

for key in ${!products[*]}
do
    echo "$key -> ${products[$key]}"
done
echo ${products['official']}
