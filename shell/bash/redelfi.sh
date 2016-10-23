#!/usr/bin/bash

# title: redelfi.sh
# author: Stephen C. Sanders <complxalgorithm>
# license: GNU GPL V.3
# description: recursively deletes every file in current working directory
# but only after it is given consent to do so.
# also offers other options, such as editing/viewing file in
# nano, etc.

for file in *
do
  if ! [[-f "$file" && -r "$file"]]
    then continue
  fi
  echo " " # blank line
  /bin/ls -l "$file"
  while :
  do
    echo -n "Delete file? "
    echo -n "[y, n, e, m, t, !, h (help), q]"
    read c
    case $c in
      y) if [[ ! -w "$file"]]
           then echo $file write-protected
         else /bin/rm "$file"
           if [[ -e "$file"]]
             then echo cannot delete $file
           else echo "$file deleted"
           fi
         fi
         break ;; # to handle next file
      n) echo "$file not deleted"
         break ;;
      e) ${EDITOR:-/bin/nano} "$file"; continue ;;
      m) /bin/more "$file"; continue ;;
      t) /bin/tail "$file"; continue ;;
      !) echo -n "command: "
         read cmd
         eval $cmd ;;
      q) break 2;; # break two levels
      h) # help for user
         echo clean commands: followed by RETURN
         echo "y - yes delete file"
         echo "n - don't delete file, skip to next file"
         echo "e - edit/view file with ${EDITOR:-/bin/nano}"
         echo "m - display file with more"
         echo "t - display tail of file"
         echo "! - shell escape"
         echo "h - help, displays role of each possible input letter"
         echo "q - quit, exit from clean"
         ;;
    esac
  done
done
