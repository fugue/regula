FROM python:3.9.2-alpine3.13

# We need bash for the main regula script since it uses arrays.
# We need git to support terraform modules
RUN apk add --update bash git && rm -rf /var/cache/apk/*

# Install OPA.
ARG OPA_VERSION=0.26.0
RUN wget -O '/usr/local/bin/opa' \
        "https://github.com/open-policy-agent/opa/releases/download/v${OPA_VERSION}/opa_linux_amd64" &&\
    chmod +x '/usr/local/bin/opa'

# Install terraform.
ARG TERRAFORM_VERSION=0.14.7
ENV TF_IN_AUTOMATION=true
RUN wget -O "/tmp/terraform-${TERRAFORM_VERSION}.zip" \
        "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip -d '/usr/local/bin' "/tmp/terraform-${TERRAFORM_VERSION}.zip" &&\
    rm "/tmp/terraform-${TERRAFORM_VERSION}.zip"

# Install cfn-flip
ARG CFNFLIP_VERSION=1.2.3
RUN pip install "cfn-flip==${CFNFLIP_VERSION}"

# Update regula files
RUN mkdir -p /opt/regula
COPY lib /opt/regula/lib
COPY rules /opt/regula/rules
COPY bin/regula /usr/local/bin

ENTRYPOINT ["regula", "-d", "/opt/regula"]
