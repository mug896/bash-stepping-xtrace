## Bash stepping xtrace


Bash script that debug bash scripts and functions by stepping xtrace

[![Imgur](http://i.imgur.com/UcwgiFP.png)](https://youtu.be/GiBrChzc7UE)


## Installation

Copy **xtrace.sh** to $HOME/bin


## Usage

>xtrace.sh command arg1 arg2 ...

```bash
# Example 1 : shell script trace

$ xtrace.sh ./twolines.sh "linux" data.txt


# Example 2 : shell function trace

$ f1() { __trace_ON__; echo $1; date; echo $2 ;}
$ export -f f1
$ xtrace.sh f1 111 222
```


Place `__trace_ON__`, `__trace_OFF__` in the scripts and functions that you want to debug

1 . If you want debug whole script then just place `__trace_ON__` on the top of the script

```bash
#!/bin/bash

__trace_ON__

arr=() flag=0
while read -r line; do  
    if [[ $line =~ $regex ]]; then 
        if [ $flag -eq 0 ]; then
            echo ${arr[0]}
            echo ${arr[1]}
...
...
```
2 . If you want debug script partially then place `__trace_ON__` , `__trace_OFF__` appropriately

```bash
#!/bin/bash
...
...
        echo $line
        flag=2
    else
__trace_ON__
        arr[0]=${arr[1]}
        arr[1]=$line
        if [ $flag -gt 0 ]; then
            echo $line
            let flag--
            : :: flag = $flag
        fi
__trace_OFF__
    fi  
done < "$datafile"
...
...
```

3 . Stepping key : <kbd>Enter</kbd>

4 . Exit key : <kbd>Ctrl-c</kbd>


