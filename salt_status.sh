#!/bin/bash
function ping {
/usr/bin/ps -ef | grep -v grep | grep -i salt | wc -l    
}

$1
