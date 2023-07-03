The script starts by cleaning up existing files /tmp/idle, /tmp/modified_sar_log_file, and /tmp/sorted_values to ensure a fresh start.

Next, it parses the sar output for all available sar log files in the /var/log/sa/ directory.

For each sar log file, it extracts relevant information and appends it to the temporary file /tmp/readsar. This information includes CPU usage percentages but excludes average values.

The modified output, along with the date information obtained from the file's last modification date, is then appended to /tmp/modified_sar_log_file.

After that, the script appends the header line to /tmp/sorted_values to prepare for storing sorted values.

The script sorts the content of /tmp/modified_sar_log_file based on the 10th column (CPU usage) in ascending order. It filters out any non-numeric values and keeps only the top 5 instances. These sorted values are then appended to /tmp/sorted_values.

A separator is printed to visually separate the header from the top 5 instances with high CPU usage.

The header "Top 5 Instances with High CPU Usage" is displayed to provide context.

Finally, the content of /tmp/sorted_values, which contains the top 5 instances with high CPU usage, is printed to the console.

This script allows you to analyze CPU usage trends over time and identify the top 5 instances that contribute the most to high CPU usage.




The script begins by clearing any existing files /tmp/idle, /tmp/modified_sar_log_file, and /tmp/sorted_values.

Next, it parses the sar output for all available sar log files in the /var/log/sa/ directory.

For each sar log file, it clears the temporary file /tmp/readsar and then extracts relevant information related to memory usage from the sar log. The extracted data is appended to the temporary file.

The modified output, along with the date information obtained from the file's last modification date, is then appended to /tmp/modified_sar_log_file.

After that, the script appends the header line to /tmp/sorted_values to prepare for storing sorted values related to memory usage.

The script sorts the content of /tmp/modified_sar_log_file based on the 5th column (percentage memory usage) in reverse order. It filters out any non-numeric values and keeps only the top 5 instances. These sorted values are then appended to /tmp/sorted_values.

A separator is printed to visually separate the header from the top 5 instances with high memory usage.

The header "Top 5 instances with High Memory Usage" is displayed to provide context.

Finally, the content of /tmp/sorted_values, which contains the top 5 instances with high memory usage, is printed to the console.

This script allows you to analyze memory usage patterns over time and identify the top 5 instances consuming the most memory.




The script starts by cleaning up any existing files: /tmp/idle, /tmp/modified_sar_log_file, and /tmp/sorted_values.

Next, it parses the sar output for all available sar log files in the /var/log/sa/ directory.

For each sar log file, it clears the temporary file /tmp/readsar and then extracts relevant information related to disk activity from the sar log. The extracted data is appended to the temporary file.

The modified output, along with the date information obtained from the file's last modification date, is then appended to /tmp/modified_sar_log_file.

After that, the script appends the header line to /tmp/sorted_values to prepare for storing sorted values related to disk activity.

The script sorts the content of /tmp/modified_sar_log_file based on the 5th column (transactions per second - tps) in reverse order. It filters out any non-numeric values and keeps only the top 5 instances. These sorted values are then appended to /tmp/sorted_values.

A separator is printed to visually separate the header from the top 5 instances with high tps.

The header "Top 5 instances with High tps (Transactions per Second)" is displayed to provide context.

Finally, the content of /tmp/sorted_values, which contains the top 5 instances with high tps, is printed to the console.

This script allows you to analyze disk activity and identify the top 5 instances with the highest number of transactions per second.




In this continuation of the script, the existing /tmp/sorted_values file is truncated to remove any previous content.

The script appends the header line to /tmp/sorted_values to prepare for storing sorted values related to disk activity.

The content of /tmp/modified_sar_log_file is sorted based on the 6th column (read sectors per second) in reverse order. It filters out any non-numeric values and keeps only the top 5 instances. These sorted values are then appended to /tmp/sorted_values.

A separator is printed to visually separate the header from the top 5 instances with high read sectors per second.

The header "Top 5 instances with High ReadSectors/Second" is displayed to provide context.

Finally, the content of /tmp/sorted_values, which contains the top 5 instances with high read sectors per second, is printed to the console.

The script then extracts the maximum read throughput in megabytes per second (MB/s) from the second line of /tmp/sorted_values. The value is calculated by multiplying the 6th column (read sectors per second) by the sector size (512 bytes) and converting it to megabytes. The maximum read throughput is stored in the variable max.

The device name (in the format devX-Y) associated with the second line of /tmp/sorted_values is extracted and stored in the variable dev. The sed command is used to convert the device name to the format X:Y.

To find the disk name associated with the device name, the lsblk command is used to list block devices, and grep is used to match the device name. The disk name is then extracted and stored in the variable disk.

Finally, the script displays a message indicating the maximum read throughput and the corresponding disk name. For example, "We observe the maximum throughput of X.XX MB/s on diskX."




In this continuation of the script, the existing /tmp/sorted_values file is truncated to remove any previous content.

The script appends the header line to /tmp/sorted_values to prepare for storing sorted values related to disk activity.

The content of /tmp/modified_sar_log_file is sorted based on the 7th column (write sectors per second) in reverse order. It filters out any non-numeric values and keeps only the top 5 instances. These sorted values are then appended to /tmp/sorted_values.

A separator is printed to visually separate the header from the top 5 instances with high write sectors per second.

The header "Top 5 instances with High WriteSectors/Second" is displayed to provide context.

Finally, the content of /tmp/sorted_values, which contains the top 5 instances with high write sectors per second, is printed to the console.

The script then extracts the maximum write throughput in megabytes per second (MB/s) from the second line of /tmp/sorted_values. The value is calculated by multiplying the 7th column (write sectors per second) by the sector size (512 bytes) and converting it to megabytes. The maximum write throughput is stored in the variable max.

The device name (in the format devX-Y) associated with the second line of /tmp/sorted_values is extracted and stored in the variable dev. The sed command is used to convert the device name to the format X:Y.

To find the disk name associated with the device name, the lsblk command is used to list block devices, and grep is used to match the device name. The disk name is then extracted and stored in the variable disk.

Finally, the script displays a message indicating the maximum write throughput and the corresponding disk name. For example, "We observe the maximum throughput of X.XX MB/s on diskX."