#!/bin/zsh
shopt -s nullglob
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

function recycle () {
  for file in $@
    do      
      if [[ -a  $file ]]
        then
          full_path=$(readlink -f $file)
          filename=$(readlink -f $file  | awk -F /  '{print $NF}')
          file_type=$(file $full_path | cut -d : -f2 | tr -s ' ' | tr -d ' ' )
          if [[ $interactive  ]]
            then
              echo "Do you want to remove this $file file [Y/n] ? "
         
              #calling interactive prompt
              inter_prompt
          fi
          
          move_to_trash
      
        else
          echo -e "\n File do not exist \n"
      fi
    done    
}


function trashing_file () { 
  #move file or dir to the  the RecycleBin
   if [[ -d $file ]]
    then
      if [[  $recursive_flag -ne 0 ]]
        then
          # cheking if the dir is empty
          if  [[  !  -z $(find $file -maxdepth 0 -empty)  ]]
            then
              break
              # should be return if folder is empty
          fi
          mkdir -p ${recyclebin}/${trashed_dir_name}
          local i
          echo $i
          for i in $file/*
            do
              echo "cikl"
              file="$i"
              trashing_file
              recursive_flag=0
              recycle $i
            done
        else
          echo "If not recursive creating same dir in the recyclebin" 
          #mkdir -p ${recyclebin}/${trashed_dir_name}
      fi 
         echo $file
        echo "directorian pti sikitir arvi ete recursive fracela vrov kam chi fracel"
        
        # rm -rf $file  
    else
      echo "if not dir move file to trash"
      #mv $file ${recyclebin}/${trashed_file_name}
   fi

}

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
      #exiting due to file will not be removed  here sholud be break due to remove is set to none 
      echo "exiting"
    else
      #removing file
      echo "removing $file"

      #calling verbose metod
      verbose

      if [[ -f $file  ]]
        then
          inode=$(ls -i $file | cut -d ' ' -f 1)
         # unset $trashed_file_name
          #Adding record to the 
          if [[ ! $(grep -q ${filename}_ $restore_file) ]]
            then
              trashed_file_name=${filename}_${inode}:${full_path}_$(date  +"%H%M%d%m%y") 
              echo $trashed_file_name >> $restore_file 
            else
              trashed_file_name=${filename}_${inode}:${full_path}
              echo $trashed_file_name >> $restore_file 
          fi
        elif [[ -d $file ]]
          then
            #unset trashed_dir_name
                if [[ ! $(grep -q ${filename}_dir $restore_file) ]]
                  then
                    trashed_dir_name=${filename}_dir_$(date  +"%H%M%d%m%y")
                    echo $trashed_dir_name >> $restore_file 
                  else
                    trashed_dir_name=${filename}_dir
                    echo $trashed_dir_name >> $restore_file 
                fi
      fi
      #calling trashing_file metod
      trashing_file

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
         -r)
           echo "You have choose recursive metod for the Directory"
           recursive_flag=1
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
