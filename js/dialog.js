// CommandFileUpdate
function showCommandFileUpdate(message, zipLabel, scriptLabel, noLabel) {
  var dialog = document.getElementById("CommandFileUpdate");
  var dialogMessage = document.getElementById("CommandFileUpdate-message");

  dialogMessage.textContent = message;

  var buttons = dialog.getElementsByTagName("button");
  buttons[0].textContent = zipLabel;
  buttons[1].textContent = scriptLabel;
  buttons[2].textContent = noLabel;

  dialog.style.display = "block";
}

function CommandFileUpdate(choice) {
  var dialog = document.getElementById("CommandFileUpdate");
  dialog.style.display = "none";
  if (choice === "zip") {
    window.open(
      "https://virtualitypage.github.io/cheat.net/laboratory/automator/CommandFileUpdate.zip"
    );
  } else if (choice === "script") {
    window.open(
      "https://virtualitypage.github.io/cheat.net/laboratory/automator/CommandFileUpdate.scpt"
    );
  } else {
  }
}

// DevelopShellScript
function showDevelopShellScript(message, zipLabel, scriptLabel, noLabel) {
  var dialog = document.getElementById("DevelopShellScript");
  var dialogMessage = document.getElementById("DevelopShellScript-message");

  dialogMessage.textContent = message;

  var buttons = dialog.getElementsByTagName("button");
  buttons[0].textContent = zipLabel;
  buttons[1].textContent = scriptLabel;
  buttons[2].textContent = noLabel;

  dialog.style.display = "block";
}

function DevelopShellScript(choice) {
  var dialog = document.getElementById("DevelopShellScript");
  dialog.style.display = "none";
  if (choice === "zip") {
    window.open(
      "https://virtualitypage.github.io/cheat.net/laboratory/automator/DevelopShellScript.zip"
    );
  } else if (choice === "script") {
    window.open(
      "https://virtualitypage.github.io/cheat.net/laboratory/automator/DevelopShellScript.scpt"
    );
  } else {
  }
}

// keepRecords
function showKeepRecords(message, zipLabel, scriptLabel, noLabel) {
  var dialog = document.getElementById("keepRecords");
  var dialogMessage = document.getElementById("keepRecords-message");

  dialogMessage.textContent = message;

  var buttons = dialog.getElementsByTagName("button");
  buttons[0].textContent = zipLabel;
  buttons[1].textContent = scriptLabel;
  buttons[2].textContent = noLabel;

  dialog.style.display = "block";
}

function keepRecords(choice) {
  var dialog = document.getElementById("keepRecords");
  dialog.style.display = "none";
  if (choice === "zip") {
    window.open(
      "https://virtualitypage.github.io/cheat.net/laboratory/automator/keepRecords.zip"
    );
  } else if (choice === "script") {
    window.open(
      "https://virtualitypage.github.io/cheat.net/laboratory/automator/keepRecords.scpt"
    );
  } else {
  }
}

// uploadLink
function showUploadLink(message, zipLabel, scriptLabel, noLabel) {
  var dialog = document.getElementById("uploadLink");
  var dialogMessage = document.getElementById("uploadLink-message");

  dialogMessage.textContent = message;

  var buttons = dialog.getElementsByTagName("button");
  buttons[0].textContent = zipLabel;
  buttons[1].textContent = scriptLabel;
  buttons[2].textContent = noLabel;

  dialog.style.display = "block";
}

function uploadLink(choice) {
  var dialog = document.getElementById("uploadLink");
  dialog.style.display = "none";
  if (choice === "zip") {
    window.open(
      "https://virtualitypage.github.io/cheat.net/laboratory/automator/uploadLink.zip"
    );
  } else if (choice === "script") {
    window.open(
      "https://virtualitypage.github.io/cheat.net/laboratory/automator/uploadLink.scpt"
    );
  } else {
  }
}