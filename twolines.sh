#!/bin/bash
#
#
#  Print two lines before and after matching line
#
#

if [ ${#@} -lt 2 ]; then
    echo
    echo Usage: $0 regex datafile
    echo
    exit 1
fi

regex=$1
datafile=$2

__trace_ON__

arr=() flag=0
while read -r line; do  
    if [[ $line =~ $regex ]]; then 
        if [ $flag -eq 0 ]; then
            echo ${arr[0]}
            echo ${arr[1]}
        fi
        echo $line
        flag=2
    else
#__trace_ON__
        arr[0]=${arr[1]}
        arr[1]=$line
        if [ $flag -gt 0 ]; then
            echo $line
            let flag--
            : :: flag = $flag
        fi
#__trace_OFF__
    fi  
done < "$datafile"

