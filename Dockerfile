FROM hashicorp/packer:light
MAINTAINER "Gerhard Lausser <gerhard.lausser@consol.de>"

RUN apk add --update ansible
