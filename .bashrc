# Add two functions to shell namespace: namemunge() and source_if()

umask 002

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# locale.
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"
# set default editor.
export EDITOR=vim

# set a fancy prompt (non-color, unless we know we "want" color)
if [ -f ~/etc/git-prompt.bash ] && [ -n "which git" ] ; then
  source ~/etc/git-prompt.bash
  PS1='\u@\h \D{%Y-%m-%d %T} [\!]\n\w $(__git_ps1 "(%s)")\n\$ '
else
  PS1='\u@\h \D{%Y-%m-%d %T} [\!]\n\w\n\$ '
fi

# determine ls color.
arch=`uname`
if [ "$TERM" != "dumb" ]; then
  if [ $arch == "Linux" ]; then
    if [ -f ~/.dir_colors ]; then
      eval "`dircolors -b ~/.dir_colors`"
    else
      eval "`dircolors -b`"
    fi
  elif [ $arch == "FreeBSD" ]; then
    export LSCOLORS="Exfxcxdxbxegedabagacad"
  elif [ $arch == "Darwin" ]; then
    export CLICOLOR=1
    export LSCOLORS="Exfxcxdxbxegedabagacad"
  fi
fi

# path munge.
namemunge () {
  if ! echo ${!1} | egrep -q "(^|:)$2($|:)" ; then
    if [ -z "${!1}" ] ; then
      eval "$1=$2"
    else
      if [ "$3" == "after" ] ; then
        eval "$1=\$$1:$2"
      else
        eval "$1=$2:\$$1"
      fi
    fi
  fi
  eval "export $1"
}

# see http://stackoverflow.com/a/370192/1805420
nameremove () {
  eval "export $1=$(echo -n ${!1} | awk -v RS=: -v ORS=: -v var="$2" '$0 != var' | sed 's/:*$//')"
}

namemunge PATH /sbin
namemunge PATH /usr/sbin
namemunge PATH /usr/local/sbin
namemunge PATH $HOME/opt/bin
namemunge PATH $HOME/opt/local/bin
alias optlocaloff='nameremove PATH $HOME/opt/local/bin'
namemunge PATH $HOME/.local/bin
namemunge PATH $HOME/bin
namemunge PATH $HOME/self/bin
if [ $arch != "Darwin" ]; then
  namemunge LD_LIBRARY_PATH ~/opt/lib
else
  namemunge DYLD_LIBRARY_PATH ~/opt/lib
fi

source_if () {
  test -f "$1" && source "$1"
}

# source_if more scripts.
source_if ~/.bashrc_aliases
source_if ~/self/etc/dot_bashrc

# git
source_if ~/etc/git-completion.bash

# docker
if [ $arch == "Darwin" ]; then
  docker_etc=/Applications/Docker.app/Contents/Resources/etc/
fi
source_if ${docker_etc}/docker.bash-completion
source_if ${docker_etc}/docker-machine.bash-completion
source_if ${docker_etc}/docker-compose.bash-completion

# account specific settings goes here.
source_if ~/.bash_acct

# vim: set et nu nobomb fenc=utf8 ft=sh ff=unix sw=2 ts=2:
