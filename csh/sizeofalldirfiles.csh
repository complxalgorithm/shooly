#!/bin/csh

if ( $#argv == 0 ) then
        set directory = "."     #if no directory is specified then the current directory is taken as the parameter.
else if ( $#argv > 1 ) then
        echo " $0 Error: You entered too many parameters." #Error message for too many parameters.
        exit 1
else if ( ! -d $argv[1] ) then
        echo " $0 Error: You entered a non-directory." #Error message for not entering a directory.
        exit 1
else
        set directory = $argv[1]        #A regular directory was entered as a parameter
endif

#Initialize files array to file names in the specified directory.

set files = `ls $directory`     #File substitution
@ nfiles = $#files              #Number of files in the specified directory stored in nfiles.
@ index = 1                     #Array index initialized to point to the first file name.
@ sum = 0                       #Running sum initialized to zero.

while ( $index <= $nfiles )
        set thisFile = "$directory"/"$files[$index]"
        if ( -f $thisFile ) then                #If the next file is an ordinary file.
                set argv = `ls -l $thisFile`    #Set Command line arguments.
                @ sum = $sum + $argv[5]         #Add file size to the running sum.
                @ index++                       #Add file size to the current total.
        else
                @ index++       #Condition if next file is not a regular file.
        endif
end

#Spell out the current directory.

if ( "$directory" == "." ) then #Condition if no directory was entered.
        set directory = "your current directory"
endif

echo "The size of all non-directory files in $directory is $sum bytes."

exit 0
