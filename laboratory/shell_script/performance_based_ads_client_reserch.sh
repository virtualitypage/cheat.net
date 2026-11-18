#!/bin/bash

input_file="/Volumes/DevOps/ops/domain_reserch/既知の成果報酬型広告の限定許可ドメイン.csv"
output_file="/Volumes/DevOps/ops/domain_reserch/既知の成果報酬型広告の限定許可ドメイン_編集済み.csv"

domain_array=()
line_num=0

while IFS= read -r domains || [[ -n $domains ]]; do
  ((line_num++))
  [[ $line_num -eq 1 ]] && continue # 1行目をスキップ
  domain_array+=("$domains")
done < "$input_file"

for domain in "${domain_array[@]}"; do
  cat << EOF >> $output_file
@@||${domain}^\$client=192.168.8.117
@@||${domain}^\$client=192.168.8.159
@@||${domain}^\$client=192.168.8.163
@@||${domain}^\$client=192.168.8.219
@@||${domain}^\$client=192.168.8.235
EOF
done
