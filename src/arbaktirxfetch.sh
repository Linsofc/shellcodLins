#!/usr/bin/env bash

magenta="\033[1;35m"
green="\033[1;32m"
white="\033[1;37m"
blue="\033[1;34m"
red="\033[1;31m"
black="\033[1;40;30m"
yellow="\033[1;33m"
cyan="\033[1;36m"
reset="\033[0m"
bgyellow="\033[1;43;33m"
bgwhite="\033[1;47;37m"
c0=${reset}
c1=${magenta}
c2=${green}
c3=${white}
c4=${blue}
c5=${red}
c6=${yellow}
c7=${cyan}
c8=${black}
c9=${bgyellow}
c10=${bgwhite}

function getCodeName() {
  codename="Pterodactyle"
}

function getClientBase() {
  client_base="Arbakti"
}

function getModel() {
  model="$(uname -m)"
}

function getDistro() {
  os="$(uname -o) $(uname -m)"
}

function getKernel() {
  kernel="$(uname -r)"
}

function getTotalPackages() {
  package_manager="$(which {apt,dpkg} 2>/dev/null | grep -v "not found" | awk -F/ 'NR==1{print $NF}')"
  case "${package_manager}" in
    "apt" )
      packages=$(apt list --installed 2>/dev/null | wc -l)
    ;;
    
    "dpkg" )
      packages=$(dpkg-query -l | wc -l)
    ;;
    
    "" )
      packages="Unknown"
    ;;
  esac
}

function getInstalledTools() {
  tools=(git curl jq file unzip make gcc ffmpeg g++ python3 pip3 libtoolize npm convert)

  installed_list=""

  for tool in "${tools[@]}"; do
    if type -P "$tool" >/dev/null 2>&1; then
      installed_list+="$tool ✓  "
    else
      installed_list+="$tool ✗  "
    fi
  done
}

# function getInstalledTools() {
#   tools=(git curl jq file unzip make gcc ffmpeg g++ python3 python3-pip libtool npm)

#   installed_list=""

#   for tool in "${tools[@]}"; do
#     if command -v $tool >/dev/null 2>&1; then
#       installed_list+="$tool ✓  "
#     else
#       installed_list+="$tool ✗  "
#     fi
#   done

#   if command -v convert >/dev/null 2>&1; then
#     installed_list+="convert ✓  "
#   elif command -v magick >/dev/null 2>&1; then
#     installed_list+="magick ✓  "
#   else
#     installed_list+="imagemagick ✗  "
#   fi
# }

function getShell() {
  shell="$(basename $SHELL)"
}

function getUptime() {
  if [ -r /proc/uptime ]; then
    _SECONDS=$(cut -d. -f1 /proc/uptime)
    _DAYS=$((_SECONDS / 86400))
    _HOURS=$((_SECONDS % 86400 / 3600))
    _MINUTES=$((_SECONDS % 3600 / 60))

    uptime=""
    [ $_DAYS -gt 0 ] && uptime="${_DAYS}d "
    [ $_HOURS -gt 0 ] && uptime="${uptime}${_HOURS}h "
    uptime=" ${uptime}${_MINUTES}m"
  else
    uptime="Unavailable"
  fi
}

function getMemoryUsage() {
  if [ -r /proc/meminfo ]; then
    _TOTAL=$(grep MemTotal /proc/meminfo | awk '{print int($2/1024)}')
    _AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print int($2/1024)}')
    _USED=$((_TOTAL - _AVAILABLE))
    memory="${_USED}MB / ${_TOTAL}MB"
  else
    memory="Tidak Tersedia"
  fi
}


function getDiskUsage() {
  if command -v df >/dev/null 2>&1; then
    _GREP_ONE_ROW="$(df -h | grep '\/$')"
    if [ -n "${_GREP_ONE_ROW}" ]; then
      _SIZE="$(echo ${_GREP_ONE_ROW} | awk '{print $2}')"
      _USED="$(echo ${_GREP_ONE_ROW} | awk '{print $3}')"
      _AVAIL="$(echo ${_GREP_ONE_ROW} | awk '{print $4}')"
      _USE="$(echo ${_GREP_ONE_ROW} | awk '{print $5}' | sed 's/%//')"
      storage="${_USED}B / ${_SIZE}B = ${_AVAIL}B (${_USE}%)"
    else
      storage="Mount not found"
    fi
  else
    storage="Unavailable"
  fi
}


function main() {
  getCodeName
  getClientBase
  getModel
  getDistro
  getKernel
  getTotalPackages
  getShell
  getUptime
  getMemoryUsage
  getDiskUsage
  getInstalledTools
}

main

echo -e "\n"
echo -e "  ┏━━━━━━━━━━━━━━━━━━━━━━┓"
echo -e "  ┃ ${c1}A${c2}r${c7}b${c4}a${c5}k${c6}${c7}t${c1}i${c0}      ${c5}𖦹${c0}  ${c6}𖦹${c0}  ${c7}𖦹${c0} ┃  ${codename}${c5}@${c0}${client_base}"
echo -e "  ┣━━━━━━━━━━━━━━━━━━━━━━┫"
echo -e "  ┃                      ┃  ${c1}phone${c0}  ${model}"
echo -e "  ┃          ${c3}•${c8}_${c3}•${c0}         ┃  ${c2}os${c0}     ${os}"
echo -e "  ┃          ${c8}${c0}${c9}oo${c0}${c8}|${c0}         ┃  ${c7}ker${c0}    ${kernel}"
echo -e "  ┃         ${c8}/${c0}${c10} ${c0}${c8}'\'${c0}        ┃  ${c4}pkgs${c0}   ${packages}"
echo -e "  ┃        ${c9}(${c0}${c8}\_;/${c0}${c9})${c0}        ┃  ${c5}sh${c0}     ${shell}"
echo -e "  ┃                      ┃  ${c6}up${c0}    ${uptime}"
echo -e "  ┃   Arbakti ${c1}♡${c0} Linux    ┃  ${c1}ram${c0}    ${memory}"
echo -e "  ┃                      ┃  ${c2}disk${c0}   ${storage}"
echo -e "  ┗━━━━━━━━━━━━━━━━━━━━━━┛  ${c1}━━━${c2}━━━${c3}━━━${c4}━━━${c5}━━━${c6}━━━${c7}━━━"


# Warna ANSI untuk output yang lebih menarik
BLUE="\e[1;34m"
CYAN="\e[1;36m"
YELLOW="\e[1;33m"
GREEN="\e[1;32m"
RED="\e[1;31m"
RESET="\e[0m"

# Menampilkan informasi Installation
echo -e "${CYAN}Installed Tools:${RESET}"
echo -e "${installed_list}"

# Menampilkan informasi lainnya
echo -e "${CYAN}Uptime:${RESET} ${uptime}"
echo -e "     •_•       "
echo -e "     oo|       "
echo -e "    / '\'"
echo -e "   (\_;/)"
echo -e "${CYAN}Created By:${RESET} ${client_base}"
