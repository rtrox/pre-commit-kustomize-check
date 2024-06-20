FROM alpine:3.20.1 AS build_base


ENV KUSTOMIZE_VERSION=v4.5.7
ARG TARGETOS=linux
ARG TARGETARCH=amd64
ARG TARGETVARIANT

ENV KUSTOMIZE_BINARY_TAR=kustomize_${KUSTOMIZE_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz
ENV KUSTOMIZE_BINARY_URL=https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/${KUSTOMIZE_BINARY_TAR}
ENV KUSTOMIZE_CHECKSUMS_URL=https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/checksums.txt

RUN apk add curl

RUN curl -L --output checksums.txt ${KUSTOMIZE_CHECKSUMS_URL}
RUN  curl -L --output ${KUSTOMIZE_BINARY_TAR} ${KUSTOMIZE_BINARY_URL} \
  && grep $KUSTOMIZE_BINARY_TAR checksums.txt | sha256sum -c \
  && tar -xvzf kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz -C /tmp/ 

# Published Image
FROM alpine:3.20.1

COPY --from=build_base /tmp/kustomize /usr/local/bin/kustomize

RUN adduser kustomize -D \
  && apk add git openssh \
  && git config --global url.ssh://git@github.com/.insteadOf https://github.com/

RUN chmod +x /usr/local/bin/kustomize \
  && mkdir ~/.ssh \
  && ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

USER kustomize
WORKDIR /src

