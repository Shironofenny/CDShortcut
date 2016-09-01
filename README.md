CDShortcut
==========

Using this command, you can change directory with shortcuts

# Installation

## Automatic installation (user level installation):

1. Change directory to this repository
2. Run install.sh
3. Enjoy

## Alternative manual installation (system level installation, require root acccess):

1. Copy ./cds to somewhere your $PATH can reach (for instance /usr/bin)
 
 ```
 [sudo] cp cds /usr/bin
 ```
2. [Optional] Rename the auto-completion file so that it might be easier for you to understand that it is bonded to the command "cds" ./script/cds_complete to ./script/cds
 
 ```
 mv script/cds_complete script/cds
 ```
3. Move the completion file to the bash-completion directory (/etc/bash_completion.d)
 
 ```
 [sudo] cp script/cds /etc/bash_completion.d/
 ```
4. Add alias to run cds under current shell (required for the command "cd") and then source $HOME/.bashrc, or restart your terminal
 
 ```
 echo "alias cds='. cds'" >> $HOME/.bashrc
 source $HOME/.bashrc
 ```

## Usage

cds [options] shortcut 

 [-h / --help]: Get the help page.
 
 [-l / --list]: List all configured shortcuts in the system.
 
 [-s / --shortcut]: Add the current directory ($PWD) into the shortcut system with a specified shortcut that follows this argument.
 
 [-c / --comment]: Add an comment to the shortcut added, only valid with -s arugument. If this is not provided, the time that the shortcut is added would be treated as default comment. 

 [-r / --remove]: Remove the shortcut following this argument. 
