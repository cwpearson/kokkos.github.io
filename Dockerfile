FROM ubuntu:22.04

ENV HUGO_VERSION=0.111.3
ENV HUGO_ENVIRONMENT=production
ENV HUGO_ENV=production
ENV DEBIAN_FRONTEND=noninteractive
ENV SASS_VERSION=1.97.3

RUN apt-get update && apt-get install -y \
    wget \
    git \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Install npm
RUN wget -O /tmp/node.xz https://nodejs.org/dist/v24.13.0/node-v24.13.0-linux-x64.tar.xz \
  && tar -xJf /tmp/node.xz -C /usr/local --strip-components=1 \
  && rm /tmp/node.xz

# Install Hugo Extended
RUN wget -O /tmp/hugo.deb https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb \
    && dpkg -i /tmp/hugo.deb \
    && rm /tmp/hugo.deb

# Install Dart Sass (standalone binary since snap doesn't work well in Docker)
RUN wget -O /tmp/dart-sass.tar.gz https://github.com/sass/dart-sass/releases/download/${SASS_VERSION}/dart-sass-${SASS_VERSION}-linux-x64.tar.gz \
    && tar -xzf /tmp/dart-sass.tar.gz -C /usr/local/bin --strip-components=1 \
    && rm /tmp/dart-sass.tar.gz

COPY package-lock.json .
COPY package.json .

# Set working directory
WORKDIR /src

# Default command
CMD ["hugo", "--gc", "--minify", "--baseURL", "https://kokkos.org/"]
