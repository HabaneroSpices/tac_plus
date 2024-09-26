#!/bin/sh
#
set -e

USER_ID=${PUID:-0}
GROUP_ID=${PGID:-0}
TAC_PLUS_CFG=${TAC_PLUS_CONFIG:-"/etc/tac_plus/tac_plus.cfg"}

echo -e "\tUser:\t$USER_ID:$GROUP_ID"

echo -e "\tConfig:\t$TAC_PLUS_CFG"

if ! /usr/local/sbin/tac_plus -P $TAC_PLUS_CFG; then
  echo -e "\tThere is an error in the tac_plus configuration file - Exiting..."
fi

echo -e "\n\tStarting tac_plus..."

exec /usr/local/sbin/tac_plus -f $TAC_PLUS_CFG
