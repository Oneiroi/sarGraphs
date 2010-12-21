#!/bin/bash

#GLOBALS
PHP=`which php`
SAR=`which sar`
sarTimeFormat=24
sarSwapCmd=''
sarNetworkSize='kb'
sarFile=''
reportType='all'
ARGS=''

#echo out usage report, does not exit so follow with prefered exit code
usage(){
	echo "Usage: $0 -f /path/to/sarfile -t report_type"
	echo "report_type: cpu, network, memory, load, io, swap, all"
}
#prerequesites, binaries and existing sar data.
prereq(){
	#check for binaries
	[[ ! -x "$PHP" ]] && { echo "PHP binary not found"; return 1 }
	[[ ! -x "$SAR" ]] && { echo "Sar binary not found"; return 1 }
	#check for data
	lCount=0
	#not using `` as causes fork, personal preference realy.
	$SAR | egrep "^[0-9]" | while read line; do (( lCount++ )); done
	[[ $lCount -le 2 ]] && { echo "Not enough SAR data, check the service is running"; return 1 }
	#getopt
	ARGS=`getopt f:t: $*`
	[[ $? != 0 ]] && {usage; return 1}
	return 0
}
setup(){
	#
	# get SAR time formart
	#
	lCount=0
	$SAR | egrep 'AM|PM' && sarTimeFormat=12 || sarTimeFormat=24
	#
	# Check if Swap usage is in Memory or Swap section
	#
	$SAR -r | grep -o '%swpused' && sarSwapCmd='sar -r' || sarSwapCmd='sar -S'
	#
	# Check if Network usage is in KB or Bytes
	#
	$sar -n DEV | grep -o 'rxbyt/s' && sarNetworkSize='byte' || sarNetworkSize='kb'		
}
#simple function echos out var values
debug(){
	echo "PHP:$PHP"
	echo "SAR:$SAR"
	echo "sarTimeFormat:$sarTimeFormat"
	echo "sarSwapCmd:$sarSwapCmd"
	echo "sarNetworkSize:$sarNetworkSize"
	echo "sarFile:$sarFile"
	echo "reportType:$reportType"
	echo "ARGS:$ARGS"
}
main(){
	#abort if prereq's failed
	[[ ! prereq ]] && exit 1;
	setup
	debug	
}
