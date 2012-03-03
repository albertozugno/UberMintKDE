#!/bin/bash
# Copyright Alberto Zugno, November 2011
# Used on Linux Mint 12 64-bit 11.10 w/ KDE 4.7, English language; NVidia Graphic card; 
# etx4 / partition (logical) and 2xRam swap partition.

# after a fresh install: first upgrade packages and reboot, then use this script

# first:
# chmod 755 post*.sh
# or
# chmod +x post*.sh
# then:
# 

# ./post*.sh password samba-workgroup vncpass

#pass="$1"
#wgroup="$2"
#vncpass="$3"


ubuntuversion () {
  sudo mv /etc/lsb-release /etc/lsb-release-BACKUP
  sudo touch /etc/lsb-release
  sudo chmod 666 /etc/lsb-release
  sudo echo -e "DISTRIB_ID=Ubuntu
  DISTRIB_RELEASE=11.10
  DISTRIB_CODENAME=oneiric
  DISTRIB_DESCRIPTION=\"Ubuntu Oneiric\"" >> /etc/lsb-release
}

mintversion () {
  ## original /etc/lsb-release file:
  #DISTRIB_ID=LinuxMint
  #DISTRIB_RELEASE=11
  #DISTRIB_CODENAME=Lisa
  #DISTRIB_DESCRIPTION="Linux Mint 12 KDE"
  sudo mv -f /etc/lsb-release-BACKUP /etc/lsb-release
}


function wgets()
{
  wget --referer="http://www.google.com" --user-agent="Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6" \
  --header="Accept:text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5" \
  --header="Accept-Language: en-us,en;q=0.5" \
  --header="Accept-Encoding: gzip,deflate" \
  --header="Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7" \
  --header="Keep-Alive: 300" "$@"
}


##### descrizione programmi principali

#if [ -d ~/Scrivania ]; then
#  lang="IT"
#  desktop_folder="Scrivania"
#else
#  lang="EN"
#  desktop_folder="Desktop"
#fi

screenWidth=$(xdpyinfo -display $DISPLAY | grep dimensions | cut -f2 -d":" | sed 's/pixels.*$//g' | sed 's/^[ \t]*//;s/[ \t]*$//' | cut -f1 -d"x")
screenHeigth=$(xdpyinfo -display $DISPLAY | grep dimensions | cut -f2 -d":" | sed 's/pixels.*$//g' | sed 's/^[ \t]*//;s/[ \t]*$//' | cut -f2 -d"x")



# Hacking sudo timeout
echo "Defaults timestamp_timeout=999" | sudo tee -a /etc/sudoers > /dev/null


# UPEK fingerprint (not for kdm, kdesudo)
#sudo add-apt-repository -y ppa:fingerprint/fingerprint-gui
#sudo apt-get update
#sudo apt-get install -y fingerprint-gui libbsapi #policykit-1-fingerprint-gui
#sudo apt-get install -y polkit-kde-1 #ubuntu-tweak

# Nvidia GTX 460M
ubuntuversion
sudo add-apt-repository -y ppa:ubuntu-x-swat/x-updates 
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y nvidia-current nvidia-settings
sudo ldconfig
mintversion

# Realtek Semiconductor Co., Ltd. RTL8188CE 802.11b/g/n WiFi Adapter (rev 01) NATTY
#ubuntuversion
#sudo add-apt-repository -y ppa:lexical/hwe-wireless
#sudo apt-get update
#sudo apt-get install rtl8192ce-dkms
#mintversion

#########openclipart-libreoffice
###### apt-cache search package

# LibreOffice
ubuntuversion
sudo add-apt-repository -y ppa:libreoffice/ppa
sudo apt-get update
sudo apt-get install -y libreoffice libreoffice-kde libreoffice-pdfimport openclipart-libreoffice mozilla-libreoffice
mintversion

sudo unopkg add --shared packages/LibreOffice/gdocs*.oxt
#sudo unopkg add --shared packages/LibreOffice/oracle-pdfimport*.oxt # enter yes

sudo unopkg add --shared packages/LibreOffice/dict/dict-it.oxt
sudo unopkg add --shared packages/LibreOffice/dict/dict-it-IT_and_Latin_2008-10-03.oxt
echo -e "yes\n" > out
sudo unopkg add --shared packages/LibreOffice/dict/Dizionari.IT_20081129.oxt < out
rm -f out

# Filezilla
ubuntuversion
sudo add-apt-repository -y ppa:n-muench/programs-ppa
sudo apt-get update
sudo apt-get install -y filezilla filezilla-common
mintversion

# Firefox & Thunderbird # NATTY
sudo add-apt-repository -y ppa:mozillateam/firefox-stable
sudo sed -i 's/oneiric/natty/g' /etc/apt/sources.list.d/mozillateam-firefox-stable-oneiric.list
sudo add-apt-repository -y ppa:ubuntu-mozilla-security/ppa
sudo add-apt-repository -y ppa:mozillateam/thunderbird-stable
sudo sed -i 's/oneiric/natty/g' /etc/apt/sources.list.d/mozillateam-thunderbird-stable-oneiric.list
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y thunderbird firefox

# Mixxx - linux DJ
#ubuntuversion
#sudo add-apt-repository -y ppa:mixxx/mixxx
#sudo apt-get update
#sudo apt-get install -y mixxx libportaudio2
#mintversion

# Ubuntu Tweak
ubuntuversion
sudo add-apt-repository -y ppa:tualatrix/next
sudo apt-get update
sudo apt-get install -y ubuntu-tweak
mintversion


# MoioSMS
#sudo apt-get install -y python-pycurl python-wxgtk2.8 python-wxgtk2.6 ocrad gocr graphicsmagick
#sudo apt-get -f install -y
#sudo dpkg -i packages/moiosms*.deb

# # Songbird, or http://getnightingale.com/
# ubuntuversion
# sudo add-apt-repository ppa:songbird-daily/ppa
# sudo apt-get update
# sudo apt-get install songbird
# mintversion

# # Nuvola Player
# ubuntuversion
# sudo add-apt-repository -y ppa:nuvola-player-builders/stable
# sudo apt-get update
# sudo apt-get install nuvolaplayer
# mintversion

# Google Chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt-get update
sudo apt-get install -y google-chrome-stable
sudo rm /etc/apt/sources.list.d/google.list

# Opera
wget -O - http://deb.opera.com/archive.key | sudo apt-key add -
sudo sh -c 'echo "deb http://deb.opera.com/opera/ stable non-free" >> /etc/apt/sources.list.d/opera.list' 
sudo apt-get update 
sudo apt-get install -y opera

# Google SysTray
#sudo dpkg -i packages/googsystray*.deb

# DropBox
sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
echo "deb http://linux.dropbox.com/ubuntu oneiric main" | sudo tee -a /etc/apt/sources.list > /dev/null
sudo apt-get update
sudo apt-get install -y dropbox nautilus-dropbox

