# RecycleBin for Linux

[![License](https://img.shields.io/github/license/iskandaryansergey/Prometheus-Cadvisor-Grafana)](LICENSE)

Most **Linux**  distributions do not have  **recyclebin** on the command line. When you remove a file or directory, it is gone and cannot be restored. This project is a script that provides users with recycling which can be used to safely delete and restore files.

## Philosophy

This project is for users who want to have recyclebin as in windows, but in cli mode. You have the ability to trash any file or folder and recover into the same path as previous it was . If the file or folder name that you want to remove already exists in the recyclebin, the mentioned object will also be moved to the recyclebin but with name changes, at the end of, file date will be added in this form **"date +"%H"_"%M"-"%F"** . Also, there are verbose and interactive options. Each will be described the after.
