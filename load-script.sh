#!/bin/bash

source /root/bin/setup.conf

printf "\nStart loading front-end resources\n\n"

printf "\ncomposer resources\n\n"

. /root/bin/scripts/back-end-build-chain.sh

printf "\nnpm resources\n\n"

. /root/bin/scripts/front-end-build-chain.sh

printf "\nConfigure sentinel\n\n"

. /root/bin/scripts/sentinel-db-setup.sh
. /root/bin/scripts/implement-sentinel.sh