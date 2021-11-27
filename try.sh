#!/bin/bash

function show_usage (){
  printf "Usage: [options] Command\n"
  printf "Options:\n"
  printf "	-n Number of attempts\n"
  printf "	-i Seconds before next attempt\n"

return 0
}

function try (){
#This functions receives 3 argument:
#number of runs, interval, and a command
#and tries executing the command accordingly
#On Failing at the last attempt, it ends with an error

numOfRuns=$1
interval=$2
tryComm=$3

counter=1
printf "Command: $tryComm\n"
printf "Try interval: $interval seconds\n"
while true; do
  printf "\rAttempt $counter of $numOfRuns ..."
  out_p=$($tryComm 2>&1) #Capture stdout and stderr
  exitcode=$? #Capture the exit code

  #Exit with code zero if successful
  if [ $exitcode -eq 0 ]; then
    echo
    echo "Succsess -->"
    echo "$out_p"
    exit 0

  #Print out the error message if failed at the last attempt
  elif [ $counter -eq $numOfRuns ]; then
    echo
    echo "Failed --> $out_p"
    exit 1
  fi
  ((counter+=1))
  sleep $interval
done
}

#Captures the options, verifies that they
# are integers and stores them in variables
while getopts ":i:n:h" opt; do
	case ${opt} in
			h)
				show_usage
				exit 0
				;;
			i)
        if [[ $OPTARG =~ ^[0-9]+$ ]]; then
          intervalOp=$OPTARG
        else
          echo "-i requires a positive integer"
          exit 1
        fi
				;;
			n)
        if [[ $OPTARG =~ ^[0-9]+$ ]]; then
          numOfRunsOp=$OPTARG
        else
          echo "-i requires a positive integer"
          exit 1
        fi
				;;
			\?)
				show_usage
				exit 1
				;;
			:)
				echo "Invalid option. $OPTARG requires an argument."
	esac
done
shift $((OPTIND-1))

#Verify if a command has been passed to the script
#and it exists in $PATH
which $1 &>/dev/null
if [[ -z "$*" || $? -ne 0 ]]; then
  echo "A command has not been passed or it does not exist in PATH."
  show_usage
  exit 1
else
  tryComm="$*"
fi

#Setting the source for numOfRuns variable
if [ -n "$numOfRunsOp" ]; then
  numOfRuns=$numOfRunsOp
elif [[ -n "$TRY_NUMBER" && "$TRY_NUMBER" != "NULL" ]]; then
  numOfRuns=$TRY_NUMBER
else
  numOfRuns=12
fi

#Setting the source for try interval variable
if [ -n "$intervalOp" ]; then
  interval=$intervalOp
elif [[ -n "$TRY_INTERVAL" && "$TRY_INTERVAL" != "NULL" ]]; then
  interval=$TRY_INTERVAL
else
  interval=5
fi

#Calls the try function and passes the arguments
try $numOfRuns $interval "$tryComm"
