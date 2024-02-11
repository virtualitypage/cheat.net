function addData() {
  var form = FormApp.getActiveForm();
  var items = form.getItems();

  if (items.length > 0) {
    var sheetId = '----SHEET_ID-----';
    var sheet = SpreadsheetApp.openById(sheetId);
    var data = sheet.getRange("B2:B" + sheet.getLastRow()).getValues(); // B列を読み込む

    // シートから読み込んだデータを選択肢として追加
    var choices = [];
    for (var i = 0; i < data.length; i++) {
      if (data[i][0] !== '') { // 空でないセルの内容を選択肢として追加
        choices.push(data[i][0]);
      }
    }
    items[1].asListItem().setChoiceValues(choices); // プルダウンメニューの選択肢を更新
    // 送信された文字列が重複していると Exception: Questions cannot have duplicate choice values. というエラーが出る
  }
}

function initializeTrigger() {
  const triggers = ScriptApp.getProjectTriggers();
  triggers.forEach(function (t) {
    if (t.getHandlerFunction() === 'createTrigger') {
      ScriptApp.deleteTrigger(t);
    }
  });
  ScriptApp.newTrigger('addData').forForm(FormApp.getActiveForm()).onFormSubmit().create(); // addData 関数を実行するトリガーを作成
}