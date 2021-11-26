#!/bin/bash

comm="ls"
runs=5
counter=1
rest=3


while true; do
  printf "\rAttempt $counter of $runs ..."
  out_p=$($comm 2>&1) #Capture stdout and stderr
  exitcode=$? #Capture the exit code

  #Exit with code zero if successful
  if [ $exitcode -eq 0 ]; then
    echo
    echo "$out_p"
    exit 0

  #Print out the error message if failed at the last attempt
  elif [ $counter -eq $runs ]; then
    echo
    echo "Failed --> $out_p"
    exit 2
  fi
  ((counter+=1))
  sleep $rest
done
