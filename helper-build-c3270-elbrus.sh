#!/usr/bin/env bash

# helper-build-c3270-elbrus.sh
#
# Helper to build suite3270 (c3270, x3270, etc) on Elbrus Linux
#
# The most recent version of this project can be obtained with:
#   git clone https://github.com/wrljet/hercules-helper.git
# or:
#   wget https://github.com/wrljet/hercules-helper/archive/master.zip
#
# Please report errors in this to me so everyone can benefit.
#
# Bill Lewis  bill@wrljet.com
#
#-----------------------------------------------------------------------------
#
# This works for me, but should be considered just an example
#
# PATH and LD_LIBRARY_PATH will need to be set

msg="$(basename "$0"):

This script will build and install Suite3270 on Elbrus Linux.

Your sudo password will be required.
"
echo "$msg"
read -p "Ctrl+C to abort here, or hit return to continue"

#-----------------------------------------------------------------------------
# Stop on errors and trace everything we do here
set -e
set -x

# FIXME: this doesn't work if this script is running off a symlink
SCRIPT_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")
SCRIPT_DIR="$(dirname $SCRIPT_PATH)"

# Create our work directory
mkdir -p ~/tools
cd ~/tools

wget http://x3270.bgp.nu/download/04.00/suite3270-4.0ga13-src.tgz
tar xfz suite3270-4.0ga13-src.tgz 
cd suite3270-4.0/

# Patch/replace config.guess with ones from Hercules-Helper
cp $SCRIPT_DIR/patches/config.{guess,sub} .

# Test config.guess
./config.guess 

# Configure package, enabling c3270, and point to a local install directory
./configure -C --enable-unix --enable-c3270 \
    --prefix=$HOME/tools \
    --bindir=$HOME/tools/bin \
    --sysconfdir=$HOME/tools/etc \
    --with-fontdir=$HOME/tools/fonts/3270

make clean && make -j 2
make install

