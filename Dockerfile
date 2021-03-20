# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: Nodejs
# Minimum Panel Version: 1.3.1
# ----------------------------------
FROM alpine:edge

MAINTAINER sub1to Software

# Pterodactyl dependencies
RUN apk add --no-cache --update curl ca-certificates openssl git tar bash sqlite fontconfig

# Installs latest Chromium (89) package.
RUN apk add --no-cache \
      chromium \
      nss \
      freetype \
      freetype-dev \
      harfbuzz \
      ca-certificates \
      ttf-freefont \
      nodejs \
      yarn

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Puppeteer v6.0.0 works with Chromium 89.
RUN yarn add puppeteer@6.0.0

# Add user so we don't need --no-sandbox.
RUN addgroup -S container && adduser -S -g container container -h /home/container \
    && mkdir -p /home/container/Downloads /app \
    && chown -R container:container /home/container \
    && chown -R container:container /app

# Run everything after as non-privileged user.
USER container

ENV  USER=container HOME=/home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]