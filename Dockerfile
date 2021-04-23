FROM alpine:3.13

ENV TERRAFORM_VERSION=0.15.0
ENV TFLINT_VERSION=v0.27.0

VOLUME ["/data"]

WORKDIR /data

ENTRYPOINT ["/usr/bin/terraform"]

CMD ["--help"]

RUN apk update && \
    apk add curl jq python3 bash ca-certificates git openssl unzip wget && \
    cd /tmp && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin && \
    curl -L -o /tmp/tflint.zip https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/tflint_linux_amd64.zip && \
    unzip -u /tmp/tflint.zip -d /tmp/ && \
    mkdir -p /usr/local/bin && \
    install -b -c -v /tmp/tflint /usr/local/bin/ && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /var/tmp/*

COPY ./hooks ./hooks

RUN chmod +x ./hooks/*

#ENV PATH = $PATH:/usr/local/google-cloud-sdk/bin/

ARG VCS_REF

#LABEL org.label-schema.vcs-ref=$VCS_REF \
#    org.label-schema.vcs-url="https://github.com/broadinstitute/docker-terraform"
