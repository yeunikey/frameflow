# Community MinIO is distributed as source. Build official, pinned release archives.
FROM golang:1.24-alpine@sha256:8bee1901f1e530bfb4a7850aa7a479d17ae3a18beb6e09064ed54cfd245b7191 AS minio-build
RUN apk add --no-cache ca-certificates curl git
WORKDIR /src
ARG MINIO_RELEASE=RELEASE.2025-10-15T17-29-55Z
ARG MINIO_SOURCE_SHA256=be6d0bd3696c3a13a35f02d3a0280b64319c67918b4501c5c3d87f96d000085c
RUN curl -fsSL "https://codeload.github.com/minio/minio/tar.gz/refs/tags/${MINIO_RELEASE}" -o source.tar.gz \
    && echo "${MINIO_SOURCE_SHA256}  source.tar.gz" | sha256sum -c - \
    && tar -xzf source.tar.gz --strip-components=1 && rm source.tar.gz
RUN CGO_ENABLED=0 go build -trimpath -o /out/minio .

FROM golang:1.24-alpine@sha256:8bee1901f1e530bfb4a7850aa7a479d17ae3a18beb6e09064ed54cfd245b7191 AS mc-build
RUN apk add --no-cache ca-certificates curl git
WORKDIR /src
ARG MC_RELEASE=RELEASE.2025-08-13T08-35-41Z
ARG MC_SOURCE_SHA256=29db22500374169a43951c7cef09daf19e7291ea5ba00ac10f321371b0a35b32
RUN curl -fsSL "https://codeload.github.com/minio/mc/tar.gz/refs/tags/${MC_RELEASE}" -o source.tar.gz \
    && echo "${MC_SOURCE_SHA256}  source.tar.gz" | sha256sum -c - \
    && tar -xzf source.tar.gz --strip-components=1 && rm source.tar.gz
RUN CGO_ENABLED=0 go build -trimpath -o /out/mc .

FROM alpine:3.22@sha256:d406446bc05b82480756ce8f1287964d28768c23955fa9480d2a74a2eae7a654 AS runtime
RUN apk add --no-cache ca-certificates curl \
    && addgroup -g 10001 minio && adduser -D -u 10001 -G minio minio \
    && mkdir -p /data /home/minio/.mc && chown -R minio:minio /data /home/minio
ENV HOME=/home/minio
USER minio

FROM runtime AS server
COPY --from=minio-build /out/minio /usr/local/bin/minio
EXPOSE 9000 9001
ENTRYPOINT ["minio"]
CMD ["server", "/data", "--address", ":9000", "--console-address", ":9001"]

FROM runtime AS client
USER root
RUN apk add --no-cache gettext-envsubst
USER minio
COPY --from=mc-build /out/mc /usr/local/bin/mc
ENTRYPOINT ["mc"]
