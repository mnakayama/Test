module.exports = (robot) ->















    #msg.send "slack_idをおしえて ： slack_idをおしえてあげるよ\n"







    msg.send "slack_idは[" + msg.message.user.id + "]だよ"

  robot.respond /アカウントを(おしえて|教えて)/i, (msg) ->
    command = "powershell ./scripts/ps/account_check.ps1 " + msg.message.user.id
    require('child_process').exec command , (error, stdout, stderr) ->
      if !error


        msg.send stderr




    require('child_process').exec command , (error, stdout, stderr) ->
      if !error
        msg.send stdout
      else
        msg.send stderr




#    require('child_process').exec command , (error, stdout, stderr) ->
#      if !error


#        msg.send stderr

  robot.respond /アイテムくれ/i, (msg) ->
    command = "powershell ./scripts/ps/regist_target_user.ps1 " + msg.message.user.id
    require('child_process').exec command , (error, stdout, stderr) ->
      if !error


        msg.send stderr
