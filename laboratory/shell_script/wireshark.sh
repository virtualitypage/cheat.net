#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
year=
prev_month=
month=
day=
prev_day=

function editcap () {
  echo -e "\033[1;32meditcap -A \"$year-$month-${day} 00:00:00\" -B \"$year-$month-${day} 00:00:59\" $year-$prev_month-${prev_day}_23-00-*.pcap $year-$prev_month-${prev_day}_23.pcap\033[0m"
}

function mergecap () {
  cd "$current_dir" || exit
  file_name=()
  for h in {0..22}; do
    hour=$(printf "%02d" "$h")
    file=$(echo "$year-$month-${day}_$hour-*.pcap")
    file_name+=("$file")
  done

  files=$(echo "${file_name[@]}" | tr -d '\n')
  echo -e "\033[1;32mmergecap $year-$prev_month-${prev_day}_23.pcap $files -w $year-$month-${day}_22.pcap\033[0m"
  echo
  echo -e "\033[1;32meditcap -A \"$year-$month-${day} 23:00:00\" -B \"$year-$month-${day} 23:59:59\" $year-$month-${day}_23-00-*.pcap $year-$month-${day}_23.pcap\033[0m"
  echo
  echo -e "\033[1;32mmergecap $year-$month-${day}_22.pcap $year-$month-${day}_23.pcap -w $year-$month-${day}.pcap\033[0m"
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
    mv /Volumes/Internal/tcpdump/$year-$month-${day}_* . 2>/dev/null
    cd "$current_dir" || exit
    gunzip -k $year-$month-${day}_*.gz
    ls -lh $HOME/Desktop/tcpdump/*.pcap
  ;;
  gunzip)
    cd "$current_dir" || exit
    gunzip -k $year-$month-${day}_*.gz
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
