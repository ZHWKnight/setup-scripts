#!/data/data/com.termux/files/usr/bin/sh

# This script will setup desktop environment on termux native terminal.
#
# Github: https://github.com/zhwknight/setup-scripts

# ========= This script is not finished yet! =========

# Update and upgrade termux
pkg update && pkg upgrade

# Install necessary packages
pkg install -y x11-repo
pkg install -y pulseaudio

echo -e "Which display method do you want to use?\n1: termux-x11\n2: VNC"
read -p "Enter the number you choice: " display
echo -e "Which graphical environment do you want to use?\n1: XFCE\n2: LXQT\n3: MATE"
read -p "Enter the number you choice: " env

case $env in
  1) # XFCE
    echo "Installing XFCE..."
    pkg install -y xfce4
    X11_ALIAS_CMD="alias desktop_start=\'termux-x11 :0 -xstartup \"dbus-launch --exit-with-session xfce4-session\"\'"
    # official
    VNC_STARTUP_CMD=$(cat <<EOF
#!/data/data/com.termux/files/usr/bin/sh
xfce4-session &
EOF
)
    cat > ~/.vnc/xstartup <<
    # unofficial
    # VNC_STARTUP_CMD=$(cat <<EOF
# #!/data/data/com.termux/files/usr/bin/sh
# unset SESSION_MANAGER
# unset DBUS_SESSION_BUS_ADRESS
# export PULSE_SERVER=127.0.0.1 && pulseaudio --start --disable-shm=1 --exit-idle-time=-1
# startxfce4 &
# EOF
# )
    ;;
  2) # LXQT
    echo "Installing LXQT..."
    pkg install -y lxqt
    X11_ALIAS_CMD="alias desktop_start=\'termux-x11 :0 -xstartup \"dbus-launch --exit-with-session startlxqt\"\'"
    VNC_STARTUP_CMD=$(cat <<EOF
#!/data/data/com.termux/files/usr/bin/sh
startlxqt &
EOF
)
    ;;
  3) # MATE
    echo "Installing MATE..."
    pkg install -y mate-* marco
    X11_ALIAS_CMD="alias desktop_start=\'termux-x11 :0 -xstartup \"dbus-launch --exit-with-session mate-session\"\'"
    VNC_STARTUP_CMD=$(cat <<EOF
#!/data/data/com.termux/files/usr/bin/sh
mate-session &
EOF
)
    ;;
  *)
    echo "Invalid choice!"
    exit 1
    ;;
esac

VNC_CONFIG_CMD=$(cat <<EOF
geometry=1920x1080
depth=32
localhost=no
EOF
)

case $display in
  1) # termux-x11
    echo "Setting up termux-x11..."
    echo $X11_ALIAS_CMD >> ~/.bashrc
    echo "you can download termux-x11 from https://github.com/termux/termux-x11/actions/workflows/debug_build.yml"
    ;;
  2) # VNC
    # Install VNC
    pkg install tigervnc

    echo $VNC_STARTUP_CMD > ~/.vnc/xstartup
    chmod +x ~/.vnc/xstartup

    echo $VNC_CONFIG_CMD > ~/.vnc/config

    echo '# alias desktop_start="vncserver :1 -geometry 1920x1080 -depth 32"' >> ~/.bashrc
    echo 'alias desktop_start="vncserver"' >> ~/.bashrc
    echo 'alias desktop_stop="vncserver -kill :1"' >> ~/.bashrc
    ;;
  *)
    echo "Invalid choice!"
    exit 1
    ;;
esac
. ~/.bashrc
