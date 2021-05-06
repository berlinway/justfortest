#！/bin/bash


##########################################
################     1、挂载GD     #######
##########################################
mkdir -p /app/rclone
mkdir -p /app/gd
mkdir -p /app/storage
mkdir -p /app/tmp
mkdir -p ~/.config/rclone

apt  -y install wget unzip  fuse fuse-devel tmux unzip iotop nload

cd  /app/rclone
wget https://github.com/rclone/rclone/releases/download/v1.55.1/rclone-v1.55.1-linux-amd64.zip
unzip rclone-v1.55.1-linux-amd64.zip
mv rclone-v1.55.1-linux-amd64 rclone
ln -s /app/rclone/rclone/rclone    /usr/bin/rclone



###向~/.config/rclone/rclone.conf追加内容
cat > ~/.config/rclone/rclone.conf <<EOF
[gd-yun]
type = drive
scope = drive
token = {"access_token":"ya29.a0AfH6SMAoZ-vLliokqCsq9mZViiI-ZtRlCk6MgSPG5XzhRQgQNESWsHI08wLpRdDz0r-j5ENZ6OzfPLnz6LpmMjGHiAIvmrnzzV8L0jmyGYLizaJBhdCv7DpnrdTkksXnVj9ZHVazMSMW-i897jB4saCuYU5E","token_type":"Bearer","refresh_token":"1//0ddhud8rBEtfGCgYIARAAGA0SNwF-L9IrS47c9ipr-FoKYLAMrx_sFa8R5vsxuRJzlperrmsu5Gc_SFJP0xuzG72bX-xLsPvJbwU","expiry":"2021-05-06T10:45:02.018913698Z"}
EOF

cat >/etc/systemd/system/rclone-gd.service<<EOF
[Unit]
Description = rclone-gd
     
[Service]
User = root
ExecStart = /usr/bin/rclone mount gd-yun: /app/gd  --vfs-cache-max-age 2h  --file-perms 0777 --copy-links --no-gzip-encoding --no-check-certificate --allow-other --allow-non-empty --umask 000 
Restart = on-abort
     
[Install]
WantedBy = multi-user.target

EOF


systemctl enable rclone-gd
systemctl start rclone-gd

##########################################
###########     2、附加500ssd      #######
##########################################

#附加去后台附加，默认是开机器的时候就加上去了
#Create new empty partitions:
parted -s /dev/vdb mklabel gpt
parted -s /dev/vdb unit mib mkpart primary 0% 100%
#Create new empty filesystem
mkfs.ext4 /dev/vdb1
#默认不关机，随意挂载
mount /dev/vdb1   /app/storage





##########################################
###########     3、p图软件设置     #######
##########################################
mkdir   -p /app/hpool/
cd /app/hpool/
wget https://github.com/hpool-dev/chia-plotter/releases/download/v0.11/chia-plotter-v0.11-x86_64-linux-gnu.zip
unzip chia-plotter-v0.11-x86_64-linux-gnu.zip
rm  -rf  __MACOSX



cat > /app/hpool/chia-plotter/p1.sh<<EOF
#!/bin/bash

for((i=0;i<1000;i++))
do
	echo $i  "start" `date` >> /app/hpool/chia-plotter/p1.log
	/app/hpool/chia-plotter/chia-plotter-linux-amd64 -action plotting -plotting-fpk 0x8bdadf4c2052ca2e1c3113d9c2752e835ab0f669113c961f85bd945ea3d1184225b49cb3595f5a59918d94bfb7c4809d -plotting-ppk 0x86a0265e3c0de8d5db9a351afe5d77ed268cfbeca0a6f89a1a097d8599aaf296ee40fb264cbe5bec2e520a84865c2ded -plotting-n 2 -b 3390 -d   /app/gd -t /app/tmp
	echo $i  "start" `date` >> /app/hpool/chia-plotter/p1.log
done

EOF

cat > /app/hpool/chia-plotter/p2.sh<<EOF
#!/bin/bash

sleep 3h
for((i=0;i<1000;i++))
do
	echo $i  "start" `date` >> /app/hpool/chia-plotter/p2.log
	/app/hpool/chia-plotter/chia-plotter-linux-amd64 -action plotting -plotting-fpk 0x8bdadf4c2052ca2e1c3113d9c2752e835ab0f669113c961f85bd945ea3d1184225b49cb3595f5a59918d94bfb7c4809d -plotting-ppk 0x86a0265e3c0de8d5db9a351afe5d77ed268cfbeca0a6f89a1a097d8599aaf296ee40fb264cbe5bec2e520a84865c2ded -plotting-n 2 -b 3390 -d   /app/gd -t /app/storage
	echo $i  "start" `date` >> /app/hpool/chia-plotter/p2.log
done

EOF
touch /app/hpool/chia-plotter/p1.log
touch  /app/hpool/chia-plotter/p2.log
chmod +x /app/hpool/chia-plotter/p1.sh
chmod +x /app/hpool/chia-plotter/p2.sh








