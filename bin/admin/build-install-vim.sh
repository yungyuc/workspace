#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

vim_version=8.1
vim_dn=vim81
vim_fn=vim-$vim_version.tar.bz2
vim_url=ftp://ftp.vim.org/pub/vim/unix/$vim_fn

mkdir -p ~/tmp
cd ~/tmp
rm -rf $vim_dn $vim_fn
wget -q $vim_url
tar xf $vim_fn

cd $vim_dn
{ time ./configure --prefix=$HOME/opt/vim ; } > configure.log 2>&1
{ time make -j $NP ; } > make.log 2>&1
{ time make install ; } > install.log 2>&1
