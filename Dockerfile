#FROM postgres:9.5
FROM ubuntu:16.04

ENV ACCEPT_EULA=Y

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
	apt-utils \
        apt-transport-https \
        ca-certificates \
        curl \
        wget \
        libcurl3 \
        libgcc1 \
        libgssapi-krb5-2 \
        liblttng-ust0 \
        libssl1.0.0 \
        libunwind8 \
        libuuid1 \
        zlib1g \
        bzr \
        git \
        procps \
        autoconf \
        automake \
        bzip2 \
        file \
        g++ \
        gcc \
        imagemagick \
        libbz2-dev \
        libcurl4-openssl-dev \
        libdb-dev \
        libevent-dev \
        libffi-dev \
        libgdbm-dev \
        libgeoip-dev \
        libglib2.0-dev \
        libjpeg-dev \
        libkrb5-dev \
        liblzma-dev \
        libmagickcore-dev \
        libmagickwand-dev \
        libmysqlclient-dev \
        libncurses-dev \
        libpng-dev \
        libpq-dev \
        libreadline-dev \
        libstdc++6 \
        libsqlite3-dev \
        libssl-dev \
        libtool \
        libwebp-dev \
        libxml2-dev \
        libxslt-dev \
        libyaml-dev \
        make \
        patch \
	telnet \
        vim \
        xz-utils \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN add-apt-repository -y ppa:ubuntu-wine/ppa
RUN apt-get update

RUN apt-get install -y g++-4.9
RUN apt-get update

RUN sh -c 'echo "deb [arch=amd64] http://security.ubuntu.com/ubuntu trusty-security main" > /etc/apt/sources.list.d/ubuntu14.list'
RUN apt-get update
RUN apt-get install -y libicu52

RUN sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/mssql-ubuntu-xenial-release/ xenial main" > /etc/apt/sources.list.d/mssqlpreview.list'
RUN apt-key adv --keyserver apt-mo.trafficmanager.net --recv-keys 417A0893
RUN apt-get update
RUN apt-get install -y msodbcsql unixodbc-dev-utf16
#for silent install use ACCEPT_EULA=Y apt-get install msodbcsql
RUN apt-get install -y unixodbc-dev-utf16 #this step is optional but recommended*

RUN wget https://packages.microsoft.com/keys/microsoft.asc
RUN apt-key add microsoft.asc
RUN wget -O /etc/apt/sources.list.d/msprod.list https://packages.microsoft.com/config/ubuntu/16.04/prod.list
RUN apt-get update
RUN apt-get install -y mssql-tools

RUN curl -sSL -o dotnet.tar.gz https://go.microsoft.com/fwlink/?LinkID=835021 --output dotnet.tar.gz \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
	
RUN groupadd --gid 1000 node \
  && useradd --uid 1000 --gid node --shell /bin/bash --create-home node

# gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 6.9.1
ENV POSTGRES_PASSWORD postgres

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs


ARG source=.
WORKDIR /app
COPY $source .

RUN cd src && dotnet restore && dotnet build **/**/project.json

RUN cd src/SimplCommerce.WebHost && npm install && npm install --global gulp-cli && gulp copy-modules

#RUN cd src/SimplCommerce.WebHost && dotnet ef database update

RUN chmod +x /app/docker-entrypoint.sh
ENTRYPOINT ["/app/docker-entrypoint.sh"]
