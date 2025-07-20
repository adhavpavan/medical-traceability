#!/bin/bash
# imports  
. envVar.sh
    
CHANNEL_NAME=distributor-retailer-channel;
createChannel(){

      setGlobals distributor 1
      osnadmin channel join --channelID ${CHANNEL_NAME} \
      --config-block ../channel-artifacts/distributor-retailer-channel.block -o localhost:7053 \
      --ca-file $ORDERER_CA \
      --client-cert $ORDERER1_ADMIN_TLS_SIGN_CERT \
      --client-key $ORDERER1_ADMIN_TLS_PRIVATE_KEY 

      setGlobals distributor 1
      osnadmin channel join --channelID ${CHANNEL_NAME} \
      --config-block ../channel-artifacts/distributor-retailer-channel.block -o localhost:8053 \
      --ca-file $ORDERER_CA \
      --client-cert $ORDERER2_ADMIN_TLS_SIGN_CERT \
      --client-key $ORDERER2_ADMIN_TLS_PRIVATE_KEY 

      setGlobals distributor 1
      osnadmin channel join --channelID ${CHANNEL_NAME} \
      --config-block ../channel-artifacts/distributor-retailer-channel.block -o localhost:9053 \
      --ca-file $ORDERER_CA \
      --client-cert $ORDERER3_ADMIN_TLS_SIGN_CERT \
      --client-key $ORDERER3_ADMIN_TLS_PRIVATE_KEY 
}

createChannel
sleep 3
joinChannel(){

        setGlobals distributor 1
        peer channel join -b ../channel-artifacts/distributor-retailer-channel.block

        setGlobals pharmacy 1
        peer channel join -b ../channel-artifacts/distributor-retailer-channel.block

        setGlobals regulator 1
        peer channel join -b ../channel-artifacts/distributor-retailer-channel.block
}

joinChannel
