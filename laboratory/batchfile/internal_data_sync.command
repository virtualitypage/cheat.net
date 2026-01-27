#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
yesterday=$(TZ=UTC-9 date -v-1d '+%Y-%m-%d')

year=${yesterday:0:4} # echo "$yesterday" | sed 's/^\(.\{4\}\).*/\1/' と同一
month=${yesterday:8:7}
months=${yesterday:0:7} # echo "$yesterday" | sed 's/^\(.\{7\}\).*/\1/' と同一
year_month=${year_month//-//} # 実行結果例：2025/12

src_dir_gl_mt3000="$current_dir/archive_GL-MT3000"
src_dir_fortigate50e="$current_dir/archive_fortigate50e"
github_path=$(find /Volumes/DevOps -type d -name "GitHub" 2>/dev/null | awk 'NR == 1')
dst_dir_gl_mt3000="$github_path/GL-MT3000_Internal/var/log/data/gl-mt3000"
dst_dir_fortigate50e="$github_path/GL-MT3000_Internal/var/log/data/fortigate50e"

function cpu_thermal_data_sync () {
  # cpu_thermal hostname: GL-MT3000
  cpu_thermal_A_src="$src_dir_gl_mt3000/luci_stat_$yesterday/thermal_zone0_$yesterday.csv"
  cpu_thermal_A_dst="$dst_dir_gl_mt3000/cpu_thermal/$year/$month"

  echo "rsync --archive --human-readable --progress \"$cpu_thermal_A_src\" \"$cpu_thermal_A_dst\""
  rsync --archive --human-readable --progress "$cpu_thermal_A_src" "$cpu_thermal_A_dst"
  echo

  # cpu_thermal hostname: FortiGate50e
  cpu_thermal_B_src="$src_dir_fortigate50e/luci_stat_$yesterday/thermal_zone0_$yesterday.csv"
  cpu_thermal_B_dst="$dst_dir_fortigate50e/cpu_thermal/$year/$month"

  echo "rsync --archive --human-readable --progress \"$cpu_thermal_B_src\" \"$cpu_thermal_B_dst\""
  rsync --archive --human-readable --progress "$cpu_thermal_B_src" "$cpu_thermal_B_dst"
  echo
}

function cpu_usage_data_sync () {
  # cpu_usage hostname: GL-MT3000
  cpu0_util_A_src="$src_dir_gl_mt3000/luci_stat_$yesterday/cpu-0_util_$yesterday.csv"
  cpu1_util_A_src="$src_dir_gl_mt3000/luci_stat_$yesterday/cpu-1_util_$yesterday.csv"
  cpu_usage_A_dst="$dst_dir_gl_mt3000/cpu_usage/$year/$month"

  echo "rsync --archive --human-readable --progress \"$cpu0_util_A_src\" \"$cpu1_util_A_src\" \"$cpu_usage_A_dst\""
  rsync --archive --human-readable --progress "$cpu0_util_A_src" "$cpu1_util_A_src" "$cpu_usage_A_dst"
  echo

  # cpu_usage hostname: FortiGate50e
  cpu0_util_B_src="$src_dir_fortigate50e/luci_stat_$yesterday/cpu-0_util_$yesterday.csv"
  cpu1_util_B_src="$src_dir_fortigate50e/luci_stat_$yesterday/cpu-1_util_$yesterday.csv"
  cpu_usage_B_dst="$dst_dir_fortigate50e/cpu_usage/$year/$month"

  echo "rsync --archive --human-readable --progress \"$cpu0_util_B_src\" \"$cpu1_util_B_src\" \"$cpu_usage_B_dst\""
  rsync --archive --human-readable --progress "$cpu0_util_B_src" "$cpu1_util_B_src" "$cpu_usage_B_dst"
  echo
}

function disk_usage_data_sync () {
  # disk_usage hostname: GL-MT3000
  disk_usage_gl_mt3000="$src_dir_gl_mt3000/disk_metrics_$months.csv"
  disk_metrics_gl_mt3000="$dst_dir_gl_mt3000/disk_usage/$year"

  echo "rsync --archive --human-readable --progress \"$disk_usage_gl_mt3000\" \"$disk_metrics_gl_mt3000\""
  rsync --archive --human-readable --progress "$disk_usage_gl_mt3000" "$disk_metrics_gl_mt3000"
  echo

  # disk_usage hostname: FortiGate50e
  disk_usage_fortigate50e="$src_dir_fortigate50e/disk_metrics_$months.csv"
  disk_metrics_fortigate50e="$dst_dir_fortigate50e/disk_usage/$year"

  echo "rsync --archive --human-readable --progress \"$disk_usage_fortigate50e\" \"$disk_metrics_fortigate50e\""
  rsync --archive --human-readable --progress "$disk_usage_fortigate50e" "$disk_metrics_fortigate50e"
  echo
}

function msmtp_log_data_sync () {
  # msmtp_log hostname: GL-MT3000
  msmtp_A_src="$src_dir_gl_mt3000/msmtp_$months.json"
  msmtp_A_dst="$dst_dir_gl_mt3000/msmtp_log/$year/msmtp_$months.json"

  echo "rsync --archive --human-readable --progress \"$msmtp_A_src\" \"$msmtp_A_dst\""
  rsync --archive --human-readable --progress "$msmtp_A_src" "$msmtp_A_dst"
  echo

  # msmtp_log hostname: FortiGate50e
  msmtp_B_src="$src_dir_fortigate50e/msmtp_$months.json"
  msmtp_B_dst="$dst_dir_fortigate50e/msmtp_log/$year/msmtp_$months.json"

  echo "rsync --archive --human-readable --progress \"$msmtp_B_src\" \"$msmtp_B_dst\""
  rsync --archive --human-readable --progress "$msmtp_B_src" "$msmtp_B_dst"
  echo
}

function traffic_stat_data_sync () {
  # br_lan_stat hostname: GL-MT3000
  br_lan_A_src="$src_dir_gl_mt3000/luci_stat_$yesterday/br-lan_$yesterday.csv"
  br_lan_A_dst="$dst_dir_gl_mt3000/traffic_stat/$year/$month/br-lan_$yesterday.csv"

  echo "rsync --archive --human-readable --progress \"$br_lan_A_src\" \"$br_lan_A_dst\""
  rsync --archive --human-readable --progress "$br_lan_A_src" "$br_lan_A_dst"
  echo

  # br_lan_stat hostname: FortiGate50e
  br_lan_B_src="$src_dir_fortigate50e/luci_stat_$yesterday/br-lan_$yesterday.csv"
  br_lan_B_dst="$dst_dir_fortigate50e/traffic_stat/$year/$month/br-lan_$yesterday.csv"

  echo "rsync --archive --human-readable --progress \"$br_lan_B_src\" \"$br_lan_B_dst\""
  rsync --archive --human-readable --progress "$br_lan_B_src" "$br_lan_B_dst"
  echo

  # eth0_stat hostname: GL-MT3000
  eth0_A_src="$src_dir_gl_mt3000/luci_stat_$yesterday/eth0_$yesterday.csv"
  eth0_A_dst="$dst_dir_gl_mt3000/traffic_stat/$year/$month/eth0_$yesterday.csv"

  echo "rsync --archive --human-readable --progress \"$eth0_A_src\" \"$eth0_A_dst\""
  rsync --archive --human-readable --progress "$eth0_A_src" "$eth0_A_dst"
  echo

  # br_wan_stat hostname: FortiGate50e
  br_wan_B_src="$src_dir_fortigate50e/luci_stat_$yesterday/br-wan_$yesterday.csv"
  br_wan_B_dst="$dst_dir_fortigate50e/traffic_stat/$year/$month/br-wan_$yesterday.csv"

  echo "rsync --archive --human-readable --progress \"$br_wan_B_src\" \"$br_wan_B_dst\""
  rsync --archive --human-readable --progress "$br_wan_B_src" "$br_wan_B_dst"
  echo

  # tailscale0_stat hostname: GL-MT3000
  tailscale0_A_src="$src_dir_gl_mt3000/luci_stat_$yesterday/tailscale0_$yesterday.csv"
  tailscale0_A_dst="$dst_dir_gl_mt3000/traffic_stat/$year/$month/tailscale0_$yesterday.csv"

  echo "rsync --archive --human-readable --progress \"$tailscale0_A_src\" \"$tailscale0_A_dst\""
  rsync --archive --human-readable --progress "$tailscale0_A_src" "$tailscale0_A_dst"
  echo

  # tailscale0_stat hostname: FortiGate50e
  tailscale0_B_src="$src_dir_fortigate50e/luci_stat_$yesterday/tailscale0_$yesterday.csv"
  tailscale0_B_dst="$dst_dir_fortigate50e/traffic_stat/$year/$month/tailscale0_$yesterday.csv"

  echo "rsync --archive --human-readable --progress \"$tailscale0_B_src\" \"$tailscale0_B_dst\""
  rsync --archive --human-readable --progress "$tailscale0_B_src" "$tailscale0_B_dst"
  echo
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの同期処理が正常に終了しました。\033[0m"
  echo
}

rm -f $src_dir_gl_mt3000/._* $src_dir_gl_mt3000/*/._*
rm -f $src_dir_fortigate50e/._* $src_dir_fortigate50e/*/._*

if [ -e "$dst_dir_gl_mt3000" ] && [ -e "$dst_dir_fortigate50e" ]; then
  echo -e "\033[1;32mSUCCESS: GitHub が有効です。\033[0m"
  echo
  cpu_thermal_data_sync
  cpu_usage_data_sync
  disk_usage_data_sync
  msmtp_log_data_sync
  traffic_stat_data_sync
else
  echo -e "\033[1;31mERROR: GitHub にアクセス出来ません。ディレクトリが存在するか確認して再度実行してください。\033[0m"
  echo
  exit 1
fi
