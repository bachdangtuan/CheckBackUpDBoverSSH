#!bin/bash

## Điều kiện bắt buộc phải có SSH key

# Variable
SERVER_IP='10.0.0.121'
COMMAND='
    echo "thành công"

'

ssh $SERVER_IP $COMMAND
