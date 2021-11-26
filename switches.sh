#!/bin/bash

function show_usage (){
  printf "Usage: [options] Command\n"
  printf "\n"
  printf "Options:\n"
  printf " -n Number of runs\n"
  printf " -i Seconds before next try\n"

return 0
}

if [ "$1" == "--help" ] || [ "$1" == "-h" ];then
  show_usage
elif [ $* -eq 0 ]; then
  echo "Please provide a command to try."
  Exit 1
else
  while [ -n "$1" ]; do
    case $1 in
    -n)
      shift
      numofRuns=$1
      echo $numofRuns
      ;;
    -i)
      shift
      interval=$1
      echo $interval
      ;;
    *)
      comm=$*
      echo $comm
    esac
    shift
  done
fi

