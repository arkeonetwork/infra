########################################################################################
# Build
########################################################################################

FROM golang:1.18-bullseye AS build

WORKDIR /app

ARG SRC_COMMIT=5db8fcc9a229730f5115bed82d0f85b6db7184b4
ARG TAG=v7.1.0
RUN git init && \
  git remote add origin https://github.com/cosmos/gaia && \
  git fetch --depth 1 origin $TAG && \
  git checkout $SRC_COMMIT && \
  make build


########################################################################################
# Deploy
########################################################################################

FROM debian:bullseye-slim
RUN apt-get update && apt-get install --no-install-recommends -y curl jq && \
  rm -rf /var/lib/apt/lists/*
COPY --from=build /app/build/gaiad /gaiad
COPY entrypoint.sh /entrypoint.sh
COPY app.toml /etc/gaia/app.toml
CMD ["/entrypoint.sh"]
