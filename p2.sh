#!/bin/bash

for((i=0;i<100;i++))
do
	echo $i  "start" `date` >> /app/hpool/chia-plotter/p2.log
	/app/hpool/chia-plotter/chia-plotter-linux-amd64 -action plotting -plotting-fpk 0x8bdadf4c2052ca2e1c3113d9c2752e835ab0f669113c961f85bd945ea3d1184225b49cb3595f5a59918d94bfb7c4809d -plotting-ppk 0x86a0265e3c0de8d5db9a351afe5d77ed268cfbeca0a6f89a1a097d8599aaf296ee40fb264cbe5bec2e520a84865c2ded -plotting-n 1 -b 3390 -d   /app/gd-yb -t /app/storage
	echo $i  "start" `date` >> /app/hpool/chia-plotter/p2.log
done







