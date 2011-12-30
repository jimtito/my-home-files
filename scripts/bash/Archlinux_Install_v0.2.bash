#!/bin/bash
#-------------------------------------------------------------------------------
#Copyright by Andreas Freitag, aka nexxx mailto: freitandi[at]gmail[dot]com
#-------------------------------------------------------------------------------
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.
#-------------------------------------------------------------------------------
# Run this script after your first boot with archlinux (as root)

INSTALL_YAOURT=0
CREATE_NEW_USER=0
ADD_MULTILIBS=0
INSTALL_SUDO=0
ADD_USER_TO_WHEEL=0
ADD_SUDO_RIGHTS=0
INSTALL_ALSA_UTILS=0
INSTALL_X_SERVER=0
INSTALL_GPU_DRIVER=0
ADD_X_KBLAYOUT=0
INSTALL_DBUS=0
INSTALL_DESKTOPENV=0
INSTALL_ACPI=0
INSTALL_TLP=0
INSTALL_CPUFREQUTILS=0
ADD_TMP_RAMDISK=0
DISABLE_TERMINAL_3_6=0
INSTALL_SHELL=0


function question_for_answer(){
echo $1
echo "y) yes"
echo "n) no"
echo -n "Selection > "
read ANSWERE
echo ""
echo ""
}


function print_line(){
echo "--------------------------------------------------------------------------------"
}


function finish_function(){
print_line
echo "Continue with RETURN"
read
clear
}

function install_yourt(){
question_for_answer "Install yaourt - AUR Backend (required for some Packages)?"
case "$ANSWERE" in
"y")
  if [ ! -e /root/pacman.conf ];
  then
    cp /etc/pacman.conf /root/pacman.conf
  fi
  echo "
[archlinuxfr]
Server = http://repo.archlinux.fr/\$arch" >> /etc/pacman.conf
  pacman -Sy
  pacman -S yaourt
  install_status
  ;;
*)
  CURRENT_STATUS=0
  ;;
esac
INSTALL_YAOURT=$CURRENT_STATUS
sumary "yaourt installation"
finish_function
}


function check_for_yaourt() {
echo "Checking if yaourt is installed"
echo ""
if [ $INSTALL_YAOURT -eq 1 ];
then
  echo "OK, continue with RETURN"
  read
else
  echo "Yaourt not found"
  echo ""
  install_yourt
fi
}


function check_for_root(){
CURRENTUSER="$(whoami)"
if [ $CURRENTUSER != "root" ];
then
  echo "Current user is NOT 'root'. EXIT now"
  finish_function
  exit 1
else
  echo "Current user is 'root'."
  finish_function
fi
}


function check_for_inet(){
if $(ping -c1 google.com &>/dev/null); 
then
  echo "Internet connection working!"
  finish_function
else
  echo "No internet connection found. EXIT now"
  finish_function
  exit 1
fi
}


function system_upgrade(){
echo "Doing a full system upgrade"
pacman -Syu
finish_function
}


function create_new_user(){
question_for_answer "Create a new user?"
case "$ANSWERE" in
"y")
  echo "Recommended groups are:"
  echo "audio,video,optical"
  echo ""
  echo "Additional (usefull) groups are: "
  echo "lp      (Access to printer hardware; enables user to manage print jobs)"
  echo "storage (enables user to mount storage devices through HAL and D-Bus)"
  echo "wheel   (Right to use sudo (setup with visudo), also affected by PAM)"
  echo "games   (Access to some game software)"
  echo "power   (Right to use Pm-utils and power management controls)"
  echo "scanner (Access to scanner hardware)"
  print_line
  adduser
  install_status
  ;;
*)
  CURRENT_STATUS=0
  ;;
esac
CREATE_NEW_USER=$CURRENT_STATUS
sumary "User creation"
finish_function
}


