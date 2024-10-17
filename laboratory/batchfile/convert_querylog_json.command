#!/bin/bash

sub_file="/Volumes/Internal/var/log/audit_trail/gl-mt3000/querylog.json"
date=$(head -n 1 "$sub_file" | awk -F\" '{print $4}' | cut -dT -f1)
main_file="/Volumes/Internal/var/log/audit_trail/gl-mt3000/querylog_$date.json"

cp $sub_file "$main_file"

head_square_brackets=$(head -n 1 "$main_file")
if [ "[" != "$head_square_brackets" ]; then
  sed -i '' '1s/^/[\n/' "$main_file"
fi

# オブジェクトの整形
sed -i '' -e 's/\":/\": /g' \
          -e 's/^{/  {/g' \
          -e 's/\"T\"/\n    \"T\"/g'  \
          -e 's/\"QH\"/\n    \"QH\"/g' \
          -e 's/\"QT\"/\n    \"QT\"/g' \
          -e 's/\"QC\"/\n    \"QC\"/g' \
          -e 's/\"CP\"/\n    \"CP\"/g' \
          -e 's/\"Upstream\"/\n    \"Upstream\"/g' \
          -e 's/\"Answer\"/\n    \"Answer\"/g' \
          -e 's/\"IP\"/\n    \"IP\"/g' \
          -e 's/\"Result\"/\n    \"Result\"/g' \
          -e 's/\"Rules\": \[/\n      \"Rules\": \[\n/g' \
          -e 's/\"IsFiltered\"/\n      \"IsFiltered\"/g' \
          -e 's/},/\n    },/g' \
          -e 's/\"Elapsed\"/\n    \"Elapsed\"/g' \
          -e 's/\("Elapsed".*\)\(}\)/\1\n  \2,/' \
          -e 's/\"Cached\"/\n    \"Cached\"/g'  "$main_file"

# "Result": {}, に変換
sed -i '' -e '/"Result": {/{N;s/\(.*\)\n\(.*},\)/\1\2/;}' \
          -e 's/\"Result\": {    },/\"Result\": {},/g' "$main_file" # "Result": { を含む行を見つけ、Nで次行読み込んで現在の行と結合。;を付けないとエラーになる

# "Result": {...}, の内部を整形
sed -i '' -e 's/\"IPList\":\[/\n      \"IPList\":\[/g' \
          -e 's/\("Result": {\)\("CanonName":.*",$\)/\1\n      \2/' \
          -e 's/\("Result": {\)\("ServiceName":.*"\)/\1\n      \2/' \
          -e 's/\"Result\": {\"IPList\"/\"Result\": { \"IPList\"/g' \
          -e 's/\"Result\": {\"CanonName\"/\"Result\": { \"CanonName\"/g' \
          -e 's/\("Reason": \)\([1-8].*$\)/\n      \1\2/;' \
          -e 's/\"Reason\": 9    },/ \"Reason\": 9 },/g' "$main_file"

# "Rules": [...] の内部を整形(例外処理)
sed -i '' 's/    },{/    },\n{/g' "$main_file"
sed -i '' -e '/.*"IP": "0.0.0.0"$/{N;s/\(.*\)\n\(.*},$\)/\1 \2/;}' \
          -e 's/\"     },/\" },/g' "$main_file"
sed -i '' '/"Text": ".*/{N;s/\(.*\)\n\(.*"IP": "0.0.0.0" },$\)/\1\2/;}' "$main_file"
sed -i '' '/"Text": ".*",$/{N;s/\(.*\)\n\(.*"IP": "0.0.0.0".*}],$\)/\1\2/;}' "$main_file"
sed -i '' -e 's/{\"Text\":/        { "Text":/g' \
          -e 's/,    \"IP\"/, \"IP\"/g' "$main_file"

# "Rules": [...] の内部を整形
sed -i '' -e '/^{$/{N;s/\(.*\)\n\(    "IP".*}\)/\1 \2/;}' \
          -e 's/{     \"IP\"/        { \"IP\"/g' \
          -e '/.*{ "Text":/{N;s/\(.*\)\n\(    "IP".*\)/\1 \2/;}' \
          -e 's/,     \"IP\"/, \"IP\"/g' \
          -e 's/,\"FilterListID\"/, \"FilterListID\"/g' \
          -e 's/}\],/ }\n      ],/g' "$main_file"

# 最終行の処理
num=$(cat -n "$main_file" | tail -1 | awk '{ print $1 }')
sed -i '' "${num}s/.*/  }\n]/" "$main_file"
