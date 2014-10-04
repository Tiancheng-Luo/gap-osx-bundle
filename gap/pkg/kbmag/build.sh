#!/bin/sh -ex

make clean
./configure
make COPTS="-O2 -g"

( cd $PREFIX && $BASEDIR/fix_install_names.sh $PREFIX $REL_PWD/bin/*/* )

# Cleanup leftovers which may contain the PREFIX path (and thus would
# trigger the code which detects hardcoded paths).
rm -rf src/.deps
rm -f config.log config.status Makefile
rm -rf autom4te.cache/
rm -rf doc/*.log