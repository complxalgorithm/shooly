#!/bin/bash
# create pdf with input

# Input file
echo "enter file name/path: "
read -r inFile

# Output location
echo "enter file output location: "
read -r o

write="$HOME/bin/py/pdfwriter.py"

# validate to see if o is a directory
if [ -e "$o" ] && [ -d "$o" ]; then
  # If file exists
  if [[ -f "inFile" ]]; then
      # read it
	  while IFS='|' read -r pdfid pdfurl pdftitle
      do
    	  pdf="$o/$pdfid.pdf"
          echo "Creating $pdf file ..."
	  # Genrate pdf file
          $write --quiet --footer-spacing 2 \
          --footer-left "nixCraft is GIT UL++++ W+++ C++++ M+ e+++ d-" \
          --footer-right "Page [page] of [toPage]" --footer-line \
          --footer-font-size 7 --print-media-type "$pdfurl" "$pdf"
      done <"inFile"
  fi
else
  echo "error: invalid directory name"
  exit 0
fi
