#!/bin/bash

input_file="/Volumes/DevOps/ops/unknownDomainSearch/domain_lists.csv"
find_dir="/Volumes/DevOps/ops/domain_reserch"

echo -e "\033[1;37m検索対象ファイル：$input_file\033[0m"

# 既知の許可ドメイン
echo
echo -e "\033[1;36m既知の許可ドメインを検索中…\033[0m"
while IFS= read -r domain; do
  if grep "$domain" $input_file >> "$find_dir/既知の許可ドメイン.csv"; then
    domains=$(grep "$domain" $input_file)
    echo -e "\033[1;32m+ $domains\033[0m"
    sed -i '' "/$domain/d" $input_file
  fi
done < "$find_dir/既知の許可ドメイン一覧.txt"

# 既知の許可ドメイン(appliance)
echo
echo -e "\033[1;36m既知の許可ドメイン(appliance)を検索中…\033[0m"
while IFS= read -r domain; do
  if grep "$domain" $input_file >> "$find_dir/既知の許可ドメイン(appliance).csv"; then
    domains=$(grep "$domain" $input_file)
    echo -e "\033[1;32m+ $domains\033[0m"
    sed -i '' "/$domain/d" $input_file 2>/dev/null
  fi
done < "$find_dir/既知の許可ドメイン一覧(appliance).txt"

# 既知の許可ドメイン(other)
echo
echo -e "\033[1;36m既知の許可ドメイン(other)を検索中…\033[0m"
while IFS= read -r domain; do
  if grep "$domain" $input_file >> "$find_dir/既知の許可ドメイン(other).csv"; then
    domains=$(grep "$domain" $input_file)
    echo -e "\033[1;32m+ $domains\033[0m"
    sed -i '' "/$domain/d" $input_file 2>/dev/null
  fi
done < "$find_dir/既知の許可ドメイン一覧(other).txt"

# 既知の成果報酬型広告の限定許可ドメイン
echo
echo -e "\033[1;36m既知の成果報酬型広告の限定許可ドメインを検索中…\033[0m"
while IFS= read -r domain; do
  if grep "$domain" $input_file >> "$find_dir/既知の成果報酬型広告の限定許可ドメイン.csv"; then
    domains=$(grep "$domain" $input_file)
    echo -e "\033[1;32m+ $domains\033[0m"
    sed -i '' "/$domain/d" $input_file 2>/dev/null
  fi
done < "$find_dir/既知の成果報酬型広告の限定許可ドメイン一覧.txt"

# 既知のブロック確定ドメイン
echo
echo -e "\033[1;36m既知のブロック確定ドメインを検索中…\033[0m"
while IFS= read -r domain; do
  if grep "$domain" $input_file >> "$find_dir/既知のブロック確定ドメイン.csv"; then
    domains=$(grep "$domain" $input_file)
    echo -e "\033[1;32m+ $domains\033[0m"
    sed -i '' "/$domain/d" $input_file
  fi
done < "$find_dir/既知のブロック確定ドメイン一覧.txt"

# 既知のブロック確定ドメイン(other)
echo
echo -e "\033[1;36m既知のブロック確定ドメインを検索中…\033[0m"
while IFS= read -r domain; do
  if grep "$domain" $input_file >> "$find_dir/既知のブロック確定ドメイン(other).csv"; then
    domains=$(grep "$domain" $input_file)
    echo -e "\033[1;32m+ $domains\033[0m"
    sed -i '' "/$domain/d" $input_file
  fi
done < "$find_dir/既知のブロック確定ドメイン一覧(other).txt"

# 既知の拒否リクエストドメイン
echo
echo -e "\033[1;36m既知の拒否リクエストドメインを検索中…\033[0m"
while IFS= read -r domain; do
  if grep "$domain" $input_file >> "$find_dir/既知の拒否リクエストドメイン.csv"; then
    domains=$(grep "$domain" $input_file)
    echo -e "\033[1;32m+ $domains\033[0m"
    sed -i '' "/$domain/d" $input_file
  fi
done < "$find_dir/既知の拒否リクエストドメイン一覧.txt"

# 既知の拒否リクエストドメイン(Netify)
echo
echo -e "\033[1;36m既知の拒否リクエストドメイン(Netify)を検索中…\033[0m"
while IFS= read -r domain; do
  if grep "$domain" $input_file >> "$find_dir/既知の拒否リクエストドメイン(Netify).csv"; then
    domains=$(grep "$domain" $input_file)
    echo -e "\033[1;32m+ $domains\033[0m"
    sed -i '' "/$domain/d" $input_file
  fi
done < "$find_dir/既知の拒否リクエストドメイン一覧(Netify).txt"

# 既知の激甚必至ドメイン
echo
echo -e "\033[1;36m既知の激甚必至ドメインを検索中…\033[0m"
while IFS= read -r domain; do
  if grep "$domain" $input_file >> "$find_dir/既知の激甚必至ドメイン.csv"; then
    domains=$(grep "$domain" $input_file)
    echo -e "\033[1;32m+ $domains\033[0m"
    sed -i '' "/$domain/d" $input_file
  fi
done < "$find_dir/既知の激甚必至ドメイン一覧.txt"

# ipgeolocation
echo
echo -e "\033[1;36mipgeolocation.io 検索対象ドメインを検索中…\033[0m"
grep "in-addr.arpa" $input_file | sed -e 's|^|https://ipgeolocation.io/browse/ip/|g' -e 's/.in.*//g' >> "$find_dir/【要警戒】ipgeolocation.txt"
grep "in-addr.arpa" $input_file >> "$find_dir/【要警戒】ipgeolocation.csv"
sed -i '' "/in-addr.arpa/d" $input_file
