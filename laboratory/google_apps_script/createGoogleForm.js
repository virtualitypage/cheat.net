function createGoogleForm() {
  var form = FormApp.create('---FORM_NAME---');
  form.setTitle('---TITLE---');
  form.setDescription('---DESCRIPTION---');

  // 選択肢の配列を定義
  var choice1 = ["---question1---", "---question2---", "---question3---", "---question4---"];

  // 複数選択肢の質問
  var multipleChoiceItem = form.addMultipleChoiceItem();
  multipleChoiceItem.setTitle("---TITLE---");
  multipleChoiceItem.setChoiceValues(choice1).showOtherOption(true); //「その他」を項目に含めるどうかの設定
  multipleChoiceItem.setRequired(true);

  // 選択肢の配列を定義
  var choice2 = ["---question1---", "---question2---", "---question3---", "---question4---"];

  // 複数選択肢の質問
  var multipleChoiceItem = form.addMultipleChoiceItem();
  multipleChoiceItem.setTitle("---TITLE---");
  multipleChoiceItem.setChoiceValues(choice2).showOtherOption(true); //「その他」を項目に含めるどうかの設定
  multipleChoiceItem.setRequired(true);

  // 選択肢の配列を定義
  var choice3 = ["---question1---", "---question2---", "---question3---", "---question4---"];

  // 複数選択肢の質問
  var multipleChoiceItem = form.addMultipleChoiceItem();
  multipleChoiceItem.setTitle("---TITLE---");
  multipleChoiceItem.setChoiceValues(choice3).showOtherOption(true); //「その他」を項目に含めるどうかの設定
  multipleChoiceItem.setRequired(true);

  // 選択肢の配列を定義
  var choice4 = ["---question1---", "---question2---", "---question3---", "---question4---"];

  // 複数選択肢の質問
  var multipleChoiceItem = form.addMultipleChoiceItem();
  multipleChoiceItem.setTitle("---TITLE---");
  multipleChoiceItem.setChoiceValues(choice4).showOtherOption(true); //「その他」を項目に含めるどうかの設定
  multipleChoiceItem.setRequired(true);

  // 記述式の質問
  var textItem = form.addParagraphTextItem();
  textItem.setTitle("---TITLE---");
  textItem.setRequired(true);

  var item = form.addListItem().setTitle('---TITLE---').setRequired(true)

  var textItem = form.addParagraphTextItem();
  textItem.setTitle("---TITLE---");

  //条件分岐するためのメソッドを用意
  var section2 = form.addPageBreakItem().setTitle('---TITLE---').setHelpText('---DESCRIPTION---');

  //セクション2に条件分岐する選択肢を追加
  item.setChoices([
    item.createChoice('はい', section2),
    item.createChoice('いいえ', FormApp.PageNavigationType.SUBMIT)
  ]);

  var sheetId = '---SHEET_ID---';
  var today = new Date(); // 現在の日時を取得
  var year = today.getFullYear();
  var month = (today.getMonth() + 1).toString().padStart(2, '0');
  var sheetName = year + month;
  var sheet = SpreadsheetApp.openById(sheetId).getSheetByName(sheetName);

  var data = sheet.getRange(":").getValues()[0]; // ここで指定した列を読み込む

  // シートから読み込んだデータを選択肢として追加
  var choices = [];
  for (var i = 0; i < data.length; i++) {
    if (data[i] !== '') { // 空でないセルの内容を選択肢として追加
      choices.push(data[i]);
    }
  }

  // プルダウンメニューを作成(指定されたスプレッドシートから取得)
  var pulldown = form.addListItem().setTitle('---TITLE---').setRequired(true)
  pulldown.setChoiceValues(choices);

  var textItem = form.addParagraphTextItem();
  textItem.setTitle("---TITLE---");

  var pulldown = form.addListItem().setTitle('---TITLE---');
  pulldown.setChoiceValues(choices);

  var textItem = form.addParagraphTextItem();
  textItem.setTitle("---TITLE---");
}