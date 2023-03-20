#!bin/bash

## Điều kiện bắt buộc phải có SSH key

# Variable
SERVER_IP='10.0.0.121'


# Function check status postGres

checkStatusPostGre(){
    service patroni status
}


ssh $SERVER_IP `$checkStatusPostGre && echo "Success" || echo "Failure"`

# ssh $SERVER_IP 'ls && echo "Success" || echo "Failure"'
