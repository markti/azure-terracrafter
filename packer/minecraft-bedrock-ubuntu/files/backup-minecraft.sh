now=`date +"%Y-%m-%d"`
  
# stop minecraft server
sudo systemctl stop mcbedrock

# backup entire minecraft directory
tar -cvpzf minecraft-backup${now}.tar.gz /home/mcserver/minecraft_bedrock/worlds
sudo cp minecraft-backup${now}.tar.gz /mnt/homenas/minecraft/backups/

sudo systemctl start mcbedrock
