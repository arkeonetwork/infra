#!/usr/bin/env bash
# Given a Docker image name, enumerate the published tags -> full hashes.
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <gitlab registry image name> [<specific tag>]"
  exit 1
fi

IMAGE="$1"
SPECIFIC_TAG="${2:-}"

get_auth_token() {
  IMAGE="$1"
  TOKEN_URI="https://gitlab.com/jwt/auth"
  curl --silent --get \
    --data-urlencode "service=container_registry" \
    --data-urlencode "scope=repository:$IMAGE:pull" \
    $TOKEN_URI | jq --raw-output '.token'
}

get_tags() {
  IMAGE="$1"

  TOKEN=$(get_auth_token "$IMAGE")
  LINK="/v2/$IMAGE/tags/list"

  # Iterate on the list until no more 'Link: ...' HTTP header is present in the response.
  while [ -n "$LINK" ]; do
    LIST_URI="https://registry.gitlab.com$LINK"
    RESP=$(curl -i --silent --get -H "Accept: application/json" -H "Authorization: Bearer $TOKEN" "$LIST_URI")
    LINK=$(printf "%s" "$RESP" | awk '/^[Ll]ink:/ { print $2 }' | sed -e 's/^<//' -e 's/>;$//')

    # Cut off the headers and parse the JSON body.
    printf "%s" "$RESP" |
      sed '1,/^\r\{0,1\}$/d' |
      jq --raw-output '.tags[]'
  done
}

get_manifest() {
  IMAGE="$1"
  TAG="$2"

  TOKEN=$(get_auth_token "$IMAGE")

  MANIFEST_URI="https://registry.gitlab.com/v2/$IMAGE/manifests/$TAG"
  curl -i --silent -H "Accept: application/json" -H "Authorization: Bearer $TOKEN" "$MANIFEST_URI" |
    awk 'BEGIN{IGNORECASE=1} /^Docker-Content-Digest:/ { print $2 }' | sed -e 's/[[:space:]]//g'
}

if [ -z "$SPECIFIC_TAG" ]; then
  TAGS=$(get_tags "$IMAGE")
else
  TAGS="$SPECIFIC_TAG"
fi

printf '['

FIRST=""
# shellcheck disable=SC2068
for TAG in ${TAGS[@]}; do
  if [ -z "$FIRST" ]; then
    FIRST="n"
  else
    printf ','
  fi
  SHA=$(get_manifest "$IMAGE" "$TAG")
  printf '\n  {"tag": "%s", "hash": "%s"}' "$TAG" "$SHA"
done

printf '\n]\n'
