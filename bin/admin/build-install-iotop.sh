#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

iotop_version=0.6
iotop_dn=iotop-$iotop_version
iotop_fn=$iotop_dn.tar.bz2
iotop_url=http://guichaz.free.fr/iotop/files/$iotop_fn

mkdir -p ~/tmp
cd ~/tmp
rm -rf $iotop_dn $iotop_fn
wget -q $iotop_url
tar xf $iotop_fn

cd $iotop_dn
{ time python setup.py install --user ; } > install.log 2>&1
