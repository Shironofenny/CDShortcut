#!/bin/bash

# This file is used to make shortcuts for frequent used directories.
# Type "cds -h / --help" to get detailed syntax.

# !! IMPORTANT
# This file is run under current bash shell. 
# Thus any call of function exit will force the shell to exit!

# Written by Fenny Zhang
# Last revise: 30th Nov, 2013

# The name of the source file
FE_CDS_Filename="$HOME/.cdshct/shortcut"

if [ ! -d "$HOME/.cdshct" ]
then
	mkdir $HOME/.cdshct
	echo "The default shortcut installation directory doesn't exist."
	echo "Created directory $HOME/.cdshct. "
fi

if [ ! -f "$FE_CDS_Filename" ]
then
	touch $FE_CDS_Filename
	echo "The default shortcut storage file doesn't exists."
	echo "Created file $FE_CDS_Filename . "
fi

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
	echo " [-l / --list]: List all configured shortcuts in the system. "
	echo " [-s / --shortcut]: Add the current directory (\$PWD) into the shortcut system with a specified shortcut that follows this argument. "
	echo " [-c / --comment]: Add an comment to the shortcut added, only valid with -s arugument. "
	echo "                   If this is not provided, the time that the shortcut is added would be treated as default comment. "
	echo " [-r / --remove]: Remove the shortcut following this argument. "
	echo ""
}

PrintUnfoundShortCut()
{
	echo ""
	echo "The shortcut you typed does not exist in current configuration. "
	echo ""
}

PrintUnfoundArgument()
{
	echo ""
	echo "Can't find a match to the argument. "
	echo ""
}

PrintAlreadyExistShortCut()
{
	echo ""
	echo "The shortcut you wanted to add already exists in the list."
	echo "Please use another shortcut name."
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

	done < "$FE_CDS_Filename"
	
	echo " Please type \"cds SHCT\" to change your directory"
	echo ""

}

# Initialize flags

	# The flag for skip searching
	FE_CDS_sflag=0

	# Memorize options
	FE_CDS_option=""

	# Memorize commands (the shortcut)
	FE_CDS_command=""

# See the extra options
if [ $# -lt 1 ]; then
	FE_CDS_sflag=1
else
	while [ $# -gt 0 ]
	do
		FE_CDS_option="$1"
		FE_CDS_command="$1"
		shift
		case "$FE_CDS_option" in
			"-l"|"--list")
				ListShortcuts $1;
				break;;
			"-h"|"--help")
				PrintHelp;
				ListShortcuts;
				break;;
			"-r"|"--remove")
				FE_CDS_Remove=$1;
				shift;;
			"-s"|"--shortcut")
				FE_CDS_NewShortCut=$1;
				shift;;
			"-c"|"--comment")
				FE_CDS_NewComment=$1;
				shift;;
			"-*")
				PrintUnfoundArgument;
				break;;
			*);;
		esac
	done
fi

# Check if FE_CDS_command is not a short cut
if [[ $FE_CDS_command == -* ]]; then
	FE_CDS_sflag=2
fi

# Check if there is anything to be removed.

if [ "$FE_CDS_Remove" != "" ]; then

	# Initialize the line counter
	FE_CDS_lineNum=0

	# Initialize the number of lines of comment
	FE_CDS_CommentLine=0

	# Initialize the flag that the shortcut exists
	FE_CDS_rflag=0

	while read line
	do

		# Get current line number
		FE_CDS_lineNum=$(( $FE_CDS_lineNum+1 ))

		# Delete comment lines and empty lines

		if [ "${line%%\ *}" = "#" ]; then
			continue
		elif [ "$line" = "" ]; then
			continue
		fi

		# Once get out of the comment area, restore the number of comment lines
		if [ $FE_CDS_CommentLine -eq 0 ]; then
			FE_CDS_CommentLine=$(( $FE_CDS_lineNum-1 ))
		fi

		# Split the line into three parts: shortcut, directory and document
		
		FE_CDS_RemoveShortCut=${line%%~*}

		if [ "$FE_CDS_Remove" = "$FE_CDS_RemoveShortCut" -o "$FE_CDS_Remove" = "$(( $FE_CDS_lineNum-$FE_CDS_CommentLine))" ]; then
			sed -i ${FE_CDS_lineNum}d $FE_CDS_Filename
			FE_CDS_rflag=1
			break
		fi

	done < "$FE_CDS_Filename"

	if [ $FE_CDS_rflag -eq 0 ]; then
		PrintUnfoundShortCut
	fi

fi

# Check if there is anything new to be added.

if [ "$FE_CDS_NewShortCut" != "" ]; then
	
	FE_CDS_aflag=1

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

		if [ $FE_CDS_NewShortCut == $FE_CDS_shortcut ]; then
			FE_CDS_aflag=0
		fi

	done < "$FE_CDS_Filename"

	if [ $FE_CDS_aflag -eq 1 ]; then
	
		if [ "$FE_CDS_NewComment" = "" ]; then
			FE_CDS_NewComment="Added at "$(date)
		fi
	
		echo "$FE_CDS_NewShortCut~$PWD~$FE_CDS_NewComment" >> "$FE_CDS_Filename"

	else

		PrintAlreadyExistShortCut

	fi

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

	done < "$FE_CDS_Filename"

	if [ "$FE_CDS_targetDir" = "" ]; then
		PrintUnfoundShortCut
		FE_CDS_sflag=2
	fi

	# Change current directory if the command is correct

	if [ $FE_CDS_sflag -eq 0 ]; then

		echo $FE_CDS_targetDir
		cd "$FE_CDS_targetDir"

	fi

fi

if [ $FE_CDS_sflag -eq 1 ]; then
	PrintUsage
fi

# Unset all the reusable parameters defined
unset FE_CDS_Filename

unset FE_CDS_option
unset FE_CDS_command
unset FE_CDS_sflag

unset FE_CDS_Remove
unset FE_CDS_NewShortCut
unset FE_CDS_NewComment

unset FE_CDS_lineNum
unset FE_CDS_CommentLine
unset FE_CDS_RemoveShortCut
unset FE_CDS_rflag
unset FE_CDS_aflag

unset FE_CDS_line
unset FE_CDS_count
unset FE_CDS_shortcut
unset FE_CDS_directory
unset FE_CDS_targetDir
unset FE_CDS_document
