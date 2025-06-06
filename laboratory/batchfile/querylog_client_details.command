#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
year=$(TZ=UTC-9 date '+%Y')
cd "$current_dir" || exit

function querylog_reason_statistics () {
  for h in {0..23}; do
    for m in {0..5}; do
      hour=$(printf "%02d" "$h")
      for i in {1..7}; do
        reason_array=("accept" "reject" "blockedService" "safeBrowsing" "safeSearch" "rewritten" "processed")
        reason="${reason_array[$i - 1]}"
        grep "$ip_addr" "$sub_file.tmp" | grep "$reason" | grep "$hour:${m}[0-9]:[0-5][0-9]" | wc -l | awk '{ print $1 }' | sed 's/$/,/g' >> "query_reason_stat.txt"
      done
      reason_raw=$(cat "query_reason_stat.txt" | tr -d '\n' | sed 's/,$//g')
      echo "$reason_raw" >> "$stat_file"
      echo > query_reason_stat.txt
    done
  done
  rm query_reason_stat.txt
}

function query_file_tmp () {
  sed -i '' -e 's/ \[.*\]//g' \
            -e 's/ (キャッシュからの配信)//g' \
            -e 's/,[0-9].[0-9][0-9] ms,//g' \
            -e 's/,[0-9] ms,//g' \
            -e 's/,[0-9][0-9] ms,//g' \
            -e 's/,[0-9][0-9][0-9] ms,//g' \
            -e 's/,[0-9][0-9][0-9][0-9] ms,//g' \
            -e 's/,[0-9][0-9][0-9][0-9][0-9] ms,//g' \
            -e '/,,,,,/q' "$sub_file" 2>/dev/null

  awk 'BEGIN { ORS=""; } # 出力の区切り文字を空に設定
  {
    gsub("種類: .*ステータス: ", "ステータス: ", $0)
    gsub("種類: .*$", "", $0)
    if ($0 ~ /許可/) {
      $0 = $0 "\n"
    }
    if ($0 ~ /ブロック済/) {
      $0 = $0 "\n"
    }
    if ($0 ~ /ブロックするサービス/) {
      $0 = $0 "\n"
    }
    if ($0 ~ /ブロックされた脅威/) {
      $0 = $0 "\n"
    }
    if ($0 ~ /セーフサーチ/) {
      $0 = $0 "\n"
    }
    if ($0 ~ /書換/) {
      $0 = $0 "\n"
    }
    if ($0 ~ /処理済み/) {
      $0 = $0 "\n"
    }
    if ($0 != "") { # 行が空でなければ出力
      print $0
    }
  }' "$sub_file" > "$sub_file.tmp"

  sed -i '' -e 's/許可/accept/g' \
            -e 's/ブロック済/reject/g' \
            -e 's/ブロックするサービス/blockedService/g' \
            -e 's/ブロックされた脅威/safeBrowsing/g' \
            -e 's/セーフサーチ/safeSearch/g' \
            -e 's/書換/rewritten/g' \
            -e 's/処理済み/processed/g' "$sub_file.tmp"
}

accept_code () {
  cat << EOF >> "$main_file_10inch"
          do shell script "/usr/local/bin/cliclick c:650,270"
          delay 0.7
          do shell script "/usr/local/bin/cliclick c:620,550" -- select lime
          delay 0.5
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end accept_variable

EOF
  cat << EOF >> "$main_file_15inch"
          do shell script "/usr/local/bin/cliclick c:945,435" -- select text color
          delay 1.5
          do shell script "/usr/local/bin/cliclick c:815,705" -- select lime
          delay 1.5
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end accept_variable

EOF
  cat << EOF >> "$main_file_21inch"
          do shell script "/usr/local/bin/cliclick c:955,400"
          delay 0.5
          do shell script "/usr/local/bin/cliclick c:915,695" -- select lime
          delay 0.3
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end accept_variable

EOF
  cat << EOF >> "$main_file_27inch"
          do shell script "/usr/local/bin/cliclick c:1945,435" -- select text color
          delay 0.3
          do shell script "/usr/local/bin/cliclick c:1815,740" -- select lime
          delay 0.1
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end accept_variable

EOF
}

