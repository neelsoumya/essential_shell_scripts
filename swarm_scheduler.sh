#!/bin/bash

##################################################################################
# Function - swarm_scheduler.sh
# Shell script to read a text file of commands
# and give them for scheduling on the Sun Grid Engine scheduler
# It creates a separate shell script that is the "wrapper" for  each line on the 
# command file. It then creates a master shell script that has a qsub call
# for each of these shell scripts.
# Finally, it calls this master shell script
#
# Example - ./swarm_scheduler.sh command_file.txt
# command_file.txt has the list of all commands separated by new lines
# 
# Author - Soumya Banerjee
# Website - https://sites.google.com/site/neelsoumya/
#	    www.cs.unm.edu/~soumya	
# Creation Date - 9th Aug 2013
# License - GNU GPL
###################################################################################



if [ $# -eq 0 ] 
then
    echo "$0:Error command arguments missing!"
    echo "Usage: $0  filename"
    exit 1
fi



# Look for sufficent arg's
#

    if [ $# -eq 1 ]; then
	if [ -e $1 ]; then

		# read control file and create separate shell scripts
		iCount=1
		while read line
		do 
			if [ -n "$line" ]; then 
				echo "#!/bin/bash" > "shell_cp$iCount.sh"
				echo "#S -S /bin/sh" >> "shell_cp$iCount.sh"
				echo $line >> "shell_cp$iCount.sh"	
				chmod +x "shell_cp$iCount.sh"
  				iCount=$(( iCount+1 ))
			fi
		done < $1
		echo $iCount


		# create master shell script that will have qsub calls to these shell scripts
		echo "#!/bin/bash" > "shell_cpmaster.sh"
                echo "#S -S /bin/sh" >> "shell_cpmaster.sh"

		iCount=1
                while read line
                do
                        if [ -n "$line" ]; then
                                echo "qsub shell_cp$iCount.sh" >> "shell_cpmaster.sh"
                                iCount=$(( iCount+1 ))
                        fi
                done < $1
                echo $iCount
	
		# give execute privileges to master shell script
		chmod +x "shell_cpmaster.sh"

         else
    	    echo "$0: Error opening file $1" 
	    exit 2
	fi   
    else
        echo "Missing arguments!"	
    fi



# call shell_cpmaster so that it can submit all jobs to scheduler on cluster
./"shell_cpmaster.sh"


