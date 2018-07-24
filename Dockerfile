FROM i386/ubuntu:latest

# Set default environment variables
ENV SERVER_HOSTNAME The best CSGO Server EVER!
ENV SERVER_PASSWORD changeme
ENV SERVER_RCON_PASSWORD changeme
ENV SERVER_IP 0.0.0.0
ENV SERVER_PORT 27015
ENV SERVER_TICKRATE 128
ENV SERVER_MAP de_dust2
ENV SERVER_MAP_GROUP mg_active
ENV SERVER_MAX_PLAYERS 12
ENV SERVER_GAME_TYPE 0
ENV SERVER_GAME_MODE 1
ENV STEAM_ACCOUNT changeme

# Create directories
RUN mkdir /steamcmd
RUN mkdir /data

# Install missing packages
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*

# Install steamcmd
WORKDIR /steamcmd
ADD https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz steamcmd_linux.tar.gz
RUN tar --no-same-owner -zxvf steamcmd_linux.tar.gz && rm steamcmd_linux.tar.gz
WORKDIR /

# Fix for missing library
RUN /steamcmd/steamcmd.sh +exit
RUN mkdir -p ~/.steam/sdk32
RUN ln -s /steamcmd/linux32/steamclient.so ~/.steam/sdk32/steamclient.so

# Add start script
ADD start.sh /start.sh

WORKDIR /data
VOLUME [ "/data" ]
ENTRYPOINT [ "/start.sh" ]