function add_multilibs(){
ADD_MULTILIBS=0
ARCHI=`uname -m`
if [ "$ARCHI" = "x86_64" ]; 
then
question_for_answer "Add multilibs to pacman repositories (32 Bit App support)?"
case "$ANSWERE" in
"y")
  if [ ! -e /root/pacman.conf ];
  then
    cp /etc/pacman.conf /root/pacman.conf
  fi
  echo "
[multilib]
Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
  install_status
  ;;
*)
  CURRENT_STATUS=0
  ;;
esac
ADD_MULTILIBS=$CURRENT_STATUS
sumary "Adding multilibs for 32Bit support"
finish_function
fi
}


function install_sudo(){
question_for_answer "Install sudo?"
case "$ANSWERE" in
"y")
  pacman -S sudo
  install_status
  ;;
*)
  CURRENT_STATUS=0
  ;;
esac
INSTALL_SUDO=$CURRENT_STATUS
sumary "sudo installation"
finish_function
}


function prepare_sudoers(){
  rm /etc/sudoers
  if [ $? -ne 0 ] ; then
    return -1
  fi 
  mv /etc/sudoers.tmp /etc/sudoers
  if [ $? -ne 0 ] ; then
    return -1
  fi   
  chmod 0440 /etc/sudoers
  if [ $? -ne 0 ] ; then
    return -1
  fi 
  chown 0 /etc/sudoers
  if [ $? -ne 0 ] ; then
    return -1
  fi
  return 0
}


function add_user_to_wheel(){
question_for_answer "Add a new user to %wheel?"
case "$ANSWERE" in
"y")
  echo "Username, which will be added to %wheel?"
  echo -n "user > "
  read NAME
  usermod -G wheel $NAME
  install_status
  ;;
*)
  CURRENT_STATUS=0
  ;;
esac
ADD_USER_TO_WHEEL=$CURRENT_STATUS
sumary "Adding $NAME to %wheel"
print_line
}


function add_sudo_rights(){
if [ $INSTALL_SUDO -eq 1 ]; #INSTALL_SUDO is set during sudo install
then
echo "Please select sudo rights for users of wheel group:"
echo "1) Members of wheel group can execute sudo commands"
echo "2) Members of wheel group can execute sudo commands without password"
echo "n) No user will get sudo command rights"
echo -n "Selection > "
read ANSWERE
echo ""
echo ""
case "$ANSWERE" in
1)
  add_user_to_wheel
  if [ ! -e /root/sudoers ];
  then
    cp /etc/sudoers /root/sudoers
  fi
  cat /etc/sudoers | sed -e "s/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/" > /etc/sudoers.tmp
  prepare_sudoers
  install_status
  ;;     
2)
  add_user_to_wheel
  if [ ! -e /root/sudoers ];
  then
    cp /etc/sudoers /root/sudoers
  fi
  cat /etc/sudoers | sed -e "s/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/" > /etc/sudoers.tmp
  prepare_sudoers
  install_status
  ;;
*)
  CURRENT_STATUS=0
  ;;
esac
ADD_SUDO_RIGHTS=$CURRENT_STATUS
sumary "Granting sudo rights to %wheel"
finish_function
fi
}


function install_alsa_utils(){
question_for_answer "Install alsa-utils?"
case "$ANSWERE" in
"y")
  pacman -S alsa-utils
  install_status
  ;;
*)
  CURRENT_STATUS=0
  ;;
esac
INSTALL_ALSA_UTILS=$CURRENT_STATUS
sumary "Alsa Utils installation"
finish_function
}


function install_x_server(){
question_for_answer "Install X-Server (req. for Desktopenvironment, GPU Drivers, Keyboardlayout,...)?"
case "$ANSWERE" in
"y")
  pacman -S xorg-server xorg-xinit xorg-utils xorg-server-utils mesa xorg-twm xorg-xclock xterm
  install_status
  ;;
*)
  CURRENT_STATUS=0
  ;;
esac
INSTALL_X_SERVER=$CURRENT_STATUS
sumary "X Server installation"
finish_function
}


