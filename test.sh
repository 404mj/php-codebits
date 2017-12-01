#!/bin/bash

a=$(ls | grep 1)
echo $?
echo ${a}
for aa in ${a[@]}
do
    echo $aa
done
echo ${a[0]}
