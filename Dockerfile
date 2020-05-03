FROM hashicorp/packer:full
MAINTAINER "Gerhard Lausser <gerhard.lausser@consol.de>"

RUN apk add --update ansible
ENV PACKER_DEV=1
RUN apk add --no-cache git bash openssl ca-certificates
RUN go get github.com/mitchellh/gox
RUN go get github.com/lausser/packer
WORKDIR $GOPATH/src/github.com/lausser/packer
RUN git checkout cloud-init
RUN /bin/bash scripts/build.sh
RUN cp $GOPATH/bin/packer /bin
WORKDIR /
ENTRYPOINT ["/bin/packer"]
