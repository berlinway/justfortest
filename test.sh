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

[gd-iokle]
type = drive
scope = drive
token = {"access_token":"ya29.a0AfH6SMCxXNCL1eV0CDOH0xaEiq5taen2ZNIO99y8n-jxd6fNe8G-knac0f-JF1l9WGeYOo9rc9nEF9WqQY-pmS6J08_g4buOZptE4pgBf1UWS5YFPFfZuVV1KiHL_x-UVuyiPEJ_zYMMeYCGfGWIbPvGYwW2","token_type":"Bearer","refresh_token":"1//0dtgwgv63wbY8CgYIARAAGA0SNwF-L9IrYLOnoCFmUEddMQkyh5_H6iifoWHFair4m26_VSuSyZ3LeAjSw0oRyNG8PJfwS_ysVUk","expiry":"2021-05-06T15:06:14.400217312Z"}
EOF

cat >/etc/systemd/system/rclone.service<<EOF
[Unit]
Description = rclone-iokle
     
[Service]
User = root
ExecStart = /usr/bin/rclone mount gd-iokle: /app/gd  --vfs-cache-max-age 2h  --file-perms 0777 --copy-links --no-gzip-encoding --no-check-certificate --allow-other --allow-non-empty --umask 000 
Restart = on-abort
     
[Install]
WantedBy = multi-user.target

EOF


systemctl enable rclone
systemctl start rclone

##########################################
###########     2、附加500ssd      #######
##########################################

#附加去后台附加，默认是开机器的时候就加上去了
#Create new empty partitions:
#parted -s /dev/vdb mklabel gpt
#parted -s /dev/vdb unit mib mkpart primary 0% 100%
#Create new empty filesystem
#mkfs.ext4 /dev/vdb1
#默认不关机，随意挂载
#mount /dev/vdb1   /app/storage





##########################################
###########     3、p图软件设置     #######
##########################################
mkdir   -p /app/hpool/
cd /app/hpool/
wget https://github.com/hpool-dev/chia-plotter/releases/download/v0.11/chia-plotter-v0.11-x86_64-linux-gnu.zip
unzip chia-plotter-v0.11-x86_64-linux-gnu.zip
rm  -rf  __MACOSX




touch /app/hpool/chia-plotter/p1.log
touch  /app/hpool/chia-plotter/p2.log
#chmod +x /app/hpool/chia-plotter/p1.sh
#chmod +x /app/hpool/chia-plotter/p2.sh








