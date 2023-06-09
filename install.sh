#!/bin/bash
#This is an installation script for the recyclebin executable

#We need to create a recyclebin folder and restore file for our purposes

recyclebin_exe=$HOME/recyclebin_for_linux/recycle
recyclebin=$HOME/recyclebin
restore_file=$HOME/.restore.info
recyclebin_link=$HOME/recycle
recycle_executable=recycle

restore_exe=$HOME/recyclebin_for_linux/restore
restore_link=$HOME/restore
restore_executable=restore


function creator () {

#Creating recyclebin dir
  if [[ ! -d $recyclebin  ]]
    then
      mkdir $recyclebin
  fi  
  
  #creating Restore File
  if [[ ! -a $restore_file ]]
    then
      touch $restore_file
  fi
}

#Create a link from the recyclebin executable file to any writable path from $PATH
function linker () {

  for paths in $(echo "$PATH" | awk -F':' '{ for(i=1; i<=NF; i++) print $i }') ; 
    do 
      if [[ -w "$paths"  ]] 
        then 
          ln -s "$recyclebin_exe"  "$paths"/ &>/dev/null
          if [ -L "${paths}/${recycle_executable}" ] && [ -e "${paths}/${recycle_executable}" ] 
            then 
              echo "${recycle_executable}Link has been created successfully in this path ${paths}/"
          else
              echo "Couldn't create ${recycle_executable} link in this path $paths"
              rm "${paths}/${recycle_executable}"
              return 1    
          fi

          ln -s "$restore_exe"  "$paths"/ &>/dev/null
          if [ -L "${paths}/${restore_executable}" ] && [ -e "${paths}/${restore_executable}" ] 
            then 
              echo "${restore_executable} Link has been created successfully in this path ${paths}/"
              break
          else
              echo "Couldn't create ${restore_executable}  link in this path $paths"
              rm "${paths}/${restore_executable}"
              return 1    
          fi
      else 
          echo "Do not have write permision in  $paths" 
      fi 
  done

}

main () {

  creator
  if [[ $? -eq 0 ]]
    then
      echo "Recyclebin folder and restore file has been created successfully"
  else
      echo "Recyclebin folder and restore file have some issue please check your home directory"
  fi
  linker
  if [[ $? -eq 1 ]]
    then
      echo "Could not create link to the executable, executable can be run only with absolute path"
  else
      echo "Links has been created successfully"
  fi

}

main


