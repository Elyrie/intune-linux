#!/bin/bash

ERR_UNSUPPORTED_DISTRO=1
LOG_FILE="$HOME/.local/share/intune/compliance.log"

log_message() {
  echo "$(date) | $1" >>"$LOG_FILE"
}

script_exit() {
  log_message "$1"
  exit "$2"
}

write_last_run() {
  timestamp=$(date +%s)
  echo "$timestamp" >"$HOME/.local/share/intune/last_run"
}

check_last_run() {
  if [ -f "$HOME/.local/share/intune/last_run" ]; then
    date=$(date +%s)
    week_ago=$(date -d "1 week ago" +%s)
    last_run=$(head -n 1 "$HOME/.local/share/intune/last_run")
    if [ $date -lt $last_run ]; then
      return 0
    fi
    if [ $last_run -lt $week_ago ]; then
      return 0
    fi
    return 1
  else
    return 0
  fi
}

detect_distro() {
  if [ -f /etc/os-release ] || [ -f /etc/mariner-release ]; then
    . /etc/os-release
    DISTRO=$ID
    VERSION=$VERSION_ID
    VERSION_NAME=$VERSION_CODENAME
  elif [ -f /etc/redhat-release ]; then
    if [ -f /etc/oracle-release ]; then
      DISTRO="ol"
    elif [[ $(grep -o -i "Red\ Hat" /etc/redhat-release) ]]; then
      DISTRO="rhel"
    elif [[ $(grep -o -i "Centos" /etc/redhat-release) ]]; then
      DISTRO="centos"
    fi
    VERSION=$(grep -o "release .*" /etc/redhat-release | cut -d ' ' -f2)
  else
    script_exit "unable to detect distro" $ERR_UNSUPPORTED_DISTRO
  fi

  # change distro to ubuntu for linux mint support
  if [ "$DISTRO" == "linuxmint" ]; then
    DISTRO="ubuntu"
  fi

  if [ "$DISTRO" == "debian" ] || [ "$DISTRO" == "ubuntu" ]; then
    DISTRO_FAMILY="debian"
  elif [ "$DISTRO" == "rhel" ] || [ "$DISTRO" == "centos" ] || [ "$DISTRO" == "ol" ] || [ "$DISTRO" == "fedora" ] || [ "$DISTRO" == "amzn" ] || [ "$DISTRO" == "almalinux" ] || [ "$DISTRO" == "rocky" ]; then
    DISTRO_FAMILY="fedora"
  elif [ "$DISTRO" == "mariner" ]; then
    DISTRO_FAMILY="mariner"
  elif [ "$DISTRO" == "sles" ] || [ "$DISTRO" == "sle-hpc" ] || [ "$DISTRO" == "sles_sap" ]; then
    DISTRO_FAMILY="sles"
  else
    script_exit "unsupported distro $DISTRO $VERSION" $ERR_UNSUPPORTED_DISTRO
  fi
}

mkdir -p $HOME/.local/share/intune
log_message "| Starting compliance script"

check_last_run
last_run_bool=$?
if [ $last_run_bool -eq 0 ]; then
  detect_distro
  log_message "|   + Last run check failed or more than a week ago, running update check"
  if [ "$DISTRO_FAMILY" == "debian" ]; then
    upgradeable=$(apt -qq list --upgradeable 2>/dev/null | wc -l)
    phased=$(apt show -a $(apt list --upgradable 2>&1 | grep / | cut -d/ -f1) 2>/dev/null | grep Phased | wc -l)

    if [ $upgradeable -eq $phased ]; then
      updates_installed="true"
      write_last_run
    else
      updates_installed="false"
    fi
  elif [ "$DISTRO_FAMILY" == "fedora" ]; then
    dnf -q check-update --security
    if [ $? -eq 100 ]; then
      updates_installed="false"
    else
      updates_installed="true"
      write_last_run
    fi
  else
    updates_installed="false"
  fi

  log_message "|   + Updates installed: [$updates_installed]"

  echo -n "{"
  echo -n "\"updates_installed\": $updates_installed"
  echo "}"
else
  log_message "|   + Last run less than a week ago, skipping update check"
  echo -n "{"
  echo -n "\"updates_installed\": true"
  echo "}"
fi

log_message "| Ending compliance script"
