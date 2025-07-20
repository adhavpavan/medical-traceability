#!/bin/bash
# imports  
. envVar.sh
    
CHANNEL_NAME=producer-distributor-channel;
createChannel(){

      setGlobals manufacturer 1
      osnadmin channel join --channelID ${CHANNEL_NAME} \
      --config-block ../channel-artifacts/producer-distributor-channel.block -o localhost:7053 \
      --ca-file $ORDERER_CA \
      --client-cert $ORDERER1_ADMIN_TLS_SIGN_CERT \
      --client-key $ORDERER1_ADMIN_TLS_PRIVATE_KEY 

      setGlobals manufacturer 1
      osnadmin channel join --channelID ${CHANNEL_NAME} \
      --config-block ../channel-artifacts/producer-distributor-channel.block -o localhost:8053 \
      --ca-file $ORDERER_CA \
      --client-cert $ORDERER2_ADMIN_TLS_SIGN_CERT \
      --client-key $ORDERER2_ADMIN_TLS_PRIVATE_KEY 

      setGlobals manufacturer 1
      osnadmin channel join --channelID ${CHANNEL_NAME} \
      --config-block ../channel-artifacts/producer-distributor-channel.block -o localhost:9053 \
      --ca-file $ORDERER_CA \
      --client-cert $ORDERER3_ADMIN_TLS_SIGN_CERT \
      --client-key $ORDERER3_ADMIN_TLS_PRIVATE_KEY 
}

createChannel
sleep 3
joinChannel(){

        setGlobals manufacturer 1
        peer channel join -b ../channel-artifacts/producer-distributor-channel.block

        setGlobals distributor 1
        peer channel join -b ../channel-artifacts/producer-distributor-channel.block

        setGlobals regulator 1
        peer channel join -b ../channel-artifacts/producer-distributor-channel.block
}

joinChannel
