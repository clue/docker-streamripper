#!/bin/bash

if [ $# -gt 0 ]; then
  # append relay config if any parameters are given
  streamripper "$@" -r 8000 -R 0
else
  # otherwise, default to no args (=> help output)
  streamripper
fi
