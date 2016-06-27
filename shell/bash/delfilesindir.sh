#!/bin/sh
delcnt=0
if [ $# -lt 1 ]; then
  echo "delfilesindir: no arguments present"
  exit
fi
echo "enter path to target directory: "
read path
if ($path == 'this') then
  $path=$PATH
fi
# won't delete files in subdirectories
for files in `find $path -mtime -${1} -maxdepth 1 -ok rm -f {}`
do
  echo "deleting file $file"
  rm $file
  delcnt=$(($delcnt + 1))
done
echo "deleted $delcnt files"
