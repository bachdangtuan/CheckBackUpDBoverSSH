#!bin/bash

## Điều kiện bắt buộc phải có SSH key

# Variable
SERVER_IP='183.80.255.19'
TOKEN="6112203391:AAEuDTYX3KQRNuoLKuJ0NAtpRoamdHIQQkA"
CHAT_ID="-957135587"
URL="https://api.telegram.org/bot${TOKEN}/sendMessage"
#PATH_SCRIPT="/backupDB" # Khong dung duoc
POST=22

# Gọi script tại server đã được SSH vào
#ketqua=$(ssh "$SERVER_IP" "bash /root/scriptCheck/myscript.sh")
ketqua=$(sshpass -p <mật khẩu> ssh -p 2127 root@x.x.x.x 'cd /root/scriptCheck && bash check_isofh_pay.sh')

#echo $ketqua

#read -r result_var <<< "$ketqua"
readarray -t result_array <<< "$ketqua"


# ServerName= ${result_array[0]}
# IP= ${result_array[1]}
# PathBackUp= ${result_array[2]}
# Filename= ${result_array[3]}
# Capacity= ${result_array[4]}


filename=${result_array[3]}
filedate=${filename:10:10}   # lấy chuỗi ngày/tháng/năm từ tên file
today=$(date +%Y_%m_%d)      # lấy ngày hiện tại
nameDatabase=${filename:0:9}
os_systems="CentOS Linux 7 (Core)"
#echo $filedate
#echo $nameDatabase


SUCCESS="
==[BACKUP-SUCCESS]==
Server: ${result_array[0]}
Database: ${nameDatabase}
Address IP :${result_array[1]}/24
Nguyen nhan: Backup Dump thanh cong databases !
"

ERROR="
==[BACKUP-ERROR]==
Server: ${result_array[0]}
Database: ${nameDatabase}
Address IP :${result_array[1]}/24
Content: Backup backup du lieu khong thanh cong !
--------
Nguyen nhan: Backup DB backup bi ngat giua chung, quyen truy cap sai, khong co db, chua backup
"

#### Send Telegram ####

alertTelegramSuccess(){
curl -s -X POST $URL \
-G -d chat_id=$CHAT_ID \
--data-urlencode "text=$SUCCESS" \
-d "parse_mode=HTML"
}

alertTelegramError(){
curl -s -X POST $URL \
-G -d chat_id=$CHAT_ID \
--data-urlencode "text=$ERROR" \
-d "parse_mode=HTML"
}

#### Send Server API ####

sendSuccessServer(){
capacityFile=$(du -sh ${DB_NAME}_$DATE.sql | awk '{print $1}')

curl -X POST http://10.0.0.210:5000/api/databases/info \
-H "Content-Type: application/json" \
-d '{"ipServer": "'"${result_array[1]}"'",
    "hostname": "'"${result_array[0]}"'",
    "osSystems": "'"$os_systems"'",
    "nameDatabase": "'"${nameDatabase}"'",
    "pathBackup": "'"${result_array[2]}"'",
    "status": "backup",
    "capacityFile": "'"${result_array[4]}"'"
    }'
}
sendErrorServer(){
capacityFile=$(du -sh ${DB_NAME}_$DATE.sql | awk '{print $1}')

curl -X POST http://10.0.0.210:5000/api/databases/info \
-H "Content-Type: application/json" \
-d '{"ipServer": "'"$IP"'",
    "hostname": "'"$ServerName"'",
    "osSystems": "'"$os_systems"'",
    "nameDatabase": "'"$nameDatabase"'",
    "pathBackup": "'"$PathBackUp"'",
    "status": "error",
    "capacityFile": "'"$Capacity"'"
    }'
}

# Send Telegram
if [ "$filedate" == "$today" ]; then
alertTelegramSuccess
sendSuccessServer
else
echo "loi"
sendErrorServer
alertTelegramError
fi


# for file in pg_archivelog*; do mv "$file" "new_$file"; done
