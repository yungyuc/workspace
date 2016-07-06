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
  PS1='\u@\h[\!]:\w$(__git_ps1 "(%s)")\n\$ '
else
  PS1='\u@\h[\!]:\w\n\$ '
fi

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

namemunge PATH /sbin
namemunge PATH /usr/sbin
namemunge PATH /usr/local/sbin
namemunge PATH $HOME/opt/bin
namemunge PATH $HOME/.local/bin
namemunge PATH $HOME/bin
namemunge PATH $HOME/self/bin
if [ `uname` != "Darwin" ]; then
  namemunge LD_LIBRARY_PATH ~/opt/lib
else
  namemunge DYLD_LIBRARY_PATH ~/opt/lib
fi

# include more scripts.
if [ -f ~/.bashrc_aliases ]; then source ~/.bashrc_aliases; fi
if [ -f ~/self/etc/dot_bashrc ]; then source ~/self/etc/dot_bashrc; fi

# conda.
alias use.conda3="namemunge PATH ~/opt/conda3/bin"
alias use.conda2="namemunge PATH ~/opt/conda2/bin"
if [ -d ~/opt/conda3/bin ]; then use.conda3; fi

# git
if [ -f ~/etc/git-completion.bash ]; then source ~/etc/git-completion.bash; fi

# google-cloud-sdk
if [ -d ~/opt/google-cloud-sdk/bin ]; then
  namemunge PATH ~/opt/google-cloud-sdk/bin
fi
if [ -f ~/opt/google-cloud-sdk/completion.bash.inc ]; then
  source ~/opt/google-cloud-sdk/completion.bash.inc
fi

alias gcei="gcloud compute instances"

gceipof() {
  gcloud compute instances describe $1 | grep natIP | cut -d ' ' -f 6
}

gce_set_instance_ip() {
  worker=${1:-worker}
  export GCE_INSTANCE_IP=`gceipof $worker`
  echo "GCE_INSTANCE_IP=$GCE_INSTANCE_IP"
}

gce_create_instance() {
  instname=${1:-worker}
  machtype=${2:-n1-standard-1}
  startup=$(mktemp -t gcp.startup.XXXXXXXXXX.sh) || exit
  cat << EOF >> $startup
timedatectl set-timezone Asia/Taipei
apt-get install -y git build-essential liblapack-pic liblapack-dev
rm -f clone_and_go
wget -q https://raw.githubusercontent.com/yungyuc/workspace/master/bin/admin/bootstrap-workspace.sh
chmod a+rx bootstrap-workspace.sh
mv bootstrap-workspace.sh /var/lib
EOF
  echo "Startup file:"
  cat $startup | sed -e "s/^/  /"
  cmd="gcloud compute instances create $instname --machine-type $machtype \
    --zone asia-east1-c --image-family ubuntu-1404-lts \
    --image-project ubuntu-os-cloud --boot-disk-size 10GB \
    --metadata-from-file startup-script=$startup"
  echo $cmd
  $cmd
  rm -f $startup
  cmd="gce_set_instance_ip $instname"
  echo $cmd
  $cmd
}

alias gcessh="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
alias gcescp="scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

# account specific settings goes here.
if [ -f ~/.bash_acct ]; then source ~/.bash_acct; fi

# vim: set et nu nobomb fenc=utf8 ft=sh ff=unix sw=2 ts=2:
