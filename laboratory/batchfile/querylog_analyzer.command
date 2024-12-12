#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
uniq_file="$current_dir/Querylog_Analysis_uniq.csv"
stat_file="$current_dir/Querylog_Analysis_stat.csv"
target="$current_dir/target_domain.csv"
counter="$current_dir/count"

read -p "クエリログファイルを指定して下さい: " sub_file
read -p "分析対象のIPアドレスを入力して下さい: " ip_addr

query_file="$current_dir/Querylog Analysis - $ip_addr.csv"
echo "時刻,総クエリ数,ドメイン" > "$query_file"

for h in {0..23}; do
  for m in {0..5}; do
    hour=$(printf "%02d" $h)
    grep -B2 "$ip_addr" "$current_dir/$sub_file" | grep "$hour:${m}[0-9]:[0-5][0-9]" | sed 's/\"//g' | awk -F ',' '{ print $2 }' > "$stat_file"
    sort -u "$stat_file" | sed 's/$/, /g' > "$uniq_file"
    count=$(wc -l "$stat_file" | awk '{ print $1 }')
    uniq_query=$(cat "$uniq_file" | tr -d '\n' | sed -e 's/, $//g' -e 's/^/"/g' -e 's/$/"/g')
    echo "$hour:${m}0,$count,$uniq_query" >> "$query_file"
  done
done

sed -e 's/^.*,0,//g' \
    -e 's/^.*,\"//g' \
    -e 's/, /\n/g' \
    -e 's/\"//g' \
    -e '1d' "$query_file" > "$target.tmp" # ドメインのみ抽出

domain_array=("mirrativ.com" "easebar.com" "netease.com") # 監視対象ドメイン(通称ターゲットドメイン)を配列で処理
for i in {1..3}; do
  domain="${domain_array[$i - 1]}"
  grep "$domain" "$target.tmp" >> "$target"
done
sort --unique "$target" > "$target.tmp" # ターゲットドメインの重複を排除
sort --numeric-sort "$target" > "${target}_2.tmp" # ターゲットドメインを昇順に並び替える
mv "${target}_2.tmp" "$target" # 昇順に並び替えたターゲットドメインのカウント用ファイル

while IFS= read -r line; do
  count=$(grep --count --only-matching "$line" "$target")
  echo "$count: $line" >> "$counter.txt"
done < "$target.tmp"  # 一意のターゲットドメインファイル
sort --numeric-sort "$counter.txt" > "$counter.tmp" # ターゲットドメイン数を昇順に並び替える
mv "$counter.tmp" "$counter.txt" # 昇順に並び替えたターゲットドメインカウントファイル

main_file="$current_dir/Querylog_Analysis_Target_Domain.scpt"

