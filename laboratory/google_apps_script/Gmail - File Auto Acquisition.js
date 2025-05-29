function autoAcquisition() {
  var folder = DriveApp.getFolderById("-----FOLDER_ID-----");
  var date = new Date();
  date.setDate(date.getDate() - 1);
  var date = Utilities.formatDate(date, 'Asia/Tokyo', 'yyyy-MM-dd');

  var query = "subject:" + date + " log file"; // 検索クエリを生成
  var threads = GmailApp.search(query); // 検索queryに一致するスレッドを取得

  // 各スレッド情報を取得
  threads.forEach(function (thread) {
    var messages = thread.getMessages(); // スレッド内の全てのメッセージを取得
    messages.forEach(function (message) { // 各メッセージ情報を取得
      var attachments = message.getAttachments(); // メッセージ内の全ての添付ファイルを取得
      attachments.forEach(function (attachment) { // 各添付ファイル情報を取得
        folder.createFile(attachment); // 添付ファイルを指定フォルダに格納
      });
    });
  });
}

function initializeTrigger() { // 通知用のトリガーを定期的に作成する
  const triggers = ScriptApp.getProjectTriggers(); // 対象のプロジェクトに登録されているトリガーを取得
  triggers.forEach(function (t) {
    if (t.getHandlerFunction() === 'createTrigger') { // createTriggerトリガーが重複しないように古いトリガーを削除
      ScriptApp.deleteTrigger(t);
    }
  });
  ScriptApp.newTrigger('createTrigger').timeBased().atHour(23).everyDays(1).create(); // 毎晩23時頃にcreateTriggerを実行するトリガーを作成
  console.log("initializeTrigger(): 初期化トリガーを作成しました");
}

function createTrigger() { // 指定した時間にautoAcquisitionを実行する
  const triggers = ScriptApp.getProjectTriggers();
  triggers.forEach(function (t) {
    if (t.getHandlerFunction() === 'autoAcquisition') { // 使用済み・不要なautoAcquisitionトリガーを削除
      ScriptApp.deleteTrigger(t);
    }
  });
  const date = new Date();
  date.setDate(date.getDate() + 1);
  date.setHours(0, 0, 0, 0); // 時間、分、秒、およびミリ秒全てを0に設定
  ScriptApp.newTrigger('autoAcquisition').timeBased().at(date).create(); // 当日の対象時刻にautoAcquisitionを実行するトリガーを作成
  console.log("createTrigger(): autoAcquisition実行トリガーを作成しました");
}