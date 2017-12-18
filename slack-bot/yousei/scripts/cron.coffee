cronJob = require('cron').CronJob

module.exports = (robot) ->

  # 特定のチャンネルへ送信するメソッド(定期実行時に呼ばれる)　
  send = (channel, msg) ->
    robot.send {room: channel}, msg

#  new cronJob('0 36 17 * * 1-5', () ->
#    # ↑のほうで宣言しているsendメソッドを実行する
#    send 'rm-dev-bot', "テスト"
#  ).start()
