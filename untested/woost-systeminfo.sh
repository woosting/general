#!/bin/bash
MHZ=$( ( lscpu | grep 'CPU max MHz' > /dev/null && ( lscpu | grep 'CPU max MHz' | head -n 1 ) || ( lscpu | grep 'CPU MHz' | head -n 1 ) ) | cut -d: -f2 | cut -d. -f1)

CPU="$(lscpu | grep '^Vendor ID\|^Model name' | head -n 2 | cut -d: -f2 | sed 's/@.*//g;s/^ //g;s/(TM)//gI;s/(R)//gI;s/[0-9]*MHz//g' | sed ':a;N;ba;s/\n/ /g' | \
sed 's/CentaurHauls//g;s/GenuineIntel/Intel/g;s/Intel Atom/Atom/g;s/Intel Celeron/Celeron/g;s/with Radeon HD Graphics//g;s/AuthenticAMD//g;s/Dual Core //g;s/Processor/CPU/g')"

DST="$(cat /etc/os-release | grep PRETTY_NAME | cut -d\" -f2)"

if type Xorg &> /dev/null; then
  DTE="Xorg (Unkown or No DE)"
  type openbox-session &> /dev/null && DTE="Openbox" # has to be first as it can be used stand-alone or with other DEs
  type cinnamon-session &> /dev/null && DTE="Cinnamon"
  type gnome-session &> /dev/null && DTE="GNOME 3"
  type plasma-desktop &> /dev/null && DTE="KDE Plasma 4"
  type plasmashell &> /dev/null && DTE="KDE Plasma 5"
  type startlxde &> /dev/null && DTE="LXDE"
  type startlxqt &> /dev/null && DTE="LXQt"
  type mate-session &> /dev/null && DTE="MATE"
  type startxfce4 &> /dev/null && DTE="XFCE"
else
  DTE="CLI"
fi

echo ${CPU} ${MHZ}MHz running ${DST} ${DTE}
