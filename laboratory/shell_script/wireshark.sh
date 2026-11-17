#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)

function port_remove () { # Internalサーバーのネットワークに接続しているローカルなPC専用の関数
  cd "$current_dir" || exit
  server_path="/Volumes/Internal/tmp"
  end_day=$(date -v1d -v+1m -v-1d -j -f "%Y/%m" "$year/$month" +%d)
  for ((d = start_day; d <= end_day; d++)); do
    day=$(printf "%02d\n" "$d")
    current_date="$year-$month-$day"
    next_date=$(date -v+1d -j -f "%Y/%m/%d" "$year/$month/$day" +%Y-%m-%d)
    for h in {0..23}; do
      hour=$(printf "%02d" "$h")
      tshark -r "$server_path/${current_date}_$hour-00-"*.pcap -Y "not udp.port == 3478" -F pcap -w "${current_date}_$hour-00-00.pcap"
      A="$(stat -f %z $server_path/${current_date}_$hour-00-*.pcap | awk '{
        if ($1 <= 1024) {
          printf "%d B\n", $1
        } else if ($1 < 1048576) {
          printf "%.2f KB\n", $1/1024
        } else if ($1 < 1073741824) {
          printf "%.2f MB\n", $1/1024/1024
        }
      }')"
      B="$(stat -f %z ${current_date}_$hour-00-00.pcap | awk '{
        if ($1 <= 1024) {
          printf "%d B\n", $1
        } else if ($1 < 1048576) {
          printf "%.2f KB\n", $1/1024
        } else if ($1 < 1073741824) {
          printf "%.2f MB\n", $1/1024/1024
        }
      }')"
      echo -e "\033[1;32m${current_date}_$hour-00-00.pcap：$A -> $B\n\033[0m"
      sleep 2
    done
    read -p "Next: $next_date, Press the \"Enter key\" to proceed ..."
  done
}

function mergecap () {
  cd "$current_dir" || exit
  server_path="/Volumes/Internal/var/tcpdump/$year-$month"
  end_day=$(date -v1d -v+1m -v-1d -j -f "%Y/%m" "$year/$month" +%d)
  for ((d = start_day; d <= end_day; d++)); do
    day=$(printf "%02d\n" "$d")
    prev_date=$(date -v-1d -j -f "%Y/%m/%d" "$year/$month/$day" +%Y-%m-%d)
    current_date="$year-$month-$day"
    next_date=$(date -v+1d -j -f "%Y/%m/%d" "$year/$month/$day" +%Y-%m-%d)
    echo
    echo -e "\033[1;37m####################################################################################################\033[0m"
    echo
    echo -e "\033[1;36m# １回目に実行（ファイルが存在しない場合は次のコマンドを実行）\033[0m"
    echo -e "\033[1;32meditcap -A \"$current_date 00:00:00\" -B \"$current_date 00:00:59\" ${prev_date}_23-00-*.pcap ${prev_date}_23.pcap\033[0m"
    echo

    file_name=()
    for h in {0..22}; do
      hour=$(printf "%02d" "$h")
      file=$(echo "${current_date}_$hour"-*.pcap)
      file_name+=("$file")
    done
    files=$(echo "${file_name[@]}" | tr -d '\n')

    echo -e "\033[1;36m# ２回目に実行\033[0m"
    echo -e "\033[1;32mmergecap ${prev_date}_23.pcap $files -w ${current_date}_22.pcap\033[0m"
    echo
    echo -e "\033[1;36m# ３回目に実行\033[0m"
    echo -e "\033[1;32meditcap -A \"${current_date} 23:00:00\" -B \"${current_date} 23:59:59\" ${current_date}_23-00-*.pcap ${current_date}_23.pcap\033[0m"
    echo
    echo -e "\033[1;36m# ４回目に実行（実行後は ${current_date}.pcap を開いて「解決したアドレス」「終端」にてデータを取得する）\033[0m"
    echo -e "\033[1;32mmergecap ${current_date}_22.pcap ${current_date}_23.pcap -w ${current_date}.pcap\033[0m"
    echo
    echo -e "\033[1;36m# ５回目に実行\033[0m"
    echo -e "\033[1;32mmkdir $current_date\nmv ${current_date}_{00..22}-*.pcap ${current_date}_{22..23}.pcap $current_date\nmv ${prev_date}_23-*.pcap $prev_date\nrm ${prev_date}_23.pcap\033[0m"
    echo
    echo -e "\033[1;36m# ６回目に実行\033[0m"
    echo -e "\033[1;32mmv ${current_date}.pcap $server_path\033[0m"
    echo
    read -p "Next: $next_date, Press the \"Enter key\" to proceed ..."
  done
}

read -p "キャプチャファイルの年数・月数・日数を選択 [ 2026 | 2027 ] [ 1..12 ] [ 1..31 ]: " year month start_day
read -p "キャプチャファイルの処理コマンドを選択 [ port_remove | merge | move | gunzip | rescue ]: " mode

case $mode in
  port_remove)
    port_remove
  ;;
  merge)
    mergecap
  ;;
  move)
    mv /Volumes/Internal/tcpdump/"$year-$month-$start_day"_* . 2>/dev/null
    cd "$current_dir" || exit
    # gunzip -k "$year-$month-$start_day"_*.gz
    ls -lh $HOME/Desktop/tcpdump/*.pcap
  ;;
  gunzip)
    cd "$current_dir" || exit
    gunzip -k "$year-$month-$start_day"_*.gz
  ;;
  rescue)
    echo "構文：gunzip -c [YYYY-MM-DD_HH-MM-SS.pcap.gz] > [YYYY-MM-DD_HH-MM-SS.pcap]"
  ;;
  *)
  ;;
esac
