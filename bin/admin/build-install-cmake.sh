#!/bin/bash -x
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

cmake_vminor=3.11
cmake_vpatch=3
cmake_dn=cmake-$cmake_vminor.$cmake_vpatch
cmake_fn=$cmake_dn.tar.gz
cmake_url=https://cmake.org/files/v$cmake_vminor/$cmake_fn

mkdir -p ~/tmp
cd ~/tmp
rm -rf $cmake_dn $cmake_fn
curl -sSL -o $cmake_fn $cmake_url
tar xf $cmake_fn

cd $cmake_dn
{ time ./configure --prefix=$HOME/opt/cmake ; } > configure.log 2>&1
{ time make -j $NP ; } > make.log 2>&1
{ time make install ; } > install.log 2>&1
