FROM mvdan/shfmt:v3.3.0-alpine@sha256:283d120dfb7db4166ed0df694b2b2c7402d8d33362ef3cd2384631c6d9731a78 AS shfmt

FROM debian:11-slim

# Build the Docker image used for running this repository's CI.

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    shellcheck curl gpg ca-certificates git

COPY --from=shfmt /bin/shfmt /usr/local/bin/

COPY scripts /tmp/scripts
RUN cd /tmp && \
    ./scripts/install-helm.sh && \
    rm -rf /tmp/scripts

WORKDIR /repo
