#!/bin/bash
scratch=$(mktemp -d -t tmp.XXXXXXXXXX) || exit
rm -rf $scratch/*
git clone http://github.com/yungyuc/workspace $scratch
mv $scratch/.git ~/
git checkout -- .
