#!bin/bash

## Điều kiện bắt buộc phải có SSH key

# Variable
SERVER_IP='10.0.0.121'


# Function check status postGres

test(){
    echo "test"
}


ssh "$SERVER_IP" "$(test && echo 'Success' || echo 'Failure')"

# ssh $SERVER_IP 'ls && echo "Success" || echo "Failure"'
