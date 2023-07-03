#!/bin/bash

# Clean up existing files
truncate -s 0 /tmp/idle
truncate -s 0 /tmp/modified_sar_log_file
truncate -s 0 /tmp/sorted_values

# Parse the sar output for all available sar log files
sar_files=$(ls /var/log/sa/sa[0-9][0-9])

# Iterate over each sar log file
for file in $sar_files; do
    # Clear temporary file
    truncate -s 0 /tmp/readsar

    # Extract relevant information from sar log and append to temporary file
    sar -f "$file" | grep -v Average | awk '{if ($8 ~ /^[0-9]+(\.[0-9]+)?$/) print $0}' >> /tmp/readsar

    # Append modified output with date information to another file
    awk -v logdate="$(date -r "$file" +"%Y-%m-%d")" '{print logdate, $0}' /tmp/readsar >> /tmp/modified_sar_log_file
done

# Append current date and relevant CPU usage information to a file
echo "Date       Timestamp       CPU     %user     %nice   %system   %iowait    %steal     %idle" > /tmp/sorted_values

# Sort the modified sar log file based on the 10th column and append the top 5 instances to the same file
sort -nk10 /tmp/modified_sar_log_file | awk '{if ($10 ~ /^[0-9]+(\.[0-9]+)?$/) print $0}' | head -n5 >> /tmp/sorted_values

# Print a separator
echo "------------------------------------"
# Display the header for the top 5 instances with high CPU usage
echo "Top 5 Instances with High CPU Usage"
echo "------------------------------------"
# Display the top 5 instances with high CPU usage
cat /tmp/sorted_values

#!/bin/bash

# Clean up existing files
truncate -s 0 /tmp/idle
truncate -s 0 /tmp/modified_sar_log_file
truncate -s 0 /tmp/sorted_values

# Parse the sar output for all available sar log files
sar_files=$(ls /var/log/sa/sa[0-9][0-9])

# Iterate over each sar log file
for file in $sar_files; do
    # Clear temporary file
    truncate -s 0 /tmp/readsar

    # Extract relevant information from sar log and append to temporary file
    sar -r -f "$file" | grep -v Average | awk '{if ($5 ~ /^[0-9]+(\.[0-9]+)?$/) print $0}' >> /tmp/readsar

    # Append modified output with date information to another file
    awk -v logdate="$(date -r "$file" +"%Y-%m-%d")" '{print logdate, $0}' /tmp/readsar >> /tmp/modified_sar_log_file
done

# Append current date and relevant memory usage information to a file
echo "Date       Timestamp   kbmemfree kbmemused  %memused kbbuffers  kbcached  kbcommit   %commit  kbactive   kbinact   kbdirty" > /tmp/sorted_values

# Sort the modified sar log file based on the 5th column in reverse order and append the top 5 instances to the same file
sort -rnk5 /tmp/modified_sar_log_file | awk '{if ($5 ~ /^[0-9]+(\.[0-9]+)?$/) print $0}' | head -n5 >> /tmp/sorted_values

# Print a separator and display the top 5 instances with high memory usage
echo "------------------------------------"
echo "Top 5 instances with High Memory Usage"
echo "------------------------------------"
cat /tmp/sorted_values


# Clean up existing files
truncate -s 0 /tmp/idle
truncate -s 0 /tmp/modified_sar_log_file
truncate -s 0 /tmp/sorted_values

# Parse the sar output for all available sar log files
sar_files=$(ls /var/log/sa/sa[0-9][0-9])

# Iterate over each sar log file
for file in $sar_files; do
    # Clear temporary file
    truncate -s 0 /tmp/readsar

    # Extract relevant information from sar log and append to temporary file
    sar -d -f "$file" | grep -v Average | awk '{if ($4 ~ /^[0-9]+(\.[0-9]+)?$/) print $0}' >> /tmp/readsar

    # Append modified output with date information to another file
    awk -v logdate="$(date -r "$file" +"%Y-%m-%d")" '{print logdate, $0}' /tmp/readsar >> /tmp/modified_sar_log_file
done

# Append current date and relevant sar information to a file
echo "Date       Timestamp         DEV       tps  rd_sec/s  wr_sec/s  avgrq-sz  avgqu-sz     await     svctm     %util" > /tmp/sorted_values

# Sort the modified sar log file based on the 5th column in reverse order and append the top 5 instances to the same file
sort -rnk5 /tmp/modified_sar_log_file | awk '{if ($5 ~ /^[0-9]+(\.[0-9]+)?$/) print $0}' | head -5 >> /tmp/sorted_values

# Print a separator and display the top 5 instances with high tps (transactions per second)
echo "------------------------------------"
echo "Top 5 instances with High tps (Transactions per Second)"
echo "------------------------------------"
cat /tmp/sorted_values

truncate -s 0 /tmp/sorted_values

# Append current date and relevant sar information to a file
echo "Date       Timestamp         DEV       tps  rd_sec/s  wr_sec/s  avgrq-sz  avgqu-sz     await     svctm     %util" > /tmp/sorted_values

sort -rnk6 /tmp/modified_sar_log_file | awk '{if ($6 ~ /^[0-9]+(\.[0-9]+)?$/) print $0}' | head -5 >> /tmp/sorted_values

# Print a separator and display the top 5 instances with high read sectors per second
echo "------------------------------------"
echo "Top 5 instances with High ReadSectors/Second"
echo "------------------------------------"
cat /tmp/sorted_values

# Extract the maximum read throughput in MB/s from the sorted values
max=$(awk 'NR == 2' /tmp/sorted_values | awk '{printf "Read: %.2f MB/s\n", $6 * 512 / (1024 * 1024)}')

# Extract the device name in the format "X:Y" from "devX-Y"
dev=$(awk 'NR == 2' /tmp/sorted_values | awk '{print $4}' | sed 's/dev\([0-9]\)-\([0-9]\)/\1:\2/')

# Find the disk name associated with the device name
disk=$(lsblk | grep $dev | awk '{print $1}')

# Display the maximum read throughput and the corresponding disk
echo "We observe the maximum throughput of $max on $disk."

truncate -s 0 /tmp/sorted_values

# Append current date and relevant sar information to a file
echo "Date       Timestamp         DEV       tps  rd_sec/s  wr_sec/s  avgrq-sz  avgqu-sz     await     svctm     %util" > /tmp/sorted_values

sort -rnk7 /tmp/modified_sar_log_file | awk '{if ($6 ~ /^[0-9]+(\.[0-9]+)?$/) print $0}' | head -5 >> /tmp/sorted_values

# Print a separator and display the top 5 instances with high write sectors per second
echo "------------------------------------"
echo "Top 5 instances with High WriteSectors/Second"
echo "------------------------------------"
cat /tmp/sorted_values

# Extract the maximum write throughput in MB/s from the sorted values
max=$(awk 'NR == 2' /tmp/sorted_values | awk '{printf "Write: %.2f MB/s\n", $7 * 512 / (1024 * 1024)}')

# Extract the device name in the format "8:0" from "dev8-0"
dev=$(awk 'NR == 2' /tmp/sorted_values | awk '{print $4}' | sed 's/dev\([0-9]\)-\([0-9]\)/\1:\2/')

# Find the disk name associated with the device name
disk=$(lsblk | grep $dev | awk '{print $1}')

# Display the maximum write throughput and the corresponding disk
echo "We observe the maximum throughput of $max on $disk."
