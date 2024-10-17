#!/usr/bin/env bash

SERVER_PATH=/home/mcserver/minecraft_java/

/usr/bin/screen -dmS mcserver /bin/bash -c "cd $SERVER_PATH; java -Xmx1024M -Xms1024M -jar server.jar nogui"
/usr/bin/screen -rD mcserver -X multiuser on
/usr/bin/screen -rD mcserver -X acladd root