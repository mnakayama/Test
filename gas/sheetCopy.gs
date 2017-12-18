function SheetCopy() {

  Browser.msgBox("シートのバックアップを開始します");
  
  var yearMonth = getYearMonth();
  if (yearMonth == "")
    return;
  
  var month = yearMonth.substr(4, 2);
  
  // コピー先のスプレッドシートを新規作成して開く
  var dstSpreadSheet = createSpreadSheet(yearMonth);
  
  // コピー元のスプレッドシートは自分自身
  var srcSpreadSheet = SpreadsheetApp.getActiveSpreadsheet();
  var srcSheet = srcSpreadSheet.getSheetByName("Menu");

  // 配列で取得
　var sheets = srcSpreadSheet.getSheets();
  
  for (var i = 0; i < sheets.length; i++)
  {
    var sheet = sheets[i];
    
    var name = sheet.getName();
    if (name.indexOf(month) === 0)
    {
      sheet.copyTo(dstSpreadSheet);
      srcSpreadSheet.deleteSheet(sheet);
    }
  }
  
  Browser.msgBox("シートのバックアップが完了しました");
}

function getYearMonth() {
  
  var ui = SpreadsheetApp.getUi();
  var re = ui.prompt("コピー対象の年月を半角数字6桁で入力してください（例：2016年5月→201605）", ui.ButtonSet.OK_CANCEL);
  var yearMonth = "";
  switch(re.getSelectedButton()){
    case ui.Button.OK:
      yearMonth = re.getResponseText();
      break;
    case ui.Button.CANCEL:
      return "";
      break;
    case ui.Button.CLOSE:
      return "";
      break;
  }
  
  if (yearMonth.length !== 6)
  {
    Browser.msgBox("入力形式が正しくありません。");
    return "";
  }
  
  if (isNaN(parseInt(yearMonth, 10)))
  {
    Browser.msgBox("入力形式が正しくありません。");
    return "";
  }

  return yearMonth;
}

function createSpreadSheet(yearMonth) {
  var folderId = "0B1LQPzw0pedcaEx4T0ZFNDRfNlE";
  var spreadSheetName = "【Rogue】" + yearMonth + "マスタ投入チェックシート";
  
  var ssId = SpreadsheetApp.create(spreadSheetName).getId();
  var file = DriveApp.getFileById(ssId);
  
  var folder = DriveApp.getFolderById(folderId)
  folder.addFile(file);
  
  var ss = SpreadsheetApp.openById(ssId);
  return ss;
}