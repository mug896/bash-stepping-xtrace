#!/bin/bash

#############################################################
#                                                           #
#   This script is for /bin/bash shell scripts              #
#   You can't use this script with /bin/sh shell scripts    #
#                                                           #
#############################################################

trap 'exec 2> /dev/null
    rm -f $mypipe
    kill $print_pid
    pkill -g $target_pid'   EXIT

mypipe=/tmp/mypipe_$$
mkfifo $mypipe

#####  Check usage

if [ ${#@} -eq 0 ]; then
    echo
    echo Usage: "$(basename $0)" command arg1 arg2 ...
    echo
    exit 1
else
    target_command=$1
    shift
fi


#####  Trace functions

__trap_debug__() {
    set -o monitor
    suspend -f
    
    # This enable stepping in subshell.                       
    # If you don't want stepping in subshell then comment it out.
    set +o monitor 
}

__trace_ON__() {
    echo --------- trace ON -----------
    set -o xtrace -o functrace 
    trap __trap_debug__ DEBUG
}
__trace_OFF__() {
    trap - DEBUG
    set +o xtrace +o functrace 
    echo --------- trace OFF -----------
}

export -f __trace_ON__ __trace_OFF__ __trap_debug__


#####  Prompt for xtrace

export PS4='+\[\e[0;32m\]:\[\e[0;49;95m\]${LINENO}\[\e[0;32m\]:${FUNCNAME[0]:+${FUNCNAME[0]}(): }\[\e[0m\]'


#####  Read from pipe and print xtrace

while read -r line; do
    case $line in
        *__trace_OFF__* )  continue ;;
        *__trap_debug__* )  continue ;;
    esac
    echo "$line" >& 2
done < $mypipe &

print_pid=$!


#####  Excute target command

# disable suspend
set -o monitor

# enable tracing for shell function
bash -c "$target_command"' "$0" "$@"' "$@" &> $mypipe & 

target_pid=$!


#####  Trace !

while read line; do  
    if kill -0 $target_pid 2> /dev/null; then
        fg %% > /dev/null
    else
        exit
    fi
done 
