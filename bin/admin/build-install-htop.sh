#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

htop_version=2.2.0
htop_dn=htop-$htop_version
htop_fn=$htop_dn.tar.gz
htop_url=http://hisham.hm/htop/releases/$htop_version/$htop_fn

mkdir -p ~/tmp
cd ~/tmp
rm -rf $htop_dn $htop_fn
wget -q $htop_url
tar xf $htop_fn

cd $htop_dn
{ time ./configure --prefix=$HOME/opt/htop ; } > configure.log 2>&1
{ time make -j $NP ; } > make.log 2>&1
{ time make install ; } > install.log 2>&1
