FROM alpine:3.12.1

ENV BITCOIN_VERSION=24.1.0
ENV BITCOIN_URL=https://github.com/bitcoin-cash-node/bitcoin-cash-node/releases/download/v24.1.0/bitcoin-cash-node-24.1.0-x86_64-linux-gnu.tar.gz
ENV BITCOIN_SHA256=857b6b95c54d84756fdd86893cd238a9b100c471a0b235aca4246cca74112ca9
ENV GLIBC_VERSION=2.28-r0
ENV BITCOIN_DATA=/home/bitcoin/.bitcoin

WORKDIR /opt/bitcoin

RUN wget -qO /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
	&& wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
	&& wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk

RUN apk update \
	&& apk --no-cache add ca-certificates gnupg bash su-exec \
	&& apk --no-cache add glibc-${GLIBC_VERSION}.apk \
	&& apk --no-cache add glibc-bin-${GLIBC_VERSION}.apk

RUN set -ex \
	&& cd /tmp \
	&& wget -qO bitcoin.tar.gz "$BITCOIN_URL" \
	&& echo "$BITCOIN_SHA256  bitcoin.tar.gz" | sha256sum -c - \
	&& tar -xzvf bitcoin.tar.gz -C /usr/local --strip-components=1 --exclude=*-qt \
	&& rm -rf /tmp/* \
	&& rm -rf glibc-*

RUN adduser -S bitcoin
COPY ./scripts /scripts

EXPOSE 8332 8333 18332 18333 18443 18444
VOLUME ["/home/bitcoin/.bitcoin"]

ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["bitcoind"]
