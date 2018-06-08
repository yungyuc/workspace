#!/bin/bash -x

mkdir -p ~/tmp

if [ -z "$SKIP_LIBEVENT" ]; then
  le_dn=libevent-2.1.8-stable
  le_fn=${le_dn}.tar.gz
  le_url=https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/$le_fn

  cd ~/tmp
  rm -rf $le_dn $le_fn
  wget -q $le_url
  tar xf $le_fn

  cd $le_dn
  ./configure \
    --prefix=$HOME/opt/libevent \
    --disable-shared \
    > configure.log 2>&1
  make > make.log 2>&1
  make install > install.log 2>&1
fi

if [ -z "$SKIP_NCURSES" ]; then
  nc_dn=ncurses-6.1
  nc_fn=${nc_dn}.tar.gz
  nc_url=https://ftp.gnu.org/pub/gnu/ncurses/$nc_fn

  cd ~/tmp
  rm -rf $nc_dn $nc_fn
  wget -q $nc_url
  tar xf $nc_fn

  cd $nc_dn
  ./configure \
    --prefix=$HOME/opt/ncurses \
    > configure.log 2>&1
  make > make.log 2>&1
  make install > install.log 2>&1
fi

if [ -z "$SKIP_TMUX" ]; then
  tmux_dn=tmux-2.7
  tmux_fn=${tmux_dn}.tar.gz
  tmux_url=https://github.com/tmux/tmux/releases/download/2.7/$tmux_fn

  cd ~/tmp
  rm -rf $tmux_dn $tmux_fn
  wget -q $tmux_url
  tar xf $tmux_fn

  export LDFLAGS="-L$HOME/opt/libevent/lib"
  export CFLAGS="-I$HOME/opt/libevent/include"

  export LDFLAGS="-L$HOME/opt/ncurses/lib $LDFLAGS"
  export CFLAGS="-I$HOME/opt/ncurses/include $CFLAGS"
  export CFLAGS="-I$HOME/opt/ncurses/include/ncurses $CFLAGS"

  export CPPFLAGS=$CFLAGS

  cd $tmux_dn
  ./configure \
    --prefix=$HOME/opt/tmux \
    > configure.log 2>&1
  make > make.log 2>&1
  make install > install.log 2>&1
fi
