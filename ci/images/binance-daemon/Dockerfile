FROM ubuntu:20.04

ARG VERSION=0.10.2
ARG HOST_USER_UID=1000
ARG HOST_USER_GID=1000

ENV BNCHOME=/opt/bnbchaind

WORKDIR /release
RUN apt-get update && apt-get install -y --no-install-recommends curl jq ca-certificates unzip && \
  curl -LO https://github.com/bnb-chain/node/releases/download/v${VERSION}/linux_binary.zip && \
  curl -LO https://github.com/bnb-chain/node/releases/download/v${VERSION}/mainnet_config.zip && \
  curl -LO https://github.com/bnb-chain/node/releases/download/v${VERSION}/testnet_config.zip && \
  unzip linux_binary.zip && \
  unzip mainnet_config.zip && mv asset/mainnet . && \
  unzip testnet_config.zip && mv asset/testnet . && \
  rmdir asset && rm *.zip

COPY entrypoint.sh /usr/local/bin/

RUN set -ex && \
  chmod +x linux/* /usr/local/bin/entrypoint.sh && \
  mkdir -p "$BNCHOME" && \
  groupadd --gid "$HOST_USER_GID" bnbchaind && \
  useradd --uid "$HOST_USER_UID" --gid "$HOST_USER_GID" --shell /bin/bash --no-create-home bnbchaind && \
  chown -R bnbchaind:bnbchaind "$BNCHOME" /release

VOLUME ${BNCHOME}

# RPC service listen on port 27147 and P2P service listens on port 27146 by default.
# Prometheus is enabled on port 26660 by default, and the endpoint is /metrics.
EXPOSE 27146 27147 26656 26657 26660

ENTRYPOINT ["entrypoint.sh"]
