# The installation file

echo "Start installation ... "

FE_CDS_HOMEDIR="$HOME/.cdshct"

if [ -d $FE_CDS_HOMEDIR ]; then
	echo "Default installation directory has already been created."
	echo "Please check if a previous version of this script is installed."
	echo "If so, please remove the directory, and all related files, and run this script again."
	echo "Installation cancelled for the reason shown above."
	exit
fi

# Make directory and copy necessary files into it
echo "Copying files ..."
mkdir $FE_CDS_HOMEDIR
cp -r ./script $FE_CDS_HOMEDIR
cp ./cds $FE_CDS_HOMEDIR
echo "Done!"

# Make modifications to the .bashrc file.
# A future switch will be added if you would like to manually do this instead of automatic
if [ ! -f $HOME/.bashrc ]; then
	echo ".bashrc is not found under your home directory."
	echo "Please make the following changes your self"
	echo "\t (1) Add $FE_CDS_HOMEDIR to your \$PATH"
	echo "\t (2) Source $FE_CDS_HOMEDIR/script/cds_init automatically upon entering the terminal"
	echo "Installation cancelled for the reason shown above."
	exit
fi

echo "Modifying $HOME/.bashrc ... "

echo "" >> $HOME/.bashrc
echo "# Added by CD Shortcut" >> $HOME/.bashrc
echo "source $FE_CDS_HOMEDIR/script/cds_init" >> $HOME/.bashrc

if [ ! -f $HOME/.bash_aliases ]; then
	echo ".bash_aliases file not found, writing alias to .bashrc."
	echo "alias cds='. cds'" >> $HOME/.bashrc
else
	echo ".bash_aliases file found, writing alias to .bash_aliases."
	echo "alias cds='. cds'" >> $HOME/.bash_aliases
fi

. $HOME/.bashrc

echo "Done!"

touch $FE_CDS_HOMEDIR/shortcut

echo "Installation finished without errors"
