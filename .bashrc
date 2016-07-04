umask 002

#[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# set a fancy prompt (non-color, unless we know we "want" color)
if [ -f ~/etc/git-prompt.bash ] && [ -n "which git" ] ; then
  source ~/etc/git-prompt.bash
  PS1='\u@\h[\!]:\w$(__git_ps1 "(%s)")\n\$ '
else
  PS1='\u@\h[\!]:\w\n\$ '
fi
# locale.
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"
# set default editor.
export EDITOR=vim

# determine ls color.
ARCH=`uname`
if [ "$TERM" != "dumb" ]; then
  if [ $ARCH == "Linux" ]; then
    if [ -f ~/.dir_colors ]; then
      eval "`dircolors -b ~/.dir_colors`"
    else
      eval "`dircolors -b`"
    fi
  elif [ $ARCH == "FreeBSD" ]; then
    export LSCOLORS="Exfxcxdxbxegedabagacad"
  elif [ $ARCH == "Darwin" ]; then
    export CLICOLOR=1
    export LSCOLORS="Exfxcxdxbxegedabagacad"
  fi
fi
unset ARCH

# include more scripts.
if [ -f ~/.bashrc_env ]; then source ~/.bashrc_env; fi
if [ -f ~/.bashrc_aliases ]; then source ~/.bashrc_aliases; fi
if [ -f ~/.bashrc_path ]; then source ~/.bashrc_path; fi
if [ -f ~/etc/git-completion.bash ]; then source ~/etc/git-completion.bash; fi

# account specific settings goes here.
if [ -f ~/.bash_acct ]; then source ~/.bash_acct; fi

# vim: set et nu nobomb fenc=utf8 ft=sh ff=unix sw=2 ts=2 tw=76:
