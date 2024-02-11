#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
main_file="$current_dir/身辺整理 ドキュメント.csv"
sub_file="$current_dir/身辺整理 ドキュメント.txt"

# 変数追加用 #
# for i in {1..29}; do
#   templates+="string$i=\$(grep '・　ある' \"\$sub_file\" | sed 's/・//g' | sed 's/　ある//g')
# "
# done

# cat << EOF >> "$current_dir"/var.txt
# $templates
# EOF

string1=$(grep "・年金手帳　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')
string2=$(grep "・公共料金関係の書類　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')
string3=$(grep "・契約書類（期限切れ含む）　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')
string4=$(grep "・手紙／はがき　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')
string5=$(grep "・領収書／明細書　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')
string6=$(grep "・その他　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')

string7=$(grep "・家具／家電等　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')
string8=$(grep "・自動車／自転車　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')
string9=$(grep "・不動産の登記簿　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')
string10=$(grep "・有価証券　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')
string11=$(grep "・銀行口座／預金通帳　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')
string12=$(grep "・保険者証　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')
string13=$(grep "・貴金属　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')
string14=$(grep "・年金　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')
string15=$(grep "・保険（車両／生命等）　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')

string16=$(grep "・ローン（不動産／車等）　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')
string17=$(grep "・借金　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')
string18=$(grep "・負債　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')

string19=$(grep "・公共料金（電気／ガス／水道／インターネット等）　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')
string20=$(grep "・家賃　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')
string21=$(grep "・携帯電話の契約　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')
string22=$(grep "・定期購入／定期支払い（サブスク関連）　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')
string23=$(grep "・クレジットカード　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')
string24=$(grep "・SNSアカウント（Googleアカウント等を含む）　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')

string25=$(grep "・スマートフォン／時計等　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')
string26=$(grep "・パソコン／モニター　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')
string27=$(grep "・写真や動画／メール等　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')
string28=$(grep "・アプリケーション／WEBアプリ　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')
string29=$(grep "・ソフトウェア（プログラム等）　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')
string30=$(grep "・ハードウェア（記憶媒体等）　ある" "$sub_file" | sed 's/・//g' | sed 's/　ある//g')

function organize_data () {
  if [ -n "$string1" ] || [ -n "$string2" ] || [ -n "$string3" ] || [ -n "$string4" ] || [ -n "$string5" ] || [ -n "$string6" ]; then
    echo "【書類の整理】" >> "$main_file"
  fi
  if [ "$string1" == "年金手帳" ]; then
    line=$(grep "・$string1(詳細)" "$sub_file" | sed 's/・年金手帳(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line" #「,」で分割された$lineの内容をreadコマンドの変数arrayに渡す。-raオプションにより渡されたデータをarray配列に格納する
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string1}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string1" >> "$main_file"
      for var in "${array[@]}"; do     # array配列の各要素を順番にvarに代入
        echo -n "$var" >> "$main_file" # ,$varで2列目に出力可
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string1}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: 年金手帳 -> なし\033[0m"
  fi
  if [ "$string2" == "公共料金関係の書類" ]; then
    line=$(grep "・$string2(詳細)" "$sub_file" | sed 's/・公共料金関係の書類(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string2}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string2" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string2}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: 公共料金関係の書類 -> なし\033[0m"
  fi
  if [ "$string3" == "契約書類（期限切れ含む）" ]; then
    line=$(grep "・$string3(詳細)" "$sub_file" | sed 's/・契約書類（期限切れ含む）(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string3}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string3" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string3}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: 契約書類（期限切れ含む） -> なし\033[0m"
  fi
  if [ "$string4" == "手紙／はがき" ]; then
    line=$(grep "・$string4(詳細)" "$sub_file" | sed 's/・手紙／はがき(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string4}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string4" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string4}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: 手紙／はがき -> なし\033[0m"
  fi
  if [ "$string5" == "領収書／明細書" ]; then
    line=$(grep "・$string5(詳細)" "$sub_file" | sed 's/・領収書／明細書(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string5}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string5" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string5}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: 領収書／明細書 -> なし\033[0m"
  fi
  if [ "$string6" == "その他" ]; then
    line=$(grep "・$string6(詳細)" "$sub_file" | sed 's/・その他(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string6}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string6" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string6}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: その他 -> なし\033[0m"
  fi

  if [ -n "$string7" ] || [ -n "$string8" ] || [ -n "$string9" ] || [ -n "$string10" ] || [ -n "$string11" ] || [ -n "$string12" ] || [ -n "$string13" ] || [ -n "$string14" ] || [ -n "$string15" ]; then
    echo "【財産の整理】" >> "$main_file"
  fi
  if [ "$string7" == "家具／家電等" ]; then
    line=$(grep "・$string7(詳細)" "$sub_file" | sed 's/・家具／家電等(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string7}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string7" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string7}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: 家具／家電等 -> なし\033[0m"
  fi
  if [ "$string8" == "自動車／自転車" ]; then
    line=$(grep "・$string8(詳細)" "$sub_file" | sed 's/・自動車／自転車(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string8}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string8" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string8}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: 自動車／自転車 -> なし\033[0m"
  fi
  if [ "$string9" == "不動産の登記簿" ]; then
    line=$(grep "・$string9(詳細)" "$sub_file" | sed 's/・不動産の登記簿(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string9}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string9" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string9}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: 不動産の登記簿 -> なし\033[0m"
  fi
  if [ "$string10" == "有価証券" ]; then
    line=$(grep "・$string10(詳細)" "$sub_file" | sed 's/・有価証券(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string10}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string10" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string10}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: 有価証券 -> なし\033[0m"
  fi
  if [ "$string11" == "銀行口座／預金通帳" ]; then
    line=$(grep "・$string11(詳細)" "$sub_file" | sed 's/・銀行口座／預金通帳(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string11}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string11" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string11}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: 銀行口座／預金通帳 -> なし\033[0m"
  fi
  if [ "$string12" == "保険者証" ]; then
    line=$(grep "・$string12(詳細)" "$sub_file" | sed 's/・保険者証(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string12}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string12" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string12}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: 保険者証 -> なし\033[0m"
  fi
  if [ "$string13" == "貴金属" ]; then
    line=$(grep "・$string13(詳細)" "$sub_file" | sed 's/・貴金属(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string13}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string13" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string13}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: 貴金属 -> なし\033[0m"
  fi
  if [ "$string14" == "年金" ]; then
    line=$(grep "・$string14(詳細)" "$sub_file" | sed 's/・年金(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string14}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string14" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string14}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: 年金 -> なし\033[0m"
  fi
  if [ "$string15" == "保険（車両／生命等）" ]; then
    line=$(grep "・$string15(詳細)" "$sub_file" | sed 's/・保険（車両／生命等）(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string15}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string15" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string15}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: 保険（車両／生命等） -> なし\033[0m"
  fi

  if [ -n "$string16" ] || [ -n "$string17" ] || [ -n "$string18" ]; then
    echo "【借金の整理】" >> "$main_file"
  fi
  if [ "$string16" == "ローン（不動産／車等）" ]; then
    line=$(grep "・$string16(詳細)" "$sub_file" | sed 's/・ローン（不動産／車等）(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string16}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string16" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string16}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: ローン（不動産／車等） -> なし\033[0m"
  fi
  if [ "$string17" == "借金" ]; then
    line=$(grep "・$string17(詳細)" "$sub_file" | sed 's/・借金(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string17}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string17" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string17}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: 借金 -> なし\033[0m"
  fi
  if [ "$string18" == "負債" ]; then
    line=$(grep "・$string18(詳細)" "$sub_file" | sed 's/・負債(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string18}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string18" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string18}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: 負債 -> なし\033[0m"
  fi

  if [ -n "$string19" ] || [ -n "$string20" ] || [ -n "$string21" ] || [ -n "$string22" ] || [ -n "$string23" ]; then
    echo "【契約関係の整理】" >> "$main_file"
  fi
  if [ "$string19" == "公共料金（電気／ガス／水道／インターネット等）" ]; then
    line=$(grep "・$string19(詳細)" "$sub_file" | sed 's/・公共料金（電気／ガス／水道／インターネット等）(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string19}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string19" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string19}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: 公共料金（電気／ガス／水道／インターネット等） -> なし\033[0m"
  fi
  if [ "$string20" == "家賃" ]; then
    line=$(grep "・$string20(詳細)" "$sub_file" | sed 's/・家賃(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string20}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string20" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string20}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: 家賃 -> なし\033[0m"
  fi
  if [ "$string21" == "携帯電話の契約" ]; then
    line=$(grep "・$string21(詳細)" "$sub_file" | sed 's/・携帯電話の契約(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string21}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string21" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string21}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: 携帯電話の契約 -> なし\033[0m"
  fi
  if [ "$string22" == "定期購入／定期支払い（サブスク関連）" ]; then
    line=$(grep "・$string22(詳細)" "$sub_file" | sed 's/・定期購入／定期支払い（サブスク関連）(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string22}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string22" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string22}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: 定期購入／定期支払い（サブスク関連） -> なし\033[0m"
  fi
  if [ "$string23" == "クレジットカード" ]; then
    line=$(grep "・$string23(詳細)" "$sub_file" | sed 's/・クレジットカード(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string23}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string23" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string23}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: クレジットカード -> なし\033[0m"
  fi
  if [ "$string24" == "SNSアカウント（Googleアカウント等を含む）" ]; then
    line=$(grep "・$string24(詳細)" "$sub_file" | sed 's/・SNSアカウント（Googleアカウント等を含む）(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string24}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string24" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string24}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: SNSアカウント（Googleアカウント等を含む） -> なし\033[0m"
  fi

  if [ -n "$string25" ] || [ -n "$string26" ] || [ -n "$string27" ] || [ -n "$string28" ] || [ -n "$string29" ] || [ -n "$string30" ]; then
    echo "【デバイスの整理】" >> "$main_file"
  fi
  if [ "$string25" == "スマートフォン／時計等" ]; then
    line=$(grep "・$string25(詳細)" "$sub_file" | sed 's/・スマートフォン／時計等(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string25}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string25" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string25}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: スマートフォン／時計等 -> なし\033[0m"
  fi
  if [ "$string26" == "パソコン／モニター" ]; then
    line=$(grep "・$string26(詳細)" "$sub_file" | sed 's/・パソコン／モニター(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string26}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string26" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string26}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: パソコン／モニター -> なし\033[0m"
  fi
  if [ "$string27" == "写真や動画／メール等" ]; then
    line=$(grep "・$string27(詳細)" "$sub_file" | sed 's/・写真や動画／メール等(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string27}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string27" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string27}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: 写真や動画／メール等 -> なし\033[0m"
  fi
  if [ "$string28" == "アプリケーション／WEBアプリ" ]; then
    line=$(grep "・$string28(詳細)" "$sub_file" | sed 's/・アプリケーション／WEBアプリ(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string28}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string28" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string28}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: アプリケーション／WEBアプリ -> なし\033[0m"
  fi
  if [ "$string29" == "ソフトウェア（プログラム等）" ]; then
    line=$(grep "・$string29(詳細)" "$sub_file" | sed 's/・ソフトウェア（プログラム等）(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string29}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string29" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string29}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: ソフトウェア（プログラム等） -> なし\033[0m"
  fi
  if [ "$string30" == "ハードウェア（記憶媒体等）" ]; then
    line=$(grep "・$string30(詳細)" "$sub_file" | sed 's/・ハードウェア（記憶媒体等）(詳細)//g' | sed 's/、/,/g' | sed 's/。/,/g' | sed 's/　//g')
    IFS=',' read -ra array <<< "$line"
    if [ -z "${array[0]}" ]; then
      echo -e "\033[1;31mERROR: ${string30}の詳細が見つかりませんでした\033[0m"
    else
      echo "$string30" >> "$main_file"
      for var in "${array[@]}"; do
        echo -n "$var" >> "$main_file"
        echo >> "$main_file"
      done
      echo -e "\033[1;32mSUCCESS: ${string30}の詳細を出力\033[0m"
    fi
  else
    echo -e "\033[1;38mNONE: ハードウェア（記憶媒体等） -> なし\033[0m"
  fi
}

if [ -f "$sub_file" ]; then
  organize_data
elif [ ! -f "$sub_file" ]; then
  echo -e "\033[1;31mERROR: $sub_file が存在しません。\033[0m"
fi
