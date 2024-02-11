function Notification() {
  const today = new Date(); // 現在の日時を取得
  const year = today.getFullYear();
  const month = (today.getMonth() + 1).toString().padStart(2, '0');
  const sheetName = year + month;
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName(sheetName);

  var channelAccessToken = "-----CHANNEL_ACCESS_TOKEN-----";

  const date = Utilities.formatDate(new Date(), 'Asia/Tokyo', 'M月d日');
  const dates = sheet.getRange('A2:A').getValues(); // 日時データの範囲を指定
  const targetDate = new Date(today.getFullYear(), today.getMonth(), today.getDate()); // 今日の日時を取得

  let text = '';

  for (let i = 0; i < dates.length; i++) { // A2から下行に向かって確認していく
    const day = dates[i][0];
    if (day instanceof Date && day.getTime() === targetDate.getTime()) {
      const row = i + 2; // 行番号を取得（A2から始まるため、+2する）
      const range = sheet.getRange('C' + row + ':AR' + row); // B 列から AR 列までの範囲を取得
      const rowData = range.getValues()[0]; // B 列から AR 列までのデータを取得（1行分のデータを取得）

      const enabledColumn = []; // キーワードを含まない空行の列を保持する配列
      const disabledColumn = ['']; // 除外する列の列を保持する配列（G列を除外）
      const selectedColumn = sheet.getRange('C1:AR1').getValues()[0]; // 列のヘッダー行を取得

      wordDetection = false; // キーワードが見つかったかどうかのフラグ

      const disabledIndex = disabledColumn.map(invalidColumn => selectedColumn.indexOf(invalidColumn));

      for (let i = 0; i < rowData.length; i++) { // 行ごとにキーワードの有無を確認していく(B列〜AQ列まで)
        const cellValue = rowData[i];
        if (typeof cellValue === 'string' && (cellValue.includes('休'))) {
          wordDetection = true;
          continue;
        }
        if (!disabledIndex.includes(i)) { // 現在ループ処理している列が disabledIndex(除外する列のインデックスを格納する)配列に含まれていない場合
          enabledColumn.push(selectedColumn[i]); // selectedColumn から列のヘッダー行を取得し、 enabledColumn 配列に有効な列のインデックスを追加
        }
      }
      text = ' ' + year + '年' + date + ' ' + '地獄谷'  + '\n' + '開店予定の店をお知らせします。' + '\n' + '\n' + enabledColumn.join('\n');
      console.log(text);
    }
  }
  if (text === '') { // 通知スケジュールがなかったら終了
    return;
  }
  var message = { 'message': text };
  var options = {
    "headers": { "Authorization": "Bearer " + channelAccessToken },
    "Content-Type": "application/json",
    "method": "post",
    "payload": message,
  };
  UrlFetchApp.fetch("https://notify-api.line.me/api/notify", options);
}

function initializeTrigger() { // 通知用のトリガーを定期的に作成する
  const triggers = ScriptApp.getProjectTriggers(); // 対象のプロジェクトに登録されているトリガーを取得
  triggers.forEach(function(t) {
    if (t.getHandlerFunction() === 'createTrigger') { // createTriggerトリガーが重複しないように古いトリガーを削除
      ScriptApp.deleteTrigger(t);
    }
  });
  ScriptApp.newTrigger('createTrigger').timeBased().atHour(10).everyDays(1).create(); // 毎朝10時頃にcreateTriggerを実行するトリガーを作成
}

function createTrigger() { // 指定した日時にNotificationを実行する
  const triggers = ScriptApp.getProjectTriggers();
  triggers.forEach(function(t) {
    if (t.getHandlerFunction() === 'Notification') { // 使用済み・不要なNotificationトリガーを削除
      ScriptApp.deleteTrigger(t);
    }
  });
  const today = Utilities.formatDate(new Date(), 'Asia/Tokyo', 'y-M-d');
  const time = '15:00:00';
  ScriptApp.newTrigger('Notification').timeBased().at(new Date(`${today} ${time}`)).create(); // 当日の対象時刻にNotificationを実行するトリガーを作成
}