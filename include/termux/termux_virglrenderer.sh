#!/data/data/com.termux/files/usr/bin/sh

# This script will setup virglrenderer(VirGL) on termux.
#
# Github: https://github.com/zhwknight/setup-scripts

# Update and upgrade termux
pkg update && pkg upgrade

echo -e "Which version of virglrenderer do you want to install?\n1: virglrenderer-android(Android GL/ES)\n2: virglrenderer-zink(Simulate Vulkan, Only support Qualcomm SoC)"
read -p "Enter the number you choice: " choice

case $choice in
  1)
    echo "Installing virglrenderer-android..."
    pkg install -y virglrenderer-android
    VIRGL_CMD=$(cat <<EOF
# virglrenderer
alias virgl_start=virgl_test_server_android
alias virgl_exec="GALLIUM_DRIVER=virpipe MESA_GL_VERSION_OVERRIDE=4.0"
EOF
)
    ;;
  2)
    echo "Installing virglrenderer-zink..."
    pkg install -y tur-repo && pkg update
    pkg install -y mesa-zink virglrenderer-mesa-zink vulkan-loader-android
    VIRGL_CMD=$(cat <<EOF
# virglrenderer
alias virgl_start="MESA_LOADER_DRIVER_OVERRIDE=zink GALLIUM_DRIVER=zink ZINK_DESCRIPTORS=lazy virgl_test_server --use-egl-surfaceless --use-gles"
alias virgl_exec="GALLIUM_DRIVER=zink MESA_GL_VERSION_OVERRIDE=4.0"
EOF
)
    ;;
  *)
    echo "Invalid choice, exiting..."
    exit 1
    ;;
esac
echo $VIRGL_CMD >> ~/.bashrc
