#!/bin/bash -x

mkdir -p ~/tmp

ag_dn=the_silver_searcher-2.1.0
ag_fn=2.1.0.tar.gz
ag_url=https://github.com/ggreer/the_silver_searcher/archive/2.1.0.tar.gz

cd ~/tmp
rm -rf $ag_dn $ag_fn
wget -q $ag_url
tar xf $ag_fn

cd $ag_dn
./autogen.sh
./configure \
  --prefix=$HOME/opt/ag \
  > configure.log 2>&1
make > make.log 2>&1
make install > install.log 2>&1
