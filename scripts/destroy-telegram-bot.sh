#!/usr/bin/env bash

source ./scripts/core.sh

get_node_info_short

echo "=> Destroying Telegram bot in $boldgreen$NAME$reset"
confirm
helm delete telegram-bot -n "$NAME"
