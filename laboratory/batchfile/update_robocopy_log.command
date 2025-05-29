#!/bin/bash

export LC_ALL=C

current_dir=$(cd "$(dirname "$0")" && pwd)
file=$(find "$current_dir" -type f -maxdepth 1 -name 'robocopy_log_*.log')
cp "$file" "$file.copy"

sed -i '' 's/Windows.*/Windows の堅牢性の高いファイル コピー/g' "$file"
sed -i '' 's/�J�n/開始/g' "$file"
sed -i '' 's/.*�f�B���N�g��/    Dir/g' "$file"
sed -i '' 's/�N/年/g' "$file"
sed -i '' 's/.*�R�s�\[�� = E/  コピー元 = E/g' "$file"
sed -i '' 's/.*�R�s�\[�� = F/  コピー先 = F/g' "$file"
sed -i '' -e '12s/^/\n/' -e '11d' "$file"
sed -i '' 's/�� /日 /g' "$file"
sed -i '' 's/\/W:30 /\/W:30/g' "$file"
sed -i '' 's/�V�����t�@�C��/新しいファイル/g' "$file"
sed -i '' 's/�t�@�C��/ファイル/g' "$file"
sed -i '' 's/    ファイル/  ファイル/g' "$file"
sed -i '' 's/�I�v�V����/オプション/g' "$file"
sed -i '' '/^ .*%/d' "$file"
sed -i '' 's/%.*$/%/g' "$file"
sed -i '' 's/.*���v.*/               合計  コピー済み   スキップ     不一致      失敗    Extras/g' "$file"
sed -i '' 's/   ファイル/   File/g' "$file"
sed -i '' 's/.*�o�C�g:/   Byte:/g' "$file"
sed -i '' 's/.*����:/   Time:/g' "$file"
sed -i '' 's/.*���x/   速度/g' "$file"
sed -i '' 's/�I��/終了/g' "$file"
sed -i '' 's/速度:            /速度: /g' "$file"
sed -i '' 's/�o�C�g/バイト/g' "$file"
sed -i '' 's/\/�b/\/秒/g' "$file"
sed -i '' 's/\/��/\/分/g' "$file"
sed -i '' 's/��/月/g' "$file"
sed -i '' '$d' "$file"
