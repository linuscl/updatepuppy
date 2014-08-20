#!/usr/bin/bash
# Maintainer: Linus Claußnitzer
# Structure:
# 1. Ask for a database update.
# 2. ( update all database )
# 3. read files: /root/.packages/user-installed-packages /root/.packages/woof-installed-packages
# 4. read database files: /root/.packages/Packages-*
# 5. compare the versions
# 6. show the packages with different versions
# 7. try to download them from the repos in this files:
# /root/.packages/DISTRO_COMPAT_REPOS
# /root/.packages/DISTRO_PET_REPOS
# 8. Install the downloaded packages with petget
########################################################

Xdialog --title "Welcome to the Puppy Update Manager!" --msgbox "Welcome to the Puppy Update Manager! Click 'OK' to continue." 0 0
Xdialog --title "Update databases?" --yesno "Click 'Yes' to update the databases" 0 0

case $? in
    0)
      cd /root/.packages/
      wget -q --tries=10 --timeout=20 http://google.com
      if [[ $? -eq 0 ]]; then
      
          urxvt -geometry "100x20" -bg yellow -fg red -e wget http://distro.ibiblio.org/puppylinux/Packages-puppy-2-official
          urxvt -geometry "100x20" -bg yellow -fg red -e wget http://distro.ibiblio.org/puppylinux/Packages-puppy-3-official 
          urxvt -geometry "100x20" -bg yellow -fg red -e wget http://distro.ibiblio.org/puppylinux/Packages-puppy-4-official 
          urxvt -geometry "100x20" -bg yellow -fg red -e wget http://distro.ibiblio.org/puppylinux/Packages-puppy-5-official
          urxvt -geometry "100x20" -bg yellow -fg red -e wget http://distro.ibiblio.org/puppylinux/Packages-puppy-slacko14-official
          Xdialog --title "The databases are updated!" --msgbox "All databases are updated!" 0 0
      else
          Xdialog --title "Error" --msgbox "Check the internetconnection. Then restart the program." 0 0
          exit
      fi
      ;;
    1) 
      Xdialog --title "Not updated" --msgbox "The databases wasn't updated." 0 0;;
esac
echo "--Installed packages: --" > /tmp/packages-install
cut -d\| -f2 /root/.packages/user-installed-packages | grep -v '^$' >> /tmp/packages-install
cut -d\| -f2 /root/.packages/woof-installed-packages | grep -v '^$' >> /tmp/packages-install
cut -d\| -f2 /root/.packages/layers-installed-packages | grep -v '^$' >> /tmp/packages-install
Xdialog --title "Installed packages" --textbox /tmp/packages-install 0 0