code=$(
  cat << EOF
on targetQuery_variable(urlList)
  tell application "Numbers"
    activate
    repeat with currentURL in urlList
      set the clipboard to currentURL
      tell application "System Events"
        keystroke "f" using {command down}
        keystroke "v" using command down
        --do shell script "/usr/local/bin/cliclick c:2010,436"
        repeat variable times -- match repeat count to number of domains
          do shell script "/usr/local/bin/cliclick c:1945,435"
          delay 0.5
          --do shell script "/usr/local/bin/cliclick c:2043,472 c:."
          do shell script "/usr/local/bin/cliclick tc:1900,775 c:. c:."
          delay 1
          keystroke "g" using {command down}
          --do shell script "/usr/local/bin/cliclick c:1830,1200 c:."
        end repeat
      end tell
    end repeat
  end tell
end targetQuery_variable
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

# 個数が 1〜5 のドメインをまとめる
if grep -E "^[1-5]:" "$counter.txt" 1>/dev/null; then
  echo -e "$code\n" > "$main_file" # Applescript のコード
  grep -E "^[1-5]:" "$counter.txt" > "${counter}_A.txt"
  sed -i '' 's/variable/6/g' "$main_file"
  sed -i '' -e '1s/.*: /set TargetDomain6 to {"/g' -e 's/[1-5]: /"/g' -e 's/$/", /g' "${counter}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${counter}_A.txt"
  cat "${counter}_A.txt" | tr -d '\n' > "${counter}_B.txt"
  sed -i '' 's/,   }/}\n\ntargetQuery_6(TargetDomain6)\n/g' "${counter}_B.txt"
  cat "${counter}_B.txt" >> "$main_file"
fi

# 個数が 6〜9 のドメインをまとめる
if grep -E "^[6-9]:" "$counter.txt" 1>/dev/null; then
  echo >> "$main_file"
  echo -e "$code\n" >> "$main_file"
  grep -E "^[6-9]:" "$counter.txt" > "${counter}_A.txt"
  sed -i '' 's/variable/10/g' "$main_file"
  sed -i '' -e '1s/.*: /set TargetDomain10 to {"/g' -e 's/[6-9]: /"/g' -e 's/$/", /g' "${counter}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${counter}_A.txt"
  cat "${counter}_A.txt" | tr -d '\n' > "${counter}_B.txt"
  sed -i '' 's/,   }/}\n\ntargetQuery_10(TargetDomain10)\n/g' "${counter}_B.txt"
  cat "${counter}_B.txt" >> "$main_file"
fi

# 個数が 10〜15 のドメインをまとめる
if grep -E "^[1][0-5]:" "$counter.txt" 1>/dev/null; then
  echo >> "$main_file"
  echo -e "$code\n" >> "$main_file"
  grep -E "^[1][0-5]:" "$counter.txt" > "${counter}_A.txt"
  sed -i '' 's/variable/16/g' "$main_file"
  sed -i '' -e '1s/.*: /set TargetDomain16 to {"/g' -e 's/[1][0-5]: /"/g' -e 's/$/", /g' "${counter}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${counter}_A.txt"
  cat "${counter}_A.txt" | tr -d '\n' > "${counter}_B.txt"
  sed -i '' 's/,   }/}\n\ntargetQuery_16(TargetDomain16)\n/g' "${counter}_B.txt"
  cat "${counter}_B.txt" >> "$main_file"
fi

# 個数が 16〜19 のドメインをまとめる
if grep -E "^[1][6-9]:" "$counter.txt" 1>/dev/null; then
  echo >> "$main_file"
  echo -e "$code\n" >> "$main_file"
  grep -E "^[1][6-9]:" "$counter.txt" > "${counter}_A.txt"
  sed -i '' 's/variable/20/g' "$main_file"
  sed -i '' -e '1s/.*: /set TargetDomain20 to {"/g' -e 's/[1][6-9]: /"/g' -e 's/$/", /g' "${counter}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${counter}_A.txt"
  cat "${counter}_A.txt" | tr -d '\n' > "${counter}_B.txt"
  sed -i '' 's/,   }/}\n\ntargetQuery_20(TargetDomain20)\n/g' "${counter}_B.txt"
  cat "${counter}_B.txt" >> "$main_file"
fi

# 個数が 20〜25 のドメインをまとめる
if grep -E "^[2][0-5]:" "$counter.txt" 1>/dev/null; then
  echo >> "$main_file"
  echo -e "$code\n" >> "$main_file"
  grep -E "^[2][0-5]:" "$counter.txt" > "${counter}_A.txt"
  sed -i '' 's/variable/26/g' "$main_file"
  sed -i '' -e '1s/.*: /set TargetDomain26 to {"/g' -e 's/[2][0-5]: /"/g' -e 's/$/", /g' "${counter}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${counter}_A.txt"
  cat "${counter}_A.txt" | tr -d '\n' > "${counter}_B.txt"
  sed -i '' 's/,   }/}\n\ntargetQuery_26(TargetDomain26)\n/g' "${counter}_B.txt"
  cat "${counter}_B.txt" >> "$main_file"
fi

# 個数が 26〜29 のドメインをまとめる
if grep -E "^[2][6-9]:" "$counter.txt" 1>/dev/null; then
  echo >> "$main_file"
  echo -e "$code\n" >> "$main_file"
  grep -E "^[2][6-9]:" "$counter.txt" > "${counter}_A.txt"
  sed -i '' 's/variable/30/g' "$main_file"
  sed -i '' -e '1s/.*: /set TargetDomain30 to {"/g' -e 's/[2][6-9]: /"/g' -e 's/$/", /g' "${counter}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${counter}_A.txt"
  cat "${counter}_A.txt" | tr -d '\n' > "${counter}_B.txt"
  sed -i '' 's/,   }/}\n\ntargetQuery_30(TargetDomain30)\n/g' "${counter}_B.txt"
  cat "${counter}_B.txt" >> "$main_file"
fi

# 個数が 30〜35 のドメインをまとめる
if grep -E "^[3][0-5]:" "$counter.txt" 1>/dev/null; then
  echo >> "$main_file"
  echo -e "$code\n" >> "$main_file"
  grep -E "^[3][0-5]:" "$counter.txt" > "${counter}_A.txt"
  sed -i '' 's/variable/36/g' "$main_file"
  sed -i '' -e '1s/.*: /set TargetDomain36 to {"/g' -e 's/[3][0-5]: /"/g' -e 's/$/", /g' "${counter}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${counter}_A.txt"
  cat "${counter}_A.txt" | tr -d '\n' > "${counter}_B.txt"
  sed -i '' 's/,   }/}\n\ntargetQuery_36(TargetDomain36)\n/g' "${counter}_B.txt"
  cat "${counter}_B.txt" >> "$main_file"
fi

# 個数が 36〜39 のドメインをまとめる
if grep -E "^[3][6-9]:" "$counter.txt" 1>/dev/null; then
  echo >> "$main_file"
  echo -e "$code\n" >> "$main_file"
  grep -E "^[3][6-9]:" "$counter.txt" > "${counter}_A.txt"
  sed -i '' 's/variable/40/g' "$main_file"
  sed -i '' -e '1s/.*: /set TargetDomain40 to {"/g' -e 's/[3][6-9]: /"/g' -e 's/$/", /g' "${counter}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${counter}_A.txt"
  cat "${counter}_A.txt" | tr -d '\n' > "${counter}_B.txt"
  sed -i '' 's/,   }/}\n\ntargetQuery_40(TargetDomain40)\n/g' "${counter}_B.txt"
  cat "${counter}_B.txt" >> "$main_file"
fi

# 個数が 40〜45 のドメインをまとめる
if grep -E "^[4][0-5]:" "$counter.txt" 1>/dev/null; then
  echo >> "$main_file"
  echo -e "$code\n" >> "$main_file"
  grep -E "^[4][0-5]:" "$counter.txt" > "${counter}_A.txt"
  sed -i '' 's/variable/46/g' "$main_file"
  sed -i '' -e '1s/.*: /set TargetDomain46 to {"/g' -e 's/[4][0-5]: /"/g' -e 's/$/", /g' "${counter}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${counter}_A.txt"
  cat "${counter}_A.txt" | tr -d '\n' > "${counter}_B.txt"
  sed -i '' 's/,   }/}\n\ntargetQuery_46(TargetDomain46)\n/g' "${counter}_B.txt"
  cat "${counter}_B.txt" >> "$main_file"
fi

# 個数が 46〜49 のドメインを追加
if grep -E "^[4][6-9]:" "$counter.txt" 1>/dev/null; then
  echo >> "$main_file"
  echo -e "$code\n" >> "$main_file"
  grep -E "^[4][6-9]:" "$counter.txt" > "${counter}_A.txt"
  sed -i '' 's/variable/50/g' "$main_file"
  sed -i '' -e '1s/.*: /set TargetDomain50 to {"/g' -e 's/[4][6-9]: /"/g' -e 's/$/", /g' "${counter}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${counter}_A.txt"
  cat "${counter}_A.txt" | tr -d '\n' > "${counter}_B.txt"
  sed -i '' 's/,   }/}\n\ntargetQuery_50(TargetDomain50)\n/g' "${counter}_B.txt"
  cat "${counter}_B.txt" >> "$main_file"
fi

# 個数が 50〜99 のドメインを追加
if grep -E "^[5-9][0-9]:" "$counter.txt" 1>/dev/null; then
  echo >> "$main_file"
  echo -e "$code\n" >> "$main_file"
  grep -E "^[5-9][0-9]:" "$counter.txt" > "${counter}_A.txt"
  sed -i '' 's/variable/100/g' "$main_file"
  sed -i '' -e '1s/.*: /set TargetDomain100 to {"/g' -e 's/[5-9][0-9]: /"/g' -e 's/$/", /g' "${counter}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${counter}_A.txt"
  cat "${counter}_A.txt" | tr -d '\n' > "${counter}_B.txt"
  sed -i '' 's/,   }/}\n\ntargetQuery_100(TargetDomain100)\n/g' "${counter}_B.txt"
  cat "${counter}_B.txt" >> "$main_file"
fi

# 個数が 100〜999 のドメインを追加
if grep -E "^[1-9][0-9][0-9]:" "$counter.txt" 1>/dev/null; then
  echo >> "$main_file"
  echo -e "$code\n" >> "$main_file"
  grep -E "^[1-9][0-9][0-9]:" "$counter.txt" > "${counter}_A.txt"
  sed -i '' 's/variable/1000/g' "$main_file"
  sed -i '' -e '1s/.*: /set TargetDomain1000 to {"/g' -e 's/[1-9][0-9][0-9]: /"/g' -e 's/$/", /g' "${counter}_A.txt"
  sed -i '' -e '$a \
  }' -e 's/,   //g' "${counter}_A.txt"
  cat "${counter}_A.txt" | tr -d '\n' > "${counter}_B.txt"
  sed -i '' 's/,   }/}\n\ntargetQuery_1000(TargetDomain1000)\n/g' "${counter}_B.txt"
  cat "${counter}_B.txt" >> "$main_file"
fi

echo
echo "$last_code" >> "$main_file"
rm "$stat_file" "$uniq_file" "$target" "$target.tmp" "$counter.txt" "${counter}_A.txt" "${counter}_B.txt"

function success_message () {
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$query_file: DNS クエリ分析用 csv ファイル\033[0m"
  echo -e "\033[1;32m$main_file\033[0m"
  echo
}

# 以下のコードは別のスクリプトからアクセスした場合、実行されない
read -p "Querylog_Analysis_Target_Domain.scpt を実行しますか？: " yesno
if [ "$yesno" = "yes" ]; then
  echo "osascript $main_file"
  osascript "$main_file"
  success_message
else
  success_message
fi
