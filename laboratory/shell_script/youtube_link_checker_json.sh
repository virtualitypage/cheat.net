#!/bin/bash

# 動画リンクを含むCSVファイルのパス
csv_file="youtube.csv"

# 判定結果を保存するJSONファイルのパス
json_file="youtube_results.json"

# SlackのAPIトークンとチャンネル名
slack_token=""
channel="#youtube-valid"

# CSVファイルの存在チェック
if [[ ! -f "$csv_file" ]]; then
    echo -e "\033[1;31mERROR: $csv_file が存在しません。$csv_file の所在を明らかにして再度実行してください。\033[0m"
    exit 1
fi

# CSVファイルからデータを読み込んでJSONファイルに変換する関数
convert_to_json() {
    local csv_file="$1"
    local json_file="$2"

    # JSON配列の開始部分を出力
    echo "[" > "$json_file"

    # CSVファイルから行を読み込み、JSONオブジェクトとして変換して出力
    sed 1d "$csv_file" | while IFS=',' read -r link result
    do
        # リンクがYouTubeの動画リンクかどうかを確認
        if [[ $link == *"youtube.com"* ]]; then
            # YouTube動画リンクの場合、curlコマンドでリンク先のHTTPステータスコードを取得
            status_code=$(curl -sL -w "%{http_code}" "$link" -o /dev/null)

            if [[ $status_code == "200" ]]; then
                # ステータスコードが200の場合はリンクが有効
                # さらにYouTubeのページから再生不可能なメッセージを確認
                if curl -sL "$link" | grep -q "この動画は再生できません"; then
                    result="404"
                else
                    result="200"
                fi
            elif [[ $status_code == "302" ]]; then
                # ステータスコードが302の場合は非公開
                result="302"
            else
                # その他のステータスコードは不明
                result="Unknown status"
            fi
        else
            # YouTubeの動画リンクではない場合は無効なリンクとして判定
            result="Invalid link"
        fi

        # JSONオブジェクトを作成して出力
        echo -e "  {\n    \"link\": \"$link\",\n    \"result\": \"$result\"\n  }," >> "$json_file"
    done

    # 最後のカンマを削除してJSON配列を終了
    sed -i '' '$ s/,$//' "$json_file"
    echo "]" >> "$json_file"
}

# JSONファイルを改行形式で出力する関数
format_json_with_newlines() {
    local json_file="$1"
    local temp_file="${json_file}.tmp"

    # JSONファイルを読み込み、カンマごとに改行を挿入して一時ファイルに出力
    sed 's/},/},\n/g' "$json_file" > "$temp_file"

    # 一時ファイルを元のJSONファイルに移動
    mv "$temp_file" "$json_file"
}

# CSVをJSONに変換して出力
convert_to_json "$csv_file" "$json_file"

# JSONファイルを改行形式で出力
format_json_with_newlines "$json_file"

# Slackにファイルを転送する関数
send_to_slack() {
    local file_path=$1
    local file_name=$(basename "$file_path")

    # Slackへのファイルアップロードリクエストを作成
    response=$(curl -F file=@"$file_path" \
                    -F channels="$channel" \
                    -H "Authorization: Bearer $slack_token" \
                    https://slack.com/api/files.upload)

    # レスポンスから成功かどうかを判定
    success=$(echo "$response" | jq -r '.ok')
    if [[ $success == "true" ]]; then
        echo "File '$file_name' uploaded to Slack successfully."
    else
        error=$(echo "$response" | jq -r '.error')
        echo "Failed to upload file to Slack. Error: $error"
    fi
}

# JSONファイルをSlackに送信
send_to_slack "$json_file"
