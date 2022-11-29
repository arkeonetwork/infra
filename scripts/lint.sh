#!/usr/bin/env bash
set -euo pipefail

get_image_versions() {
  local CONF="$1"
  local NET="$1"
  (
    pushd arkeo-stack/
    helm dependency build
    popd
  ) &>/dev/null
  if [ "$CONF" == "chaosnet" ]; then
    NET="mainnet"
  fi
  helm template --values arkeo-stack/"$CONF".yaml \
    --set "global.net=$NET" \
    --set "midgard.enabled=true" arkeo-stack/ |
    grep -E '^\s*image:\s*[^\s]+'
}

check_charts() {
  local NET="$1"

  # Check for k8s definitions that aren't using explicit hashes.
  UNCHAINED=$(get_image_versions "$NET" | grep -v sha256 || true)

  if [ "$(printf "%s" "$UNCHAINED" | wc -l)" -ne 0 ]; then
    cat <<EOF
[ERR] Some container images are specified without an explicit hash in config $NET:

$UNCHAINED

EOF
    exit 1
  fi
}

for NET in stagenet chaosnet; do
  check_charts "$NET"
done

# Lint shell scripts.
find . -type f -name '*.*sh' | grep -v '^./ci/images/' |
  while read -r SCRIPT; do
    shellcheck --external-sources --exclude SC2034 "$SCRIPT"
    shfmt -i 2 -ci -d "$SCRIPT"
  done

# Lint the Helm charts.
find . -type f -name 'Chart.yaml' -printf '%h\n' |
  while read -r CHART_DIR; do
    pushd "$CHART_DIR"
    helm lint .
    popd
  done

# Check arkeo-stack with the various net configs.
for NET in stagenet chaosnet testnet; do
  helm lint --values arkeo-stack/"$NET".yaml arkeo-stack/
done

# TODO: enable yamllint - will be a major whitespace change across the charts.
# yamllint .
