# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: Nodejs
# Minimum Panel Version: 1.3.1
#
# Initially based upon:
# https://github.com/GoogleChrome/puppeteer/blob/master/docs/troubleshooting.md#running-puppeteer-in-docker
# ----------------------------------

FROM openjdk:17-jdk-alpine

MAINTAINER sub1to Software

# Pterodactyl dependencies
RUN apk add --no-cache --update curl ca-certificates openssl git tar bash sqlite fontconfig \

# Chrome dependencies
    && apt update \
    && apt install -y wget gnupg ca-certificates procps libxss1 \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt update \
    # We install Chrome to get all the OS level dependencies, but Chrome itself
    # is not actually used as it's packaged in the node puppeteer library.
    # Alternatively, we could could include the entire dep list ourselves
    # (https://github.com/puppeteer/puppeteer/blob/master/docs/troubleshooting.md#chrome-headless-doesnt-launch-on-unix)
    # but that seems too easy to get out of date.
    && apt install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/* \
    && wget --quiet https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -O /usr/sbin/wait-for-it.sh \
    && chmod +x /usr/sbin/wait-for-it.sh \

    # Create container user
    && adduser --disabled-password --home /home/container container

# Install Puppeteer under /node_modules so it's available system-wide
ADD package.json package-lock.json /
RUN npm install

USER container
ENV  USER=container HOME=/home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]