#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
yesterday=$(TZ=UTC-9 date -v-1d '+%Y-%m-%d')
SetFile_date=$(TZ=UTC-9 date -v-1d '+%m/%d')

year=${yesterday:0:4} # echo "$yesterday" | sed 's/^\(.\{4\}\).*/\1/' と同一
month=${yesterday:0:7} # echo "$yesterday" | sed 's/^\(.\{7\}\).*/\1/' と同一
year_month=${year_month//-//} # 実行結果例：2025/12

src_dir_gl_mt3000="$current_dir/archive_GL-MT3000"
src_dir_fortigate50e="$current_dir/archive_FortiGate50E"
github_path=$(find /Volumes/DevOps -type d -name "GitHub" 2>/dev/null | awk 'NR == 1')
dst_dir_gl_mt3000="$github_path/GL-MT3000_Internal/var/log/data/gl-mt3000"
dst_dir_fortigate50e="$github_path/GL-MT3000_Internal/var/log/data/fortigate50e"

function cpu_usage_data_sync () {
  # cpu_usage hostname: GL-MT3000
  cpu0_util_A_src="$src_dir_gl_mt3000/luci_stat_$yesterday/cpu-0_util_$yesterday.csv"
  cpu1_util_A_src="$src_dir_gl_mt3000/luci_stat_$yesterday/cpu-1_util_$yesterday.csv"
  cpu_usage_A_dst="$dst_dir_gl_mt3000/cpu_usage/$year_month"

  SetFile -m "$SetFile_date/$year 23:50" "$cpu0_util_A_src" "$cpu1_util_A_src"
  SetFile -d "$SetFile_date/$year 23:50" "$cpu0_util_A_src" "$cpu1_util_A_src"
  echo "rsync --archive --human-readable --progress \"$cpu0_util_A_src\" \"$cpu1_util_A_src\" \"$cpu_usage_A_dst\""
  rsync --archive --human-readable --progress "$cpu0_util_A_src" "$cpu1_util_A_src" "$cpu_usage_A_dst"
  echo

  # cpu_usage hostname: FortiGate50e
  cpu0_util_B_src="$src_dir_fortigate50e/luci_stat_$yesterday/cpu-0_util_$yesterday.csv"
  cpu1_util_B_src="$src_dir_fortigate50e/luci_stat_$yesterday/cpu-1_util_$yesterday.csv"
  cpu_usage_B_dst="$dst_dir_fortigate50e/cpu_usage/$year_month"

  SetFile -m "$SetFile_date/$year 23:50" "$cpu0_util_B_src" "$cpu1_util_B_src"
  SetFile -d "$SetFile_date/$year 23:50" "$cpu0_util_B_src" "$cpu1_util_B_src"
  echo "rsync --archive --human-readable --progress \"$cpu0_util_B_src\" \"$cpu1_util_B_src\" \"$cpu_usage_B_dst\""
  rsync --archive --human-readable --progress "$cpu0_util_B_src" "$cpu1_util_B_src" "$cpu_usage_B_dst"
  echo
}

function disk_usage_data_sync () {
  # disk_usage hostname: GL-MT3000
  disk_usage_gl_mt3000="$src_dir_gl_mt3000/disk_logger/disk_metrics_$month.csv"
  disk_metrics_gl_mt3000="$dst_dir_gl_mt3000/disk_usage/$year"

  echo "rsync --archive --human-readable --progress \"$disk_usage_gl_mt3000\" \"$disk_metrics_gl_mt3000\""
  rsync --archive --human-readable --progress "$disk_usage_gl_mt3000" "$disk_metrics_gl_mt3000"
  echo

  # disk_usage hostname: FortiGate50e
  disk_usage_fortigate50e="$src_dir_fortigate50e/disk_logger/disk_metrics_$month.csv"
  disk_metrics_fortigate50e="$dst_dir_fortigate50e/disk_usage/$year"

  echo "rsync --archive --human-readable --progress \"$disk_usage_fortigate50e\" \"$disk_metrics_fortigate50e\""
  rsync --archive --human-readable --progress "$disk_usage_fortigate50e" "$disk_metrics_fortigate50e"
  echo
}

function msmtp_log_data_sync () {
  # msmtp_log hostname: GL-MT3000
  msmtp_A_src="$src_dir_gl_mt3000/msmtp_$month.json"
  msmtp_A_dst="$dst_dir_gl_mt3000/msmtp_log/$year/msmtp_$month.json"

  echo "rsync --archive --human-readable --progress \"$msmtp_A_src\" \"$msmtp_A_dst\""
  rsync --archive --human-readable --progress "$msmtp_A_src" "$msmtp_A_dst"
  echo

  # msmtp_log hostname: FortiGate50e
  msmtp_B_src="$src_dir_fortigate50e/msmtp_$month.json"
  msmtp_B_dst="$dst_dir_fortigate50e/msmtp_log/$year/msmtp_$month.json"

  echo "rsync --archive --human-readable --progress \"$msmtp_B_src\" \"$msmtp_B_dst\""
  rsync --archive --human-readable --progress "$msmtp_B_src" "$msmtp_B_dst"
  echo
}

function traffic_stat_data_sync () {
  # br_lan_stat hostname: GL-MT3000
  br_lan_A_src="$src_dir_gl_mt3000/luci_stat_$yesterday/br-lan_$yesterday.csv"
  br_lan_A_dst="$dst_dir_gl_mt3000/traffic_stat/$year_month/br-lan_$yesterday.csv"

  SetFile -m "$SetFile_date/$year 23:50" "$br_lan_A_src"
  SetFile -d "$SetFile_date/$year 23:50" "$br_lan_A_src"
  echo "rsync --archive --human-readable --progress \"$br_lan_A_src\" \"$br_lan_A_dst\""
  rsync --archive --human-readable --progress "$br_lan_A_src" "$br_lan_A_dst"
  echo

  # br_lan_stat hostname: FortiGate50e
  br_lan_B_src="$src_dir_fortigate50e/luci_stat_$yesterday/br-lan_$yesterday.csv"
  br_lan_B_dst="$dst_dir_fortigate50e/traffic_stat/$year_month/br-lan_$yesterday.csv"

  SetFile -m "$SetFile_date/$year 23:50" "$br_lan_B_src"
  SetFile -d "$SetFile_date/$year 23:50" "$br_lan_B_src"
  echo "rsync --archive --human-readable --progress \"$br_lan_B_src\" \"$br_lan_B_dst\""
  rsync --archive --human-readable --progress "$br_lan_B_src" "$br_lan_B_dst"
  echo

  # eth0_stat hostname: GL-MT3000
  eth0_A_src="$src_dir_gl_mt3000/luci_stat_$yesterday/eth0_$yesterday.csv"
  eth0_A_dst="$dst_dir_gl_mt3000/traffic_stat/$year_month/eth0_$yesterday.csv"

  SetFile -m "$SetFile_date/$year 23:50" "$eth0_A_src"
  SetFile -d "$SetFile_date/$year 23:50" "$eth0_A_src"
  echo "rsync --archive --human-readable --progress \"$eth0_A_src\" \"$eth0_A_dst\""
  rsync --archive --human-readable --progress "$eth0_A_src" "$eth0_A_dst"
  echo

  # br_wan_stat hostname: FortiGate50e
  br_wan_B_src="$src_dir_fortigate50e/luci_stat_$yesterday/br_wan_$yesterday.csv"
  br_wan_B_dst="$dst_dir_fortigate50e/traffic_stat/$year_month/br_wan_$yesterday.csv"

  SetFile -m "$SetFile_date/$year 23:50" "$br_wan_B_src"
  SetFile -d "$SetFile_date/$year 23:50" "$br_wan_B_src"
  echo "rsync --archive --human-readable --progress \"$br_wan_B_src\" \"$br_wan_B_dst\""
  rsync --archive --human-readable --progress "$br_wan_B_src" "$br_wan_B_dst"
  echo

  # tailscale0_stat hostname: GL-MT3000
  tailscale0_A_src="$src_dir_gl_mt3000/luci_stat_$yesterday/tailscale0_$yesterday.csv"
  tailscale0_A_dst="$dst_dir_gl_mt3000/traffic_stat/$year_month/tailscale0_$yesterday.csv"

  SetFile -m "$SetFile_date/$year 23:50" "$tailscale0_A_src"
  SetFile -d "$SetFile_date/$year 23:50" "$tailscale0_A_src"
  echo "rsync --archive --human-readable --progress \"$tailscale0_A_src\" \"$tailscale0_A_dst\""
  rsync --archive --human-readable --progress "$tailscale0_A_src" "$tailscale0_A_dst"
  echo

  # tailscale0_stat hostname: FortiGate50e
  tailscale0_B_src="$src_dir_fortigate50e/luci_stat_$yesterday/tailscale0_$yesterday.csv"
  tailscale0_B_dst="$dst_dir_fortigate50e/traffic_stat/$year_month/tailscale0_$yesterday.csv"

  SetFile -m "$SetFile_date/$year 23:50" "$tailscale0_B_src"
  SetFile -d "$SetFile_date/$year 23:50" "$tailscale0_B_src"
  echo "rsync --archive --human-readable --progress \"$tailscale0_B_src\" \"$tailscale0_B_dst\""
  rsync --archive --human-readable --progress "$tailscale0_B_src" "$tailscale0_B_dst"
  echo
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの同期処理が正常に終了しました。\033[0m"
  echo
}

if [ -e "$dst_dir_gl_mt3000" ] && [ -e "$dst_dir_fortigate50e" ]; then
  echo -e "\033[1;32mSUCCESS: GitHub が有効です。\033[0m"
  echo
  cpu_usage_data_sync
  disk_usage_data_sync
  msmtp_log_data_sync
  traffic_stat_data_sync
  rm -r archive_GL-MT3000 archive_FortiGate50E
else
  echo -e "\033[1;31mERROR: GitHub にアクセス出来ません。ディレクトリが存在するか確認して再度実行してください。\033[0m"
  echo
  exit 1
fi
