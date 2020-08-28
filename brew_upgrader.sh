#!/usr/bin/env bash
#
# SCRIPT: brew_upgrader.sh
# AUTHOR: Fabio Scotto di Santolo <fabio.scottodisantolo@gmail.com>
# DATE:   28/08/2020
# REV:    1.0
#
# PLATFORM: MacOS
#
# REQUIREMENTS: brew
#
# PURPOSE: This script run Brew upgrade logging output on file.
#
# set -n   # Uncomment to check script syntax, without execution.
#          # NOTE: Do not forget to put the # comment back in or
#          #       the shell script will never execute!
# set -x   # Uncomment to debug this shell script
#
##########################################################
#         DEFINE FILES AND VARIABLES HERE
##########################################################

declare -r LOG_BASE_DIR="$HOME/Library/Logs"
declare -r LOG_DIR="$LOG_BASE_DIR/Brew"
declare -r TITLE_NOTIFY="Brew Upgrader"

##########################################################
#              DEFINE FUNCTIONS HERE
##########################################################

function _file_log_name
{
  local today
  today=$(date +"%Y%m%d")
  echo "brew_$today.log"
}

##########################################################
#               BEGINNING OF MAIN
##########################################################

if [[ ! -d "$LOG_DIR" ]]; then
  mkdir -p "$LOG_DIR"
fi

_file_name="$LOG_DIR/$(_file_log_name)"
if /usr/local/bin/brew upgrade >> "$_file_name" 2>&1; then
  osascript -e "display notification \"brew upgrade successful\" with title \"${TITLE_NOTIFY//\"/\\\"}\""
else
  osascript -e "display notification \"brew upgrade with errors for more details view $_file_name\" with title \"${TITLE_NOTIFY//\"/\\\"}\""
fi
# End of script
