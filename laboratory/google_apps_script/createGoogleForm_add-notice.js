function createGoogleForm() {
  const form = FormApp.create('---FORM_NAME---');

  form.setTitle('---TITLE---');
  form.setDescription('---DESCRIPTION---');

  // 記述式の質問
  var textItem = form.addParagraphTextItem();
  textItem.setTitle("---TITLE---");
  textItem.setRequired;

  // 新しいスプレッドシートを作成
  var spreadsheet = SpreadsheetApp.create('---SPREADSHEET---');

  // フォームの回答先を新しいスプレッドシートに設定
  form.setDestination(FormApp.DestinationType.SPREADSHEET, spreadsheet.getId());

  var choices = [''];

  // プルダウンメニューを作成
  var pulldown = form.addListItem().setTitle('---TITLE---');
  pulldown.setChoiceValues(choices);
}