install_gpu_drivers(){
if [ $INSTALL_X_SERVER -eq 1 ];
then
echo "Installing Graphic Card driver"
echo "Please which GPU you use:"
echo "1) nVidia GPU"
echo "2) Intel"
echo "3) nVidia Optimus (nVidia+Intel)"
echo "4) ATI"
echo "5) VirtualBox Guest Additions (incl. video driver)"
echo "n) I will install the GPU myself"
echo -n "Selection > "
read ANSWERE
echo ""
echo ""
case "$ANSWERE" in
  1)
    pacman -S nvidia nvidia-utils
    install_status
    sumary "nVidia GPU driver installation"
    ;;
  2)
    pacman -S xf86-video-intel
    install_status
    sumary "Intel GPU driver installation"
    ;;  
  3)
    check_for_yaourt
    yaourt -S bumblebee nvidia-utils-bumblebee lib32-nvidia-utils-bumblebee
    install_status
    echo "blacklist nouveau" >> /etc/modprobe.d/modprobe.conf
    print_line
    echo "Please add nvidia to your modules array in /etc/rc.conf"
    echo "and add bumblebee at the end of your daemons array in /etc/rc.conf"
    echo "e.g.: MODULES=(... nvidia ...)"
    echo "&"
    echo "DAEMONS=(... @bumblebee)"
    echo "Modification must be done in another terminal - CTRL+ALT+F[2-6]"
    sumary "nVidia Optimus (bumblebee) installation"
    ;;  
  4)
    if [ ! -e /root/pacman.conf ];
    then
      cp /etc/pacman.conf /root/pacman.conf
    fi
    echo "
[catalyst]
Server = http://catalyst.apocalypsus.net/repo/catalyst/\$arch" >> /etc/pacman.conf
    pacman -Sy
    pacman -S catalyst catalyst-utils
    install_status
    aticonfig --initial
    sumary "ATI GPU driver installation"
    ;;    
  5)
    pacman -S virtualbox-archlinux-additions
    install_status
    modprobe -a vboxguest vboxsf vboxvideo
    print_line
    echo "Please add vboxguest vboxsf vboxvideo at the end of your daemons array in /etc/rc.conf"
    echo "e.g.: DAEMONS=(... vboxguest vboxsf vboxvideo)"
    echo "Modification must be done in another terminal - CTRL+ALT+F[2-6]"
    sumary "Virtualbox guest additions (incl. video drivers) installation"
    ;;
  *)
    CURRENT_STATUS=0
    sumary "GPU drivers installation"
    ;; 
esac
INSTALL_GPU_DRIVER=$CURRENT_STATUS
finish_function
fi
}


function add_x_kblayout(){
if [ $INSTALL_X_SERVER -eq 1 ];
then
echo "Change Keyboardlayout in X11 Applications (requires X-Server installed)?"
echo "1) German - Latin No dead keys"
echo "n) no"
echo -n "Selection > "
read ANSWERE
echo ""
echo ""
case "$ANSWERE" in
1)
  if [ ! -e /root/10-evdev.conf ];
  then
    cp /etc/X11/xorg.conf.d/10-evdev.conf /root/10-evdev.conf
  fi
  echo "#
# Catch-all evdev loader for udev-based systems
# We don't simply match on any device since that also adds accelerometers
# and other devices that we don't really want to use. The list below
# matches everything but joysticks.

Section \"InputClass\"
        Identifier \"evdev pointer catchall\"
        MatchIsPointer \"on\"
        MatchDevicePath \"/dev/input/event*\"
        Driver \"evdev\"
EndSection

Section \"InputClass\"
        Identifier \"evdev keyboard catchall\"
        MatchIsKeyboard \"on\"
        MatchDevicePath \"/dev/input/event*\"
        Driver \"evdev\"
        Option \"XkbLayout\" \"de\"
        Option \"XkbVariant\" \"nodeadkeys\"
EndSection

Section \"InputClass\"
        Identifier \"evdev touchpad catchall\"
        MatchIsTouchpad \"on\"
        MatchDevicePath \"/dev/input/event*\"
        Driver \"evdev\"
