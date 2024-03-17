function readGoogleDocFromDrive() {
  var fileId = '-----DOCUMENT_FILE_ID-----';  // 読み込むGoogleドキュメントのID
  var channelAccessToken = '-----CHANNEL_ACCESS_TOKEN-----';
  var doc = DocumentApp.openById(fileId);

  if (doc) {
    var content = doc.getBody().getText();
    Logger.log(content); // ログにテキストファイルの内容を表示
  } else {
    Logger.log("ファイルが見つかりませんでした。");
  }

  var message = { 'message': '\n' + content };
  var options = {
    "headers": { "Authorization": "Bearer " + channelAccessToken },
    "Content-Type": "application/json",
    "method": "post",
    "payload": message,
  };
  UrlFetchApp.fetch("https://notify-api.line.me/api/notify", options);
}

function initializeTrigger() { // 通知用のトリガーを定期的に作成する
  var triggers = ScriptApp.getProjectTriggers(); // 対象のプロジェクトに登録されているトリガーを取得
  triggers.forEach(function (t) {
    if (t.getHandlerFunction() === 'createTrigger') { // createTriggerトリガーが重複しないように古いトリガーを削除
      ScriptApp.deleteTrigger(t);
    }
  });
  ScriptApp.newTrigger('createTrigger').timeBased().atHour(10).everyDays(1).create(); // 毎朝10時頃にcreateTriggerを実行するトリガーを作成
}

function createTrigger() { // 指定した日時にreadGoogleDocFromDriveを実行する
  var triggers = ScriptApp.getProjectTriggers();
  triggers.forEach(function (t) {
    if (t.getHandlerFunction() === 'readGoogleDocFromDrive') { // 使用済み・不要なreadGoogleDocFromDriveトリガーを削除
      ScriptApp.deleteTrigger(t);
    }
  });
  var today = Utilities.formatDate(new Date(), 'Asia/Tokyo', 'y-M-d');
  var time = '16:00:00';
  ScriptApp.newTrigger('readGoogleDocFromDrive').timeBased().at(new Date(`${today} ${time}`)).create(); // 当日の対象時刻にreadGoogleDocFromDriveを実行するトリガーを作成
}