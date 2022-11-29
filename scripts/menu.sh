#!/usr/bin/env bash
# set -eu

MENU_LOG=/tmp/menu.sh.log
MENU_INDEX=-1
MENU_COUNT=0
MENU_ACTIVE=""
MENU_OPTIONS=()

MENU_COLOR_OPTIONS=${MENU_COLOR_OPTIONS:-2}
MENU_COLOR_ACTIVE=${MENU_COLOR_ACTIVE:-0}
MENU_COLOR_ARROW=${MENU_COLOR_ARROW:-36}

menu.cursor_on() {
  printf >&2 "\e[?25h"
}
# Restore the cursor no matter how the script exits.
trap menu.cursor_on EXIT

menu.cursor_off() {
  printf >&2 "\e[?25l"
}

menu.cleanup() {
  # echo -e "\033[$((MENU_COUNT + 1))A"
  tput cnorm >/dev/tty
  stty "$_stty" <>/dev/tty
}

_stty=$(stty -g </dev/tty)

### Prints the options
menu.show() {
  local counter=0
  for i in "${MENU_OPTIONS[@]}"; do
    if [ "$i" = "$MENU_SELECTED" ]; then
      MENU_INDEX=$counter
      printf >&2 "  \e[7m %s \e[27m\n" "${i}"
    else
      printf >&2 "  \e[2m %s \e[22m\n" "${i}"
    fi
    counter=$((counter + 1))
  done
}

### Selects an active option by index, clears the screen and prints the options
menu.select() {
  local index=$1

  ### Boundary checks
  if [ "$index" -ge $MENU_COUNT ]; then
    # echo "Max reached" >> $MENU_LOG
    index=$((MENU_COUNT - 1))
  elif [ $index -lt 0 ]; then
    # echo "Min reached" >> $MENU_LOG
    index=0
  fi

  ### This clears <MENU_COUNT> lines
  echo -e "\033[$((MENU_COUNT + 1))A"
  MENU_SELECTED="${MENU_OPTIONS[index]}"
  menu.show
}

menu() {
  MENU_SELECTED=${1:-}
  MENU_COUNT=$(($# - 1))
  MENU_OPTIONS=("${@:2}")

  ESCAPE_SEQ=$'\033'
  ARROW_UP=$'A'
  ARROW_DOWN=$'B'

  menu.cursor_off
  menu.show
  while true; do
    read -rsn 1 key1
    case "$key1" in
      "$ESCAPE_SEQ")
        read -rsn 1 -t 1 key2
        if [[ "$key2" == "[" ]]; then
          read -rsn 1 -t 1 key3
          case "$key3" in
            "$ARROW_UP")
              if [[ $MENU_INDEX -eq 0 ]]; then
                menu.select $MENU_COUNT
              else
                menu.select $((MENU_INDEX - 1))
              fi
              ;;
            "$ARROW_DOWN")
              if [[ $MENU_INDEX -eq $((MENU_COUNT - 1)) ]]; then
                menu.select 0
              else
                menu.select $((MENU_INDEX + 1))
              fi
              ;;
          esac
        fi
        ;;

      "q")
        unset MENU_SELECTED
        menu.cleanup
        return
        ;;
      "")
        export MENU_SELECTED
        menu.cleanup
        return
        ;;
    esac
  done
}
