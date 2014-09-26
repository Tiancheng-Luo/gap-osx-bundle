#!/bin/sh -ev

make install

rm -f $PREFIX/lib/libflint.a

for name in libflint.dylib ; do
    install_name_tool -id @rpath/$name $PREFIX/lib/$name
    #install_name_tool -rpath $PREFIX/lib "../Resources/lib" $PREFIX/lib/$name
done

install_name_tool -add_rpath "../Resources/lib" $PREFIX/lib/libflint.dylib

# TODO: libflint.dylib references the file
#    $PREFIX/share/flint/CPimport.txt
