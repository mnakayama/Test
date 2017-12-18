@echo off
set HUBOT_SLACK_TOKEN=xoxb-168587316947-BSZznXVaywS0vTJnuB4vbpzO
call npm install
SETLOCAL
SET PATH=node_modules\.bin;node_modules\hubot\node_modules\.bin;%PATH%

node_modules\.bin\hubot.cmd --name "yousei" %* 
