FROM python:2-alpine

# Install packages
RUN apk update && apk add --no-cache \
    ca-certificates \
    curl \
    openssl \
    tar \
    gnupg \
    bash \
    postgresql-client \
    mysql-client \
    busybox-extras
RUN update-ca-certificates

# Install kubectl
RUN curl -L -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.9.3/bin/linux/amd64/kubectl
RUN chmod a+x /usr/local/bin/kubectl

# See https://stackoverflow.com/questions/34729748/installed-go-binary-not-found-in-path-on-alpine-linux-docker/35613430
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

# Install kubesec
RUN curl -L -o /usr/local/bin/kubesec https://github.com/shyiko/kubesec/releases/download/0.6.1/kubesec-0.6.1-linux-amd64
RUN chmod a+x /usr/local/bin/kubesec

# Install AWS Cli
RUN pip install awscli

# Install jq
RUN curl -L -o /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
RUN chmod a+x /usr/local/bin/jq

# Install yq
RUN curl -L -o /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/1.15.0/yq_linux_amd64
RUN chmod a+x /usr/local/bin/yq

# Install promtool
COPY --from=quay.io/prometheus/prometheus:latest /bin/promtool /usr/local/bin/promtool

# Install scripts
COPY ./scripts/*.sh /usr/local/bin/
RUN mkdir -p /sqlscripts
COPY ./anonymise.sql /sqlscripts/anonymise.sql
