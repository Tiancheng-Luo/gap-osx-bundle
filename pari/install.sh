#!/bin/sh -ev

make install

VER=$(echo $VERSION | cut -f1-2 -d.)

install -m 755 -d "$PREFIX/etc/"
install -m 644 "misc/gprc.dft" "$PREFIX/etc/"
install -m 644 "misc/gpalias" "$PREFIX/etc/"

cd "$PREFIX"
rm lib/pari/pari.cfg
mv bin/gp-$VER bin/gp-$VER-real
install -m 755 "$BASEDIR/pari/gp.sh" bin/gp-$VER

# remove more files hard coding build path
# TODO: can/should we instead adjust them somehow?
rm -f "$PREFIX"/share/pari/doc/paricfg.tex
rm -f "$PREFIX"/share/pari/examples/Makefile
