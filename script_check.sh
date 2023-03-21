#!bin/bash

hostname=$(hostname)
myip=$(hostname -I | awk '{print $1}')

# Add đường dẫn chứa file backup ở dưới
pathBackup="/root/pg_backup"
cd $pathBackup

# Tìm file mới nhất
filename="$(find . -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d" " | sed 's/^.\///')"
dungluonFile=$(du -sh $filename | awk '{print $1}')



echo "$hostname"
echo "$myip"
echo "$pathBackup"
echo "$filename"
echo "$dungluonFile"