EndSection

Section \"InputClass\"
        Identifier \"evdev tablet catchall\"
        MatchIsTablet \"on\"
        MatchDevicePath \"/dev/input/event*\"
        Driver \"evdev\"
EndSection

Section \"InputClass\"
        Identifier \"evdev touchscreen catchall\"
        MatchIsTouchscreen \"on\"
        MatchDevicePath \"/dev/input/event*\"
        Driver \"evdev\"
EndSection" > /etc/X11/xorg.conf.d/10-evdev.conf
  install_status
  ;;
*)
  CURRENT_STATUS=0
  ;;
esac
ADD_X_KBLAYOUT=$CURRENT_STATUS
sumary "X Keyboardlayout modifications"
finish_function
fi
}


function install_dbus(){
if [ $INSTALL_X_SERVER -eq 1 ];
then
echo "Install dbus (required for all X11 Applications)?"
echo "y) yes"
echo "n) no"
echo -n "Selection > "
read ANSWERE
echo ""
echo ""
case "$ANSWERE" in
"y")
  pacman -S dbus
  install_status
  rc.d start dbus
  print_line
  echo "Please add dbus to your daemons array in /etc/rc.conf"
  echo "e.g.: DAEMONS=(... dbus ...)"
  echo "Modification must be done in another terminal - CTRL+ALT+F[2-6]"
  ;;
*)
  CURRENT_STATUS=0
  ;;
esac
INSTALL_DBUS=$CURRENT_STATUS
sumary "Dbus installation"
finish_function
fi
}


function prepare_de_startup(){
if [ ! -e /root/inittab ];
then
  cp /etc/inittab /root/inittab
fi
cat /etc/inittab | sed -e "s/id:3:initdefault:/#id:3:initdefault:/" > /etc/inittab.tmp
if [ $? -ne 0 ] ; then
  return -1
fi 
cat /etc/inittab.tmp | sed -e "s/#id:5:initdefault:/id:5:initdefault:/" > /etc/inittab
if [ $? -ne 0 ] ; then
  return -1
fi
cat /etc/inittab | sed -e "s/#x:5:respawn:\/usr\/bin\/$1 -nodaemon/x:5:respawn:\/usr\/bin\/$1 -nodaemon/" > /etc/inittab.tmp
if [ $? -ne 0 ] ; then
  return -1
fi
cat /etc/inittab.tmp | sed -e "s/x:5:respawn:\/usr\/bin\/xdm -nodaemon/#x:5:respawn:\/usr\/bin\/xdm -nodaemon/" > /etc/inittab
if [ $? -ne 0 ] ; then
  return -1
fi
rm /etc/inittab.tmp
if [ $? -ne 0 ] ; then
  return -1
fi
return 0
}

function install_desktopenv(){
if [ $INSTALL_X_SERVER -eq 1 ];
then
if [ $INSTALL_DBUS -eq 1 ];
then
echo "Please select your wanted Desktop Environment"
echo "1) KDE (usefull minimal installation)"
echo "2) Gnome (full)"
echo "n) I will install the DEv myself"
echo -n "Selection > "
read ANSWERE
echo ""
echo ""
case "$ANSWERE" in
  1)
    
    echo "Which language do you want to use?"
    echo "Check available localizations in another terminal (CTRL+ALT+F[2-6]) with"
    echo "pacman -Ss kde-l10n" 
    echo "'de' for german, 'ja' for japanese, 'hu' for hungarian, 'es' for spanish"
    echo -n "Localization > "
    read LOCALE
    LOCALIZATION="kde-l10n-$LOCALE"
    pacman -S kdeadmin kde-agent kdeartwork kdebase kdebindings kdegraphics kdemultimedia kdeutils kde-wallpapers $LOCALIZATION oxygen-gtk lxappearance ttf-dejavu ttf-liberation #TODO: switch for more languages
    install_status
    prepare_de_startup "kdm"
    sumary "KDE $LOCALE installation"
    ;;     
  2)
    pacman -S gnome gnome-extra gnome-tweak-tool gnome-power-manager
    install_status
    prepare_de_startup "gdm"
    sumary "Gnome installation"
    ;;  
  *)
    CURRENT_STATUS=0
    sumary "DEv installation"
    ;; 
