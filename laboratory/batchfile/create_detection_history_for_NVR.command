#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
year=2026

function channel1 () {
  FLAG="false"
  while IFS= read -r line; do
    if [ "$line" = "・Channel1" ]; then
      FLAG="true"
      continue
    fi

    if [ $FLAG = "true" ]; then
      line=$(echo "$line" | awk '{ gsub("-", ":", $2); print }')
      echo "●,$line,CH1" >> "$history_file"
    fi

    if [ "$line" = "・Channel2" ] || [ "$line" = "・Channel3" ] || [ "$line" = "・Channel4" ]; then
      FLAG="false"
      break
    fi
  done < "$status_file.tmp"
}

function channel2 () {
  FLAG="false"
  while IFS= read -r line; do
    if [ "$line" = "・Channel2" ]; then
      FLAG="true"
      continue
    fi

    if [ $FLAG = "true" ]; then
      line=$(echo "$line" | awk '{ gsub("-", ":", $2); print }')
      echo "●,$line,CH2" >> "$history_file"
    fi

    if [ "$line" = "・Channel3" ] || [ "$line" = "・Channel4" ]; then
      FLAG="false"
      break
    fi
  done < "$status_file.tmp"
}

function channel3 () {
  FLAG="false"
  while IFS= read -r line; do
    if [ "$line" = "・Channel3" ]; then
      FLAG="true"
      continue
    fi

    if [ $FLAG = "true" ]; then
      line=$(echo "$line" | awk '{ gsub("-", ":", $2); print }')
      echo "●,$line,CH3" >> "$history_file"
    fi

    if [ "$line" = "・Channel4" ]; then
      FLAG="false"
      break
    fi
  done < "$status_file.tmp"
}

function channel4 () {
  FLAG="false"
  while IFS= read -r line; do
    if [ "$line" = "・Channel4" ]; then
      FLAG="true"
      continue
    fi

    if [ $FLAG = "true" ]; then
      line=$(echo "$line" | awk '{ gsub("-", ":", $2); print }')
      echo "●,$line,CH4" >> "$history_file"
    fi
  done < "$status_file.tmp"
}

read -p "有効動体検知の通知履歴まとめを実行する月数を選択 [ 1..12 ]: " m
month=$(printf "%02d" "$m")
for d in {1..31}; do
  day=$(printf "%02d\n" "$d")
  status_file="$current_dir/$year-$month-$day status nvr.txt"
  history_file="$current_dir/$year-$month-$day history nvr.csv"
  sed -e 's/ ->.*//g' -e 's/_/ /g' -e 's/.mov//g' "$status_file" > "$status_file.tmp"
  channel1
  channel2
  channel3
  channel4
  rm "$status_file.tmp"

  command=$(
  cat << EOF
sort "$history_file" > "$history_file.tmp"
sed -i '' 's/$/\n｜/g' "$history_file.tmp"
sed -e '/・Channel2/d' -e '/・Channel3/d' -e '/・Channel4/d' "$history_file.tmp" > "$history_file"
rm "$history_file.tmp"
EOF
  )
  echo -e "\033[1;36mINFO: 最後に以下のコマンドを実行\033[0m"
  echo "$command"
  echo
done
