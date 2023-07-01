#!/bin/bash

# Parse the sar output for the past 30 days.
sar -A -f /var/log/sa/sa$(date +%d -d "30 days ago") > /tmp/sar_output

# Collect 10 instances with lowest %idle and store in /tmp/idle along with date and timestamp.
cat /tmp/sar_output | grep -v Average | sort -k9n | head -n 10 | awk '{print $1, $2, $9}' > /tmp/idle

# Collect 10 instances with highest %commit and store in /tmp/commit along with date and timestamp.
cat /tmp/sar_output | grep -v Average | sort -k10nr | head -n 10 | awk '{print $1, $2, $10}' > /tmp/commit

# Collect 10 instances with highest tps and store in /tmp/tps along with date and timestamp.
cat /tmp/sar_output | grep -v Average | sort -k3nr | head -n 10 | awk '{print $1, $2, $3}' > /tmp/tps

# Collect 10 instances with highest rd_sec/s and store in /tmp/read along with date and timestamp.
cat /tmp/sar_output | grep -v Average | sort -k4nr | head -n 10 | awk '{print $1, $2, $4}' > /tmp/read

# Collect 10 instances with highest wr_sec/s and store in /tmp/write along with date and timestamp.
cat /tmp/sar_output | grep -v Average | sort -k5nr | head -n 10 | awk '{print $1, $2, $5}' > /tmp/write

# End with a code that will calculate the average of the 10 lowest %idle, 10 highest %commit, 10 highest tps, 10 highest rd_sec/s, 10 highest wr_sec/s.
avg_idle=$(awk '{ sum += $3 } END { if (NR > 0) print sum / NR }' /tmp/idle)
avg_commit=$(awk '{ sum += $3 } END { if (NR > 0) print sum / NR }' /tmp/commit)
avg_tps=$(awk '{ sum += $3 } END { if (NR > 0) print sum / NR }' /tmp/tps)
avg_read=$(awk '{ sum += $3 } END { if (NR > 0) print sum / NR }' /tmp/read)
avg_write=$(awk '{ sum += $3 } END { if (NR > 0) print sum / NR }' /tmp/write)

# Add the average of rd_sec/s and wr_sec/s and convert to MB/s.
avg_rw=$((avg_read + avg_write))
avg_rw_mb=$((avg_rw*512/1024))

echo "The average of the 10 lowest %idle is: ${avg_idle}"
echo "The average of the 10 highest %commit is: ${avg_commit}"
echo "The average of the 10 highest tps is: ${avg_tps}"
echo "The average of the 10 highest rd_sec/s is: ${avg_read}"
echo "The average of the 10 highest wr_sec/s is: ${avg_write}"
echo "The average of rd_sec/s and wr_sec/s is: ${avg_rw} bytes/sec or ${avg_rw_mb} MB/sec"


sar -u -f $(ls /var/log/sa/sa[0-9]*) | sort -k 8 -n | head -n 10


#!/bin/bash

# Parse the sar output for all the available sar log files.
sar_files=$(ls /var/log/sa/sa[0-9]*)

# Collect 10 instances with lowest %idle and store in /tmp/idle along with date and timestam.
sar -u -f $sar_files | sort -k 8 -n | head -n 10 > /tmp/idle

# Collect 10 instances with highest %commit and store in /tmp/commit along with date and timestamp.
sar -r -f $sar_files | sort -k 9 -n | tail -n 10 > /tmp/commit

# Collect 10 instances with highest tps and store in /tmp/tps along with date and timestamp.
sar -b -f $sar_files | sort -k 2 -n | tail -n 10 > /tmp/tps

# Collect 10 instances with highest rd_sec/s for the block device with mountpoint named /eClinicalWorks and store in /tmp/read along with date and timestamp.
sar -dp -f $sar_files | grep "/eClinicalWorks" | sort -k 7 -n | tail -n 10 > /tmp/read

# Collect 10 instances with highest wr_sec/s block device with mountpoint named /eClinicalWorks and store in /tmp/write along with date and timestamp.
sar -dp -f $sar_files | grep "/eClinicalWorks" | sort -k 8 -n | tail -n 10 > /tmp/write

# Calculate the average of the 10 lowest %idle, 10 highest %commit, 10 highest tps, 10 highest rd_sec/s, 10 highest wr_sec/s.
avg_idle=$(awk '{ sum += $8 } END { if (NR > 0) print sum / NR }' /tmp/idle)
avg_commit=$(awk '{ sum += $9 } END { if (NR > 0) print sum / NR }' /tmp/commit)
avg_tps=$(awk '{ sum += $2 } END { if (NR > 0) print sum / NR }' /tmp/tps)
avg_read=$(awk '{ sum += $7 } END { if (NR > 0) print sum / NR }' /tmp/read)
avg_write=$(awk '{ sum += $8 } END { if (NR > 0) print sum / NR }' /tmp/write)

