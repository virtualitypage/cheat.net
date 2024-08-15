#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
current_dir=$(echo $current_dir | sed 's/\/@COMMAND//g')
src_dir="$current_dir/archive"
yesterday=$(TZ=UTC-9 date -v -1d '+%Y-%m-%d')
yesterday_date=$(TZ=UTC-9 date -v -1d '+%m/%d')
date=$(find $src_dir/$yesterday -type f -name CPU_temp_*.log)
year=$(basename "$date" | sed -e 's/CPU_temp_//g' -e 's/^\(.\{4\}\).*/\1/')
month=$(basename "$date" | sed -e 's/CPU_temp_//g' -e 's/^\(.\{7\}\).*/\1/')
month_=$(basename "$date" | sed -e 's/CPU_temp_//g' -e 's/^\(.\{7\}\).*/\1/' -e 's/-/_/g')

drive="$HOME/Library/CloudStorage/GoogleDrive-youguigujing42@gmail.com/マイドライブ/共有フォルダ/Internal/var/log/audit_trail/gl-mt3000"
github="$current_dir/GitHub/GL-MT3000_Internal/var/log/audit_trail/gl-mt3000"

function audit_trail_high_availability () {
  # cpu_usage
  cpu_usage_temp="$src_dir/$yesterday/CPU_temp_$yesterday.log"
  cpu_usage_util="$src_dir/$yesterday/CPU_util_$yesterday.log"
  cpu_usage_A="$drive/cpu_usage/$month_"
  cpu_usage_B="$github/cpu_usage/$month_"

  echo "setfile -m \"$yesterday_date/$year 23:50\" \"$cpu_usage_temp\" \"$cpu_usage_util\""
  setfile -m "$yesterday_date/$year 23:50" "$cpu_usage_temp" "$cpu_usage_util"
  echo "rsync --archive --human-readable --progress \"$cpu_usage_temp\" $cpu_usage_A"
  rsync --archive --human-readable --progress "$cpu_usage_temp" $cpu_usage_A
  echo
  echo "rsync --archive --human-readable --progress \"$cpu_usage_temp\" $cpu_usage_B"
  rsync --archive --human-readable --progress "$cpu_usage_temp" $cpu_usage_B
  echo
  echo "rsync --archive --human-readable --progress \"$cpu_usage_util\" $cpu_usage_A"
  rsync --archive --human-readable --progress "$cpu_usage_util" $cpu_usage_A
  echo
  echo "rsync --archive --human-readable --progress \"$cpu_usage_util\" $cpu_usage_B"
  rsync --archive --human-readable --progress "$cpu_usage_util" $cpu_usage_B
  echo

  # process
  process="$src_dir/$yesterday/process_kill_$yesterday.log"
  process_A="$drive/process/$month_"
  process_B="$github/process/$month_"

  echo "setfile -m \"$yesterday_date/$year 23:50\" \"$process\""
  setfile -m "$yesterday_date/$year 23:50" "$process"
  echo "rsync --archive --human-readable --progress \"$process\" $process_A"
  rsync --archive --human-readable --progress "$process" $process_A
  echo
  echo "rsync --archive --human-readable --progress \"$process\" $process_B"
  rsync --archive --human-readable --progress "$process" $process_B
  echo

  # disk_usage
  disk_metrics="$src_dir/disk_logger/disk_metrics_$month.log"
  disk_metrics_A="$drive/disk_usage/$year"
  disk_metrics_B="$github/disk_usage/$year"

  echo "rsync --archive --human-readable --progress \"$disk_metrics\" $disk_metrics_A"
  rsync --archive --human-readable --progress "$disk_metrics" $disk_metrics_A
  echo
  echo "rsync --archive --human-readable --progress \"$disk_metrics\" $disk_metrics_B"
  rsync --archive --human-readable --progress "$disk_metrics" $disk_metrics_B
  echo

  # msmtp
  msmtp="$src_dir/msmtp.log"
  msmtp_A="$drive/msmtp.log"
  msmtp_B="$github/msmtp.log"

  echo "rsync --archive --human-readable --progress \"$msmtp\" $msmtp_A"
  rsync --archive --human-readable --progress "$msmtp" $msmtp_A
  echo
  echo "rsync --archive --human-readable --progress \"$msmtp\" $msmtp_B"
  rsync --archive --human-readable --progress "$msmtp" $msmtp_B
  echo

  # traffic_stat
  br_lan="$src_dir/interface_logger/br-lan_$month.log"
  br_lan_A="$drive/traffic_stat/$year"
  br_lan_B="$github/traffic_stat/$year"

  echo "rsync --archive --human-readable --progress \"$br_lan\" $br_lan_A"
  rsync --archive --human-readable --progress "$br_lan" $br_lan_A
  echo
  echo "rsync --archive --human-readable --progress \"$br_lan\" $br_lan_B"
  rsync --archive --human-readable --progress "$br_lan" $br_lan_B
  echo

  eth0="$src_dir/interface_logger/eth0_$month.log"
  eth0_A="$drive/traffic_stat/$year"
  eth0_B="$github/traffic_stat/$year"

  echo "rsync --archive --human-readable --progress \"$eth0\" $eth0_A"
  rsync --archive --human-readable --progress "$eth0" $eth0_A
  echo
  echo "rsync --archive --human-readable --progress \"$eth0\" $eth0_B"
  rsync --archive --human-readable --progress "$eth0" $eth0_B
  echo

  lo="$src_dir/interface_logger/lo_$month.log"
  lo_A="$drive/traffic_stat/$year"
  lo_B="$github/traffic_stat/$year"

  echo "rsync --archive --human-readable --progress \"$lo\" $lo_A"
  rsync --archive --human-readable --progress "$lo" $lo_A
  echo
  echo "rsync --archive --human-readable --progress \"$lo\" $lo_B"
  rsync --archive --human-readable --progress "$lo" $lo_B
  echo

  rax0="$src_dir/interface_logger/rax0_$month.log"
  rax0_A="$drive/traffic_stat/$year"
  rax0_B="$github/traffic_stat/$year"

  echo "rsync --archive --human-readable --progress \"$rax0\" $rax0_A"
  rsync --archive --human-readable --progress "$rax0" $rax0_A
  echo
  echo "rsync --archive --human-readable --progress \"$rax0\" $rax0_B"
  rsync --archive --human-readable --progress "$rax0" $rax0_B
  echo

  tailscale0="$src_dir/interface_logger/tailscale0_$month.log"
  tailscale0_A="$drive/traffic_stat/$year"
  tailscale0_B="$github/traffic_stat/$year"

  echo "rsync --archive --human-readable --progress \"$tailscale0\" $tailscale0_A"
  rsync --archive --human-readable --progress "$tailscale0" $tailscale0_A
  echo
  echo "rsync --archive --human-readable --progress \"$tailscale0\" $tailscale0_B"
  rsync --archive --human-readable --progress "$tailscale0" $tailscale0_B
  echo
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの同期処理が正常に終了しました。\033[0m"
  echo
}

URL="https://drive.google.com/drive/my-drive"
success=$(curl -I $URL 2>/dev/null | head -n 1)
failure=$(curl -I $URL 2>&1 | grep -o "Could not resolve host")

if [ "$success" ] && [ -e "$src_volume" ]; then
  echo -e "\033[1;32mSUCCESS: $success\033[0m"
elif [ "$failure" == "Could not resolve host" ]; then
  echo -e "\033[1;31mNETWORK ERROR: Google Drive にアクセス出来ませんでした。端末が Wi-Fi に接続されているか確認して再度実行してください。\033[0m"
  echo
  exit 1
fi

if [ -e "$drive" ] && [ -e "$github" ]; then
  echo -e "\033[1;32mSUCCESS: Google Drive ／ GitHub 共に有効です。\033[0m"
  echo
  audit_trail_high_availability
else
  echo -e "\033[1;31mERROR: Google Drive ／ GitHub またはその両方にアクセス出来ません。端末が Wi-Fi に接続されているか等を確認して再度実行してください。\033[0m"
  echo
  exit 1
fi
