#!/bin/bash

# This script uses the linode cli package on your local machine to
# rebuild your remote machine-- which I am doing a lot as I am going
# through the configurations

# https://www.linode.com/docs/platform/linode-cli
# https://github.com/linode/cli

LINODELABEL="rust-belt-rebellion"
DISTRIBUTION="Debian 8.1"
PASSWORD="ffff4444"


linode stop "$LINODELABEL"

linode rebuild $LINODELABEL --distribution "$DISTRIBUTION" --password "$PASSWORD"

linode start "$LINODELABEL"