esac
INSTALL_DESKTOPENV=$CURRENT_STATUS
finish_function
fi
fi
}


function install_acpi(){
question_for_answer "Install acpi?"
case "$ANSWERE" in
"y")
  pacman -S acpi acpid
  install_status
  /etc/rc.d/acpid start
  print_line
  echo "Please add acpid to your daemons array in /etc/rc.conf"
  echo "e.g.: DAEMONS=(... acpid ...)"
  echo "Modification must be done in another terminal - CTRL+ALT+F[2-6]"
  ;;
*)
  CURRENT_STATUS=0
  ;;
esac
INSTALL_ACPI=$CURRENT_STATUS
sumary "Acpi installation"
finish_function
}


function install_tlp(){
question_for_answer "Install tlp (great battery improvement on laptops)?"
case "$ANSWERE" in
"y")
  check_for_yaourt
  yaourt -S tlp
  install_status
  rc.d start tlp
  print_line
  echo "Please add tlp to your daemons array in /etc/rc.conf"
  echo "e.g.: DAEMONS=(... tlp ...)"
  echo "Modification must be done in another terminal - CTRL+ALT+F[2-6]"
  ;;
*)
  CURRENT_STATUS=0
  ;;
esac
INSTALL_TLP=$CURRENT_STATUS
sumary "TLP installation"
finish_function
}


function install_cpufrequtils(){
question_for_answer "Install cpufrequtils?"
case "$ANSWERE" in
"y")
  pacman -S cpufrequtils
  install_status
  cp /etc/conf.d/cpufreq /root/cpufreq
  cat /etc/conf.d/cpufreq | sed -e "s/#governor=\"ondemand\"/governor=\"ondemand\"/" > /etc/conf.d/cpufreq.tmp
  rm /etc/conf.d/cpufreq
  mv /etc/conf.d/cpufreq.tmp /etc/conf.d/cpufreq
  modprobe acpi-cpufreq
  modprobe cpufreq_ondemand
  print_line
  echo "Please add acpi-cpufreq & cpufreq_ondemand to your modules array in /etc/rc.conf"
  echo "e.g.: MODULES=(... acpi-cpufreq cpufreq_ondemand ...)"
  echo "and"
  echo "Please add cpufreq to your daemons array in /etc/rc.conf"
  echo "e.g.: DAEMONS=(... cpufreq ...)"
  echo "Modifications must be done in another terminal - CTRL+ALT+F[2-6]"
  echo ""
  echo "If there is an Errormessage while booting, load the proper module for you CPU"
  ;;
*)
  CURRENT_STATUS=0
  ;;
esac
INSTALL_CPUFREQUTILS=$CURRENT_STATUS
sumary "Cpufrequtils (ondemand) installation"
finish_function
}


function add_tmp_ramdisk(){
question_for_answer "Use a RAM-Disk for /tmp?"
case "$ANSWERE" in
"y")
  if [ ! -e /root/fstab ];
  then
  cp /etc/fstab /root/fstab
  fi
  echo "#/tmp to RAM
tmpfs /tmp tmpfs defaults,noatime,nodev,nosuid,mode=1777 0 0" >> /etc/fstab
  install_status
  ;;     
*)
  CURRENT_STATUS=0
  ;;
esac
ADD_TMP_RAMDISK=$CURRENT_STATUS
sumary "Adding /tmp to RAM Disk"
finish_function
}


