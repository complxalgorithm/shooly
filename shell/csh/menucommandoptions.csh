#!/bin/csh
while(1)
echo "Menu:"
echo "a-List all files in the present working directory."
echo "b-Display today's date and time."
echo "c-Display users currently logged in to server."
echo "d-Display whether a file is an 'ordinary' file or a 'directory'"
echo "e-Create a backup for a file."
echo "x-Exit"
echo -n "->"
set answer = $<
switch($answer)
   case [aA]:
	    ls -a
      breaksw
   case [bB]:
	    date
      breaksw
   case [cC]:
	    w
      breaksw
   case [dD]:
	    echo -n "Type the name of the file to test:"
	    set fileName = $<
	    if( !(-e "$fileName")) then
		    echo "This file does not exist."
		    breaksw
	    else if (-f "$fileName") then
		    echo "This is a regular file."
	    else if (-d "$fileName") then
		    echo "This file is a directory."
	    endif
      breaksw
   case [eE]:
	    echo -n "Type the name of the file to create a backup for it:"
	    set fileName = $<
	    if(!(-e "$fileName")) then
		    echo "This file does not exist."
	    else
	      cp $fileName "$fileName".bak
	      ls -l "$fileName".bak
	    endif
      breaksw
   case [xX]:
	    clear
	    sleep 1
	    echo "exiting..."
	    sleep 1
      echo "exit complete"
	    clear
	    exit 0
      breaksw
   default:
      echo "Invalid option. Try again."
endsw
end
