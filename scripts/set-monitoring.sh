#!/usr/bin/env bash

set -e

source ./scripts/core.sh

echo
echo "=> Select a Monitoring service to configure"
menu pagerduty-and-deadman pagerduty-and-deadman pagerduty-only
SERVICE=$MENU_SELECTED

line_num=$(grep -ni pager prometheus/values.yaml | grep -i dead | grep -vi slack | cut -d: -f1)
((line_num++))
sed -n "$line_num,/^$/p" prometheus/values.yaml >prometheus/tmp.yaml
sed -i "s/^# //" prometheus/tmp.yaml

echo
read -r -p "Insert the PagerDuty key: " pager_key
sed -i "s/\"XXX Insert PagerDuty Integration Key here XXX\"/$pager_key/" prometheus/tmp.yaml

if [ "$SERVICE" = "pagerduty-and-deadman" ]; then
  read -r -p 'Insert the Dead Mans Snitch URL: ' deadman_url
  deadman_url_esc=$(echo "$deadman_url" | sed -e 's/[/]/\\\//g')
  sed -i "s/\"XXX Insert Dead Man's Snitch URL here XXX\"/$deadman_url_esc/" prometheus/tmp.yaml
else
  sed -i "/webhook_configs/ s?^?#?" ./prometheus/tmp.yaml
  sed -i "/url/ s?^?#?" ./prometheus/tmp.yaml
fi

sed -i "$line_num r prometheus/tmp.yaml" prometheus/values.yaml
rm prometheus/tmp.yaml

echo
echo "Prometheus stack will be recreated to implement the changes, ${boldyellow}existing custom configuration will be overwritten${reset}."
confirm

source ./scripts/install-prometheus.sh
