module.exports = (robot) ->
  robot.respond /([\s\S]*)のテスト/i, (msg) ->
    word = msg.match[1].replace(/\n/g, "")
    msg.send word
  
  robot.respond /コマンド/i, (msg) ->
    message = """
               slack_idをおしえて ： slack_idをおしえてあげるよ
               アカウントをおしえて ： アカウントが登録されていたらおしえてあげるよ
               アイテムくれ ： 期間中のイベント用アイテムを付与してあげるよ
               使い方は
               https://docs.google.com/spreadsheets/d/1CQLPFtWE9_PLxdN7a__4sLwqGbrtLwKKgRtis1vjdvw/
               をみてね
               """
    msg.send message
    
    #msg.send "slack_idをおしえて ： slack_idをおしえてあげるよ\n"
    #msg.send "アカウントをおしえて ： アカウントが登録されていたらおしえてあげるよ\n"
    #msg.send "アイテムくれ ： 期間中のイベント用アイテムを付与してあげるよ\n"
    #msg.send "詳しい使い方は\n"
    #msg.send "https://docs.google.com/spreadsheets/d/1CQLPFtWE9_PLxdN7a__4sLwqGbrtLwKKgRtis1vjdvw/\n"
    #msg.send "をみてね"
  
  robot.respond /slack_idを(おしえて|教えて)/i, (msg) ->
    msg.send "slack_idは[" + msg.message.user.id + "]だよ"
  
  robot.respond /アカウントを(おしえて|教えて)/i, (msg) ->
    command = "powershell ./scripts/ps/account_check.ps1 " + msg.message.user.id
    require('child_process').exec command , (error, stdout, stderr) ->
      if !error
        msg.send stdout
      else
        msg.send stderr
        
  robot.respond /([\s\S]*)のアカウントを(おしえて|教えて)/i, (msg) ->
    word = msg.match[1].replace(/\n/g, "")
    command = "powershell ./scripts/ps/account_check.ps1 " + word
    require('child_process').exec command , (error, stdout, stderr) ->
      if !error
        msg.send stdout
      else
        msg.send stderr

#  robot.respond /([0-9]+)のアカウントを(とうろくして|登録して)/i, (msg) ->
#    uid = msg.match[1].replace(/\n/g, "")
#    command = "powershell ./scripts/ps/account_add.ps1 " + msg.message.user.id + " " + msg.message.user.name + " " + uid
#    require('child_process').exec command , (error, stdout, stderr) ->
#      if !error
#        msg.send stdout
#      else
#        msg.send stderr

  robot.respond /アイテムくれ/i, (msg) ->
    command = "powershell ./scripts/ps/regist_target_user.ps1 " + msg.message.user.id
    require('child_process').exec command , (error, stdout, stderr) ->
      if !error
        msg.send stdout
      else
        msg.send stderr
        