# SpiderOak
wget -q http://apt.spideroak.com/spideroak-apt-pubkey.asc -O- | sudo apt-key add -
echo "deb http://apt.spideroak.com/ubuntu-spideroak-hardy/ release restricted" | sudo tee -a /etc/apt/sources.list > /dev/null
sudo apt-get update
sudo apt-get install -y spideroak
sudo sed -i -e "s/deb http:\/\/apt.spideroak.com\/ubuntu-spideroak-hardy\/ release restricted//g" /etc/apt/sources.list

# VirtualBox
sudo add-apt-repository -y "deb http://download.virtualbox.org/virtualbox/debian oneiric contrib" 
wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
sudo sed -i -e "s/deb-src http:\/\/download.virtualbox.org\/virtualbox\/debian oneiric contrib//g" /etc/apt/sources.list
sudo apt-get update
sudo apt-get install -y dkms virtualbox-4.1

##################### Adobe Air
#sudo add-apt-repository -y ppa:dajhorn/adobeair
#sudo apt-get update
#sudo apt-get install adobeair

# VLC
ubuntuversion
sudo add-apt-repository -y ppa:chimerarevo/vlc
sudo apt-get update
sudo apt-get install -y vlc mozilla-plugin-vlc
mintversion

# Clementine Player # NATTY ####################
#sudo add-apt-repository -y ppa:me-davidsansome/clementine
#sudo sed -i 's/oneiric/natty/g' /etc/apt/sources.list.d/me-davidsansome-clementine-oneiric.list
#sudo apt-get update
#sudo apt-get install -y clementine

# daap client? rythmbox



############### Gloobus-preview & Covergloobus,  gloobus.net
#ubuntuversion
#sudo add-apt-repository -y ppa:gloobus-dev/gloobus-preview
#sudo apt-get update
#sudo apt-get install gloobus-preview
#sudo apt-get upgrade

#sudo add-apt-repository -y ppa:gloobus-dev/covergloobus
#sudo apt-get update
#sudo apt-get install covergloobus
#sudo apt-get upgrade
#mintversion

## M.A.R.S, two-dimensional space shooting game
#ubuntuversion
#sudo add-apt-repository -y ppa:mars-core/ppa
#sudo apt-get update
#sudo apt-get install marsshooter
#mintversion

# Wireshark
ubuntuversion
sudo add-apt-repository -y ppa:n-muench/programs-ppa
sudo apt-get update
sudo apt-get install -y wireshark
mintversion

# Wine
ubuntuversion
sudo add-apt-repository -y ppa:ubuntu-wine
sudo apt-get update
sudo apt-get install -y wine winetricks q4wine # acept eula terms 2 schermate
wget -q "http://deb.playonlinux.com/public.gpg" -O- | sudo apt-key add -
sudo wget http://deb.playonlinux.com/playonlinux_oneiric.list -O /etc/apt/sources.list.d/playonlinux.list
sudo apt-get update
sudo apt-get install -y playonlinux
sudo apt-get install -y mesa-utils
sudo rm -rvf ~/.wine # cleaning wine configuration
mintversion

# Radio Tray
ubuntuversion
sudo add-apt-repository -y ppa:ferramroberto/radiotray
sudo apt-get update
sudo apt-get install -y radiotray
mintversion

# CWP, Customizable Weather Plasmoid, https://launchpad.net/~tehnick/+archive/plasma-widget-cwp
ubuntuversion
sudo add-apt-repository -y ppa:tehnick/plasma-widget-cwp
sudo apt-get update
sudo apt-get install -y plasma-widget-cwp 
mintversion

# Kazam Screencaster #### deleted, try ppa:and471/kazam-daily-builds
#ubuntuversion
#sudo add-apt-repository -y ppa:bigwhale/kazam-oneric
#sudo apt-get update
#sudo apt-get install -y kazam
#mintversion

# Pidgin & plugins 
wget http://ch.archive.ubuntu.com/ubuntu/pool/main/libn/libnotify/libnotify1_0.5.0-2ubuntu1_amd64.deb
sudo dpkg -i libnotify*deb
rm libnotify*deb
ubuntuversion
sudo add-apt-repository -y ppa:pidgin-developers/ppa
#sudo sed -i 's/oneiric/natty/g' /etc/apt/sources.list.d/pidgin-developers-ppa-oneiric.list
sudo apt-get update
sudo apt-get install -y pidgin
sudo apt-get upgrade -y
# http://developer.pidgin.im/wiki/ThirdPartyPlugins
sudo add-apt-repository -y ppa:konradgraefe/pidgin-plugins
sudo apt-get update
sudo apt-get install -y pidgin-advanced-sound-notification
sudo apt-get install -y pidgin-themes pidgin-extprefs pidgin-awayonlock
# http://code.google.com/p/pidgin-knotifications/
wget http://pidgin-knotifications.googlecode.com/files/knotifications-0.3.6.pl
mkdir -p $HOME/.purple/plugins/
mv knotifications* $HOME/.purple/plugins/
# http://www.siorarina.net/gtalk-shared-status/
sudo add-apt-repository -y ppa:federico-zanco/ppa-gss
sudo apt-get update
sudo apt-get install -y gtalk-shared-status
#/etc/apt/sources.list.d/federico-zanco-ppa-gss-natty.list
#deb http://ppa.launchpad.net/federico-zanco/ppa-gss/ubuntu oneiric main
#deb-src http://ppa.launchpad.net/federico-zanco/ppa-gss/ubuntu oneiric main
# http://fahhem.com/pidgin/
wget http://fahhem.com/pidgin/gtalkinvisible.tar.gz
tar -xvf gtalkinvisible.tar.gz
mv gtalk*/gtalk*.so $HOME/.purple/plugins/
rm -R gtalk*
# http://www.siorarina.net/jabber-pseudo-invisibility/
sudo apt-get install -y gcc make pidgin-dev
wget http://www.siorarina.net/jpi/amd64/jabber-pseudo-invisibility-0.3.4.amd64.tar.gz
tar -xvf jabber-pseudo*.tar.gz
cd jabber-pseudo*
make
make install
cd ..
rm -R jabber-pseudo*
# http://www.webupd8.org/2010/05/script-to-set-up-everything-for-using.html , http://www.adiumxtras.com/
SCRIPTSDIR="$HOME/.purple"
sudo add-apt-repository -y ppa:webkit-team/ppa
sudo apt-get update
sudo apt-get install -y --force-yes libnotify-bin pidgin-dev libpurple-dev libwebkit-dev bzr checkinstall
bzr branch lp:~spoidar/pidgin-webkit/karmic-fixes
cd karmic-fixes/
make
sudo checkinstall --fstrans=no --install=yes --pkgname=pidgin-adium --pkgversion "0.1" --default
cd ..
sudo rm -r karmic-fixes/
mkdir -p $SCRIPTSDIR
cd $SCRIPTSDIR/
wget http://webupd8.googlecode.com/files/pidgin_adium2.sh;
chmod +x $SCRIPTSDIR/pidgin_adium2.sh;
gconftool-2 -t string -s /desktop/gnome/url-handlers/adiumxtra/command "$SCRIPTSDIR/pidgin_adium2.sh %s"
gconftool-2 -t bool -s /desktop/gnome/url-handlers/adiumxtra/enabled true
gconftool-2 -t bool -s /desktop/gnome/url-handlers/adiumxtra/needs_terminal false
sudo chown -R $USER $HOME/.purple/
# http://code.google.com/p/pidgin-guiops/
wget http://pidgin-guiops.googlecode.com/files/pidgin-guiops-0.5RC1.tar.gz
tar -xvf pidgin-guiops*.tar.gz
cd pidgin-guiops*
make
mv *.so $HOME/.purple/plugins/
cd ..
rm -R pidgin-guiops*
# http://www.siorarina.net/google-invisibility-tracker/
sudo apt-get install -y gcc make pidgin-dev
wget http://www.siorarina.net/git/amd64/google-invisibility-tracker-0.2.2.amd64.tar.gz
tar -xvf google-invisibility*.tar.gz
cd google-invisibility*
make
make install
cd ..
rm -R google-invisibility*
# http://code.google.com/p/pidgin-sendscreenshot/
wget http://pidgin-sendscreenshot.googlecode.com/files/pidgin-sendscreenshot-0.8-3-amd64.deb
sudo dpkg -i pidgin-sendscreenshot*.deb
rm pidgin-sendscreenshot*.deb
# oxygen buddy list icon theme
wget http://gnome-look.org/CONTENT/content-files/140799-oxygen.tar.gz
tar -xvf *-oxygen.tar.gz
mkdir ~/.purple/themes
mv oxygen ~/.purple/themes/
rm *-oxygen.tar.gz
# FaenzaWolfe theme
wgets http://www.deviantart.com/download/207001654/pidgin_faenzawolfe_by_superwolfe2000-d3f8rhy.zip -O pidgin.zip
unzip pidgin.zip
sudo mv /usr/share/pixmaps/pidgin /usr/share/pixmaps/pidgin-BACKUP
sudo mv pidgin /usr/share/pixmaps/
rm pidgin.zip
mintversion


