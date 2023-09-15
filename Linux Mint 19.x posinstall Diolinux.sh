#!/usr/bin/env bash

# Por Diolinux <blogdiolinux@gmail.com>
#
# Colaboração: Fernando Souza <https://www.youtube.com/@fernandosuporte>
# Data: 15/09/2023 as 19:27
#
#
# Adicionado uma verificação básica para os programas;
# Adicionado uma verificação para Root;
# Removido o comando sudo do script (vulnerabilidade no comando sudo permite escalonar privilégios de Root);
#
# https://cve.mitre.org/
#  
# Removeria as PPAs (repositórios de terceiros) e usaria somente os repositórios oficiais da distribuição Linux;
# Por questão de segurança os repositórios de PPAs foram desativados neste script.



# ----------------------------- VARIÁVEIS ----------------------------- #


# PPA_LIBRATBAG="ppa:libratbag-piper/piper-libratbag-git"


# Verificar se no repositório oficial da sua distribuição Linux não tem o Lutris.
#
# Site oficial: https://lutris.net/downloads
#
# PPA_LUTRIS="ppa:lutris-team/lutris"


# PPA_GRAPHICS_DRIVERS="ppa:graphics-drivers/ppa"


# No repositório oficial da sua distribuição Linux já tem o Wine.
#
# Site oficial: https://wiki.winehq.org/Download
#
# URL_WINE_KEY="https://dl.winehq.org/wine-builds/winehq.key"
# URL_PPA_WINE="https://dl.winehq.org/wine-builds/ubuntu/"



# No repositório oficial da sua distribuição Linux já tem o Google Chrome.

URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"


# Simplenote -  programa de anotações com suporte a Markdown.
#
# Site oficial: https://simplenote.com/
#
# https://github.com/Automattic/simplenote-electron/releases

URL_SIMPLE_NOTE="https://github.com/Automattic/simplenote-electron/releases/download/v2.21.0/Simplenote-linux-2.21.0-amd64.deb"


# Tem outros programas no repositório oficial da sua distribuição Linux com a mesma finalidade do "4K Video Downloader".

# URL_4K_VIDEO_DOWNLOADER="https://dl.4kdownload.com/app/4kvideodownloader_4.27.1-1_amd64.deb"



# InSync - sincronizar arquivo para nuvem
#
# https://diolinux.com.br/softwares/insync-melhor-cliente.html
# 
# Site oficial: https://www.insynchq.com/downloads/linux
#
# Versão para o Ubuntu 23.04
#
URL_INSYNC="https://cdn.insynchq.com/builds/linux/insync_3.8.6.50504-lunar_amd64.deb"



DIRETORIO_DOWNLOADS="$HOME/Downloads/programas"



PROGRAMAS_PARA_INSTALAR=(
  snapd
  mint-meta-codecs
  winff
  guvcview
  virtualbox
  flameshot
  nemo-dropbox
  steam-installer
  steam-devices
  steam:i386
  ratbagd
  piper
  libvulkan1
  libvulkan1:i386
  libgnutls30:i386
  libldap-2.4-2:i386
  libgpg-error0:i386
  libxml2:i386
  libasound2-plugins:i386
  libsdl2-2.0-0:i386
  libfreetype6:i386
  libdbus-1-3:i386
  libsqlite3-0:i386
)
# ---------------------------------------------------------------------- #

# Verificar Root

clear

if  test `whoami` != root ;
then

echo -e "\e[1;31mATENÇÃO

Você precisa ser Root para executar este script.

Ex:

# $0 \e[0m
"

exit 1

fi



# Verificação basica para os programas:

which apt     || exit
which dpkg    || exit
which wget    || exit
which flatpak || exit
which snap    || exit
which rm      || exit
which mkdir   || exit

# ----------------------------- REQUISITOS ----------------------------- #

## Removendo travas eventuais do apt ##

rm -Rf /var/lib/dpkg/lock-frontend
rm -Rf /var/cache/apt/archives/lock

## Adicionando/Confirmando arquitetura de 32 bits ##

dpkg --add-architecture i386


## Atualizando o repositório ##

apt update -y


## Adicionando repositórios de terceiros e suporte a Snap (Driver Logitech, Lutris e Drivers Nvidia)##

# apt-add-repository "$PPA_LIBRATBAG" -y
# add-apt-repository "$PPA_LUTRIS" -y
# apt-add-repository "$PPA_GRAPHICS_DRIVERS" -y
# wget -nc "$URL_WINE_KEY"
# apt-key add winehq.key
# apt-add-repository "deb $URL_PPA_WINE bionic main"


# ---------------------------------------------------------------------- #



# ----------------------------- EXECUÇÃO ----------------------------- #

## Atualizando o repositório depois da adição de novos repositórios ##

apt update -y

## Download e instalaçao de programas externos ##

mkdir -p "$DIRETORIO_DOWNLOADS"

wget -c "$URL_GOOGLE_CHROME"       -P "$DIRETORIO_DOWNLOADS"
wget -c "$URL_SIMPLE_NOTE"         -P "$DIRETORIO_DOWNLOADS"

# wget -c "$URL_4K_VIDEO_DOWNLOADER" -P "$DIRETORIO_DOWNLOADS"

wget -c "$URL_INSYNC"              -P "$DIRETORIO_DOWNLOADS"


## Instalando pacotes .deb baixados na sessão anterior ##

dpkg -i $DIRETORIO_DOWNLOADS/*.deb


# Instalar programas no apt

for nome_do_programa in ${PROGRAMAS_PARA_INSTALAR[@]}; do

  if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
  
    apt install -y "$nome_do_programa"
    
  else
  
    echo "[INSTALADO] - $nome_do_programa"
    
  fi
  
done

apt install --install-recommends winehq-stable wine-stable wine-stable-i386 wine-stable-amd64 -y


## Instalando pacotes Flatpak ##

# OBS Studio
#
# Site oficial: https://obsproject.com/pt-br/download
#

flatpak install flathub com.obsproject.Studio -y



## Instalando pacotes Snap ##


# Spotify
#
# Site oficial: https://open.spotify.com/intl-pt

snap install spotify


# snap install slack --classic


# Skype
#
# Site oficial: https://www.skype.com/pt-br/get-skype/

snap install skype --classic


# PhotoGIMP - O GIMP para quem vem do Photoshop

snap install photogimp

# https://diolinux.com.br/aplicativos/photogimp-2020.html
# https://github.com/Diolinux/PhotoGIMP/blob/master/fonts.txt


# ---------------------------------------------------------------------- #


# ----------------------------- PÓS-INSTALAÇÃO ----------------------------- #

clear

## Finalização, atualização e limpeza ##

apt update && apt dist-upgrade -y

flatpak update

apt autoclean

apt autoremove -y

# ---------------------------------------------------------------------- #


exit 0