function disable_terminal_sed() {
if [ ! -e /root/inittab ];
  then
    cp /etc/inittab /root/inittab
  fi
  cat /etc/inittab | sed -e "s/c3:2345:respawn:\/sbin\/agetty -8 -s 38400 tty3 linux/#c3:2345:respawn:\/sbin\/agetty -8 -s 38400 tty3 linux/" > /etc/inittab.tmp
  if [ $? -ne 0 ] ; then
    return -1
  fi
  cat /etc/inittab.tmp | sed -e "s/c4:2345:respawn:\/sbin\/agetty -8 -s 38400 tty4 linux/#c4:2345:respawn:\/sbin\/agetty -8 -s 38400 tty4 linux/" > /etc/inittab
  if [ $? -ne 0 ] ; then
    return -1
  fi
  cat /etc/inittab | sed -e "s/c5:2345:respawn:\/sbin\/agetty -8 -s 38400 tty5 linux/#c5:2345:respawn:\/sbin\/agetty -8 -s 38400 tty5 linux/" > /etc/inittab.tmp 
  if [ $? -ne 0 ] ; then
    return -1
  fi  
  cat /etc/inittab.tmp | sed -e "s/c6:2345:respawn:\/sbin\/agetty -8 -s 38400 tty6 linux/#c6:2345:respawn:\/sbin\/agetty -8 -s 38400 tty6 linux/" > /etc/inittab
  if [ $? -ne 0 ] ; then
    return -1
  fi  
  rm /etc/inittab.tmp
  if [ $? -ne 0 ] ; then
    return -1
  fi
  return 0
}


function disable_terminal_3_6()
{
question_for_answer "Disable Terminal 3-6?"
case "$ANSWERE" in
"y")
  disable_terminal_sed
  install_status
  ;;
*)
  CURRENT_STATUS=0
  ;;
esac
DISABLE_TERMINAL_3_6=$CURRENT_STATUS
sumary "Disabling terminal 3-6"
finish_function
}


function install_software(){
if [ $INSTALL_X_SERVER -eq 1 ];
then
LOOP=1
while [ "$LOOP" -ne 0 ]
do
echo "Which software do you want to install?"
echo "1)  Unrar"
echo "2)  Codecs"
echo "3)  Flashplugin"
echo "4)  Jre"
echo "5)  Jdk"
echo "6)  Eclipse"
echo "7)  Eclipse-subclipse"
echo "8)  Android SDK+ Eclipse-Android"
echo "9)  Unison"
echo "10) Kdesdk-kate"
echo "11) JDownloader"
echo "12) Libreoffic"
echo "13) All of the above and QUIT afterwards"
echo "14) Dropbox"
echo "0)  QUIT"
echo -n "Selection > "
read ANSWERE
echo ""
echo ""
case "$ANSWERE" in
1)
  pacman -S unrar
  ;;
2)
  check_for_yaourt
  yaourt -S codecs
  ;;
3)
  pacman -S flashplugin
  ;;
4)
  check_for_yaourt
  yaourt -S jre
  echo "Link oracle java to correct directory:"
  echo "ln -s /opt/java/bin/java /usr/bin"
  ;;
5)
  check_for_yaourt
  yaourt -S jdk
  echo "Link oracle java to correct directory:"
  echo "ln -s /opt/java/bin/java /usr/bin"  
  ;;
6)
  pacman -S eclipse
  ;;
7)
  pacman -S eclipse-subclipse
  ;;
8)
  check_for_yaourt
  yaourt -S eclipse-android android-apktool android-sdk android-sdk-platform-tools android-udev
  echo "In order to use adb, you have to be in the 'adbusers' group"
  echo "gpasswd -a USERNAME adbusers"
  ;;
9)
  pacman -S unison
  ;;
10)
  pacman -S kdesdk-kate
  ;;
11)
  check_for_yaourt
  yaourt -S jdownloader
  ;;
12)
  pacman -S libreoffice 
  ;;
13)
  check_for_yaourt
  yaourt -S unrar codecs flashplugin jdk eclipse eclipse-subclipse eclipse-android android-apktool android-sdk android-sdk-platform-tools android-udev unison kdesdk-kate jdownloader
  echo "Link oracle java to correct directory:"
  echo "ln -s /opt/java/bin/java /usr/bin"  
  echo ""
  echo "In order to use adb, you have to be in the 'adbusers' group"
  echo "gpasswd -a USERNAME adbusers"
  LOOP=0
  ;;
