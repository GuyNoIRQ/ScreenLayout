#!/bin/bash

ssh john@10.0.200.6 'xrandr --display :0.0 --output eDP-1 --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output HDMI-2 --off';

sleep 3;
xrandr --newmode "2560x1440_33.00"  162.77  2560 2688 2960 3360  1440 1441 1444 1468  -HSync +Vsync;
xrandr --addmode VGA-1 2560x1440_33.00;
xrandr --output VGA-1 --primary --mode 2560x1440_33.00 --pos 1440x0 --rotate normal --output HDMI-2 --off --output HDMI-1 --off --output DP-1 --mode 2560x1440 --pos 1440x1440 --rotate normal --output DP-2 --mode 2560x1440 --pos 0x1005 --rotate right;

sleep 1;

#Left Bottom 
for Window in $(wmctrl -lG | egrep -i "john@FrankenDell:" | awk '{print $1}'); do
	wmctrl -ir $Window -b remove,maximized_horz;
	wmctrl -ir $Window -b remove,maximized_vert;
	wmctrl -ir $Window -e 0,0,2285,1430,1246;
	wmctrl -ir $Window -b add,maximized_horz;
done;

#Left Top
for Window in $(wmctrl -lG | egrep -i " Discord| Mozilla Thunderbird| Signal" | awk '{print $1}'); do
	wmctrl -ir $Window -b remove,maximized_horz;
	wmctrl -ir $Window -b remove,maximized_vert;
	wmctrl -ir $Window -e 0,0,1000,1430,1246;
	wmctrl -ir $Window -b add,maximized_horz;
done;

#Main FS
for Window in $(wmctrl -lG | egrep -i " Mozilla Firefox" | awk '{print $1}'); do
	wmctrl -ir $Window -b remove,maximized_horz;
	wmctrl -ir $Window -b remove,maximized_vert;
	wmctrl -ir $Window -e 0,1440,1465,2550,1382;
	wmctrl -ir $Window -b add,maximized_horz;
	wmctrl -ir $Window -b add,maximized_vert;
done;

sleep 1;
xfconf-query -c xfce4-panel -p /panels/panel-1/output-name -s monitor-1;

pkill conky;
conky --daemonize --config=/home/john/SyncThing/ConfigFiles/FrankenDell/conky.conf;
conky --daemonize --config=/home/john/SyncThing/ConfigFiles/FrankenDell/conky2.conf;
	
sleep 10;
pacmd set-default-sink $(pacmd list-sinks | grep -e 'name:.*hdmi' | awk '{print $2}' | sed 's/<//g;s/>//g');

echo "play" > /home/john/.screenlayout/state;
