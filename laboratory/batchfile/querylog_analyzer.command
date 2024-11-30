#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
uniq_file="$current_dir/Querylog_Analysis_uniq.csv"
stat_file="$current_dir/Querylog_Analysis_stat.csv"
domain_file="$current_dir/Querylog_Analysis_domain.csv"
file_name="$current_dir/Querylog_Analysis"

read -p "クエリログファイルを指定して下さい: " sub_file
read -p "分析対象のIPアドレスを入力して下さい: " ip_addr

query_file="$current_dir/Querylog Analysis - $ip_addr.csv"
echo "時刻,総クエリ数,ドメイン" > "$query_file"

for h in {0..23}; do
  for m in {0..5}; do
    hour=$(printf "%02d" $h)
    grep -B2 "$ip_addr" "$current_dir/$sub_file" | grep "$hour:${m}[0-9]:[0-5][0-9]" | sed 's/\"//g' | awk -F ',' '{ print $2 }' > "$stat_file"
    sort -u "$stat_file" | sed 's/$/, /g' > "$uniq_file"
    sort "$stat_file" | sed 's/, $//g' >> "$domain_file"
    count=$(wc -l "$stat_file" | awk '{ print $1 }')
    uniq_query=$(cat "$uniq_file" | tr -d '\n' | sed -e 's/, $//g' -e 's/^/"/g' -e 's/$/"/g')
    echo "$hour:${m}0,$count,$uniq_query" >> "$query_file"
  done
done

sort -u "$domain_file" > "$uniq_file"

function mirrativ () {
  mkdir "$current_dir/mirrativ"
  count_file="$current_dir/mirrativ/Querylog_Analysis_mirrativ"
  main_file="${file_name}_mirrativ.com.txt"

  array=()
  while IFS= read -r csv; do
    array+=("$csv")
  done < <(grep "mirrativ.com" "$uniq_file")

  for domain in "${array[@]}"; do
    count=$(grep -o "$domain" "$query_file" | wc -l | awk '{ print $1 }')
    echo "$count: $domain" >> "$count_file.csv"
  done
  sort -n "$count_file.csv" > "$count_file.txt"

  # 個数が 1〜5 のドメインをまとめる
  grep -E "^[1-5]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[1-5]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 6 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" > "$main_file"

  # 個数が 6〜9 のドメインをまとめる
  grep -E "^[6-9]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[6-9]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 10 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" >> "$main_file"

  # 個数が 10〜15 のドメインをまとめる
  grep -E "^[1][0-5]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[1][0-5]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 16 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" >> "$main_file"

  # 個数が 16〜19 のドメインをまとめる
  grep -E "^[1][6-9]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[1][6-9]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 20 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" >> "$main_file"

  # 個数が 20〜25 のドメインをまとめる
  grep -E "^[2][0-5]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[2][0-5]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 26 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" >> "$main_file"

  # 個数が 26〜29 のドメインをまとめる
  grep -E "^[2][6-9]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[2][6-9]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 30 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" >> "$main_file"

  # 個数が 30〜35 のドメインをまとめる
  grep -E "^[3][0-5]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[3][0-5]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 36 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" >> "$main_file"

  # 個数が 36〜39 のドメインをまとめる
  grep -E "^[3][6-9]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[3][6-9]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 40 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" >> "$main_file"

  # 個数が 40〜45 のドメインをまとめる
  grep -E "^[4][0-5]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[4][0-5]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 46 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" >> "$main_file"

  # 個数が 46〜49 のドメインを追加
  grep -E "^[4][6-9]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[4][6-9]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 50 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" >> "$main_file"

  # 個数が 50〜99 のドメインを追加
  grep -E "^[5][0-9]:" "$count_file.txt" > "${count_file}_A.txt"
  cat "${count_file}_A.txt" >> "$main_file"

  # 個数が 100〜999 のドメインを追加
  grep -E "^[1-9][0-9][0-9]:" "$count_file.txt" > "${count_file}_A.txt"
  cat "${count_file}_A.txt" >> "$main_file"
  main_file=$(basename "$main_file")
}

