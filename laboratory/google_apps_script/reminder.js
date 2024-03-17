function reminder() {
  var sheet = SpreadsheetApp.getActive().getSheetByName('-----SHEET_NAME-----'); // getSheetByNameで指定したシートの全行を取得する
  var lastRow = sheet.getLastRow();
  var range = sheet.getRange('B3:D' + lastRow);
  var sheetRows = range.getValues();
  var today = Utilities.formatDate(new Date(), 'Asia/Tokyo', 'y-M-d');

  var todays = new Date();
  var year = todays.getFullYear();
  var month = todays.getMonth() + 2;

  // 取得したスプレッドシートの行配列から，メッセージを作成
  // 列はA,B,C,...が0,1,2,...にマップされる
  let text = '';
  sheetRows.forEach(function (row) {
    // 対象スケジュールが当日でなければメッセージに追加しない
    if (today !== Utilities.formatDate(new Date(row[0]), 'Asia/Tokyo', 'y-M-d')) {
      return;
    }
    text_title = year + '年' + month + '月分' + ' ' + '{銀行名}銀行への入金のお知らせ' + '\n';
    text += `${row[1]}　${row[2]}円\n`;
  });
  text = text.trim(); // 末尾の改行文字を削除する

  // 通知スケジュールがなかったら終了
  if (text === '') {
    return;
  }
  return text_title + text; // メッセージを返す
}

function LineDeveloperMessage() {
  var channelAccessToken = "-----CHANNEL_ACCESS_TOKEN-----";
  var myUserId = "-----USER_ID-----";

  // 以下、メッセージの内容を設定
  var headers = {
    "Authorization": "Bearer " + channelAccessToken,
    "Content-Type": "application/json"
  };

  var messageText = reminder(); // reminder()関数を呼び出してテキストを取得

  if (!messageText) {
    return; // メッセージがない場合は終了
  }

  var message = {
    "type": "template",
    "altText": "銀行振込のリマインド通知です({銀行名}銀行)", // バナーに表示される文字
    "template": {
      "type": "confirm",
      "text": messageText + '\n\n' + 'こちら完了しましたら「完了」を押して下さい。', // reminder()関数から取得したメッセージを表示
      "actions": [
        {
          "type": "message",
          "label": "完了",
          "text": "{銀行名}銀行への振込完了"
        },
        {
          "type": "message",
          "label": "未完了",
          "text": "{銀行名}銀行への振込未完了"
        }
      ]
    }
  };

  var options = {
    "method": "post",
    "headers": headers,
    "payload": JSON.stringify({
      "to": myUserId,
      "messages": [message]
    })
  };

  var response = UrlFetchApp.fetch("https://api.line.me/v2/bot/message/push", options);
  Logger.log(response.getContentText());
}

function initializeTrigger() { // 通知用のトリガーを定期的に作成する
  var triggers = ScriptApp.getProjectTriggers(); // 対象のプロジェクトに登録されているトリガーを取得
  triggers.forEach(function (t) {
    if (t.getHandlerFunction() === 'createTrigger') { // createTriggerトリガーが重複しないように古いトリガーを削除
      ScriptApp.deleteTrigger(t);
    }
  });
  ScriptApp.newTrigger('createTrigger').timeBased().atHour(5).everyDays(1).create(); // 毎朝5時頃にcreateTriggerを実行するトリガーを作成
}

function createTrigger() { // 指定した日時にLineDeveloperMessageを実行する
  var triggers = ScriptApp.getProjectTriggers();
  triggers.forEach(function (t) {
    if (t.getHandlerFunction() === 'LineDeveloperMessage') { // 使用済み・不要なLineDeveloperMessageトリガーを削除
      ScriptApp.deleteTrigger(t);
    }
  });
  var today = Utilities.formatDate(new Date(), 'Asia/Tokyo', 'y-M-d');
  var time = '9:00:00';
  ScriptApp.newTrigger('LineDeveloperMessage').timeBased().at(new Date(`${today} ${time}`)).create(); // 当日の対象時刻にLineDeveloperMessageを実行するトリガーを作成
}