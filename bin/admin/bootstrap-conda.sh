#!/bin/bash

mkdir -p ${HOME}/tmp/miniconda
cd ${HOME}/tmp/miniconda

miniconda3=Miniconda3-latest-Linux-x86_64.sh
if [[ ! -f $miniconda3 ]]; then
  echo "Download from http://repo.continuum.io/miniconda/$miniconda3"
  wget --quiet http://repo.continuum.io/miniconda/$miniconda3
fi
if [[ `which conda` != "${HOME}/opt/conda3/bin/conda" ]]; then
  bash $miniconda3 -b -p ${HOME}/opt/conda3
fi

miniconda2=Miniconda2-latest-Linux-x86_64.sh
if [[ ! -f $miniconda2 ]]; then
  echo "Download from http://repo.continuum.io/miniconda/$miniconda2"
  wget --quiet http://repo.continuum.io/miniconda/$miniconda2
fi
if [[ `which conda` != "${HOME}/opt/conda2/bin/conda" ]]; then
  bash $miniconda2 -b -p ${HOME}/opt/conda2
fi
