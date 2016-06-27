#!/bin/csh

# initialize variables
set fileList = () # list of all specified files
set listFlag = 0  # set to 1 if -l is specified
set purgeFlag = 0 # 1 if -p is specified
set fileFlag = 0  # 1 if at least 1 file is specified
set junk = ~/.junk  # junk directory

# parse command line
foreach arg ($*)
  switch ($arg)
    case "-p":
      set purgeFlag = 1
      breaksw

    case "-l":
      set listFlag = 1
      breaksw

    case -*:
      echo $arg is an illegal option
      goto error
      breaksw

    default:
      set fileFlag = 1
      set fileList = ($fileList $arg) # append to listFlag
      breaksw
  endsw
end

# check for too many options
@ total = $listFlag + $purgeFlag + $fileFlag
if ($total != 1) goto error

# if junk directory doesn't exist, create it
if (!(-e $junk)) then
  'mkdir' $junk
endif

# process options
if ($listFlag) then
  'ls' -lgF $junk     # list junk directory
  exit 0
endif

if ($purgeFlag) then
  'rm' $junk/*      # remove contents of junk directory
  exit 0
endif

if ($fileFlag) then
  'mv' $fileList $junk   # move files to junk directory
  exit 0
endif

exit 0

# display error message and quit
error:
cat << ENDOFTEXT
TO $USER: the usage of junkfiles.csh only contains these options:
  junk -p means "purge all files"
  junk -l means "list junked files"
  junk <list of files> to junk them
ENDOFTEXT
exit 1