reject_code () {
  cat << EOF >> "$main_file_10inch"
          do shell script "/usr/local/bin/cliclick c:650,270"
          delay 0.7
          do shell script "/usr/local/bin/cliclick c:560,550" -- select cherry
          delay 0.5
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end reject_variable

EOF
  cat << EOF >> "$main_file_15inch"
          do shell script "/usr/local/bin/cliclick c:945,435" -- select text color
          delay 1.5
          do shell script "/usr/local/bin/cliclick c:755,705" -- select cherry
          delay 1.5
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end reject_variable

EOF
  cat << EOF >> "$main_file_21inch"
          do shell script "/usr/local/bin/cliclick c:955,400"
          delay 0.5
          do shell script "/usr/local/bin/cliclick c:855,695" -- select cherry
          delay 0.3
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end reject_variable

EOF
  cat << EOF >> "$main_file_27inch"
          do shell script "/usr/local/bin/cliclick c:1945,435" -- select text color
          delay 0.3
          do shell script "/usr/local/bin/cliclick c:1755,740" -- select cherry
          delay 0.1
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end reject_variable

EOF
}

blockedService_code () {
  cat << EOF >> "$main_file_10inch"
          do shell script "/usr/local/bin/cliclick c:650,270"
          delay 0.7
          do shell script "/usr/local/bin/cliclick c:560,550" -- select cherry
          delay 0.5
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end blockedService_variable

EOF
  cat << EOF >> "$main_file_15inch"
          do shell script "/usr/local/bin/cliclick c:945,435" -- select text color
          delay 1.5
          do shell script "/usr/local/bin/cliclick c:755,705" -- select cherry
          delay 1.5
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end blockedService_variable

EOF
  cat << EOF >> "$main_file_21inch"
          do shell script "/usr/local/bin/cliclick c:955,400"
          delay 0.5
          do shell script "/usr/local/bin/cliclick c:855,695" -- select cherry
          delay 0.3
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end blockedService_variable

EOF
  cat << EOF >> "$main_file_27inch"
          do shell script "/usr/local/bin/cliclick c:1945,435" -- select text color
          delay 0.3
          do shell script "/usr/local/bin/cliclick c:1755,740" -- select cherry
          delay 0.1
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end blockedService_variable

EOF
}

safeBrowsing_code () {
  cat << EOF >> "$main_file_10inch"
          do shell script "/usr/local/bin/cliclick c:650,270"
          delay 0.7
          do shell script "/usr/local/bin/cliclick c:580,600" -- select cantaloupe
          delay 0.5
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end safeBrowsing_variable

EOF
  cat << EOF >> "$main_file_15inch"
          do shell script "/usr/local/bin/cliclick c:945,435" -- select text color
          delay 1.5
          do shell script "/usr/local/bin/cliclick c:775,760" -- select cantaloupe
          delay 1.5
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end safeBrowsing_variable

EOF
  cat << EOF >> "$main_file_21inch"
          do shell script "/usr/local/bin/cliclick c:955,400"
          delay 0.5
          do shell script "/usr/local/bin/cliclick c:875,755" -- select cantaloupe
          delay 0.3
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end safeBrowsing_variable

EOF
  cat << EOF >> "$main_file_27inch"
          do shell script "/usr/local/bin/cliclick c:1945,435" -- select text color
          delay 0.3
          do shell script "/usr/local/bin/cliclick c:1775,820" -- select cantaloupe
          delay 0.1
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end safeBrowsing_variable

EOF
}

safeSearch_code () {
  cat << EOF >> "$main_file_10inch"
          do shell script "/usr/local/bin/cliclick c:650,270"
          delay 0.7
          do shell script "/usr/local/bin/cliclick c:580,600" -- select cantaloupe
          delay 0.5
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end safeSearch_variable

EOF
  cat << EOF >> "$main_file_15inch"
          do shell script "/usr/local/bin/cliclick c:945,435" -- select text color
          delay 1.5
          do shell script "/usr/local/bin/cliclick c:775,760" -- select cantaloupe
          delay 1.5
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end safeSearch_variable

EOF
  cat << EOF >> "$main_file_21inch"
          do shell script "/usr/local/bin/cliclick c:955,400"
          delay 0.5
          do shell script "/usr/local/bin/cliclick c:875,755" -- select cantaloupe
          delay 0.3
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end safeSearch_variable

EOF
  cat << EOF >> "$main_file_27inch"
          do shell script "/usr/local/bin/cliclick c:1945,435" -- select text color
          delay 0.3
          do shell script "/usr/local/bin/cliclick c:1775,820" -- select cantaloupe
          delay 0.1
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end safeSearch_variable

EOF
}