# FreeNX
ubuntuversion
sudo add-apt-repository -y ppa:freenx-team
sudo sed -i 's/oneiric/lucid/g' /etc/apt/sources.list.d/freenx-team-ppa-oneiric.list
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y nxssh nxclient-installer nxproxy qtnx
wget http://de.archive.ubuntu.com/ubuntu/pool/main/e/esound/esound-common_0.2.41-8_all.deb
sudo dpkg -i esound-common_0.2.41-8_all.deb
wget http://de.archive.ubuntu.com/ubuntu/pool/main/e/esound/libesd0_0.2.41-8_amd64.deb
sudo dpkg -i libesd0_0.2.41-8_amd64.deb
sudo apt-get -fy install # error in previous line
sudo dpkg -i esound-common_0.2.41-8_all.deb
sudo dpkg -i libesd0_0.2.41-8_amd64.deb
wget http://de.archive.ubuntu.com/ubuntu/pool/main/e/esound/esound-clients_0.2.41-8_amd64.deb
sudo dpkg -i esound-clients_0.2.41-8_amd64.deb
rm -f *.deb
sudo apt-get install -y freenx
wget https://bugs.launchpad.net/freenx-server/+bug/576359/+attachment/1378450/+files/nxsetup.tar.gz
tar zxvf nxsetup.tar.gz
sudo cp nxsetup /usr/lib/nx/nxsetup
sudo /usr/lib/nx/nxsetup --install
# NX Client, http://www.nomachine.com/select-package-client.php, /usr/NX/bin/nxclient
wget http://64.34.161.181/download/3.5.0/Linux/nxclient_3.5.0-7_amd64.deb
sudo dpkg -i nxclient*.deb
rm nxclient*.deb
sudo /etc/init.d/freenx-server restart
mintversion



# snes9x, super nintendo emulator
ubuntuversion
sudo add-apt-repository -y ppa:bearoso/ppa
sudo apt-get update
sudo apt-get install -y snes9x-gtk
mintversion

#GIMP
ubuntuversion
sudo add-apt-repository -y ppa:shnatsel/gimp-paint-studio
sudo apt-get update
sudo apt-get install -y gimp-paint-studio gimp gimp-data gimp-plugin-registry gimp-data-extras
sudo add-apt-repository -y ppa:mizuno-as/gimp-painter
sudo apt-get update
sudo apt-get upgrade -y
mintversion

#Audacity
ubuntuversion
sudo add-apt-repository -y ppa:audacity-team/daily
sudo apt-get update
sudo apt-get install -y audacity lame libmp3lame0
mintversion

#Amule # NATTY
# ubuntuversion
# sudo add-apt-repository -y ppa:happyaron/amule-dlp
# sudo apt-get update
# sudo apt-get install -y amule-dlp amule-dlp-gnome-support amule-dlp-utils-gui amule-dlp-daemon
# mintversion
# The following packages have unmet dependencies:
#  amule-dlp : Depends: libcrypto++8 but it is not installable
#              Recommends: amule-dlp-ipfilter but it is not going to be installed
#  amule-dlp-daemon : Depends: libcrypto++8 but it is not installable
#                     Recommends: amule-dlp-ipfilter but it is not going to be installed
#  amule-dlp-utils-gui : Depends: libcrypto++8 but it is not installable
# E: Unable to correct problems, you have held broken packages.


# Handbrake
ubuntuversion
sudo add-apt-repository -y ppa:stebbins/handbrake-snapshots
sudo apt-get update
sudo apt-get install -y handbrake-gtk handbrake-cli
mintversion

# FreetuxTV
ubuntuversion
sudo add-apt-repository -y ppa:freetuxtv/freetuxtv
sudo apt-get update
sudo apt-get install -y freetuxtv
mintversion

# Kubuntu Updates
ubuntuversion
sudo add-apt-repository -y ppa:kubuntu-ppa/ppa
sudo apt-get update && sudo apt-get upgrade -y
mintversion

# servon:
#---prima ancora
#ttf-mscorefonts-installer 
# etc/gnome/default.list  predefinito=N
#custom keypair=y

# sempre errori:
# midori
# flash plugin con adobe plugin
# eclipse
# vuze

# riavviare apache2
# etc/prelink.conf predefinito=N

## apt-get AutoPreferences
echo -e "sun-java6-jdk shared/accepted-sun-dlj-v1-1 select true\nsun-java6-jre shared/accepted-sun-dlj-v1-1 select true\nsun-java6-bin shared/accepted-sun-dlj-v1-1 select true\nvirtualbox virtualbox/module-compilation-allowed boolean true\nvirtualbox virtualbox/delete-old-modules boolean true\nvirtualbox virtualbox/group-vboxusers boolean true\nttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true\nkdm shared/default-x-display-manager select kdm\nracoon racoon/config_mode select direct\nacroread-common acroread-common/default-viewer boolean true\nphpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2\nlirc lirc/remote select None\nlirc lirc/transmitter select None\n" > autoprefs ########### not all working!
sudo debconf-set-selections < autoprefs
rm autoprefs

#withunmentdep="recorditnow" # manca libpolkit-qt-1-0

#sudo apt-get remove -y digikam-data