# Add the average of rd_sec/s and wr_sec/s and convert to MB/s after converting sectors per seconds to bytes per second.
avg_rd_wr=$((($avg_read + $avg_write) * 512))
avg_rd_wr_mb=$(echo "scale=2; $avg_rd_wr/(1024*1024)" | bc)

echo "The average of the following values are:"
echo "Lowest %idle: $avg_idle"
echo "Highest %commit: $avg_commit"
echo "Highest tps: $avg_tps"
echo "Highest rd_sec/s: $avg_read"
echo "Highest wr_sec/s: $avg_write"
echo "The average of rd_sec/s and wr_sec/s is $(printf '%.2f' "$avg_rd_wr_mb") MB/s."












#!/bin/bash

# Step 1: Parse sar output for all available sar log files
sar_files=$(ls /var/log/sa/sa[0-9][0-9])

# Step 2: Collect 10 instances with lowest %idle and store in /tmp/idle along with date and timestamp
for file in $sar_files; do
  echo "Date: $(date -r "$file" +"%Y-%m-%d %H:%M:%S")" >> /tmp/idle
  sar -f "$file" | awk '{if ($8 == "%idle") print $0}' | sort -k9n | head -n 10 >> /tmp/idle
  echo "---------------------" >> /tmp/idle
done

# Step 3: Collect 10 instances with highest %commit and store in /tmp/commit along with date and timestamp
for file in $sar_files; do
  echo "Date: $(date -r "$file" +"%Y-%m-%d %H:%M:%S")" >> /tmp/commit
  sar -f "$file" | awk '{if ($1 ~ /^[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$/) print $0}' | sort -k14nr | head -n 10 >> /tmp/commit
  echo "---------------------" >> /tmp/commit
done

# Step 4: Collect 10 instances with highest tps and store in /tmp/tps along with date and timestamp
for file in $sar_files; do
  echo "Date: $(date -r "$file" +"%Y-%m-%d %H:%M:%S")" >> /tmp/tps
  sar -f "$file" | awk '{if ($1 ~ /^[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$/) print $0}' | sort -k4nr | head -n 10 >> /tmp/tps
  echo "---------------------" >> /tmp/tps
done

# Step 5: Collect 10 instances with highest rd_sec/s for the block device with mountpoint named /eClinicalWorks and store in /tmp/read along with date and timestamp
for file in $sar_files; do
  echo "Date: $(date -r "$file" +"%Y-%m-%d %H:%M:%S")" >> /tmp/read
  sar -f "$file" -d | awk -v mountpoint="/eClinicalWorks" '$1 ~ /^[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$/ && $NF == mountpoint {print $0}' | sort -k6nr | head -n 10 >> /tmp/read
  echo "---------------------" >> /tmp/read
done

# Step 6: Collect 10 instances with highest wr_sec/s for the block device with mountpoint named /eClinicalWorks and store in /tmp/write along with date and timestamp
for file in $sar_files; do
  echo "Date: $(date -r "$file" +"%Y-%m-%d %H:%M:%S")" >> /tmp/write
  sar -f "$file" -d | awk -v mountpoint="/eClinicalWorks" '$1 ~ /^[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$/ && $NF == mountpoint {print $0}' | sort -k7nr | head -n 10 >> /tmp/write
  echo "---------------------" >> /tmp/write
done

# Step 7: Calculate the average of the 10 lowest %idle, 10 highest %commit, 10 highest tps, 10 highest rd_sec/s, 10 highest wr_sec/s
average_idle=$(awk '{sum += $9} END {print sum/NR}' /tmp/idle)
average_commit=$(awk '{sum += $14} END {print sum/NR}' /tmp/commit)
average_tps=$(awk '{sum += $4} END {print sum/NR}' /tmp/tps)
average_read=$(awk '{sum += $6} END {print sum/NR}' /tmp/read)
average_write=$(awk '{sum += $7} END {print sum/NR}' /tmp/write)

# Step 8: Add the average of rd_sec/s and wr_sec/s and convert to MB/s after converting sectors per second to bytes per second
average_io=$(echo "scale=2; ($average_read + $average_write) * 512 / 1024 / 1024" | bc)

# Print the results
echo "Average of the 10 lowest %idle: $average_idle"
echo "Average of the 10 highest %commit: $average_commit"
echo "Average of the 10 highest tps: $average_tps"
echo "Average of the 10 highest rd_sec/s: $average_read"
echo "Average of the 10 highest wr_sec/s: $average_write"
echo "Average of rd_sec/s + wr_sec/s in MB/s: $average_io MB/s"



rm -f /tmp/idle /tmp/commit /tmp/tps /tmp/read /tmp/write 