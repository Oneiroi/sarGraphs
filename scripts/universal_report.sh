#!/bin/bash

req(){
	#check for binaries
	php=`which php`
	sar=`which sar`
	[[ ! -x "$php" ]] && echo "PHP Binary not found" && return 1
	[[ ! -x "$sar" ]] && echo "Sar bianry not found" && return 1
	#check for data
	lCount=0
	#not using `` as causes fork, personal reference realy.
	$sar | egrep "^[0-9]" | while read line; do (( lCount++ )); done
	#getopt
	args=`getopt f:t: $*`
	[[ $? != 0 ]] && echo "Usage: $0 -f /path/to/sarfile -t report_type (cpu, network, memory, load, io, swap, all)" && return 0
	return 0
}

