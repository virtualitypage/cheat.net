#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
year=2026
month=02
day=18
prev_day=17

function mergecap () {
  cd "$current_dir" || exit
  file_name=()
  for h in {0..22}; do
    hour=$(printf "%02d" "$h")
    file=$(echo "$year-$month-${day}_$hour-*.pcap")
    file_name+=("$file")
  done

  files=$(echo "${file_name[@]}" | tr -d '\n')
  echo -e "\033[1;32mmergecap $year-$month-${prev_day}_23.pcap $files -w $year-$month-${day}_22.pcap\033[0m"
  echo
  echo -e "\033[1;32meditcap -A \"$year-$month-${day} 23:00:00\" -B \"$year-$month-${day} 23:59:59\" $year-$month-${day}_23-00-*.pcap $year-$month-${day}_23.pcap\033[0m"
  echo
  echo -e "\033[1;32mmergecap $year-$month-${day}_22.pcap $year-$month-${day}_23.pcap -w $year-$month-${day}.pcap\033[0m"
}

function editcap () {
  echo -e "\033[1;32meditcap -A \"$year-$month-${day} 00:00:00\" -B \"$year-$month-${day} 00:00:59\" $year-$month-${prev_day}_23-00-*.pcap $year-$month-${prev_day}_23.pcap\033[0m"
}

# function editcap () {
#   cd "$current_dir" || exit
#   read -rp "before time >" before_time
#   read -rp "after time >" after_time
#   read -rp "before file name >" before_file
#   read -rp "after file name >" after_file
#   echo -e "\033[1;32meditcap -A \"$before_time\" -B \"$after_time\" $before_file ${after_file}\033[0m"
# }

case $1 in
  move)
    mv /Volumes/Internal/tcpdump/2026-02-${day}_* .
    cd "$current_dir" || exit
    gunzip -k 2026-02-${day}_*.gz
    ;;
  gunzip)
    cd "$current_dir" || exit
    gunzip -k 2026-02-${day}_*.gz
    ;;
  merge)
    mergecap
    ;;
  edit)
    editcap
    ;;
  *)
    echo "{ merge | edit }"
    ;;
esac
