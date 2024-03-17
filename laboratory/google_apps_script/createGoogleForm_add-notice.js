function createGoogleForm() {
  var form = FormApp.create('-----FORM_NAME-----');
  form.setTitle('-----TITLE-----');
  form.setDescription('---DESCRIPTION---');

  var textItem = form.addParagraphTextItem(); // 記述式の質問
  textItem.setTitle("-----TITLE-----");
  textItem.setRequired;

  var spreadsheet = SpreadsheetApp.create('-----SPREADSHEET-----'); // 新しいスプレッドシートを作成

  form.setDestination(FormApp.DestinationType.SPREADSHEET, spreadsheet.getId()); // フォームの回答先を新しいスプレッドシートに設定

  var choices = [''];

  var pulldown = form.addListItem().setTitle('-----TITLE-----'); // プルダウンメニューを作成
  pulldown.setChoiceValues(choices);
}