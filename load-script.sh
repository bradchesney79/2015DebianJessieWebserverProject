#!/bin/bash

source /root/bin/setup.conf

printf "\nStart loading front-end resources\n\n"

. /root/bin/scripts/back-end-build-chain.sh

. /root/bin/scripts/front-end-build-chain.sh

. /root/bin/scripts/sentinel.sh