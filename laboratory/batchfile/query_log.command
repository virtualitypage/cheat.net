#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
main_file="$current_dir/query_log"
sub_file="$current_dir/querylog"

# キャリッジリターンを削除
tr -d '\r' < "$sub_file.csv" > "${sub_file}_2.csv"
mv "${sub_file}_2.csv" "$sub_file.csv"
echo "時刻,リクエスト,応答,クライアント" >> "$main_file.csv"

# 時刻を成形 (YYYY/mm/dd hh:mm:ss)
awk '{
  if ($0 ~ /^[0-9]{2}:[0-9]{2}:[0-9]{2}$/) {
    time = $0;
    next;
  }
  else if ($0 ~ /^[0-9]{4}\/[0-9]{2}\/[0-9]/) {
    print $0, time ",\""
  }
  else {
    print $0
  }
}' "$sub_file.csv" >> "$main_file.csv"

sed -i '' '2,21d' "$main_file.csv"

# "ドメイン"を時刻の横(2列目)に配置 (ゼロパディング対応済)
awk '{
  if ($0 ~ /^[0-9]{4}\/[0-9]{2}\/[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}/) {
    printf "%s", $0;
    getline;
    printf "%s", $0;
    next
  }
  else if($0 ~ /^[0-9]{4}\/[0-9]\/[0-9] [0-9]{2}:[0-9]{2}:[0-9]{2}/) {
    printf "%s", $0;
    getline;
    printf "%s", $0;
    next
  }
  print
}' "$main_file.csv" > "${main_file}_2.csv"

# ダブルクォートを削除
sed -i '' 's/\"種類/種類/g' "${main_file}_2.csv"

# "応答"を連結
awk '{
  if ($0 ~ /通常のDNS/) {
  printf "%s", $0;
  getline;
  printf ",\"" $0;
  next;
  }
  print
}' "${main_file}_2.csv" > "$main_file.csv"

# "IPアドレス"を"応答"の横(4列目)に配置
awk '{
  if ($0 ~ /通常のDNS/) {
    printf "%s", $0;
    getline;
    printf "%s", $0;
    getline;
    next;
  }
  print;
}' "$main_file.csv" > "${main_file}_2.csv"

sed -e 's/許可/許可\n/g' -e 's/処理済/処理済\n/g' -e 's/ブロック済/ブロック済\n/g' "${main_file}_2.csv" > "$main_file.csv"
sed -i '' 's/\([0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\)/\",\1/g' "$main_file.csv"
sed -i '' 's/,\"\",/,\"/g' "$main_file.csv"
sed -i '' 's/\"カスタム・フィルタリングルール, QueryLog_Deny\"/カスタム・フィルタリングルール/g' "$main_file.csv"
sed -i '' -e 's/127.0.0.1/\"127.0.0.1/g' -e 's/localhost/localhost\"/g' "$main_file.csv"
sed -i '' '/^$/d' "$main_file.csv"
rm "${main_file}_2.csv"
