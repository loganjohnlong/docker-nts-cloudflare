FROM alpine:latest

ARG BUILD_DATE

# first, a bit about this container
LABEL build_info="loganjohnlong/docker-nts-cloudflare build-date:- ${BUILD_DATE}"
LABEL maintainer="Logan Long"
LABEL documentation="https://github.com/loganjohnlong/docker-nts-cloudflare"

# install chrony
RUN apk add --no-cache chrony tzdata

# script to configure/startup chrony (ntp)
COPY assets/startup.sh /opt/startup.sh

# ntp port
EXPOSE 123/udp

# let docker know how to test container health
HEALTHCHECK CMD chronyc tracking || exit 1

# start chronyd in the foreground
ENTRYPOINT [ "/bin/sh", "/opt/startup.sh" ]
