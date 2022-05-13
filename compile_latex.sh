#!/bin/bash

##################################################################################
# Function - compile_latex.sh
# Shell script to compile a latex file into pdf 
#
# Parameters - Pass the filename (full filename of latex file) as an argument 
#
# Example - ./compile_latex.sh paper_version12.tex
# where the name of the tex file is paper_version12.tex
#
# Notes - 1) Pass the full filename as an argument 
#	  2) Assumes that latex, dvips and ps2pdf are installed	
# 
# Author - Soumya Banerjee
# Website - https://sites.google.com/site/neelsoumya/
#	    www.cs.unm.edu/~soumya	
# Creation Date - 18th July 2014
# License - GNU GPL
###################################################################################



if [ $# -eq 0 ] 
then
    echo "$0:Error command arguments missing!"
    echo "Usage: $0  filename"
    exit 1
fi


#echo $1

file_extension=`echo $1 | awk -F . '{print $NF}' `

if [ $file_extension = 'tex' ]
then
	echo 'File extension correct'
else
	echo "$0: Error, incorrect file extension (expects .tex file)"
	exit 1
fi

# Look for sufficent arg's
#

    if [ $# -eq 1 ]; then
	if [ -e "$1" ]; then

		# call latex compile commands

		file_name_only=`basename $1 .tex`  	
		
		latex "$1"
		bibtex "$file_name_only"
		latex "$1"
		latex "$1"
		dvips "$file_name_only".dvi
		ps2pdf "$file_name_only".ps
		
         else
    	    echo "$0: Error opening file $1" 
	    exit 2
	fi   
    else
        echo "Missing arguments!"	
    fi



rm *.log *.ps *.dvi *.aux *.bbl *.blg

