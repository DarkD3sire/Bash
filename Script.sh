#!/bin/bash
truncate -s 0 /tmp/idle
truncate -s 0 /tmp/modified_sar_log_file
truncate -s 0 /tmp/lowest_values.txt
# Parse the sar output for all the available sar log files.
sar_files=$(ls /var/log/sa/sa[0-9][0-9])
for file in $sar_files; do
  	truncate -s 0 /tmp/readsar
	sar -f "$file" | grep -v Average | awk '{if ($8 ~ /^[0-9]+(\.[0-9]+)?$/) print $0}' >> /tmp/readsar
	awk -v logdate="$(date -r "$file" +"%Y-%m-%d")" '{print logdate, $0}' /tmp/readsar >> /tmp/modified_sar_log_file
done
echo "$(date +"%Y-%m-%d") $(sar | head -n 3 | tail -n 1)" > /tmp/lowest_values.txt
sort -nk10 /tmp/modified_sar_log_file | awk '{if ($10 ~ /^[0-9]+(\.[0-9]+)?$/) print $0}' | head -n5 >> /tmp/lowest_values.txt
echo "------------------------------------"
echo "Top 5 instances with High CPU Usage"
echo "------------------------------------"
cat /tmp/lowest_values.txt