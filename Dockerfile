FROM golang:alpine3.13

ENV TERRAFORM_VERSION=0.15.0
ENV TERRAGRUNT_VERSION=0.29.0
ENV TFLINT_VERSION=0.27.0
ENV TERRASCAN_VERSION=1.5.0
ENV CHECKOV_VERSION=2.0.69

VOLUME ["/data"]

WORKDIR /data

ENTRYPOINT ["/usr/bin/terraform"]

CMD ["--help"]

RUN apk update && \
    apk add curl jq python3 bash ca-certificates git openssl unzip wget && \
    cd /tmp && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin && \
    curl -L -o /tmp/tflint.zip https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip && \
    unzip -u /tmp/tflint.zip -d /tmp/ && \
    mkdir -p /usr/local/bin && \
    install -b -c -v /tmp/tflint /usr/local/bin/ && \
    curl -L -o /usr/local/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 && \
    chmod +x /usr/local/bin/terragrunt && \
    go get golang.org/x/tools/cmd/goimports && \
    python3 -m ensurepip --default-pip && \
    pip3 install --upgrade pip && pip3 install --upgrade setuptools && \
    pip3 install checkov==${CHECKOV_VERSION} && \
    curl -L -o /tmp/terrascan.tar.gz https://github.com/accurics/terrascan/releases/download/v${TERRASCAN_VERSION}/terrascan_${TERRASCAN_VERSION}_Linux_x86_64.tar.gz && \
    tar -xzf /tmp/terrascan.tar.gz terrascan && \
    install terrascan /usr/local/bin/ && \
    rm -f terrascan* && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /var/tmp/*

COPY ./hooks ./hooks

RUN chmod +x ./hooks/*