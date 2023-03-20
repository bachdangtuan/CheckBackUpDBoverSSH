#!bin/bash

## Điều kiện bắt buộc phải có SSH key

# Variable
SERVER_IP='10.0.0.121'

variable_name() {
  # Body of the function
  # ...
  echo "thanh cong"
}

# Create a script that defines the function and calls it
echo 'function_to_call=$(declare -f variable_name); eval "$function_to_call"; variable_name' > myscript.sh

# Make the script executable
chmod +x myscript.sh

# Call the script using SSH
ssh "$SERVER_IP" "./myscript.sh"
