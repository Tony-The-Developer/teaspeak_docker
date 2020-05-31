FROM debian:10-slim
ARG VERSION=1.4.14
ENV LOG_LEVEL 3
ENV FILE_PORT 30033
ENV QUERY_PORT 10011
ENV DEFAULT_PORT 9987
ENV WEB_ENABLED 1
ENV MUSIC_ENABLED 1
ENV ALLOW_WEBLIST 0
ENV EXPERIMENTAL_31 1
RUN mkdir -p /opt/teaspeak
WORKDIR /opt/teaspeak
RUN useradd -M teaspeak
RUN apt-get update -y &&\
        apt-get --no-install-recommends install -y wget curl unzip ca-certificates python &&\
        wget --no-check-certificate https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl &&\
        chmod a+rx /usr/local/bin/youtube-dl &&\
        wget https://repo.teaspeak.de/server/linux/amd64_stable/TeaSpeak-$VERSION.tar.gz &&\
        tar -xzf TeaSpeak-$VERSION.tar.gz &&\
        rm TeaSpeak-$VERSION.tar.gz &&\
        ./install_music.sh install &&\
        chown -R teaspeak:teaspeak /opt/teaspeak &&\
        apt-get purge -y wget curl unzip &&\
        rm -r tmp_files &&\
        rm -rf /var/lib/apt/lists/*
COPY protocol_key.txt /opt/teaspeak/
COPY docker-entrypoint /usr/local/bin/
EXPOSE 10011/tcp 30033/tcp 9987/udp 9987/tcp
VOLUME /opt/teaspeak/files /opt/teaspeak/database /opt/teaspeak/certs /opt/teaspeak/logs
ENTRYPOINT ["docker-entrypoint"]
