function color() {
  var keyword1 = '土';
  var keyword2 = '日';
  var keyword3 = '祝';
  var keywordCol = 2;
  var today = new Date(); // 現在の日時を取得
  var year = today.getFullYear();
  var month = (today.getMonth() + 1).toString().padStart(2, '0');
  var sheetName = year + month;
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName(sheetName);
  var numColumns = sheet.getLastColumn();

  for (var i = 1; i <= sheet.getLastRow(); i++) {
    if (1 >= 1 && i <= 2) {
      sheet.getRange(i, 1, 1, numColumns).setBackground('#00FFFF'); // A列の背景色を変更する
      continue;
    }
    if (i >= 4 && i <= 6) {
      sheet.getRange(i, 1, 1, numColumns).setBackground('#A9A9A9'); // 今日より前日を灰色にする
      continue;
    }
    if (sheet.getRange(i, keywordCol).getValue() == keyword1) {
      sheet.getRange(i, 1, 1, numColumns).setBackground('#B0E0E6').setBorder(true, true, true, true, true, true); // 土の背景色を変更し、枠線を設定する(上、左、下、右、垂直、水平)
    } else if (sheet.getRange(i, keywordCol).getValue() == keyword2 || sheet.getRange(i, keywordCol).getValue() == keyword3) { // 日・祝の背景色を変更する
      sheet.getRange(i, 1, 1, numColumns).setBackground('#ADD8E6');
    }
  }
}