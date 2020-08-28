#!/usr/bin/env bash
#
# SCRIPT: install.sh
# AUTHOR: Fabio Scotto di Santolo <fabio.scottodisantolo@gmail.com>
# DATE:   28/08/2020
# REV:    1.0
#
# PLATFORM: MacOS
#
# set -n   # Uncomment to check script syntax, without execution.
#          # NOTE: Do not forget to put the # comment back in or
#          #       the shell script will never execute!
# set -x   # Uncomment to debug this shell script
#
##########################################################
#         DEFINE FILES AND VARIABLES HERE
##########################################################

declare -r LIBRARY_DIR="$HOME/Library"
declare -r SCRIPTS_INSTALL_DIR="$LIBRARY_DIR/Scripts"
declare -r PLIST_INSTALL_DIR="$LIBRARY_DIR/LaunchAgents"
declare -r SCRIPT_NAME="brew_upgrader.sh"
declare -r PLIST_FILE_NAME="local.brew.upgrade.plist"

##########################################################
#              DEFINE FUNCTIONS HERE
##########################################################

function _install
{
  # Copy agent and launchd configuration in LaunchAgents
  printf "Copy %s in %s...\n" "$SCRIPT_NAME" "$SCRIPTS_INSTALL_DIR"
  cp "$SCRIPT_NAME" "$SCRIPTS_INSTALL_DIR" 2>/dev/null
  printf "Copy %s in %s...\n" "$PLIST_FILE_NAME" "$PLIST_INSTALL_DIR"
  cp "$PLIST_FILE_NAME" "$PLIST_INSTALL_DIR" 2>/dev/null
  printf "...Done\n"

  local _plist_file="$PLIST_INSTALL_DIR/$PLIST_FILE_NAME"
  if [[ ! -e "$_plist_file" ]]; then
    echo "Error copy file in $_plist_file"
    exit 1
  fi

  local _script_file="$SCRIPTS_INSTALL_DIR/$SCRIPT_NAME"
  if [[ ! -e "$_script_file" ]]; then
    echo "Error copy file in $_script_file"
    exit 1
  fi

  chmod 700 "$_script_file"

  # Load plist in launchd
  printf "Load %s in launchd...\n" "$_plist_file"
  /bin/launchctl unload "$_plist_file" 2>/dev/null
  if /bin/launchctl load "$_plist_file"; then
    printf "Brew upgrader installed with success\n"
  else
    printf "Brew upgrader install failed\n"
  fi
}

function _uninstall
{
  /bin/launchctl unload "$PLIST_INSTALL_DIR/$PLIST_FILE_NAME" 2>/dev/null
  rm "$SCRIPTS_INSTALL_DIR/$SCRIPT_NAME" 2>/dev/null
  rm "$PLIST_INSTALL_DIR/$PLIST_FILE_NAME" 2>/dev/null
}

##########################################################
#               BEGINNING OF MAIN
##########################################################

case "$1" in
'clean'*)
  _uninstall
  ;;
*)
  printf "Pre cleaning...\n"
  _uninstall
  printf "...done.\n"
  _install
  ;;
esac

# End of script