#!/bin/bash

comm="ls somefile"
runs=5
counter=1
rest=3


while [ $counter -le $runs ]; do
  printf "\rAttemp $counter ..."
  out_p=$($comm 2>&1) #Capture stdout and stderr
  exitcode=$? #Capture the exit code

  #Exit with code zero if successful
  if [ $exitcode -eq 0 ]; then
    echo
    echo "Success --> $out_p"
    exit 0

  #Print out the error message if failed in the last attempt
  elif [ $counter -eq $runs ]; then
    echo
    echo "Failed --> $out_p"
    exit 2
  fi
  ((counter+=1))
  sleep $rest
done