latex="texlive-full dvi2ps kile auctex gnuplot"
devlibs="libgtk2.0-dev libcairo2-dev kdelibs5-dev"
devtools="eclipse checkinstall kdevelop kdevelop-data blender linux-headers-generic build-essential xmlto gettext ncurses-dev cdbs devscripts dh-make fakeroot libxml-parser-perl check avahi-daemon git git-core git-gui and git-doc git-cola qgit"
p2p="dvdrip acidrip k3b-extrathemes normalize-audio" 
system="w3m w3m-img kubuntu-low-fat-settings flashplugin-nonfree bleachbit xvidcap acroread-fonts gtk-chtheme xscreensaver grub2 preload prelink grsync gthumb pstoedit acpi bridge-utils p7zip-full rar unrar gparted transcode wmctrl tagtool sysinfo ntfs-config unace-nonfree isomaster gmountiso ubuntu-restricted-extras startupmanager macutils qt4-qtconfig libqt4-sql-psql moodbar movixmaker-2 vcdimager kttsd djvulibre-bin cmake kile-doc gallery kleopatra spamassassin bogofilter spambayes bsfilter crm114 clamav gnokii kjots knode racoon vpnc xl2tpd openct opensc libjasper-runtime poppler-data reiser4progs hfsutils hfsplus googleearth xul-ext-gdata-provider kalarm vinagre kvpnc kdeutils kfloppy kchmviewer muon sweeper systemsettings yakuake showfoto qapt-batch quassel rekonq akregator amarok ark bluedevil choqok digikam  gwenview jockey-kde jovie k3b kaddressbook kalarm kalgebra kcalc kcharselect kchmviewer kdepasswd kdepim-groupware kdepim-kresources kdepim-runtime kdepim-strigi-plugins kdepim-wizards kdf kdm kfind kfloppy kftpgrabber kget kgpg khelpcenter4 kinfocenter kipi-plugins kmag kmix kmousetool kmouth kmymoney knotes konsole korganizer kscreensaver-xsavers kscreensaver-xsavers-extra ksnapshot ksysguard ksystemlog ktimer kubuntu-debug-installer kvkbd kwalletmanager language-selector-qt libkdepim4 libkopete4  libmessagelist4 libpolkit-qt-1-1 libqapt-runtime okular okular-odp-backend partitionmanager bluez blueman bluez-compat bluez-utils bluez-alsa bluez-cups bluez-gstreamer python-bluez bluez-hcidump bluez-btsco sl kate screen mozplugger ttf-mscorefonts-installer zip unzip sharutils mpack lha arj cabextract file-roller"
internet="midori usb-modeswitch vuze pssh kmail kppp krdc kremotecontrol krfb kontact kopete kopete-message-indicator kdenetwork wakeonlan remmina-plugin-nx remmina sshfs gshare smbfs curl uml-utilities gftp filezilla ssh autossh system-config-samba samba openvpn enigmail thunderbird chromium-browser chromium-browser-l10n seamonkey"
media="krita clementine kdenlive kino openshot pitivi winff gtkpod kdemultimedia-kio-plugins kde-config-phonon-xine kde-config-phonon-xine phonon-backend-vlc gstreamer0.10-plugins-good phonon-backend-gstreamer libdvdcss2 libdvdnav4 audacious audacious-plugins kino audacity sound-juicer vlc brasero w64codecs libsox-fmt-mp3 sox libxine1-ffmpeg gxine mencoder mpeg2dec vorbis-tools id3v2 mpg321 mpg123 libflac++6 ffmpeg totem-mozilla icedax tagtool easytag id3tool lame nautilus-script-audio-convert libmad0 libjpeg-progs flac faac faad sox ffmpeg2theora libmpeg2-4 uudeview flac libmpeg3-1 mpeg3-utils mpegdemux liba52-0.7.4-dev libquicktime2 gstreamer0.10-ffmpeg gstreamer0.10-fluendo-mp3 gstreamer0.10-gnonlin gstreamer0.10-sdl gstreamer0.10-plugins-bad-multiverse gstreamer0.10-schroedinger gstreamer0.10-plugins-ugly totem-plugins-extra gstreamer-dbus-media-service gstreamer-tools ubuntu-restricted-extras"
office="pinta pdftk scribus kalgebra klipper gnumeric inkscape speedcrunch acroread acroread-fonts pdfedit tuxpaint tuxpaint-stamps-default msttcorefonts cups-pdf"
games="frozen-bubble knetwalk pinball nexuiz openarena sauerbraten warsow wesnoth yofrankie warzone2100 tremulous teeworlds opencity alien-arena" # 2.6 GB 2 download, 3.3 GB of space to be used
utilities="expect xvkbd xdotool pv autokey alarm-clock skanlite xsane mail-notification"
kde4="dia strigi-daemon kdeartwork vlc-plugin-pulse polkit-kde-1 akonadi-kde-resource-googledata ffmpegthumbs kde-service-menu-fuseiso kde-thumbnailer-openoffice colibri konqueror-nsplugins kde-window-manager kdeplasma-addons kdesudo kdeutils kdeaccessibility kdelibs5 kdelibs5-plugins update-manager-kde konq-plugins oxygen-molecule firefox-kde-support kscreensaver-xsavers-webcollage kdesdk-dolphin-plugins kde-plasma-desktop plasma-scriptengine* kdeplasma-addons plasma-widget-adjustableclock plasma-widget-bkodama plasma-widget-cpuload plasma-widget-cwp plasma-widget-drop2ftp plasma-widget-facebook plasma-widget-fastuserswitch plasma-widget-flickr plasma-widget-folderview plasma-widget-fortunoid plasma-widget-googlecalendar plasma-widget-kbstate plasma-widget-kdeobservatory plasma-widget-kepas plasma-widget-kimpanel plasma-widget-kimpanel-backend-ibus plasma-widget-lancelot plasma-widget-lastmoid plasma-widget-mail plasma-widget-makestatus plasma-widget-memusage plasma-widget-menubar plasma-widget-message-indicator plasma-widget-networkmanagement plasma-widget-nextwallpaper plasma-widget-pgame plasma-widget-playwolf plasma-widget-quickaccess plasma-widget-runcommand plasma-widget-searchmoid plasma-widget-simplemonitor plasma-widget-smooth-tasks plasma-widget-stockquote plasma-widget-teacooker plasma-widget-tictactoe plasma-widget-toggle-compositing plasma-widget-translatoid plasma-widget-tvprogramme plasma-widget-weatherforecast plasma-widget-wifi plasma-widgets-addons plasma-widgets-workspace kde-config-touchpad system-config-printer-kde kde-config-gtk kde-config-grub2 kde-config-cron gdebi-kde oxygen-cursor-theme-extra oxygen-icon-theme-complete"
ita="kde-l10n-it qviaggiatreno witalian language-pack-gnome-it gimp-help-it libreoffice-l10n-it thunderbird-locale-it iitalian hyphen-it libreoffice-help-it aspell-it myspell-it"

sudo apt-get install -y --force-yes --ignore-missing --install-recommends $latex $devlibs $devtools $p2p $system $internet $media $office $utilities $kde4 $ita #$games

#sudo apt-get install -y digikam

