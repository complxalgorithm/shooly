#!/bin/csh
if ( ($#argv == 0) ) then
  echo “Error: Please pass in an argument.”
  exit 1
endif
if ( (-f $argv[1] && -z $argv[1]) ) then    # if file is empty then delete it
  rm $argv[1]
  echo $argv[1] was removed
  exit 0
endif
if (-d $argv[1]) then
  echo this is a directory with the path:
  echo $PATH
  exit 0
endif
if (-f $argv[1]) then
  echo this is a file
  set filename = $argv[1]
  set fileInfo = `ls –il $fileName`
  set size = $fileInfo[6]
  set linkCount = $fileInfo[3]
  set owner = $fileInfo[4]
  set date = “$fileInfo[7] $fileInfo[8] $fileInfo[9]”
  echo “Filename: $fileName\n Size: $size\n Link Count: $linkCount\n Owner: $owner\n Date: $date”
  exit 0
endif
echo “$0: illegal choice”
exit 1
