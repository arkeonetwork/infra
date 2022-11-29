#!/bin/sh

# check <values-file> <network>
check() {
  VALUES_FILE="$1"
  EXPECTED_NETWORK="$2"

  IMAGE=$(yq -r '"registry.gitlab.com/thorchain/arkeo:"+.global.tag+"@sha256:"+.global.hash' "$VALUES_FILE")
  VERSION=$(yq -r '.global.tag|split("-")[-1]' "$VALUES_FILE")
  IMAGE_VERSION_LONG=$(docker run --rm "$IMAGE" arkeo version --long)

  IMAGE_VERSION=$(echo "$IMAGE_VERSION_LONG" | yq -r '.version')
  if [ "$IMAGE_VERSION" != "$VERSION" ]; then
    echo "Error: $IMAGE"
    echo "Version mismatch: $IMAGE_VERSION != $VERSION"
    exit 1
  fi

  IMAGE_NETWORK=$(echo "$IMAGE_VERSION_LONG" | yq -r '.build_tags')
  if [ "$IMAGE_NETWORK" != "$EXPECTED_NETWORK" ]; then
    echo "Error: $IMAGE"
    echo "Network mismatch: $IMAGE_NETWORK != $EXPECTED_NETWORK"
    exit 1
  fi

  IMAGE_COMMIT=$(echo "$IMAGE_VERSION_LONG" | yq -r '.commit')
  if [ "$IMAGE_NETWORK" = "chaosnet-multichain" ]; then
    # check that the tag explicitly matches the image commit
    REPO_COMMIT=$(curl -s "https://gitlab.com/api/v4/projects/13422983/repository/commits/v$VERSION" | jq -r .id)
    if [ "$IMAGE_COMMIT" != "$REPO_COMMIT" ]; then
      echo "Warning: $IMAGE"
      echo "Commit mismatch: image=$IMAGE_COMMIT tag=$REPO_COMMIT"
      echo
    fi
  else
    # check that the version on the repo commit matches
    REPO_VERSION=$(curl -s "https://gitlab.com/thorchain/arkeo/-/raw/$IMAGE_COMMIT/version")
    if [ "$IMAGE_VERSION" != "$REPO_VERSION" ]; then
      echo "Error: $IMAGE"
      echo "Image Commit: $IMAGE_COMMIT"
      echo "Image Version: $IMAGE_VERSION"
      echo "Repo Version: $REPO_VERSION"
      exit 1
    fi
  fi

  echo "Image $IMAGE is valid"
  echo "$IMAGE_VERSION_LONG" | head -n5
  echo
}

check arkeo-stack/chaosnet.yaml chaosnet-multichain
check arkeo-stack/stagenet.yaml stagenet
