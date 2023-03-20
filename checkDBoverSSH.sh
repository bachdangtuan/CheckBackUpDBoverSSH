#!bin/bash

## Điều kiện bắt buộc phải có SSH key

# Variable
SERVER_IP='10.0.0.121'


# Function check status postGres

test() {
  mkdir test
}

function check_server() {
  local command=$(test)
  ssh "$SERVER_IP" "$command"
}



# ssh $SERVER_IP '$(test) && echo "Success" || echo "Failure"'
