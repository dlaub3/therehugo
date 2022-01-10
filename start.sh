#!/usr/bin/env bash

usage() {
  echo "Usage ${0} [-p] [-d]" 1>&2
  echo "-p production"
  echo "-d development"
  echo "$@"
  echo "$AGRV"
  exit 1
}

while getopts :dp OPTION
do 
  case ${OPTION} in 
    d) 
      MODE="DEV"
      echo "DEV Mode"
      ;;
    p) 
      MODE="PROD"
      echo "PROD Mode"
      ;;
    ?)
      usage
      ;;
  esac
done

if [[ "$MODE" == "PROD" ]]
then
  hugo server --watch --ignoreCache --config config.toml --environment=production
elif [[ "$MODE" == "DEV" ]]
then
  cd themes/awayhugo
  npm run hugo-watch & tmux split-window -p 50 -h bash -c "npm run gulp-watch"
else
  usage
fi

