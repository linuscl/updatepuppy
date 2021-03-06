#!/bin/bash
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

Xdialog --title "Update databases?" --yesno "Click 'Yes' to update the databases" 0 0
case $? in
    0)
      cd /tmp/
      wget -q --tries=10 --timeout=20 http://google.com
      if [[ $? -eq 0 ]]; then
          cd /root/.packages/
          urxvt -geometry "100x20" -bg yellow -fg red -e wget http://distro.ibiblio.org/puppylinux/Packages-puppy-2-official -O Packages-puppy-2-official
          urxvt -geometry "100x20" -bg yellow -fg red -e wget http://distro.ibiblio.org/puppylinux/Packages-puppy-3-official -O Packages-puppy-3-official
          urxvt -geometry "100x20" -bg yellow -fg red -e wget http://distro.ibiblio.org/puppylinux/Packages-puppy-4-official -O Packages-puppy-4-official
          urxvt -geometry "100x20" -bg yellow -fg red -e wget http://distro.ibiblio.org/puppylinux/Packages-puppy-5-official -O Packages-puppy-5-official
          urxvt -geometry "100x20" -bg yellow -fg red -e wget http://distro.ibiblio.org/puppylinux/Packages-puppy-slacko-official -O Packages-puppy-slacko-official
          urxvt -geometry "100x20" -bg yellow -fg red -e wget http://distro.ibiblio.org/puppylinux/Packages-puppy-slacko14-official -O Packages-puppy-slacko14-official
          urxvt -geometry "100x20" -bg yellow -fg red -e wget http://distro.ibiblio.org/puppylinux/Packages-puppy-common-official -O Packages-puppy-common-official
          urxvt -geometry "100x20" -bg yellow -fg red -e wget http://distro.ibiblio.org/puppylinux/Packages-puppy-noarch-official -O Packages-puppy-noarch-official
          Xdialog --title "The databases are updated!" --msgbox "All databases are updated!" 0 0
      else
          Xdialog --title "Error" --msgbox "Check the internetconnection. Then restart the program." 0 0
          exit
      fi
      ;;
    1) 
      Xdialog --title "Not updated" --msgbox "The databases wasn't updated." 0 0;;
esac
cut -d\| -f 2,3 /root/.packages/user-installed-packages | grep -v '^$' > /tmp/packages-install
cut -d\| -f 2,3 /root/.packages/woof-installed-packages | grep -v '^$' >> /tmp/packages-install
cut -d\| -f 2,3 /root/.packages/layers-installed-packages | grep -v '^$' >> /tmp/packages-install

cut -d\| -f 2 /root/.packages/Packages-puppy-5-official | grep -v '^$' > /tmp/packages-puppy-4
cut -d\| -f 2 /root/.packages/Packages-puppy-slacko-official | grep -v '^$' > /tmp/packages-puppy-5
cut -d\| -f 2 /root/.packages/Packages-puppy-slacko14-official | grep -v '^$' > /tmp/packages-puppy-6
cut -d\| -f 2 /root/.packages/Packages-puppy-common-official | grep -v '^$' > /tmp/packages-puppy-7
cut -d\| -f 2 /root/.packages/Packages-puppy-noarch-official | grep -v '^$' > /tmp/packages-puppy-8

packages=( )
while IFS='|' read -r name version; do
  echo "Package $name is at version $version" >&2
  packages+=( "$name" "$version" )
done </tmp/packages-install

Xdialog --menubox "Installed packages:" 20 100 1 "${packages[@]}"

search=( )
while IFS='|' read -r name version; do
  search+=( "$name" )
done </tmp/packages-install

Xdialog --no-buttons --title "Wait" --infobox "Please wait..." 0 0 2000

avaiblepackages=( )

for searching in "${search[@]}"; do

    ausgabegrep=$(grep -n -w "$searching" /tmp/packages-puppy-* | sed -n '1p')

    file=$(echo "$ausgabegrep" | cut -d ':' -f 1)

    ausgabefile=$(echo "$ausgabegrep" | cut -d ':' -f 3)

    if [ "$file" = "/tmp/packages-puppy-4" ]; then
        filedirectory="/root/.packages/Packages-puppy-5-official"
    elif [ "$file" = "/tmp/packages-puppy-5" ]; then
        filedirectory="/root/.packages/Packages-puppy-slacko-official"
    elif [ "$file" = "/tmp/packages-puppy-6" ]; then
        filedirectory="/root/.packages/Packages-puppy-slacko14-official"
    elif [ "$file" = "/tmp/packages-puppy-7" ]; then
        filedirectory="/root/.packages/Packages-puppy-common-official"
    elif [ "$file" = "/tmp/packages-puppy-8" ]; then
        filedirectory="/root/.packages/Packages-puppy-noarch-official"
    else
        echo ""
    fi
    
    if [ -n "$ausgabefile" ]; then
        avaiblepackages+=( "$ausgabefile" "$filedirectory" )
    else 
        echo ""
    fi

done


Xdialog --menubox "Avaible packages:" 20 100 1 "${avaiblepackages[@]}"