rewritten_code () {
  cat << EOF >> "$main_file_10inch"
          do shell script "/usr/local/bin/cliclick c:650,270"
          delay 0.7
          do shell script "/usr/local/bin/cliclick c:700,600" -- select sky
          delay 0.5
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end rewritten_variable

EOF
  cat << EOF >> "$main_file_15inch"
          do shell script "/usr/local/bin/cliclick c:945,435" -- select text color
          delay 1.5
          do shell script "/usr/local/bin/cliclick tc:890,705" -- select sky
          delay 1.5
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end rewritten_variable

EOF
  cat << EOF >> "$main_file_21inch"
          do shell script "/usr/local/bin/cliclick c:955,400"
          delay 0.5
          do shell script "/usr/local/bin/cliclick c:990,755" -- select sky
          delay 0.3
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end rewritten_variable

EOF
  cat << EOF >> "$main_file_27inch"
          do shell script "/usr/local/bin/cliclick c:1945,435" -- select text color
          delay 0.3
          do shell script "/usr/local/bin/cliclick tc:1890,820" -- select sky
          delay 0.1
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end rewritten_variable

EOF
}

processed_code () {
  cat << EOF >> "$main_file_10inch"
          do shell script "/usr/local/bin/cliclick c:650,270"
          delay 0.7
          do shell script "/usr/local/bin/cliclick c:650,460" -- select tin
          delay 0.5
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end processed_variable

EOF
  cat << EOF >> "$main_file_15inch"
          do shell script "/usr/local/bin/cliclick c:945,435" -- select text color
          delay 1.5
          do shell script "/usr/local/bin/cliclick c:855,610" -- select tin
          delay 1.5
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end processed_variable

EOF
  cat << EOF >> "$main_file_21inch"
          do shell script "/usr/local/bin/cliclick c:955,400"
          delay 0.5
          do shell script "/usr/local/bin/cliclick c:955,605" -- select tin
          delay 0.3
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end processed_variable

EOF
  cat << EOF >> "$main_file_27inch"
          do shell script "/usr/local/bin/cliclick c:1945,435" -- select text color
          delay 0.3
          do shell script "/usr/local/bin/cliclick c:1855,620" -- select tin
          delay 0.1
          keystroke "g" using {command down}
        end repeat
        delay 0.1
        do shell script "pbcopy < /dev/null"
        set the clipboard to "  "
        keystroke "f" using {command down}
        keystroke "v" using {command down} -- paste
      end tell
    end repeat
  end tell
end processed_variable

EOF
}

common_code=$(
  cat << EOF
  tell application "Numbers"
    activate
    repeat with currentURL in urlList
      set the clipboard to currentURL
      tell application "System Events"
        keystroke "f" using {command down}
        keystroke "v" using {command down}
        repeat variable times -- match repeat count to number of domains
EOF
)

last_code=$(
  cat << EOF
tell application "System Events"
	keystroke (ASCII character 7)
	display alert "Finished" as informational
end tell
EOF
)

