var folderId = '-----FOLDER_ID-----';
var folder = DriveApp.getFolderById(folderId);
var files = folder.getFiles();

function init() { // 初回のみ実行
  var currentFileLists = [];

  while (files.hasNext()) {
    var file = files.next();
    currentFileLists.push(file.getName());
  }
  PropertiesService.getScriptProperties().setProperty('previousFileLists', currentFileLists.join(',')); // ファイルリストを設定
  PropertiesService.getScriptProperties().setProperty('previousFileCount', currentFileLists.length.toString()); // ファイル数を設定
  Logger.log("init(): スクリプトプロパティを作成しました");
  initializeTrigger();
}

function checkForNewFiles() {
  var currentFileLists = [];

  while (files.hasNext()) {
    var file = files.next();
    currentFileLists.push(file.getName());
  }
  var currentFileCount = currentFileLists.length; // 名称変更

  var previousFileListsProperty = PropertiesService.getScriptProperties().getProperty('previousFileLists'); // 前回更新されたファイルリストを取得
  var previousFileCountProperty = PropertiesService.getScriptProperties().getProperty('previousFileCount'); // 前回更新されたファイル数を取得

  if (previousFileCountProperty < currentFileCount || previousFileListsProperty != currentFileLists) { // ファイルが増えた場合（1 < 2 = true）|| ファイル名に変更があった場合
    var message = '-----MESSAGE-----\n\n';
    for (var i = 0; i < currentFileLists.length; i++) {
      message += '- ' + currentFileLists[i];
      if (i !== currentFileLists.length - 1) {
        message += '\n'; // 最終行でない場合に改行を追加
      }
    }
    PropertiesService.getScriptProperties().setProperty('previousFileLists', currentFileLists.join(',')); // ファイルリストを更新
    PropertiesService.getScriptProperties().setProperty('previousFileCount', currentFileLists.length.toString()); // ファイル数を更新
    return message;
  } else {
    PropertiesService.getScriptProperties().setProperty('previousFileLists', currentFileLists.join(','));
    PropertiesService.getScriptProperties().setProperty('previousFileCount', currentFileLists.length.toString());
  }

  // 参照元：https://developers.google.com/apps-script/guides/properties?hl=ja
  // try { // 単一のユーザープロパティを削除
  //   const previousFileListsProperty = PropertiesService.getScriptProperties(); // 現在のスクリプト内のユーザープロパティを取得
  //   const previousFileCountProperty = PropertiesService.getScriptProperties();
  //   previousFileListsProperty.deleteProperty('previousFileLists'); // 現在のスクリプト内のユーザープロパティを削除
  //   previousFileCountProperty.deleteProperty('previousFileCount');
  // } catch (err) {
  //   console.log('Failed with error %s', err.message); // 例外処理
  // }
}

function LineDeveloperMessage() {
  var channelAccessToken = "----CHANNEL_ACCESS_TOKEN-----";
  var groupId = "-----GROUP_ID-----";

  // 以下、メッセージの内容を設定
  var headers = {
    "Authorization": "Bearer " + channelAccessToken,
    "Content-Type": "application/json"
  };

  var messageText = checkForNewFiles(); // checkForNewFiles()関数を呼び出してテキストを取得

  if (!messageText) {
    return; // メッセージがない場合は終了
  }
  console.log('messageText:', messageText); // `messageText`の値をデバッグログで出力

  var options = {
    "method": "post",
    "headers": headers,
    "payload": JSON.stringify({
      "to": groupId,
      "messages": [{"type": "text", "text": messageText}]
    })
  };

  var response = UrlFetchApp.fetch("https://api.line.me/v2/bot/message/push", options);
  Logger.log(response.getContentText());

  // スクリプトの実行制限コード
  var frequencyIntProperty = PropertiesService.getScriptProperties(); // 現在のスクリプト内のユーザープロパティを取得
  var current = frequencyIntProperty.getProperty('frequency') || '0'; // プロパティが存在しない場合は 0 が代入される
  var frequency = parseInt(current, 10); // プロパティの値を10進数で数値に変換
  frequency++;
  frequencyIntProperty.setProperty('frequency', frequency.toString()); // 実行回数を更新

  var frequencyIntProperty = PropertiesService.getScriptProperties().getProperty('frequency'); // 実行回数を取得
  if (frequencyIntProperty == 2) { // スクリプトの実行回数が2回になった場合
    var currentProperty = PropertiesService.getScriptProperties(); // 現在のスクリプト内のユーザープロパティを取得
    currentProperty.deleteProperty('frequency'); // 指定のユーザープロパティを削除
    var triggers = ScriptApp.getProjectTriggers(); // 対象のプロジェクトに登録されているトリガーを取得
    triggers.forEach(function (t) {
      if (t.getHandlerFunction() === 'LineDeveloperMessage') {
        ScriptApp.deleteTrigger(t);
        Logger.log("createTrigger(): LineDeveloperMessage 実行トリガーを削除しました");
      }
    });
  }
}

function initializeTrigger() { // 通知用のトリガーを定期的に作成する
  ScriptApp.newTrigger('createTrigger').timeBased().atHour(0).everyDays(1).create(); // 毎日0時頃に createTrigger を実行するトリガーを作成
  console.log("initializeTrigger(): 初期化トリガーを作成しました");
}

function createTrigger() {
  const triggers = ScriptApp.getProjectTriggers(); // 対象のプロジェクトに登録されているトリガーを取得
  triggers.forEach(function (t) {
    if (t.getHandlerFunction() === 'LineDeveloperMessage') {
      ScriptApp.deleteTrigger(t);
      Logger.log("createTrigger(): LineDeveloperMessage 実行トリガーを削除しました");
    }
  });
  ScriptApp.newTrigger('LineDeveloperMessage').timeBased().everyMinutes(1).create(); // 1分毎に実行するトリガーを作成
  Logger.log("createTrigger(): LineDeveloperMessage 実行トリガーを作成しました");
}