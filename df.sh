#!/bin/bash

# Check if the following mount points exist in df -GB command output
# with minimum size as specified

mount_points=(
  "/ 25G"
  "/usr 7G"
  "/boot 1G"
  "/home 10G"
  "/var 15G"
  "/var/log 25G"
  "/var/log/audit 15G"
  "/var/tmp 15G"
  "/tmp 10G"
)

# Loop through the mount points
for mount_point in "${mount_points[@]}"; do
  # Split the mount point into its components
  mount_point_name=$(echo "$mount_point" | cut -d " " -f1)
  mount_point_size=$(echo "$mount_point" | cut -d " " -f2)

  # Check if the mount point exists
  grep -aq "$mount_point_name" /etc/fstab
  if [[ $? -ne 0 ]]; then
    echo "Mount point $mount_point_name does not exist"
  fi

  # Check if the mount point size is at least the specified size
  df -BG | grep -a "$mount_point_name" | awk '{print $4}' | grep -q "$mount_point_size"
  if [[ $? -ne 0 ]]; then
    echo "Mount point $mount_point_name is too small (should be at least $mount_point_size GB)"
  fi
done

# Report any failures
if [[ $? -ne 0 ]]; then
  echo "There were some failures"
fi

#!/bin/bash

# Check if the /mnt or /mnt/resource mount point exists in df -GB command
# If the server hostname contains the case insensitive keywords "db" or "ebo" and the mount point exists, then parameter is a pass.
# Else, if the keywords are not present and the mount point exists, mark the parameter as a fail and display the reason as "Server is not DB or EBO but /mnt is present".
# Else, if the keywords are not present and the mount point is also not present, then parameter is a pass.

server_hostname=$(hostname)

# Check if the mount point exists
mount_points=(
  "/mnt"
  "/mnt/resource"
)

for mount_point in "${mount_points[@]}"; do
  # Check if the mount point exists
  grep -q "$mount_point" /etc/fstab
  if [[ $? -eq 0 ]]; then
    # Check if the server hostname contains the keywords "db" or "ebo"
    if [[ $server_hostname =~ db|ebo ]]; then
      # The server hostname contains the keywords, so this is a pass
      echo "Server hostname contains the keywords 'db' or 'ebo', so this is a pass"
    else
      # The server hostname does not contain the keywords, but the mount point exists, so this is a fail
      echo "Server is not DB or EBO but /mnt is present"
    fi
  else
    # The mount point does not exist, so this is a pass
    echo "$mount_point mount point does not exist"
  fi
done








#!/bin/bash

# Check if the server hostname contains the case insensitive keyword "db"
server_hostname=$(hostname)

if [[ $server_hostname =~ db ]]; then
  # Check if the mount point exists
  mount_points=(
    "/data"
    "/db"
    "/eClinicalWorks"
  )

  for mount_point in "${mount_points[@]}"; do
    # Check if the mount point exists
    grep -q "$mount_point" /etc/fstab
    if [[ $? -ne 0 ]]; then
      # The mount point does not exist, so this is a fail
      echo "None of the mount points /data, /db, or /eClinicalWorks are present"
    fi
  done
else
  # Check if the /eClinicalWorks partition is present
  grep -q "eClinicalWorks" /etc/fstab
  if [[ $? -ne 0 ]]; then
    # The partition does not exist, so ask the user to get an exception
    echo "The /eClinicalWorks partition does not exist, so please get an exception for building the server without a data drive"
  fi
fi