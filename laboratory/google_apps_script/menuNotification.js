function menuNotification() {
  var today = new Date(); // 現在の日時を取得
  var year = today.getFullYear();
  var month = (today.getMonth() + 1).toString().padStart(2, '0');
  var sheetName = year + month;
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName(sheetName);

  var dates = sheet.getRange('A2:A').getValues(); // 日時データの範囲を指定
  var targetDate = new Date(today.getFullYear(), today.getMonth(), today.getDate()); // 今日の日時を取得

  let message = '';

  for (let i = 0; i < dates.length; i++) { // A2から下行に向かって確認していく
    var day = dates[i][0];
    if (day instanceof Date && day.getTime() === targetDate.getTime()) {
      var row = i + 2; // 行番号を取得（A2から始まるため、+2する）
      var range = sheet.getRange('C' + row + ':AG' + row); // D 列から L 列までの範囲を取得
      var rowData = range.getValues()[0]; // D 列から L 列までのデータを取得（1行分のデータを取得）

      var enabledColumn = []; // キーワードを含まない含まない空行の列を保持する配列
      var disabledColumn = []; // 除外する列の列を保持する配列
      var selectedColumn = sheet.getRange('C1:AG1').getValues()[0]; // 列のヘッダー行を取得

      wordDetection = false; // キーワードが見つかったかどうかのフラグ

      var disabledIndex = disabledColumn.map(invalidColumn => selectedColumn.indexOf(invalidColumn));

      for (let i = 0; i < rowData.length; i++) { // 行ごとにキーワードの有無を確認していく(C列〜AG列まで)
        var cellValue = rowData[i];
        if (typeof cellValue === 'string' && (cellValue.includes('休') || cellValue.includes('済'))) {
          wordDetection = true;
          continue;
        }
        if (!disabledIndex.includes(i)) { // 現在ループ処理している列が disabledIndex(除外する列のインデックスを格納する)配列に含まれていない場合
          enabledColumn.push(i); // enabledColumn 配列に有効な列のインデックスを追加
        }
      }

      if (enabledColumn.length >= 1) { // enabledColumn 配列に格納された、使用可能な列数が1つ以上ある場合
        var randomLottery = []; // ランダムに選出された1つの列を格納する
        while (randomLottery.length < 1) { //　ランダム抽選(列数が1になるまで繰り返し処理)
          var randomIndex = Math.floor(Math.random() * enabledColumn.length);
          if (!randomLottery.includes(randomIndex)) {
            randomLottery.push(randomIndex);
          }
        }

        // 献立を選出
        var election = [];
        for (var randomIndex of randomLottery) {
          var electionIndex = enabledColumn[randomIndex]; // 選択された列のインデックス
          election.push(selectedColumn[electionIndex]);
        }

        var targets = [];
        for (var electedMenu of election) {
          var menu = electedMenu;
          targets.push(menu);
        }
        message = '本日の夕食は「' + targets + '」にしませんか？';
      }

      if (message === '') { // 通知スケジュールがなかったら終了
        return;
      }
      return message; // メッセージを返す
    }
  }
}

function LineDeveloperMessage() {
  var channelAccessToken = "-----CHANNEL_ACCESS_TOKEN-----";
  var myUserId = "-----USER_ID-----";
  // var myUserId = "C97fda4cd18f1d0bd01e7765567540c75"; // グループLINEのグループID

  var headers = { // 以下、メッセージの内容を設定
    "Authorization": "Bearer " + channelAccessToken,
    "Content-Type": "application/json"
  };

  var messageText = menuNotification(); // menuNotification()関数を呼び出してテキストを取得

  if (!messageText) {
    return; // メッセージがない場合は終了
  }
  console.log('messageText:', messageText); // `messageText`の値をデバッグログで出力

  // スプレッドシートにアクセスして値を書き込む
  var spreadsheetId = "-----SPREAD_SHEET_ID-----"; // スプレッドシートのID　※シートを変更したら必ず更新すること
  var sheetName = "レシピ集"; // 書き込むシートの名前に置き換える
  var cellAddress = "A2"; // 書き込むセルのアドレスに置き換える
  var sheet = SpreadsheetApp.openById(spreadsheetId).getSheetByName(sheetName);
  sheet.getRange(cellAddress).setValue(messageText);

  var message = {
    "type": "template",
    "altText": "夕食の候補メッセージです",
    "template": {
      "type": "confirm",
      "text": messageText + '\n\n' + '"はい" → レシピを表示' + '\n' + '"いいえ" → メニューを再選択', // menuNotification()関数から取得したメッセージを表示
      "actions": [
        {
          "type": "message",
          "label": "はい",
          "text": "それにしましょう"
        },
        {
          "type": "message",
          "label": "いいえ",
          "text": "いやです"
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
  ScriptApp.newTrigger('createTrigger').timeBased().atHour(12).everyDays(1).create(); // 毎朝7時頃にcreateTriggerを実行するトリガーを作成
}

function createTrigger() { // 指定した日時にLineDeveloperMessageを実行する
  var triggers = ScriptApp.getProjectTriggers();
  triggers.forEach(function (t) {
    if (t.getHandlerFunction() === 'LineDeveloperMessage') { // 使用済み・不要なLineDeveloperMessageトリガーを削除
      ScriptApp.deleteTrigger(t);
    }
  });
  var today = Utilities.formatDate(new Date(), 'Asia/Tokyo', 'y-M-d');
  var time = '17:00:00';
  ScriptApp.newTrigger('LineDeveloperMessage').timeBased().at(new Date(`${today} ${time}`)).create(); // 当日の対象時刻にLineDeveloperMessageを実行するトリガーを作成
}