# NTM Network traffic Monitor http://sourceforge.net/projects/netramon/files/latest/download?source=files

# kde-config-qt-graphicsystem
#  hal-cups-utils
# apturl-kde


## x11vnc (default VNC server doesn't work with compiz), see also "Gdm init script" for configuration
#sudo apt-get install x11vnc
#sudo x11vnc -storepasswd "$vncpass" /etc/x11vnc.pass


## Add current user to samba, set workgroup
#(echo $pass; echo $pass) | sudo smbpasswd -s -a $user
#sudo sed -i -e "s/workgroup = WORKGROUP/workgroup = "$wgroup"/g" /etc/samba/smb.conf

## Gdm init script
#sudo sed -i -e "s/exit 0//g" /etc/gdm/Init/Default
#echo "sudo x11vnc -rfbauth /etc/x11vnc.pass -o /tmp/x11vnc.log -forever -bg -noxdamage -rfbport 5900 -avahi -display :0" | sudo tee -a /etc/gdm/Init/Default > /dev/null
#echo "sudo modprobe vboxnetflt" | sudo tee -a /etc/gdm/Init/Default > /dev/null
#echo "exit 0" | sudo tee -a /etc/gdm/Init/Default > /dev/null

# Flash Player  #########  tweaks break usability
# sudo apt-get --yes install flashplugin-nonfree
# TWEAK=$(cat /etc/adobe/mms.cfg | grep 'OverrideGPUValidation')
# if test -z "${TWEAK}";then
#   echo 'OverrideGPUValidation=true' | sudo tee -a /etc/adobe/mms.cfg
# fi
# TWEAK=$(cat /etc/adobe/mms.cfg | grep 'EnableLinuxHWVideoDecode')
# if test -z "${TWEAK}";then
#   echo 'EnableLinuxHWVideoDecode=1' | sudo tee -a /etc/adobe/mms.cfg
# fi
# NPVIEWER=/usr/lib/nspluginwrapper/i386/linux/npviewer
# if test -f "${NPVIEWER}";then
#   TWEAK=$(cat /usr/lib/nspluginwrapper/i386/linux/npviewer | grep 'GDK_NATIVE_WINDOWS=1')
#   if test -z "${TWEAK}";then
#     echo '#!/bin/sh' | sudo tee /usr/lib/nspluginwrapper/i386/linux/npviewer
#     echo 'TARGET_OS=linux' | sudo tee -a /usr/lib/nspluginwrapper/i386/linux/npviewer
#     echo 'TARGET_ARCH=i386' | sudo tee -a /usr/lib/nspluginwrapper/i386/linux/npviewer
#     echo 'case "$*" in' | sudo tee -a /usr/lib/nspluginwrapper/i386/linux/npviewer
#     echo '*libflashplayer*)' | sudo tee -a /usr/lib/nspluginwrapper/i386/linux/npviewer
#     echo '	export GDK_NATIVE_WINDOWS=1' | sudo tee -a /usr/lib/nspluginwrapper/i386/linux/npviewer
#     echo '	;;' | sudo tee -a /usr/lib/nspluginwrapper/i386/linux/npviewer
#     echo 'esac' | sudo tee -a /usr/lib/nspluginwrapper/i386/linux/npviewer
#     echo '. /usr/lib/nspluginwrapper/noarch/npviewer' | sudo tee -a /usr/lib/nspluginwrapper/i386/linux/npviewer
#   fi
# fi

# Florence Keyboard
wget http://dfn.dl.sourceforge.net/project/florence/florence/0.5.1/florence-0.5.1.tar.bz2 -O florence.tar.bz2
sudo apt-get install -y build-essential libxml2-dev libgconf2-dev libglade2-dev libatspi-dev libcairo2-dev gnome-doc-utils librsvg2-dev gettext libnotify-dev libxtst-dev intltool libgnome-desktop-dev
tar -xjvf florence*.tar.bz2
cd florence*
./configure --prefix=/usr --without-panelapplet # --with-xrecord 
make
sudo make install
cd ..
rm -R florence*


# fresher packages
ubuntuversion
sudo add-apt-repository -y ppa:nilarimogard/webupd8
sudo apt-get update && sudo apt-get upgrade -y
mintversion

## Mac fonts
tar -zxvf packages/macfonts.tar.gz
sudo mv macfonts /usr/share/fonts/
sudo fc-cache -f -v

# Sikuli
# SCRIPT #### java -jar /usr/local/Sikuli-IDE/sikuli-script.jar /path/things2do.sikuli 
#  IDE   #### java -jar /usr/local/Sikuli-IDE/sikuli-ide.jar
cd
git clone git://github.com/sikuli/sikuli.git
sudo apt-get install -y cmake libcv-dev libcvaux-dev libtiff4-dev tesseract-ocr-dev swig sun-java6-jdk debhelper exuberant-ctags libhighgui-dev libjxgrabkey-java libjxgrabkey-doc libswingx-java
cd sikuli
mkdir sikuli-script/build
cd sikuli-script/build
cmake ..
make
cd ../.. 
mkdir sikuli-ide/build
cd sikuli-ide/build
cmake ..
make package
sudo checkinstall -y --pkgname sikuli
sudo dpkg -i sikuli*.deb
cd
rm -Rf sikuli*

# 'vlc-data' and other packages have to be upgrated at this point
#sleep 6
#sudo apt-get update && sudo apt-get upgrade

# KpackageKit is better with KDE4 than MintUpdate Manager
sudo apt-get remove -y mintupdate apper kpackagekit

# NumLock at KDM
sudo apt-get install -y numlockx
# in /etc/kde4/kdm/Xsetup penultima riga prima di     /sbin/initctl -q emit login-session-start DISPLAY_MANAGER=kdm
# numlockx on &

# Colibri Setup
# http://gitorious.org/colibri/pages/SetupHowto

# Dropbox ServiceMenu
# http://kde-apps.org/content/show.php/Dropbox+ServiceMenu?content=124416

## Enabling NFTS writing support
################ ln: creating symbolic link `/etc/hal/fdi/policy/20-ntfs-config-write-policy.fdi': No such file or directory
sudo rm -f /etc/hal/fdi/policy/20-ntfs-config-ro-policy.fdi
sudo ln -s /usr/share/ntfs-config/write-policy.fdi /etc/hal/fdi/policy/20-ntfs-config-write-policy.fdi

# Google Earth
# apt-add-repository 'deb http://dl.google.com/linux/earth/deb/ stable main'; apt-get update; apt-get install google-earth-stable 
sudo apt-get install -y googleearth-package lsb-core ttf-mscorefonts-installer
prevdir=$(pwd)
cd
sudo make-googleearth-package --force
sudo dpkg -i googleearth*.deb
sudo rm googleearth*.deb
cd $prevdir

# Java 6
ubuntuversion
sudo add-apt-repository -y ppa:ferramroberto/java
sudo apt-get update
sudo apt-get install -y sun-java6-jre sun-java6-plugin sun-java6-fonts
mintversion


# JDownloader
ubuntuversion
sudo add-apt-repository -y ppa:jd-team/jdownloader
sudo apt-get update
sudo apt-get install -y jdownloader
mintversion


