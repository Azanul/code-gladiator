#!/bin/bash

# Set your token here
TOKEN=""

RESPONSE=$(curl --header "X-Vault-Token: Bearer $TOKEN" --request POST https://gladiator-kms.fly.dev/v1/cubbyhole/my-secret)
PASS=$(echo "$RESPONSE" | jq -r '.data.key')


# Function to encrypt the solution file
SOLUTION_FILE="solution"
encrypt_solution_file() {
  # Encrypt the solution file using OpenSSL with AES-256-CBC
  openssl enc -aes-256-cbc -salt -in "$SOLUTION_FILE" -out "$SOLUTION_FILE.enc" -pass "pass:$PASS"
  
  # Remove the original solution file
  rm "$SOLUTION_FILE"
  
  # Rename the encrypted file to the original file name
  mv "$SOLUTION_FILE.enc" "$SOLUTION_FILE"
  
  echo "Solution file encrypted successfully."
}

# Call the encryption function
encrypt_solution_file

# Proceed with the git push
exit 0