14)
  check_for_yaourt
  yaourt -S dropbox
  ;;
*)
  LOOP=0
  ;;
esac
finish_function
done
fi
}


function set_shell_user(){
LOOP=1
while [ "$LOOP" -ne 0 ]
do
echo -n "Which user will use $1 (stop adding users with RETURN)? > "
read NAME
if [ "$NAME" = "" ];
then
  break
fi
chsh -s $(which $1) $NAME
install_status
sumary "Changing shell to $1 for $NAME"
done
}


function install_shell(){
echo "Install another shell?"
echo "1) grml-zsh"
echo "2) zsh"
echo "n) No, I like Bash"
echo -n "Selection > "
read ANSWERE
echo ""
echo ""
case "$ANSWERE" in
1)
  pacman -S zsh grml-zsh-config
  install_status
  set_shell_user "zsh"
  ;;
2) 
  pacman -S zsh
  install_status
  set_shell_user "zsh"
  ;;
*)
  CURRENT_STATUS=0
  ;;
esac
INSTALL_SHELL=$CURRENT_STATUS
sumary "Shell installation"
finish_function
}


function print_tweaks(){
print_line
echo "WAFNING:"
echo "The following tweaks may cause instability on some system!"
echo "Only apply them if you know what you are doing!!!"
finish_function


echo "For faster and 'cleaner' boot"
echo "edit you /boot/grub/menu.lst and add to your Kernel line: "
echo "console=tty9 logo.nologo quiet"
echo "e.g.: "
echo "kernel /vmlinuz-linux root=/dev/disk/by-uuid/* ro console=tty9 logo.nologo quiet"
echo "Modification must be done in another terminal - CTRL+ALT+F[2-6]"
finish_function


echo "Edit you /etc/fstab and add to drives (excluding swap): "
echo "noatime"
echo "e.g.: UUID=22b46cdc-dc05-4401-b8fd-3c737c34dfd3 / ext4 defaults,noatime 0 1"
echo ""
echo "If you are using a SSD, also add (only on ext4 drives):"
echo "discard"
echo "e.g.:"
echo "UUID=22b46cdc-dc05-4401-b8fd-3c737c34dfd3 / ext4 discard,defaults,noatime 0 1"
echo "Modification must be done in another terminal - CTRL+ALT+F[2-6]"
finish_function


echo "To speedup boot process, backgroud (@) some of your daemons in /etc/rc.conf"
echo "e.g.:"
echo "DAEMONS=(syslog-ng @acpid @alsa @dbus @dkms_autoinstaller !network @wicd "
echo "@sensors @netfs @gopreload @cpufreq @crond @ntpd @tlp @bumblebee)"
finish_function
}


function reboot_now(){
question_for_answer "Reboot now?"
case "$ANSWERE" in
"y")
  echo "Thanks for using the Arch install helper script by Andreas Freitag aka nexxx"
  echo "Your Computer will now restart"
  print_line
  echo "Continue with RETURN"
  read
  reboot  
  ;;
*)
  echo "Thanks for using the Arch install helper script by Andreas Freitag aka nexxx"
  exit 0
  ;;
esac
}


function install_status(){
if [ $? -ne 0 ] ; then
  CURRENT_STATUS=-1
else
  CURRENT_STATUS=1
fi  
}


function sumary(){
case $CURRENT_STATUS in
0)
  print_line
  echo "$1 not successfull (Canceled)"
  ;;
-1)
  print_line
  echo "$1 not successfull (Error)"
  ;;
1)
  print_line
  echo "$1 successfull"
  ;;
*)
  print_line
  echo "WRONG ARG GIVEN"
  ;;
esac
}