# FF Multi Converter
ubuntuversion
sudo add-apt-repository -y ppa:ffmulticonverter/stable
sudo apt-get update
sudo apt-get install -y ffmulticonverter python-qt4 ffmpeg unoconv
mintversion


# gSharkDown
ubuntuversion
sudo add-apt-repository -y ppa:ferramroberto/gsharkdown
sudo apt-get update
sudo apt-get install -y gsharkdown
mintversion

# GrooveDown
# wget http://groovedown.me/wp-content/plugins/download-monitor/download.php?id=groovedown.zip -O groovedown.zip


# Fixing Grub
sudo sed -i -e "s/#GRUB_GFXMODE=640x480/GRUB_GFXMODE=${screenWidth}x${screenHeigth}/g" /etc/default/grub
sudo sed -i -e "s/GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash\"/GRUB_CMDLINE_LINUX_DEFAULT=\" splash\"/g" /etc/default/grub
sudo sed -i -e "s/GRUB_HIDDEN_TIMEOUT_QUIET=true/GRUB_HIDDEN_TIMEOUT_QUIET=false/g" /etc/default/grub 
sudo sed -i -e "s/GRUB_HIDDEN_TIMEOUT=0/# GRUB_HIDDEN_TIMEOUT=0/g" /etc/default/grub 
sudo update-grub2
sudo update-initramfs -u

# Plymouth Manager & Settings 
ubuntuversion
sudo apt-add-repository -y ppa:mefrio-g/plymouthmanager
sudo apt-add-repository -y ppa:plymouth-themes/ppa 
sudo apt-get update
sudo apt-get install -y plymouth-manager plymouth-theme-azenis plymouth-theme-basmalah plymouth-theme-earth-sunrise plymouth-theme-fade-in plymouth-theme-fun-with-linux-one plymouth-theme-fun-with-linux-two plymouth-theme-fwl-gold plymouth-theme-glow plymouth-theme-int-mint plymouth-theme-internauta plymouth-theme-kmint plymouth-theme-lmde plymouth-theme-mint-does-seven plymouth-theme-mint-logo plymouth-theme-mint-sunrise plymouth-theme-mud-world-black plymouth-theme-mud-world-blue plymouth-theme-narwhals plymouth-theme-paw-osx plymouth-theme-script plymouth-theme-seven plymouth-theme-solar plymouth-theme-space-sunrise plymouth-theme-spinfinity plymouth-theme-spinfinity-mint-one plymouth-theme-spinfinity-mint-two plymouth-theme-stargate plymouth-theme-texans  plymouth-theme-text plymouth-theme-u-p-one plymouth-theme-u-p-two plymouth-theme-wheat plymouth-X11
mintversion
sudo update-alternatives --install /lib/plymouth/themes/default.plymouth default.plymouth /lib/plymouth/themes/solar/solar.plymouth 100
sudo update-alternatives --set default.plymouth /lib/plymouth/themes/solar/solar.plymouth
sudo update-initramfs -u


# KDM Theme (KDE login screen)
wget http://kde-look.org/CONTENT/content-files/143848-stripes-kdm-theme.tar.gz -O themetar.tar.gz
rm -fR themefolder
mkdir themefolder
tar -xvf  themetar.tar.gz -C themefolder
themename=$(ls themefolder)
sudo mv themefolder/${themename}/ /usr/share/kde4/apps/kdm/themes/
sudo sed -i "s/wallpaper=\"Stripes\"/file=\"wallpapers\/background.png\"/g" /usr/share/kde4/apps/kdm/themes/stripes/stripes.xml
sudo sed -i "s/Theme=\/usr\/share\/kde4\/apps\/kdm\/themes\/.*$/Theme=\/usr\/share\/kde4\/apps\/kdm\/themes\/$themename/g" /etc/kde4/kdm/kdmrc
sudo chmod -R 755 /usr/share/kde4/apps/kdm/themes/stripes
rm -fR themefolder
rm themetar.tar.gz

# Ksplash Theme (KDE after-login screen)
wget http://dl.dropbox.com/u/31781148/stripes-ksplash-theme.tar.gz -O themetar.tar.gz
rm -fR themefolder
mkdir themefolder
tar -xvf  themetar.tar.gz -C themefolder
themename=$(ls themefolder)
mkdir -p ~/.kde/share/apps/ksplash/Themes/
sudo mv themefolder/${themename}/ ~/.kde/share/apps/ksplash/Themes/
sed -i "s/Theme=.*$/Theme=$themename/g" ~/.kde/share/config/ksplashrc
cp -f /usr/share/kde4/apps/kdm/themes/stripes/wallpapers/background.png $HOME/.kde/share/apps/ksplash/Themes/Stripes/1366x768/background.png
rm -fR themefolder
rm themetar.tar.gz

## Apps Associations mimetype
sudo rm -f ~/.local/share/applications/defaults.list
mkdir ~/.local/share/applications/
echo -e "[Default Applications]\nimage/jpeg=gimp.desktop\napplication/vnd.ms-excel=openoffice.org3-calc.desktop\napplication/msword=openoffice.org3-writer.desktop\naudio/mpeg=vlc.desktop\nvideo/x-msvideo=vlc.desktop\napplication/rtf=openoffice.org3-writer.desktop\napplication/pdf=AdobeReader.desktop\napplication/x-shellscript=gedit.desktop" > ~/.local/share/applications/defaults.list

# MEdibuntu codecs
sudo wget --output-document=/etc/apt/sources.list.d/medibuntu.list http://www.medibuntu.org/sources.list.d/$(lsb_release -cs).list && sudo apt-get --quiet update && sudo apt-get --yes --quiet --allow-unauthenticated install medibuntu-keyring && sudo apt-get --quiet update
sudo apt-get -y update && sudo apt-get -y upgrade
sudo apt-get install -y app-install-data-medibuntu apport-hooks-medibuntu

# Prism, http://prism.mozillalabs.com/
# http://ch.archive.ubuntu.com/ubuntu/pool/universe/x/... _amd64.deb _i386.deb
wget http://ch.archive.ubuntu.com/ubuntu/pool/universe/x/xulrunner-1.9.2/xulrunner-1.9.2_1.9.2.17+build3+nobinonly-0ubuntu1_amd64.deb -O xulrunner.deb
sudo dpkg -i xulrunner.deb
wget http://ch.archive.ubuntu.com/ubuntu/pool/universe/p/prism/prism_1.0b3+svn20100210r62050-0ubuntu2_amd64.deb -O prism.deb
sudo dpkg -i prism.deb
sudo apt-get install -fy
rm xulrunner.deb
rm prism.deb

# Kfilebox, http://sourceforge.net/projects/kdropbox/files/latest/download
#sudo dpkg -i packages/kfilebox*.deb
#echo "alias dropbox=\"$HOME/.dropbox-dist/dropboxd &\"" >> .bashrc

# Hydroxygen icons
#wgets http://www.deviantart.com/download/100826865/hydroxygen_iconset_by_deviantdark.zip -O hydroxygen.zip
#unzip hydroxygen.zip
#sleep 3
#tar xvjf iconset/hydroxygen*.tar.bz2 

