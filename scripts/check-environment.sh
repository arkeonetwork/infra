#!/bin/bash

check_gnu() {
  $1 --version 2>/dev/null | head -n 1 | grep -q "GNU" && return
  echo "GNU $1 is required." >/dev/tty
  FAILED=1
}

check_gnu grep
check_gnu awk
check_gnu find
check_gnu sed

# check make is version 4+
if [ -z "$FAILED" ]; then
  MAKE_VERSION=$(make --version 2>/dev/null | head -n 1 | awk -F '[ \\.]' '{print $3}')
  if [ "$MAKE_VERSION" -lt 4 ]; then
    echo "make version 4+ is required." >/dev/tty
    FAILED=1
  fi
fi

if [ -n "$FAILED" ]; then
  if [ "$(uname)" == "Darwin" ]; then
    echo >/dev/tty
    echo "Mac OS can try the following to update native utilities to the latest GNU version (homebrew):" >/dev/tty
    echo "1. Run: brew install coreutils binutils diffutils findutils gnu-tar gnu-sed gawk grep make" >/dev/tty
    echo "2. Follow the instructions from the brew output to update your PATH so the GNU utilities are default" >/dev/tty
  fi
  echo >/dev/tty
  echo FAILED
fi