function print_script_sumary() {
echo "Sumary:"
print_line
if [ $CREATE_NEW_USER -eq 1 ];
then
  echo "User created                                                    YES"
else
  echo "User created                                                    NO"
fi
if [ $ADD_MULTILIBS -eq 1 ];
then
  echo "Added Multilibs                                                 YES"
else
  echo "Added Multilibs                                                 NO"
fi
if [ $INSTALL_YAOURT -eq 1 ];
then
  echo "Yaourt installed                                                YES"
else
  echo "Yaourt installed                                                NO"
fi
if [ $INSTALL_SUDO -eq 1 ];
then
  echo "Sudo installed                                                  YES"
else
  echo "Sudo installed                                                  NO"
fi
if [ $ADD_SUDO_RIGHTS -eq 1 ];
then
  echo "%wheel granted sudo rights                                      YES"
else
  echo "%wheel granted sudo rights                                      NO"
fi
if [ $INSTALL_ALSA_UTILS -eq 1 ];
then
  echo "Alsa-utils installed                                            YES"
else
  echo "Alsa-utils installed                                            NO"
fi
if [ $INSTALL_X_SERVER -eq 1 ];
then
  echo "X Server installed                                              YES"
else
  echo "X Server installed                                              NO"
fi
if [ $INSTALL_GPU_DRIVER -eq 1 ];
then
  echo "GPU Driver installed                                            YES"
else
  echo "GPU Driver installed                                            NO"
fi
if [ $ADD_X_KBLAYOUT -eq 1 ];
then
  echo "X Keyboardlayout changed                                        YES"
else
  echo "X Keyboardlayout changed                                        NO"
fi
if [ $INSTALL_DBUS -eq 1 ];
then
  echo "Dbus installed                                                  YES"
else
  echo "Dbus installed                                                  NO"
fi
if [ $INSTALL_DESKTOPENV -eq 1 ];
then
  echo "Desktopenvironment installed                                    YES"
else
  echo "Desktopenvironment installed                                    NO"
fi
if [ $INSTALL_ACPI -eq 1 ];
then
  echo "Acpi installed                                                  YES"
else
  echo "Acpi installed                                                  NO"
fi
if [ $INSTALL_TLP -eq 1 ];
then
  echo "TLP installed                                                   YES"
else
  echo "TLP installed                                                   NO"
fi
if [ $INSTALL_CPUFREQUTILS -eq 1 ];
then
  echo "Cpufrequtils (ondemand) installed                               YES"
else
  echo "Cpufrequtils (ondemand) installed                               NO"
fi
if [ $ADD_TMP_RAMDISK -eq 1 ];
then
  echo "/tmp moved to RAMDISK                                           YES"
else
  echo "/tmp moved to RAMDISK                                           NO"
fi
if [ $DISABLE_TERMINAL_3_6 -eq 1 ];
then
  echo "Terminal 3-6 disabled                                           YES"
else
  echo "Terminal 3-6 disabled                                           NO"
fi
if [ $INSTALL_SHELL -eq 1 ];
then
  echo "Shell installed                                                 YES"
else
  echo "Shell installed                                                 NO"
fi
finish_function
}


#-------------------------------------------------------------------------------
# Start of MAIN
#-------------------------------------------------------------------------------
clear
echo "Welcome to the Archlinux install script by Andreas Freitag aka nexxx"
print_line
echo "Requirements:"
echo "-> Archlinux installation with base + base_devel"
echo "-> Run script as root user"
echo "-> Working internet connection"
print_line
echo "Backup of modified files will be stored at /root/*"
echo "Script can be canceled all the time with CTRL+C"
print_line
echo "This version is still in ALPHA. Send bugreports to: "
echo "freitandi at gmail dot com"
finish_function

check_for_root
check_for_inet
system_upgrade
create_new_user
add_multilibs
install_yourt
install_sudo
add_sudo_rights
install_alsa_utils
install_x_server
install_gpu_drivers
add_x_kblayout
install_dbus
install_desktopenv
install_acpi
install_tlp
install_cpufrequtils
add_tmp_ramdisk
disable_terminal_3_6
install_software
install_shell
print_tweaks
print_script_sumary
reboot_now
