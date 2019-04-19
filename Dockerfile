FROM debian:9.5-slim
RUN mkdir -p /opt/teaspeak
RUN apt-get update -y &&\
	apt-get --no-install-recommends install -y wget curl ca-certificates &&\
	rm -rf /var/lib/apt/lists/*
WORKDIR /opt/teaspeak
RUN wget https://repo.teaspeak.de/server/linux/amd64_optimized/TeaSpeak-1.3.16-beta-2.tar.gz &&\
	tar -xzf TeaSpeak-1.3.16-beta-2.tar.gz &&\
	rm TeaSpeak-1.3.16-beta-2.tar.gz
RUN ./install_libnice.sh
RUN apt-get purge -y wget curl ca-certificates
COPY config.yml /opt/teaspeak/
COPY protocol_key.txt /opt/teaspeak/
EXPOSE 10011/tcp 30033/tcp 9987/udp 9987/tcp
VOLUME /opt/teaspeak/files /opt/teaspeak/database /opt/teaspeak/certs /opt/teaspeak/logs
CMD ./teastart_minimal.sh
