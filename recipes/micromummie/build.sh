#!/usr/bin/env bash

mkdir -p $PREFIX/lib/perl5/
mkdir -p $PREFIX/bin

for script in $( ls bin/*pl ); do
    sed -i "2i use lib '$PREFIX/lib/perl5/micromummie_perlLib';" $script;
done

chmod +x bin/* micromummie_perlLib/*

mv bin/*  $PREFIX/bin
mv micromummie_perlLib $PREFIX/lib/perl5/
