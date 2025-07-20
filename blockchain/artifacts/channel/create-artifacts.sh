#!/bin/bash
  echo "Hello, this is a shell script created with Node.js!"
  

    echo Creating artifacts for  producer-distributor-channel
    CHANNEL_NAME=producer-distributor-channel
    configtxgen -profile producer-distributor-channel -configPath . -channelID $CHANNEL_NAME  -outputBlock ../../channel-artifacts/$CHANNEL_NAME.block

    

    echo Creating artifacts for  distributor-retailer-channel
    CHANNEL_NAME=distributor-retailer-channel
    configtxgen -profile distributor-retailer-channel -configPath . -channelID $CHANNEL_NAME  -outputBlock ../../channel-artifacts/$CHANNEL_NAME.block

    