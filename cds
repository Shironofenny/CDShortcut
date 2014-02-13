#!/bin/sh

# This file is used to make shortcuts for frequent used directories.
# Type "cds -h / --help" to get detailed syntax.

# !! IMPORTANT
# This file is run under current bash shell. 
# Thus any call of function exit will force the shell to exit!

# Written by Fenny Zhang
# Last revise: 30th Nov, 2013

# The name of the source file
filename="/home/fenny/.shortcut"

# The print usage function
PrintUsage()
{
	echo ""
	echo " CDS lack of certain argument."
	echo " Refer to cds -h / --help for further information."
	echo ""
}

PrintHelp()
{
	echo ""
	echo " Change Directory with Shortcuts -- Help Page "
	echo " CDS can get to a restored directory using shortcuts "
	echo ""
	echo " [Usage] cds [options] shortcut "
	echo ""
	echo " [-h / --help]: Get the help page. "
	echo " [-l / --list]: List all configured shortcuts in the system"
	echo ""
	echo " See also: cdsconfig --help"
	echo ""
}

PrintErrorMessage()
{
	echo ""
	echo " The shortcut you typed does not exist in current configuration. "
	echo ""
}

ListShortcuts()
{
	# The line number used in count
	FE_CDS_count=1

	echo ""
	echo " Following configurations are available now: "
	echo ""
	while read FE_CDS_line
	do

		# Delete comment lines and empty lines

		if [ "${FE_CDS_line%%\ *}" = "#" ]; then
			continue
		elif [ "$FE_CDS_line" = "" ]; then
			continue
		fi

		# Split the line into three parts: shortcut, directory and document
		
		FE_CDS_shortcut=${FE_CDS_line%%~*}
		export FE_CDS_targetDir="${FE_CDS_line#*~}"
		FE_CDS_directory="${FE_CDS_targetDir%~*}"
		FE_CDS_document="${FE_CDS_line##*~}"

		echo "  $FE_CDS_count)"$'\t'"SHCT = $FE_CDS_shortcut"$'\t'"DIR = $FE_CDS_directory"
		echo "  "$'\t'"Description: $FE_CDS_document"
		echo ""

		FE_CDS_count=$(( $FE_CDS_count + 1 ))

	done < "$filename"
	
	echo " Please type \"cds SHCT\" to change your directory"
	echo ""

}

# Initialize flags

	# The flag for printing help
	FE_CDS_hflag=0

	# The flag for lack of arguments
	FE_CDS_aflag=0

	# The flag for skip searching
	FE_CDS_sflag=0

	# Memorize options
	FE_CDS_option=""

	# Memorize commands (the shortcut)
	FE_CDS_command=""

# See the extra options
if [ $# -lt 1 ]; then
	FE_CDS_aflag=1
else
	while [ $# -gt 0 ]
	do
		FE_CDS_option="$1"
		FE_CDS_command="$1"
		shift
		case "$FE_CDS_option" in
			"-l"|"--list")
				ListShortcuts $1;
				FE_CDS_sflag=1;;
			"-h"|"--help")
				FE_CDS_hflag=1;;
			*);;
		esac
	done
fi

if [ $FE_CDS_hflag -eq 1 ]; then
	PrintHelp
	FE_CDS_sflag=1
elif [ $FE_CDS_aflag -eq 1 ]; then
	PrintUsage
	FE_CDS_sflag=1
fi

# Change to the target directory if the command is available

if [ $FE_CDS_sflag -eq 0 ]; then

	# Config the target directory

	FE_CDS_targetDir=""

	while read FE_CDS_line
	do

		# Delete comment lines and empty lines

		if [ "${FE_CDS_line%%\ *}" = "#" ]; then
			continue
		elif [ "$FE_CDS_line" = "" ]; then
			continue
		fi

		# Split the line into three parts: shortcut, directory and document
		
		FE_CDS_shortcut=${FE_CDS_line%%~*}

		if [ "$FE_CDS_command" = "$FE_CDS_shortcut" ]; then
			FE_CDS_directory="${FE_CDS_line#*~}"
			FE_CDS_targetDir="${FE_CDS_directory%~*}"
			FE_CDS_document="${FE_CDS_line##*~}"
			break
		fi

	done < "$filename"

	if [ "$FE_CDS_targetDir" = "" ]; then
		PrintErrorMessage
		FE_CDS_sflag=1
	fi

	# Change current directory if the command is correct

	if [ $FE_CDS_sflag -eq 0 ]; then

		echo $FE_CDS_targetDir
		cd $FE_CDS_targetDir

	fi

	unset filename

fi
