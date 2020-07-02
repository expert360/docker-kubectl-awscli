FROM python:2-alpine

RUN apk update && \
  apk add --no-cache \
  bash \
  ca-certificates \
  curl \
  openssl \
  tar \
  gnupg \
  postgresql-client \
  mysql-client \
  grep \
  busybox-extras \
  xz \
  && update-ca-certificates \
  && rm /usr/bin/[[

# Install kubectl
RUN curl -sL https://storage.googleapis.com/kubernetes-release/release/v1.18.5/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && chmod a+x /usr/local/bin/kubectl

# Install a specific version of kustomize that we use
RUN curl -sL https://github.com/kubernetes-sigs/kustomize/releases/download/v1.0.11/kustomize_1.0.11_linux_amd64 -o /usr/local/bin/kustomize && chmod 755 /usr/local/bin/kustomize

# Install aws-iam-authenticator
RUN curl -sL https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.3.0/heptio-authenticator-aws_0.3.0_linux_amd64 -o /usr/local/bin/aws-iam-authenticator && chmod a+x /usr/local/bin/aws-iam-authenticator

# Install awscli
RUN pip install awscli

# Install jq
RUN curl -sL https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o /usr/local/bin/jq && chmod a+x /usr/local/bin/jq

# Install yq
RUN curl -sL https://github.com/mikefarah/yq/releases/download/1.15.0/yq_linux_amd64 -o /usr/local/bin/yq && chmod a+x /usr/local/bin/yq

# Install scripts
COPY ./scripts/*.sh /usr/local/bin/

# Install shfmt
COPY --from=jamesmstone/shfmt:latest /shfmt /usr/local/bin/shfmt

# Install shellcheck
RUN curl -sL https://storage.googleapis.com/shellcheck/shellcheck-stable.linux.x86_64.tar.xz -o shellcheck-stable.tar.xz \
  && tar xvf shellcheck-stable.tar.xz \
  && mv ./shellcheck-stable/shellcheck /usr/local/bin/shellcheck \
  && chmod a+x /usr/local/bin/shellcheck

# Install sops
RUN curl -sL https://github.com/mozilla/sops/releases/download/3.0.5/sops-3.0.5.linux -o /usr/local/bin/sops && chmod a+x /usr/local/bin/sops
