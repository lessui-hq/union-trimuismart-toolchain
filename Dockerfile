# Download buildroot in a modern image that has working TLS
FROM debian:bookworm-slim AS downloader
RUN apt-get update && apt-get install -y curl
RUN curl -L -o /buildroot-2016.05.tar.gz https://buildroot.org/downloads/buildroot-2016.05.tar.gz

FROM debian/eol:stretch-slim
ENV DEBIAN_FRONTEND=noninteractive
COPY --from=downloader /buildroot-2016.05.tar.gz /root/

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get -y update && apt-get -y install \
	bc \
	build-essential \
	bzip2 \
	bzr \
	cmake \
	cmake-curses-gui \
	cpio \
	git \
	libncurses5-dev \
	locales \
	make \
	rsync \
	scons \
	tree \
	unzip \
	wget \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/workspace
WORKDIR /root

COPY support .
RUN ./build-toolchain.sh
RUN cat ./setup-env.sh >> .bashrc

VOLUME /root/workspace
WORKDIR /root/workspace

CMD ["/bin/bash"]