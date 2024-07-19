#!/bin/bash
# ash 環境に合わせて開発

month=$(TZ=UTC-9 date '+%Y-%m')
date=$(TZ=UTC-9 date '+%Y-%m-%d')
time=$(TZ=UTC-9 date '+%H:%M')

dir="/etc/archive"
dir_disk="/etc/archive/$date/disk_logger"
dir_int="/etc/archive/$date/interface_logger"

disk_log="$dir_disk/disk_metrics_$month.log"
temp_log="$dir_int/temperature_$date.log"
temp_path="/sys/class/thermal/thermal_zone0/temp"

disk_logger () {
  mkdir -p "$dir" "$dir_disk" 2>/dev/null
  echo "[$date]" >> "$disk_log"
  echo "・システム稼働時間" >> "$disk_log"
  uptime | sed 's/^ //g' >> "$disk_log"
  echo >> "$disk_log"
  echo "・各ディスク空き容量" >> "$disk_log"
  df -h >> "$disk_log"
  echo >> "$disk_log"
  echo "・各ディレクトリ容量" >> "$disk_log"
  du -sh /* >> "$disk_log" 2>/dev/null
  echo >> "$disk_log"
}

interface_logger () {
  mkdir -p "$dir" "$dir_int" 2>/dev/null
  cat $temp_path | sed -e 's/\([0-9]\{2\}\)\([0-9]\{3\}\)/\1.\2/g' -e 's/$/℃/g' -e "s/^/$date $time -> /g" >> "$temp_log"
  ints="br-lan eth0 lo rax0 tailscale0"
  i=1
  for int in $ints; do
  echo "$date $time" >> "$dir_int/${int}_$date.log"
  ifconfig -a $int >> "$dir_int/${int}_$date.log"
  i=$((i + 1))
  done
}

case $1 in
  "disk_logger")
    disk_logger
  ;;
  "interface_logger")
    interface_logger
  ;;
esac
