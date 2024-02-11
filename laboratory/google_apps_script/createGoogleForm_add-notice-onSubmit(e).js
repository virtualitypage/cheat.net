function onFormSubmit(e) {
  var selectedValue = e.namedValues['----TITLE-----'][0]; // 質問タイトルに合わせて修正
  var numericValue = Number(selectedValue);
  var sheetName = 'フォームの回答 1';

  var sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName(sheetName);
  var data = sheet.getRange("B2:B" + sheet.getLastRow()).getValues();

  for (var i = data.length - 1; i >= 0; i--) { // 変数 i を data の数から1を引いた値で値で初期化。変数 i が 0 以上である限りループ処理を実行する。
    if (data[i][0] === selectedValue) { // 値が文字列の場合
      sheet.deleteRow(i + 2); // B列は1行目ではなく2行目から始まるため、行番号を調整
    }
  }
  // B2のセルには空白を入れておく。プルダウンメニューには空白の状態で表示され、それを選択することで「最後のメモ」を完全に消すことができる。
  for (var i = data.length - 1; i >= 0; i--) { // 変数 i を data の数から1を引いた値で値で初期化。変数 i が 0 以上である限りループ処理を実行する。
    if (data[i][0] === numericValue) { // 値が整数値の場合
      sheet.deleteRow(i + 2); // B列は1行目ではなく2行目から始まるため、行番号を調整
    }
  }
}

function Notification() {
  var sheetName = '----SHEET_NAME-----';

  var sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName(sheetName);
  var data = sheet.getRange("B2:B" + sheet.getLastRow()).getValues();

  var channelAccessToken = "----ACCESS_TOKEN-----";

  var text = '';
  message = '----MESSAGE-----';

  var cellValues = []; // 空の配列を用意

  for (var i = 0; i < data.length; i++) {
    var cellValue = data[i][0];

    if (cellValue !== '') {
      cellValues.push(cellValue); // セルの値を配列に追加
    }
    if (cellValues !== '') {
      text = cellValues.join('\n');
    }
  }

  if (text === '') { // 通知スケジュールがなかったら終了
    return;
  }

  var message = { 'message': message + '\n' + text };
  var options = {
    "headers": { "Authorization": "Bearer " + channelAccessToken },
    "Content-Type": "application/json",
    "method": "post",
    "payload": message,
  };
  UrlFetchApp.fetch("https://notify-api.line.me/api/notify", options);
}

function initializeTrigger() {
  var spreadsheet = SpreadsheetApp.getActiveSpreadsheet();

  const triggers = ScriptApp.getProjectTriggers();
  triggers.forEach(function (t) {
    if (t.getHandlerFunction() === 'createTrigger') {
      ScriptApp.deleteTrigger(t);
    }
  });

  ScriptApp.newTrigger('createTrigger').timeBased().atHour(5).everyDays(1).create();
  ScriptApp.newTrigger('sendReply').forSpreadsheet(spreadsheet).onFormSubmit().create();
}

function createTrigger() { // 指定した日時にNotificationを実行する
  const triggers = ScriptApp.getProjectTriggers();
  triggers.forEach(function(t) {
    if (t.getHandlerFunction() === 'Notification') { // 使用済み・不要なNotificationトリガーを削除
      ScriptApp.deleteTrigger(t);
    }
  });
  const today = Utilities.formatDate(new Date(), 'Asia/Tokyo', 'y-M-d');
  const time = '10:00:00';
  ScriptApp.newTrigger('Notification').timeBased().at(new Date(`${today} ${time}`)).create(); // 当日の対象時刻にNotificationを実行するトリガーを作成
}