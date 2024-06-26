#!/bin/bash
# ash 環境に合わせて開発

year=$(TZ=UTC-9 date '+%Y')
date=$(TZ=UTC-9 date '+%Y-%m-%d')
time=$(TZ=UTC-9 date '+%H_00_00')
dir="/etc/Archive/$date"
main_file="$dir/$time/system.csv"
sub_file="$dir/$time/system_${time}.log"
MacTableEntry="$dir/$time/MacTableEntry.csv"

systemlog_acquisition () {
  mkdir "$dir" "$dir/$time" 2>/dev/null
  cat /tmp/system.log >> "$sub_file"
}

systemlog_convert () {
  sed -e "s/ ${year} / /g" -e "s/^/${year}\//g" "$dir/$time/system_${time}.log" > "$main_file"
  days="Sun Mon Tue Wed Thu Fri Sat"
  i=1
  for day in $days; do
    sed -i.bak "s/${day} //g" "$main_file"
    i=$((i + 1))
  done
  j=1
  months="Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"
  for month in $months; do
    sed -i.bak "s/${month} /$j\//g" "$main_file"
    j=$((j + 1))
  done
  sed -i.bak 's/^\([^ ]* [^ ]*\) /\1,"/' "$main_file" # 各行の二つ目の半角スペースの前にコンマを挿入
  sed -i.bak 's/$/"/g' "$main_file"
  rm "$dir/$time/system.csv.bak"
}

mac_table_entry () {
  mac_table="04:d3:b5:f3:f6:a7 fc:87:43:48:63:7a b8:9a:2a:7d:79:7c 34:e8:94:8b:e1:96 54:f2:94:48:44:39 ca:23:49:d1:5c:33 58:40:4e:e4:d8:b2 8c:85:90:b9:18:32 86:a9:22:a4:9d:f2 82:dd:fa:5c:21:cc"
  host_table="alisa_HUAWEI_P30_lite ayako_HUAWEI_P30_lite DESKTOP-CL4OL20 DESKTOP-TCDB3LJ hideki_HUAWEI_P30_lite hideki_OPPO-A79-5G iMac-Kochi MacBook-Pro tetsuo_iPhone_SE yuki_iPhone_11_Pro_Max"
  while IFS=, read -r col1 col2; do
    case "$col2" in
      *MacTableInsertEntry*)
        echo "$col1,$col2" >> "$MacTableEntry"
      ;;
      *MacTableDeleteEntry*)
        echo "$col1,$col2" >> "$MacTableEntry"
      ;;
    esac
  done < "$main_file"
  i=1
  for mac in $mac_table; do
    host=$(echo "$host_table" | cut -d' ' -f$i)
    sed -i.bak "s/$mac/$host/g" "$MacTableEntry" 2>/dev/null
    i=$((i + 1))
  done
  sed -i.bak 's/kern.*New Sta:/MacTableInsertEntry(): /g' "$MacTableEntry" 2>/dev/null
  sed -i.bak 's/kern.*Del Sta:/MacTableDeleteEntry(): /g' "$MacTableEntry" 2>/dev/null
  sed -i.bak 's/_P30_lite/ P30 lite/g' "$MacTableEntry" 2>/dev/null
  sed -i.bak 's/iPhone_SE/iPhone SE/g' "$MacTableEntry" 2>/dev/null
  sed -i.bak 's/iPhone_11_Pro_Max/iPhone 11 Pro Max/g' "$MacTableEntry" 2>/dev/null
  rm "$dir/$time/MacTableEntry.csv.bak"
}
systemlog_acquisition
systemlog_convert
mac_table_entry
