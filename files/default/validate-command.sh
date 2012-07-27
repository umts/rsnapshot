#!/bin/bash

case "$SSH_ORIGINAL_COMMAND" in
  *\&*|*\(*|*\{*|*\;*|*\<*|*\`*)
    echo "Connection closed."
  ;;
  rsync\ --server*)
    sudo $SSH_ORIGINAL_COMMAND
  ;;
  *)
    echo "Connection closed."
  ;;
esac