function querylog_client_details () {
  for h in {0..23}; do
    for m in {0..5}; do
      hour=$(printf "%02d" "$h")
      query=$(grep "$ip_addr" "$sub_file.tmp" | grep "$hour:${m}[0-9]:[0-5][0-9]")
      query_cluster=$(echo "$query" | sed -e 's/^.*,\"//g' -e 's/ステータス: .*//g')
      uniq_query_cluster=$(echo "$query_cluster" | sort -u)
      uniq_query=$(echo "$uniq_query_cluster" | sed -e 's/^/DUMMY /g' -e 's/$/ DUMMY, /g' | tr -d '\n' | sed -e 's/^/"/g' -e 's/, $/"/g')
      query_count=$(echo "$query_cluster" | wc -l | awk '{ print $1 }')
      if [[ "$uniq_query" =~ "DUMMY  DUMMY" ]]; then
        query_count=0
      fi
      echo "$hour:${m}0,$query_count,$uniq_query" >> "$query_file"
      echo "$query" | sed -e 's/^.*,\"/DUMMY /g' -e 's/ステータス: / DUMMY,/g' -e 's/192.168.8.*//g' -e 's/\"//g' | sort --unique >> "$current_dir/query_reason_$ip_addr.csv"
    done
  done

  reason_array=("accept" "reject" "blockedService" "safeBrowsing" "safeSearch" "rewritten" "processed")
  for i in {1..7}; do
    reason="${reason_array[$i - 1]}"
    grep "$reason" "$current_dir/query_reason_$ip_addr.csv" > "$reason.csv"
    sort --unique "$reason.csv" | sed 's/,.*//g' > "$i.txt"
    while IFS= read -r uniq; do
      count=$(grep --count --only-matching "$uniq" "$reason.csv")
      echo "$count: $uniq" >> "$reason-count.txt"
    done < "$i.txt"
    rm "$reason.csv" "$i.txt"
  done

  for a in {1..7}; do
    reason="${reason_array[$a - 1]}"
    counter="$current_dir/$reason-count.txt"
    if [ -e "$counter" ]; then
      for b in {1..144}; do
        c=$(($b + 1))
        if grep --extended-regexp "^$b:" "$counter" 1>/dev/null; then
          echo "on ${reason}_variable(urlList)" >> "$main_file_10inch"
          echo "on ${reason}_variable(urlList)" >> "$main_file_15inch"
          echo "on ${reason}_variable(urlList)" >> "$main_file_21inch"
          echo "on ${reason}_variable(urlList)" >> "$main_file_27inch"
          echo "$common_code" >> "$main_file_10inch"
          echo "$common_code" >> "$main_file_15inch"
          echo "$common_code" >> "$main_file_21inch"
          echo "$common_code" >> "$main_file_27inch"
          case "$reason" in
            accept)
              accept_code
            ;;
            reject)
              reject_code
            ;;
            blockedService)
              blockedService_code
            ;;
            safeBrowsing)
              safeBrowsing_code
            ;;
            safeSearch)
              safeSearch_code
            ;;
            rewritten)
              rewritten_code
            ;;
            processed)
              processed_code
            ;;
          esac
          grep --extended-regexp "^$b:" "$counter" > "${reason}_A.txt"
          sed -i '' "s/variable/$c/g" "$main_file_10inch" "$main_file_15inch" "$main_file_21inch" "$main_file_27inch"
          sed -i '' "s/reasonName/$reason/g" "$main_file_10inch" "$main_file_15inch" "$main_file_21inch" "$main_file_27inch"
          sed -i '' -e "1s/.*: /set $reason${c} to {\"/g" -e "s/$b: /\"/g" -e 's/$/", /g' "${reason}_A.txt"
          sort -u "${reason}_A.txt" > "${reason}_A2.txt"
          sed -i '' -e '$a \
          }' -e 's/,   //g' "${reason}_A2.txt"
          < "${reason}_A.txt" tr -d '\n' > "${reason}_B.txt"
          sed -i '' "s/, $/}\n${reason}_$c($reason${c})\n\ndelay 2\n\n/g" "${reason}_B.txt"
          cat "${reason}_B.txt" >> "$main_file_10inch"
          cat "${reason}_B.txt" >> "$main_file_15inch"
          cat "${reason}_B.txt" >> "$main_file_21inch"
          cat "${reason}_B.txt" >> "$main_file_27inch"
        fi
      done
      rm "$counter" "${reason}_A.txt" "${reason}_A2.txt" "${reason}_B.txt" 2>/dev/null
    fi
  done

  echo "$last_code" >> "$main_file_10inch"
  echo "$last_code" >> "$main_file_15inch"
  echo "$last_code" >> "$main_file_21inch"
  echo "$last_code" >> "$main_file_27inch"
}

cd "$current_dir" || exit
read -rp "クエリログファイルを指定して下さい: " sub_file
if [[ "$sub_file" =~ -$year.*.csv ]]; then
  rename "s/-$year.*.csv/.csv/g" "$current_dir/"*
  query_file_tmp
elif [[ "$sub_file" =~ ^querylog_$year.*.csv$ ]]; then
  rename -e "s/querylog_//g" "$current_dir/$sub_file"
  query_file_tmp
else
  query_file_tmp
fi

sub_file_name=${sub_file//.csv/}
ip_addr_array=("192.168.8.117" "192.168.8.159" "192.168.8.163" "192.168.8.175" "192.168.8.183" "192.168.8.204" "192.168.8.219" "192.168.8.235")
for i in {1..8}; do
  export ip_addr="${ip_addr_array[$i - 1]}"
  query_file="$current_dir/Querylog Client Details $sub_file_name - $ip_addr.csv"
  stat_file="$current_dir/Querylog Reason Statistics $sub_file_name - $ip_addr.csv"
  main_file_10inch="$current_dir/Querylog_Client_Details_${sub_file_name}($ip_addr)_10inch(1200×800).scpt"
  main_file_15inch="$current_dir/Querylog_Client_Details_${sub_file_name}($ip_addr)_15inch.scpt"
  main_file_21inch="$current_dir/Querylog_Client_Details_${sub_file_name}($ip_addr)_21inch.scpt"
  main_file_27inch="$current_dir/Querylog_Client_Details_${sub_file_name}($ip_addr)_27inch.scpt"
  echo "時刻,総クエリ数,ドメイン" > "$query_file"
  querylog_reason_statistics
  querylog_client_details
  rm "$current_dir/query_reason_$ip_addr.csv"
done
rm "$sub_file.tmp"
