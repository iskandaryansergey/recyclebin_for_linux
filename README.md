# RecycleBin for Linux

[![License](https://img.shields.io/github/license/iskandaryansergey/Prometheus-Cadvisor-Grafana)](LICENSE)

Most **Linux**  distributions do not have  **recyclebin** on the command line. When you remove a file or directory, it is gone and cannot be restored. This project is a script that provides users with recycling which can be used to safely delete and restore files.

## Philosophy

This project is for users who want to have recyclebin as in windows, but in cli mode. You have the ability to trash any file or folder and recover into the same path as previous it was . The file or folder  that you want to remove will  be moved to the recyclebin but with name changes, at the end of, file date will be added in this form **"date +"%H"_"%M"-"%F"** . Also, there is interactive option. Each will be described the after.

##  Requirements

### Host setup

* Kernel Version 2.6 or newer
* User should have a home directory
* User should be able change files mod to executables

##  Usage

### Installation

First of all, you need to go to your user's home directory. 
``` sh
cd $HOME

```
After that, you need to clone this project in your home directory.
``` sh
git clone https://github.com/iskandaryansergey/recyclebin_for_linux.git

```
When cloning has been finished, please change your directory to the project directory.
``` sh
cd recyclebin_for_linux

```
Make the below  scripts executable by this command.
``` sh
chmod u+x restore recycle install.sh 
```
Run install.sh
```sh
./install.sh
```
The installation script creates all nesesar folders and files for this project. First, it creates a recyclebin folder and .restore.info file, after it creates symbolic links for the recycle and restore scripts in the first writable path from your  $PATH environment variable, that provide you ability to run scripts without mentioning absolute  path to the scripts. If install.sh ended without errors, you should see this.

![Install pic]()

### Recycle

Now you are able to recycle and restore from any folder.
If you want to recycle some files or dirts, write in the command line **recycle** and files or directories that you want to remove, example:
``` sh
recycle test test_dir
```
Also, you can specify options **-i -v|-vv**
You can see usage by typing recycle without any argument

-i option provides you with the ability to run recycling in interactive mode. It means that you will be prompted about removal or not, before it is moved to recyclebin.

![Recycle -i pic]()

-v or -vv provide verbose and deep verbose options. In deep verbose mode, when you recycle the directory it will show you all files and directories of removable folder.

![Recycle -vv pic]()

### Restore

You can restore any recycled file or directory by typing restore
``` sh
restore
```
> **Warning**  
> If restorable file|dir parent's path do not exist and you want to restore child dir|file 
> you should manually  create parent path otherwise the  restore will exit with error 

After that you will see the list of files that can be restored, you should specify index of the file|dir you want to restore.
By submitting the index you will be prompted to restore if -i option is specified, otherwise file|dir will be restored in original path.

![Restore pic]()


> **Warning**  
> If the file|dir with the same name exists in the original path, file|dir will be restored as in  this template filename_date +'%H'_'%M'-'%F'
