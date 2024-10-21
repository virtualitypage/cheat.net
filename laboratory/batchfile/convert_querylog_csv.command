#!/bin/bash

sub_file="/Volumes/Internal/var/log/audit_trail/gl-mt3000"
sub_file=$(find "$sub_file" -maxdepth 1 -type f -iname 'querylog_*.json') # -maxdepth 1 でサブディレクトリを含めない検索を行う
json_file=$(echo "$sub_file"| sed 's/.json//')
main_file="$json_file.csv"

awk '
  BEGIN {
    FS="[:,]"; OFS=","
    print "タイムスタンプ,ドメイン,DNSサーバ,クエリ詳細情報,経過時間,クライアント"  # CSVのヘッダーを出力
  }
  {
    if ($1 ~ /"T"/) {
      gsub(/.*"T":"([^"]*)"/, "", $1);
      time = $2 ":" $3 ":" $4;
      gsub(/\..*/, "", time);
      gsub(/^ "/, "", time);
      gsub(/T/, " ", time);
    }

    if ($1 ~ /"QH"/) {
      gsub(/.*"QH":"[^"]*"/, "", $1);
      queryHost = $2;
      gsub(/^ |"$/, "", queryHost);
    }

    if ($1 ~ /"QT"/) {
      gsub(/.*"QT":"[^"]*"/, "", $1);
      queryType = $2;
      gsub(/^ "|"$/, "", queryType);
      queryType = "\n種類: " queryType ", ";
    }

    if ($1 ~ /"QC"/) {
      gsub(/.*"QC":"[^"]*"/, "", $1);
      queryClass = $2;
      gsub(/^ "/, "", queryClass);
      queryClass = "プロトコル: " queryClass;
    }

    if ($1 ~ /"CP"/) {
      gsub(/.*"CP":"[^"]*"/, "", $1);
      cp = $2
    }

    if ($0 ~ /"Upstream": "\[/) {
      gsub(/.*"Upstream": "/, "", $1);
      upstream = $2 ":" $3 ":" $4 ":" $5 ":" $6 ":" $7 ":" $8 ":" $9 ":" $10
      gsub(/^ "|"$/, "", upstream);
    } else if ($1 ~ /"Upstream"/) {
      gsub(/.*"Upstream":.*"/, "", $1);
      upstream = $2 ":" $3
      gsub(/^ "|"$/, "", upstream);
    }

    if ($0 ~ /"Answer":/) {
      getline clientIP; # 次の行を読み込む
      if (clientIP ~ /"IP":/) {
        match(clientIP, /"IP": "[^"]+"/);
        client = substr(clientIP, RSTART, RLENGTH);
        gsub(/^"|"$|"IP": "/, "", client);
      }
    }

    if ($0 ~ /"Text":/) {
      match($0, /"Text": "[^"]+"/); # "Text": " に続くダブルクォーテーション内の文字列全体をマッチさせる
      text = substr($0, RSTART, RLENGTH); # マッチした部分を取り出す
      gsub(/"Text": |"$/, "", text); # "Text": " の部分を削除
    }
    if ($0 ~ /"ServiceName":/) {
      match($0, /"ServiceName": "[^"]+"/);
      serviceName = substr($0, RSTART, RLENGTH);
      gsub(/"ServiceName": "|"$/, "", serviceName);
      serviceName = " サービス名: " serviceName;
    }

    if ($0 ~ /"CanonName"/) {
      match($0, /"CanonName": "[^"]+"/);
      cname = $0;
      gsub(/    |"Result": {|.*"CanonName":|^ "|\["|"\].*|",| "Reason".*/, "", cname);
      cname = "\"CNAME:" cname;
    }

    if ($0 ~ /"IPList"/) { # 書換時のクエリログ(Aレコードだけの場合)
      match($0, /"IPList": "[^"]+"/);
      ipList = $0;
      gsub(/    |"Result": { "IPList": \["|"\].*/, "", ipList);
      ipList = "A: " ipList " ";
    }

    if ($0 ~ /{ "IP":/) {
      match($0, /{ "IP": ": "[^"]+"/);
      address_record = $0;
      gsub(/        |{ "IP": "|",.*/, "", address_record);
      address_record = address_record;
      if (address_record ~ /:/) {
        address_record = "\nAAAA: " address_record;
      } else {
        address_record = "\nA: " address_record;
      }
    }

    if ($0 ~ /"FilterListID"/) {
      match($0, /"FilterListID": "[^"]+"/);
      filter_list = $0;
      gsub(/        |{ "Text": ".*", |{ "IP": ".*", |"FilterListID": | }$/, "", filter_list);
      filter_list = " [" filter_list "]\"";
    }

    if ($1 ~ /"Reason"/ || /"Result": {}/) {
      gsub(/.*"Reason": [0-9]+/, "", $1);
      reason = $2
      if (reason ~ 1) {                          # フィルタリングが行われず、許可リストに該当するリソースである為アクセスが許可されたことを示す
        gsub(/.*/, "\nステータス: 許可\"", reason);
      } else if (reason ~ 3) {                   # ブロックリストによってフィルタリングされ、リクエストがブロックされたことを示す
        gsub(/.*/, "\nステータス: ブロック済\"", reason);
      } else if (reason ~ 4) {                   # セーフブラウジングのフィルタリングによってリクエストがブロックされたことを示す
        gsub(/.*/, "\nステータス: ブロックされた脅威\"", reason);
      } else if (reason ~ 5) {                   # 親による制限（ペアレンタルコントロール）によってフィルタリングされ、アクセスが制限されたことを示す
        gsub(/.*/, "\nステータス: ペアレンタルコントロールによってブロック済\"", reason);
      } else if (reason ~ 7) {                   # セーフサーチフィルタによってリクエストがブロックされたことを示す
        gsub(/.*/, " ステータス: セーフサーチ\"", reason);
      } else if (reason ~ 8) {                   # 特定のサービスがブロックされ、リクエストが拒否されたことを示す
        gsub(/.*/, "\nステータス: ブロックするサービス\"", reason);
      } else {
        gsub(/.*/, "ステータス: 処理済み", reason);
      }
    }

    if ($0 ~ /"Reason": 9/) { # リクエストが書き換えられたことを示す
      reason9 = "ステータス: 書換";
    }

    if ($0 ~ /"IP": "" }$/) {
      gsub(/.*/, "", $1);
      nofilter = $2
      gsub(/.*/, " [カスタム・フィルタリングルール]", nofilter);
    }

    if ($0 ~ /"Elapsed"/) {
      match($0, /"Text": "[^"]+"/);
      gsub(/.*"Elapsed":[0-9]+/, "", $1);
      elapsed = $2;
      elapsed = elapsed / 1000000;
      if (elapsed < 1) {
        elapsed = sprintf("%.2f ms", elapsed); # 1未満(0.XXXX)の数値を小数第2位まで表示
      } else {
        elapsed = int(elapsed) " ms";          # 数値の小数点以下を切り捨てて表示
      }
    }

    if ($1 ~ /"Cached"/) {
      gsub(/.*"Cached":"[^"]*"/, "", $1);
      cached = $2
      gsub(/.*/, " (キャッシュからの配信)\"", cached);
    }

    domain_data = queryHost queryType queryClass
    result_data = text nofilter reason9 cname ipList address_record serviceName reason filter_list cached;

    # 閉じ扇括弧が見つかったら行を出力
    if ($0 ~ "^  },$") {
      print time, domain_data, upstream, result_data, elapsed, client;
      upstream = "";        # "DNSサーバ"を取得
      cname = "";           # "CNAMEレコード"を取得
      text = "";            # "フィルタリングルールの内容"を取得
      nofilter = "";        # "カスタムフィルタリング・ルール"を明示的にする
      ipList = "";          # "書換後のIPアドレス"を取得
      address_record = "";  # "Aレコード・AAAAレコード"を取得
      serviceName = "";     # "ブロックするサービス"の名称を取得
      reason = "";          # "書換"を除くステータスを取得
      reason9 = "";         # "書換"ステータスを取得
      filter_list = "";     # "フィルタリングリストの一意のID"を取得
      elapsed = "";         # "経過時間"を取得
      cached = "";          # "DNSキャッシュから配信"された事実を取得
    } else if ($0 ~ "^  }$") {
      print time, domain_data, upstream, result_data, elapsed, client;
      upstream = "";
      cname = "";
      text = "";
      nofilter = "";
      ipList = "";
      address_record = "";
      serviceName = "";
      reason = "";
      reason9 = "";
      filter_list = "";
      elapsed = "";
      cached = "";
    }
  }' "$sub_file" > "$main_file"

sed -i '' -e 's/\" (/ (/g' \
          -e 's/\" \[/ [/g' \
          -e 's/CNAME: \"/CNAME: /g' \
          -e 's/\(ステータス: 書換"\)\(CNAME:[^,]*\),/"\1\2",/' \
          -e 's/\(ステータス: 書換\)\(A:[^,]*\),/"\1\2",/' \
          -e 's/書換\"CNAME/書換\nCNAME/g' \
          -e 's/書換A/書換\nA/g' \
          -e 's/ \",/\",/g' \
          -e 's/,,/,-,/g' \
          -e 's/ \[-.*\]//g' \
          -e 's/処理済み (キャッシュからの配信)\"/処理済み (キャッシュからの配信)/g' \
          -e 's/(キャッシュからの配信)\"\"/(キャッシュからの配信)\"/g' "$main_file"

# ls -l /etc/AdGuardHome/data/filters 配下のファイルと同一
sed -i '' -e 's/1720874115/Advertisement/g' \
          -e 's/1720874116/PhishingSite/g' \
          -e 's/1720874117/ScamSite/g' \
          -e 's/1720874118/QueryLog_Deny/g' \
          -e 's/1720874119/QueryLog_Allow/g' \
          -e 's/1722950284/Allow_domain/g' "$main_file"
