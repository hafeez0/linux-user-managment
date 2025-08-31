#!/bin/bash
# Bulk User Creation Script

INPUT_FILE="users.csv"

if [ ! -f "$INPUT_FILE" ]; then
  echo "CSV file not found!"
  exit 1
fi

while IFS=',' read -r username group
do
  # Skip header line
  if [[ "$username" == "username" ]]; then
    continue
  fi

  # Create group if it doesn’t exist
  if ! getent group "$group" >/dev/null; then
    groupadd "$group"
    echo "Group $group created."
  fi

  # Create user if it doesn’t exist
  if ! id "$username" &>/dev/null; then
    useradd -m -g "$group" -s /bin/bash "$username"
    echo "$username:Password@123" | chpasswd
    passwd -e "$username"   # force password reset
    echo "User $username created in group $group."
  else
    echo "User $username already exists."
  fi
done < "$INPUT_FILE"

