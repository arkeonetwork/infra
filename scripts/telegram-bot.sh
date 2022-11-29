#!/usr/bin/env bash

set -e

source ./scripts/core.sh

get_node_info_short

echo "=> Deploying Telegram bot in $boldgreen$NAME$reset"
echo "Start a Telegram chat with BotFather, click start, then send /newbot command."
echo -n "Enter Telegram bot token: " && read -r TOKEN
helm upgrade -n "$NAME" --install telegram-bot ./telegram-bot \
  --set telegramToken="$TOKEN" \
  --set net="$NET"
