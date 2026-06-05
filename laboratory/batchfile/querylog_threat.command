#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
cd "$current_dir" || exit

# 必要に応じて値を変更する
last_line=
ip_address1=192.168.8.117
ip_address2=192.168.8.219
ip_address3=192.168.8.235
ip_address4=192.168.8.159
ip_address5=192.168.8.160
ip_address6=192.168.8.204
ip_address7=192.168.8.163

# GL-MT3000 (Beryl AX) ブロックされた脅威 - 月間レポート YYYY.numbers の「検知クライアント毎の詳細(アクセスしたドメイン) 」１行目にあるドメインを以下に貼り付ける
domain_name_array=()

function gen_blocked_domains () {
  for domain_name in "${domain_name_array[@]}"; do
    code=$(
      cat << EOF
"=COUNTIFS!(querylog_threat::\$B2:\$B$last_line, ""$domain_name"")",
EOF
    )
    echo "$code" >> "querylog_threat(blocked_domains).csv"
  done

  domains=$(cat "querylog_threat(blocked_domains).csv" | tr -d '\n')
  echo "$domains" > "querylog_threat(blocked_domains).csv"
  sed -i '' 's/,$//g' "querylog_threat(blocked_domains).csv"
}

function gen_blocked_domains_client () {
  files=() # 処理に必要な空配列

  for domain_name in "${domain_name_array[@]}"; do
    file="querylog_threat($domain_name).csv"
    code=$(
      cat << EOF
"=COUNTIFS!(querylog_threat::\$F2:\$F$last_line, ""$ip_address1"", querylog_threat::\$B2:\$B$last_line, ""$domain_name"")"
"=COUNTIFS!(querylog_threat::\$F2:\$F$last_line, ""$ip_address2"", querylog_threat::\$B2:\$B$last_line, ""$domain_name"")"
"=COUNTIFS!(querylog_threat::\$F2:\$F$last_line, ""$ip_address3"", querylog_threat::\$B2:\$B$last_line, ""$domain_name"")"
"=COUNTIFS!(querylog_threat::\$F2:\$F$last_line, ""$ip_address4"", querylog_threat::\$B2:\$B$last_line, ""$domain_name"")"
"=COUNTIFS!(querylog_threat::\$F2:\$F$last_line, ""$ip_address5"", querylog_threat::\$B2:\$B$last_line, ""$domain_name"")"
"=COUNTIFS!(querylog_threat::\$F2:\$F$last_line, ""$ip_address6"", querylog_threat::\$B2:\$B$last_line, ""$domain_name"")"
"=COUNTIFS!(querylog_threat::\$F2:\$F$last_line, ""$ip_address7"", querylog_threat::\$B2:\$B$last_line, ""$domain_name"")"
EOF
    )
    echo "$code" > "querylog_threat($domain_name).csv"
    files+=("$file")
  done

  paste -d , "${files[@]}" > querylog_threat.csv
  rm "${files[@]}"
}

gen_blocked_domains
gen_blocked_domains_client
