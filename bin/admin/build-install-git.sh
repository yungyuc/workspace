#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

git_dn=git-2.17.1
git_fn=v2.17.1.tar.gz
git_url=https://github.com/git/git/archive/$git_fn

mkdir -p ~/tmp
cd ~/tmp
rm -rf $git_dn $git_fn
wget -q $git_url
tar xf $git_fn

cd $git_dn
make configure
{ time ./configure --prefix=$HOME/opt/git ; } > configure.log 2>&1
{ time make -j $NP ; } > make.log 2>&1
{ time make install ; } > install.log 2>&1
