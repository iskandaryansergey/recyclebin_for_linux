#!/bin/bash

# This script will implement recycle bin for the Unix based systems
# Due to Unix based repos do not have recycle bin 


recyclebin=$HOME/recyclebin
restore_file=$HOME/.restore.info

#creating RecycleBin
if [[ ! -d $recyclebin  ]]
  then
    mkdir $recyclebin
fi  

if [[ ! -a $restore_file ]]
  then
    mkdir $restore_file
fi

function verbose () {
  #checking if verbose flag is persist and print msg
  if [[ $verbose_flag ]]
    then
      echo "The $filename $file_type  will be moved to the trash"
  fi  
}

function move_to_trash () {
  if [[ $remove -eq 2 ]]
    then
      #exiting due to file will not be removed
      echo "exiting"
    else
      #removing file
      echo "removing $file"

      #calling verbose metod
      verbose

      if [[ -f $file  ]]
        then
          #Adding record to the 
          if [[ !$(grep -q ${filename}_ $restore_file) ]]
            then
              echo "${filename}_${inode}:${full_path}_`date  +"%H%M%d%m%y"`" >> $restore_file 
            else
              echo "${filename}_${inode}:${full_path}" >> $restore_file 
          fi
        else
          echo "dir"
      fi
  fi
}

function inter_prompt () {
  while true
    do
      read answer
      case $answer 
        in
          [Yy]*)
            echo "Your file $file  will removed"
            remove=1
            break
            ;;
          [Nn]*)
            echo "This file $file will be untouched "
            remove=2
            break
            ;;
          *)
            echo -e  " \n Please type only Yes/No \n"
            ;;
      esac  
    done  
}

function recycle () {
  for file in $@
    do      
      if [[ -a  $file ]]
        then
          full_path=$(readlink -f $file)
          filename=$(readlink -f $file  | awk -F /  '{print $NF}')
          file_type=$(file $full_path | cut -d : -f2 |  tr [:lower:] [:upper:])
          inode=$(ls -i $file | cut -d ' ' -f 1)
          if [[ $interactive  ]]
            then
              echo "Do you want to remove this $file file [Y/n] ? "
              inter_prompt
          fi
          
          move_to_trash
      
        else
          echo -e "\n File do not exist \n"
      fi
    done    
}

function main () {
	if [[ $# < 1  ]]
	then	
		echo -e "\n No File Name Provided \n"	
		exit 1
	fi
	
		
  for opt in $@
	do	
		case $opt
		in	
			-i)
				echo "Choosen interactive"
				shift
				interactive=1
				;;
			-v)
				echo "Enter verbose mode"
				verbose_flag=1
				shift	
				;;
      *)
        #Exiting from loop 
        break
        ;;
		esac
	done
  
  recycle $@
			
}


main $@
