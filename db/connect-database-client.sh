#!/bin/sh

# working dir fix
SCRIPT_FOLDER=$(cd $(dirname "$0"); pwd)
cd $SCRIPT_FOLDER

../redis-2.6.13/src/redis-cli -a D0m0b12idG3-p4s5w012d -p 7379
