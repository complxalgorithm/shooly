#!/bin/bash
echo Menu:
stop=0    # initialize loop termination flag
while test $stop -eq 0  # loop until exit
do
  cat << ENDOFMENU  # display menu
  1: List all files in working directory
  2: Print the date
  3: Print the current working directory
  4: Print users currently logged into server
  5: Display whether input is a file or a directory
  6: Exit
ENDOFMENU
echo
echo -n 'choice: '  # prompt
read reply  # read response
echo
case $reply in  # process response
  "1")
    ls -a   # display all files in working directory
    ;;
  "2")
    date  # display date
    ;;
  "3")
    pwd   # display current working directory
    ;;
  "4")
    who   # display all users who're logged into server
    ;;
  "5")
    echo "Type name of file: "
    read fileName
    if [ -f "$fileName" ]; then
      echo "This is a regular file."
    elif [ -d "$fileName" ]; then
      echo "This is a directory."
    else
      echo "This file/directory does not exist."
    endif
    ;;
  "6")
    echo "exited script"
    stop=1
    ;;
  *)
    echo illegal choice
    ;;
esac
echo
done