# Oxygen Icons KDE 4.6
wgets http://content.wuala.com/contents/csslayer/eyecandy/icons/oxygen-old.tar.bz2
tar xvjf oxygen*.tar.bz2 
sudo mv oxygen-old /usr/share/icons/
rm -f oxygen-old.tar.bz2



# Fixing Google Search in Linux Mint
current_dir=$PWD
cd /usr/share/linuxmint/common/artwork/firefox/
sudo wget http://mxr.mozilla.org/firefox/source/browser/locales/en-US/searchplugins/google.xml?raw=1 -O google.xml.fixed
sudo mv google.xml google.xml.orig
sudo mv google.xml.fixed google.xml
sudo cp google.xml /usr/lib/firefox-addons/searchplugins/en-US/google.xml
cd "$current_dir"

# Removing Mint ramdom console message
sudo sed -i -e "s/\/usr\/bin\/mint-fortune/# \/usr\/bin\/mint-fortune/g" /etc/bash.bashrc

## Fixing permissions
sudo chown -R "$USER" ~/.gconf
chmod 755 -R ~/.gconf
sudo chown -R "$USER" ~/.config
chmod 755 -R ~/.config
sudo chown -R "$USER" ~/.kde
chmod 755 -R ~/.kde
chmod 777 -R ~/.local
chmod 777 -R ~/.webapps
chmod 700 ~/.ssh/id_rsa
sudo mkdir "/media/VirtualDVD"  
sudo chmod 777 -R  "/media/VirtualDVD"

# Adding current user to groups
sudo adduser "$USER" vboxusers
sudo adduser "$USER" floppy

# Oxygen GTK, https://projects.kde.org/projects/playground/artwork/oxygen-gtk
git clone git://anongit.kde.org/oxygen-gtk
cd oxygen-gtk*
mkdir build
cd build
cmake -DLIB_SUFFIX=64 -DCMAKE_INSTALL_PREFIX=`pkg-config --variable=prefix gtk+-2.0` ../
make
sudo checkinstall -y --pkgname oxygen-gtk
sudo dpkg -i oxygen-gtk*.deb
cd ../..
rm -Rf oxygen-gtk*
sudo cp /usr/lib64/gtk-2.0/2.10.0/engines/liboxygen-gtk.so /usr/lib/gtk-2.0/2.10.0/engines/
cd
mv .gtkrc-2.0-kde4 .gtkrc-2.0-kde4-backup
echo -e "# This file was written by KDE
# You can edit it in the KDE control center, under \"GTK Styles and Fonts\"
include \"/usr/share/themes/oxygen-gtk/gtk-2.0/gtkrc\"
style \"user-font\"
{
	font_name=\"Sans\"
}
widget_class \"*\" style \"user-font\"
gtk-theme-name=\"oxygen-gtk\"
gtk-font-name=\"Sans 7\"" > .gtkrc-2.0-kde4 
echo -e "# edited with gtk-theme-switch2
include \"/usr/share/themes/oxygen-gtk/gtk-2.0/gtkrc\"
style \"user-font\" {
	font_name = \"Sans 7\"
}
widget_class \"*\" style \"user-font\"
gtk-font-name=\"Sans 7\"
include \"/home/alz/.gtkrc.mine\"" > .gtkrc-2.0
sudo cp .gtkrc* /root/

# Screenlets [requiring Oxygen GTK]; `sudo aptitude search screenlet` for listing them all
#sudo apt-add-repository ppa:screenlets/ppa 
#sudo apt-get update 
#sudo apt-get install screenlets 
#sudo apt-get install googlecalendar-screenlet brightness-screenlet clock-screenlet control-screenlet convert-screenlet daynight-screenlet diskspace-screenlet diskusage-screenlet dropbox-screenlet execute-screenlet furiusmoon-screenlet fuzzyclock-screenlet manometer-screenlet meter-screenlet mount-screenlet myip-screenlet netmon-screenlet netmonitor-screenlet netspeed-screenlet nvidia-screenlet sensors-screenlet slideshow-screenlet smoothweather-screenlet storage-screenlet sysmonitor-screenlet widescapeweather-screenlet

# Enabling DVD Playback
sudo sh /usr/share/doc/libdvdread4/install-css.sh

# Preventing fullscreen flickering in KDE
kwriteconfig --file kwinrc --group Compositing --key UnredirectFullscreen --type bool false
qdbus org.kde.kwin /KWin reconfigure

# XScreensaver theming, https://wiki.archlinux.org/index.php/Xdefaults#xscreensaver_theming
# KDE & Xscreensaver http://www.jwz.org/xscreensaver/man1.html#9
# # # # ####xscreensavercheck.sh
# # # #!/bin/bash
# # # # check with
# # # # crontab -e
# # # # *   */2    *   *  *    bash $HOME/Scripts/xscreensavercheck.sh
# # # 
# # # screensaverfile="/usr/lib/kde4/libexec/kscreenlocker"
# # # isxscsv=$(cat $screensaverfile | wc -l)
# # # 
# # # if [[ $isxscsv -le "6" ]] ; then 
# # #   echo "xscrennsaver ok"
# # # else
# # #   sudo -S mv $screensaverfile /usr/lib/kde4/libexec/kscreenlocker-backup
# # #   sudo -S touch $screensaverfile < "$HOME/.config/userpass"
# # #   sudo -S chmod 777 $screensaverfile < "$HOME/.config/userpass"
# # #   sudo -S echo -e "#\041/bin/bash
# # #   xscreensaver-command -lock" > $screensaverfile < "$HOME/.config/userpass"
# # #   echo "xscrennsaver now ok"
# # # fi

# uncomment in order 2 activate xscreensaver
# #screensaverfile="/usr/lib/kde4/libexec/kscreenlocker"
# #sudo mv $screensaverfile /usr/lib/kde4/libexec/kscreenlocker-backup
# #sudo touch $screensaverfile
# #sudo chmod 777 $screensaverfile
sudo echo -e "#\041/bin/bash
xscreensaver-command -lock" > $screensaverfile
echo -e "! xscreensaver ---------------------------------------------------------------

