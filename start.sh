#!/bin/bash

DATA_PATH="/data"

function update_cfg()
{
    sed -i -r "s/^($1)\s+(.+)$/\1 \"$2\"/" "$DATA_PATH/csgo/cfg/server.cfg"
}

# Install CSGO when is not installed
if [ ! -f "./srcds_run" ] || [ -f "./.force_update" ]
then
    /steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType linux +login anonymous +force_install_dir $DATA_PATH +app_update 740 validate +quit
    rc=$?
    # Check the exit code of steamcmd
    if [[ $rc != 0 ]]
    then
        (>&2 echo "SteamCMD exited with error code: $rc")
        exit $rc
    fi

    # If the configuration of the server is not present, create new one
    if [ ! -f "./csgo/cfg/server.cfg"]
    then
        cat << SERVERCFG > ./csgo/cfg/server.cfg
hostname "$SERVER_HOSTNAME"
rcon_password "$SERVER_RCON_PASSWORD"
sv_password "$SERVER_PASSWORD"
sv_lan 0
sv_cheats 0
SERVERCFG
    fi

    # If everything ok, delete the file
    rm -f .force_update
fi

# Make backup of the configuration
cp ./csgo/cfg/server.cfg './csgo/cfg/server-`date --iso`.cfg.bak'

# Update configuration
update_cfg 'hostname' $SERVER_HOSTNAME
update_cfg 'rcon_password' $SERVER_RCON_PASSWORD
update_cfg 'sv_password' $SERVER_PASSWORD

# Start the server
./srcds_run \
    -console \
    -usercon \
    -game csgo \
    -tickrate $SERVER_TICKRATE \
    -port $SERVER_PORT \
    -maxplayers_override $SERVER_MAX_PLAYERS \
    +game_type $SERVER_GAME_TYPE \
    +game_mode $SERVER_GAME_MODE \
    +mapgroup $SERVER_MAP_GROUP \
    +map $SERVER_MAP \
    +ip $SERVER_SERVER_IP \
    +sv_setsteamaccount $STEAM_ACCOUNT