#!/usr/bin/env bash

# VOTE_REMINDER_THRESHOLD is the number of votes for a mimir key at which we
# will start reminding the NO vote.
VOTE_REMINDER_THRESHOLD=10

# VOTE_REMINDER_BLACKLIST contains the set of mimir keys we will never prompt
# for a vote.
VOTE_REMINDER_BLACKLIST=$(
  cat <<EOF | awk -v q="\"" '{print q$1q}' | tr "\n" "," | sed 's/.$//'
CLOUDPROVIDERLIMIT
ENABLEUPDATEMEMOTERRA
HALTGAIACHAIN
KILLSWITCHSTART
RAGNAROK-TERRA-LUNA
RAGNAROK-TERRA-UST
EOF
)