function easebar () {
  mkdir "$current_dir/easebar"
  count_file="$current_dir/easebar/Querylog_Analysis_easebar"
  main_file="${file_name}_easebar.com.txt"

  array=()
  while IFS= read -r csv; do
    array+=("$csv")
  done < <(grep "easebar.com" "$uniq_file")

  for domain in "${array[@]}"; do
    count=$(grep -o "$domain" "$query_file" | wc -l | awk '{ print $1 }')
    echo "$count: $domain" >> "$count_file.csv"
  done
  sort -n "$count_file.csv" > "$count_file.txt"

  # 個数が 1〜5 のドメインをまとめる
  grep -E "^[1-5]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[1-5]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 6 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" > "$main_file"

  # 個数が 6〜9 のドメインをまとめる
  grep -E "^[6-9]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[6-9]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 10 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" >> "$main_file"

  # 個数が 10〜15 のドメインをまとめる
  grep -E "^[1][0-5]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[1][0-5]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 16 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" >> "$main_file"

  # 個数が 16〜19 のドメインをまとめる
  grep -E "^[1][6-9]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[1][6-9]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 20 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" >> "$main_file"

  # 個数が 20〜25 のドメインをまとめる
  grep -E "^[2][0-5]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[2][0-5]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 26 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" >> "$main_file"

  # 個数が 26〜29 のドメインをまとめる
  grep -E "^[2][6-9]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[2][6-9]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 30 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" >> "$main_file"

  # 個数が 30〜35 のドメインをまとめる
  grep -E "^[3][0-5]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[3][0-5]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 36 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" >> "$main_file"

  # 個数が 36〜39 のドメインをまとめる
  grep -E "^[3][6-9]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[3][6-9]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 40 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" >> "$main_file"

  # 個数が 40〜45 のドメインをまとめる
  grep -E "^[4][0-5]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[4][0-5]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 46 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" >> "$main_file"

  # 個数が 46〜49 のドメインを追加
  grep -E "^[4][6-9]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[4][6-9]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 50 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" >> "$main_file"

  # 個数が 50〜99 のドメインを追加
  grep -E "^[5][0-9]:" "$count_file.txt" > "${count_file}_A.txt"
  cat "${count_file}_A.txt" >> "$main_file"

  # 個数が 100〜999 のドメインを追加
  grep -E "^[1-9][0-9][0-9]:" "$count_file.txt" > "${count_file}_A.txt"
  cat "${count_file}_A.txt" >> "$main_file"
  main_file=$(basename "$main_file")
}

function netease () {
  mkdir "$current_dir/netease"
  count_file="$current_dir/netease/Querylog_Analysis_netease"
  main_file="${file_name}_netease.com.txt"

  array=()
  while IFS= read -r csv; do
    array+=("$csv")
  done < <(grep "netease.com" "$uniq_file")

  for domain in "${array[@]}"; do
    count=$(grep -o "$domain" "$query_file" | wc -l | awk '{ print $1 }')
    echo "$count: $domain" >> "$count_file.csv"
  done
  sort -n "$count_file.csv" > "$count_file.txt"

  # 個数が 1〜5 のドメインをまとめる
  grep -E "^[1-5]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[1-5]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 6 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" > "$main_file"

  # 個数が 6〜9 のドメインをまとめる
  grep -E "^[6-9]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[6-9]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 10 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" >> "$main_file"

  # 個数が 10〜15 のドメインをまとめる
  grep -E "^[1][0-5]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[1][0-5]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 16 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" >> "$main_file"

  # 個数が 16〜19 のドメインをまとめる
  grep -E "^[1][6-9]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[1][6-9]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 20 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" >> "$main_file"

  # 個数が 20〜25 のドメインをまとめる
  grep -E "^[2][0-5]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[2][0-5]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 26 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" >> "$main_file"

  # 個数が 26〜29 のドメインをまとめる
  grep -E "^[2][6-9]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[2][6-9]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 30 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" >> "$main_file"

  # 個数が 30〜35 のドメインをまとめる
  grep -E "^[3][0-5]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[3][0-5]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 36 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" >> "$main_file"

  # 個数が 36〜39 のドメインをまとめる
  grep -E "^[3][6-9]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[3][6-9]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 40 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" >> "$main_file"

  # 個数が 40〜45 のドメインをまとめる
  grep -E "^[4][0-5]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[4][0-5]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 46 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" >> "$main_file"

  # 個数が 46〜49 のドメインを追加
  grep -E "^[4][6-9]:" "$count_file.txt" > "${count_file}_A.txt"
  sed -i '' -e '1s/.*: /set TargetDomain to {"/g' -e 's/[4][6-9]: /"/g' -e 's/$/", /g' "${count_file}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${count_file}_A.txt"
  cat "${count_file}_A.txt" | tr -d '\n' > "${count_file}_B.txt"
  sed -i '' -e '1s/^/repeat 50 times\n/' -e 's/,   //g' -e 's/}/}\n\n/g' "${count_file}_B.txt"
  cat "${count_file}_B.txt" >> "$main_file"

  # 個数が 50〜99 のドメインを追加
  grep -E "^[5][0-9]:" "$count_file.txt" > "${count_file}_A.txt"
  cat "${count_file}_A.txt" >> "$main_file"

  # 個数が 100〜999 のドメインを追加
  grep -E "^[1-9][0-9][0-9]:" "$count_file.txt" > "${count_file}_A.txt"
  cat "${count_file}_A.txt" >> "$main_file"
  main_file=$(basename "$main_file")
}

function success_message () {
  main_file=$(basename "$file_name")
  query_file=$(basename "$query_file")
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$query_file: DNS クエリ分析用 csv ファイル\033[0m"
  echo -e "\033[1;32m${main_file}_mirrativ.com.txt: Apple Script 用 mirrativ.com definition list\033[0m"
  echo -e "\033[1;32m${main_file}_easebar.com.txt: Apple Script 用 easebar.com definition list\033[0m"
  echo -e "\033[1;32m${main_file}_netease.com.txt: Apple Script 用 netease.com definition list\033[0m"
  echo
  rm -r "$stat_file" "$uniq_file" "$domain_file" "$current_dir/mirrativ" "$current_dir/easebar" "$current_dir/netease"
}

mirrativ
easebar
netease
success_message
