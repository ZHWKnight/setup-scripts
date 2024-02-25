#!/data/data/com.termux/files/usr/bin/sh

# This script will setup desktop environment on termux proot-distro.
#
# Github: https://github.com/zhwknight/setup-scripts

# ============= Run this script in proot-distro =============

groupadd storage
groupadd wheel
groupadd video

usermod -aG storage,audio,video,wheel $(whoami)

cat >> ~/.bashrc <<EOF
# alias virgl_exec=GALLIUM_DRIVER=virpipe MESA_GL_VERSION_OVERRIDE=4.0
alias virgl_exec=GALLIUM_DRIVER=zink MESA_GL_VERSION_OVERRIDE=4.0
EOF

# ============= Run this script in termux =============

cat >> ~/.bashrc <<EOF
# proot-distro desktop environment
proot_desktop_stop(){
  killall -9 termux-x11 Xwayland pulseaudio virgl_test_server virgl_test_server_android termux-wake-lock >> /dev/null 2>&1
}
proot_desktop_start(){
  if [[ -z $1 || -z $2 || -z $3 ]]; then
    echo "Usage: proot_desktop_start <distro> <username> <startx_command>"
    else
    # kill all old processes
    proot_desktop_stop
    pulseaudio_start
    termux-x11_start &
    virgl_start &
    proot-distro login $1 --user $2 --shared-tmp -- bash -c "export DISPLAY=:0 PULSE_SERVER=tcp:127.0.0.1; dbus-launch --exit-with-session $3"
  fi
}
EOF
. ~/.bashrc
