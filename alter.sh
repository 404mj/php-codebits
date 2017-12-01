#!/bin/bash

ids=$(awk -F "\n"  'BEGIN {ORS=","} { print $1}' userids.log)
userids="("${ids:0:3453}")"
sub=$(echo ${#ids} - 1 | bc )
echo $userids
