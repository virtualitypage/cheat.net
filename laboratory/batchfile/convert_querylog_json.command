#!/bin/bash

today=$(TZ=UTC-9 date '+%Y-%m-%d')
main_file="/Volumes/Internal/var/log/audit_trail/gl-mt3000/querylog_$today.json"
sub_file="/Volumes/Internal/var/log/audit_trail/gl-mt3000/querylog.json"

cp $sub_file "$main_file"

head_square_brackets=$(head -n 1 "$main_file")
if [ "[" != "$head_square_brackets" ]; then
  sed -i '' '1s/^/[\n/' "$main_file"
fi

sed -i '' -e 's/{/  {/g' \
          -e 's/\"T\"/\n    \"T\"/g'  \
          -e 's/\"QH\"/\n    \"QH\"/g' \
          -e 's/\"QT\"/\n    \"QT\"/g' \
          -e 's/\"QC\"/\n    \"QC\"/g' \
          -e 's/\"CP\"/\n    \"CP\"/g' \
          -e 's/\"Upstream\"/\n    \"Upstream\"/g' \
          -e 's/\"Answer\"/\n    \"Answer\"/g' \
          -e 's/\"IP\"/\n    \"IP\"/g' \
          -e 's/\"Result\"/\n    \"Result\"/g' \
          -e 's/\"Result\":  {/\"Result\":{/g' \
          -e 's/\"Rules\":\[/\n      \"Rules\":\[\n/g' \
          -e 's/{\"Text\":/      { "Text":/g' "$main_file"

sed -i '' -e 's/\],/\n      ],/g' \
          -e 's/\"Reason\"/\n      \"Reason\"/g' \
          -e 's/\"IsFiltered\"/\n      \"IsFiltered\"/g' \
          -e 's/},/\n    },/g' \
          -e 's/\"Elapsed\"/\n    \"Elapsed\"/g' "$main_file"

sed -i '' -e '/{ "Text":/{N;s/\(.*\)\n\(.*\)/\1 \2/;}' \
          -e 's/\",     \"IP\"/\", \"IP\"/' "$main_file" # "{ "Text":"を含む行を見つけ、Nで次行読み込んで現在の行と結合。;を付けないとエラーになる

sed -i '' -e 's/\("Text".*\)\(}\)/\1 \2/' \
          -e 's/\("Elapsed".*\)\(}\)/\1\n  \2,/' \
          -e 's/\"Cached\"/\n    \"Cached\"/g' "$main_file"

sed -i '' -e 's/\":/\": /g' \
          -e 's/,\"FilterListID\"/, \"FilterListID\"/g' \
          -e 's/    },        /        /g' \
          -e 's/\(\"IP\".*\"$\)/\1 },/g' "$main_file"

sed -i '' -e '/"Result": {/{N;s/\(.*\)\n\(.*\)/\1\2/;}' \
          -e 's/\"Result\": {    },/\"Result\": {},/g' \
          -e 's/\("Result": {\)\(.*"Rules": \[\)/\1\n\2/' "$main_file"

num=$(cat -n "$main_file" | tail -1 | awk '{ print $1 }')
sed -i '' "${num}s/.*/  }\n]/" "$main_file"
