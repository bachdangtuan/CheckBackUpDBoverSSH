#!bin/bash

## Điều kiện bắt buộc phải có SSH key

# Variable
SERVER_IP='10.0.0.121'
TOKEN="6112203391:AAEuDTYX3KQRNuoLKuJ0NAtpRoamdHIQQkA"
CHAT_ID="-957135587"
URL="https://api.telegram.org/bot${TOKEN}/sendMessage"

# Gọi script tại server đã được SSH vào
ketqua=$(ssh "$SERVER_IP" "bash /root/scriptCheck/myscript.sh")

#read -r result_var <<< "$ketqua"
readarray -t result_array <<< "$ketqua"


# echo "$ketqua"

# # In kết quả
# #echo "Ket qua: $result_var"
# echo "IP la: ${result_array[0]}"
# echo "Server la: ${result_array[1]}"
# echo "PathBackUp: ${result_array[2]}"
# echo "Filename: ${result_array[3]}"


# Check alert 
filename=${result_array[3]}
filedate=${filename:11:10}   # lấy chuỗi ngày/tháng/năm từ tên file
today=$(date +%Y_%m_%d)      # lấy ngày hiện tại
nameDatabase=${filename:0:10}

echo $filedate
echo $nameDatabase


if [ "$filedate" == "$today" ]; then
  alertTelegramSuccess
else
  alertTelegramError
fi


SUCCESS="
==[BACKUP-SUCCESS]==
Server: ${result_array[1]}
Database: ${DB_NAME}
Address IP :${result_array[0]}/24
Nguyen nhan: Backup Dump thanh cong databases !
"

ERROR="
==[BACKUP-ERROR]==
Server: ${result_array[1]}
Database: ${DB_NAME}
Address IP :${result_array[0]}/24
Content: Backup backup du lieu khong thanh cong !
--------
Nguyen nhan: Backup DB backup bi ngat giua chung, quyen truy cap sai, khong co db, chua backup
"


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