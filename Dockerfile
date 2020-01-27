FROM alpine:latest

LABEL "com.github.actions.name"="Hugo Build and Deploy"

LABEL maintainer="benjamin@bckr.me"

# Configure Go
ENV GOROOT /usr/lib/go
ENV GOPATH /opt/go
ENV PATH /opt/go/bin:$PATH

RUN apk add --no-cache git make musl-dev go g++ rsync bash openssh bind-tools

RUN mkdir -p "/root/.ssh" && chmod 700 "/root/.ssh"

RUN mkdir -p /opt/hugo && cd /opt/hugo && \
    git clone https://github.com/gohugoio/hugo.git && \
    cd hugo && \
    go install --tags extended && \
    cd /root && rm -rf /opt/hugo

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