!font settings
xscreensaver.Dialog.headingFont:        -*-dina-bold-r-*-*-12-*-*-*-*-*-*-*
xscreensaver.Dialog.bodyFont:           -*-dina-medium-r-*-*-12-*-*-*-*-*-*-*
xscreensaver.Dialog.labelFont:          -*-dina-medium-r-*-*-12-*-*-*-*-*-*-*
xscreensaver.Dialog.unameFont:          -*-dina-medium-r-*-*-12-*-*-*-*-*-*-*
xscreensaver.Dialog.buttonFont:         -*-dina-bold-r-*-*-12-*-*-*-*-*-*-*
xscreensaver.Dialog.dateFont:           -*-dina-medium-r-*-*-12-*-*-*-*-*-*-*
xscreensaver.passwd.passwdFont:         -*-dina-bold-r-*-*-12-*-*-*-*-*-*-*
!general dialog box (affects main hostname, username, password text)
xscreensaver.Dialog.foreground:         #ffffff
xscreensaver.Dialog.background:         #111111
xscreensaver.Dialog.topShadowColor:     #111111
xscreensaver.Dialog.bottomShadowColor:  #111111
xscreensaver.Dialog.Button.foreground:  #666666
xscreensaver.Dialog.Button.background:  #ffffff
!username/password input box and date text colour
xscreensaver.Dialog.text.foreground:    #666666
xscreensaver.Dialog.text.background:    #ffffff
xscreensaver.Dialog.internalBorderWidth:24
xscreensaver.Dialog.borderWidth:        20
xscreensaver.Dialog.shadowThickness:    2
!timeout bar (background is actually determined by Dialog.text.background)
xscreensaver.passwd.thermometer.foreground:  #ff0000
xscreensaver.passwd.thermometer.background:  #000000
xscreensaver.passwd.thermometer.width:       8
!datestamp format--see the strftime(3) manual page for details
xscreensaver.dateFormat:    %I:%M%P %a %b %d, %Y" > ~/.Xresources
xrdb ~/.Xresources && xscreensaver-command -restart &
killall xscreensaver
sudo apt-get install -y rss-glx
killall gnome-screensaver
sudo apt-get remove -y nautilus gnome-screensaver
/usr/bin/rss-glx_install
xscreensaver-command -restart &

## x11vnc (default VNC server doesn't work with compiz), see also "Gdm init script" for configuration
############### TO DO WITH KDM
#sudo x11vnc -storepasswd "$vncpass" /etc/x11vnc.pass
## Gdm init script
#sudo sed -i -e "s/exit 0//g" /etc/gdm/Init/Default
# o in /etc/kde4/kdm/Xsetup prima di /sbin/initctl -q emit login-session-start DISPLAY_MANAGER=kdm
#echo "sudo x11vnc -rfbauth /etc/x11vnc.pass -o /tmp/x11vnc.log -forever -nodpms -bg -noxdamage -rfbport 5900 -avahi -display :0" | sudo tee -a /etc/gdm/Init/Default > /dev/null
#echo "sudo modprobe vboxnetflt" | sudo tee -a /etc/gdm/Init/Default > /dev/null
#echo "exit 0" | sudo tee -a /etc/gdm/Init/Default > /dev/null


# Setting how may reboots between HD checks, w/ /dev/sda5 your root partition
sudo tune2fs -c 120 /dev/sda5

## Adding CUPS-PDF virtual printer, http://localhost:631
sudo apt-get purge -y cups-pdf
sudo apt-get install -y cups-pdf
mkdir $HOME/PDF
sudo chmod 777 -R $HOME/PDF
sudo sed -i -e "s/#UserUMask 0077/UserUMask 0000/g" /etc/cups/cups-pdf.conf
#sudo sed -i -e "s/Out \${HOME}/Out \${HOME}\/PDF/g" /etc/cups/cups-pdf.conf
sudo restart cups
#sudo sed -i -e "s/<Printer PDF>/<Printer CUPS-PDF>/g" /etc/cups/printers.conf
#sudo sed -i -e "s/<Printer CUPS-PDF>/<Printer CUPS-PDF>\nLocation \$HOME\/PDF/g" /etc/cups/printers.conf #sudo sed -i -e "s/Location In your home folder/Location \$HOME\/PDF/g" /etc/cups/printers.conf
#sudo restart cups
# sudo cupsaddsmb -v -H $HOSTNAME -U "$USER"%"$pass" PDF 

# Upgrading paths (with R2011b as your current Matlab version)
#echo "PATH=\"\$HOME/Scripts:\$HOME/Scripts/Sikuli-IDE/:\$HOME/Documents/Site DESIGN/Drupal/Scripts/:\$HOME/Documents/GNU-Linux DEV/GitHub/Scripts/:\$HOME/Documents/Android SDK/tools/:\$HOME/Documents/Android SDK/platform-tools/:/usr/local/MATLAB/R2011b/bin/:\$PATH\"" | tee -a ~/.bashrc > /dev/null
echo "PATH=\"\$HOME/.Scripts:\$PATH\"" | tee -a ~/.bashrc > /dev/null

# Docky, http://do.davebsd.com/wiki/Docky
#ubuntuversion
#sudo add-apt-repository -y ppa:docky-core/stable
#sudo apt-get update
#sudo apt-get install docky
#mintversion


## Prelinking Apps
sudo sed -i -e "s/PRELINKING=unknown/PRELINKING=yes/g" /etc/default/prelink
sudo /etc/cron.daily/prelink # this might take some time...


# Fixing Skype
sudo apt-get install skype
killall -9 skype
sudo sed -i -e "s/-b \/usr\/bin\/skype//g" /etc/prelink.conf
sudo sh -c 'echo "-b /usr/bin/skype" >> /etc/prelink.conf'
sudo ldconfig
#wget www.skype.com/go/getskype-linux-static -O skype.tar.bz2
#tar xvjf skype.tar.bz2
#sudo mv /usr/bin/skype /usr/bin/skype.backup
#sudo mv skype*/skype /usr/bin/skype
#mv skype*/ skype
#sudo rm -R /usr/share/skype
#sudo mv skype/ /usr/share/
#sudo cp /usr/share/skype/icons/SkypeBlue_48x48.png /usr/share/pixmaps/skype.png
#sudo rm /etc/dbus-1/system.d/skype.conf
#sudo cp /usr/share/skype/skype.conf /etc/dbus-1/system.d/
#rm -fR skype*

## Apt-Get autoclean
sudo apt-get autoclean
sudo apt-get clean

## Restoring sudo timeout
sudo sed -i -e "s/Defaults timestamp_timeout=999//g" /etc/sudoers

# rsync -r -t -p -o -v --progress --delete -c -l -H -D -z -i -s --exclude=.cache --exclude=.ecryptfs --exclude=.Private --exclude=.ICEauthority --exclude=.thumbnails --exclude=.strigi --exclude=.dropbox/command_socket --exclude=.dropbox/iface_socket --exclude=.dropbox/l/ --exclude=.google/gadgets/ggl-host-socket --exclude=.lastpass/pipes/lastpassffplugin --exclude=.wine/dosdevices/z: --exclude=.appdata/jrcf_* --exclude=.Xauthority-n --exclude=.appdata/TweetDeckFast.*/Local*Store/*.db-journal /media/Alz/CONFIGURATION/studio/ /home/$USER
# rsync -r -t -p -o -v --progress --delete -c -l -H -D -z -i -s --exclude=.cache --exclude=.ecryptfs --exclude=.Private --exclude=.ICEauthority --exclude=.thumbnails --exclude=.strigi --exclude=.dropbox/command_socket --exclude=.dropbox/iface_socket --exclude=.dropbox/l/ --exclude=.google/gadgets/ggl-host-socket --exclude=.lastpass/pipes/lastpassffplugin --exclude=.wine/dosdevices/z: --exclude=.appdata/jrcf_* --exclude=.Xauthority-n --exclude=.appdata/TweetDeckFast.*/Local*Store/*.db-journal /media/Alz/CONFIGURATION/studio/ /home/$USER
# sudo reboot

