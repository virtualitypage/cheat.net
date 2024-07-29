#!/bin/bash
# ash 環境に合わせて開発

month=$(TZ=UTC-9 date '+%Y-%m')
date=$(TZ=UTC-9 date '+%Y-%m-%d')
time=$(TZ=UTC-9 date '+%H:%M')

dir="/etc/archive"
dir_disk="/etc/archive/disk_logger"
dir_int="/etc/archive/interface_logger"
dir_temp="/etc/archive/$date"

disk_log="$dir_disk/disk_metrics_$month.log"
temp_log="$dir_temp/temperature_$date.log"
cpu_log="$dir_temp/CPU_utilization_$date.log"
kill_log="$dir_temp/proccess_kill_$date.log"
temp_path="/sys/class/thermal/thermal_zone0/temp"

disk_logger () {
  mkdir "$dir" "$dir_disk" "$dir_int" 2>/dev/null
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

traffic_logger () {
  ints="br-lan eth0 lo rax0 tailscale0"
  i=1
  for int in $ints; do
    echo "$date" >> "$dir_int/${int}_$month.log"
    ifconfig $int | grep "RX bytes:" | sed -e 's/          //g' -e 's/  /\n/g' > "$dir_int/${int}_cache.log"
    sed -i.bak -e 's/RX bytes:[^ ]* (\(.*\))/RX bytes: \1/p' -e 's/TX bytes:[^ ]* (\(.*\))/TX bytes: \1/p' "$dir_int/${int}_cache.log"
    echo >> "$dir_int/${int}_cache.log"
    sed -e '1d' -e '4d' "$dir_int/${int}_cache.log" >> "$dir_int/${int}_$month.log"
    rm "$dir_int/${int}_cache.log" "$dir_int/${int}_cache.log.bak"
    i=$((i + 1))
  done
}

cpu_logger () {
  mkdir -p "$dir" "$dir_temp" 2>/dev/null
  cat $temp_path | sed -e 's/\([0-9]\{2\}\)\([0-9]\{3\}\)/\1.\2/g' -e 's/$/℃/g' -e "s/^/$date $time -> /g" >> "$temp_log"
  mpstat | awk 'NR==4 {printf "%.2f\n", 100-$12}' | sed "s/^/$date $time -> /g" >> "$cpu_log"
  # NRで4行目、$12で12列目のフィールドを指定、その値から100引いてCPU総使用率(少数第2位)を求める
  ps=$(ps aux | grep "cat /dev/urandom" | grep -v grep | awk 'NR==1 {print $2}' 2>&1)
  echo "$ps" | sed "s/^/$date $time -> /g" >> "$kill_log"
  kill "$ps"
}

csv_conversion () {
  sed -e 's/ /,/g' -e 's/℃//g' "$temp_log" > "$temp_log.csv"
  sed -e 's/ /,/g' "$cpu_log" > "$cpu_log.csv"
}

case $1 in
  "disk_logger")
    disk_logger
  ;;
  "traffic_logger")
    traffic_logger
  ;;
  "cpu_logger")
    cpu_logger
  ;;
  "csv_conversion")
    csv_conversion
  ;;
esac
