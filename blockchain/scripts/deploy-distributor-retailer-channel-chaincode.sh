#!/bin/bash
        # imports  
        . envVar.sh
    
        CHANNEL_NAME=distributor-retailer-channel
        CC_RUNTIME_LANGUAGE="node"
        VERSION="1"
        SEQUENCE=1
        CC_SRC_PATH="../artifacts/chaincode2/javascript"
        CC_NAME=distributor-retailer-channel-chaincode 

      presetup() {
    echo Installing npm packages ...
    pushd ../artifacts/chaincode2/javascript
    npm install
    popd
    echo Finished installing npm dependencies
}

    packageChaincode() {
      rm -rf ${CC_NAME}.tar.gz
      setGlobals distributor 1
      peer lifecycle chaincode package ${CC_NAME}.tar.gz \
          --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} \
          --label ${CC_NAME}_${VERSION}
      echo "===================== Chaincode is packaged ===================== "
    }

installChaincode() {

        setGlobals distributor 1
        peer lifecycle chaincode install ${CC_NAME}.tar.gz

        setGlobals pharmacy 1
        peer lifecycle chaincode install ${CC_NAME}.tar.gz

        setGlobals regulator 1
        peer lifecycle chaincode install ${CC_NAME}.tar.gz
}

        queryInstalled() {
          setGlobals distributor 1
          peer lifecycle chaincode queryinstalled >&log.txt
          cat log.txt
          PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
          echo PackageID is ${PACKAGE_ID}
          echo "===================== Query installed successful on peer0.org1 on channel ===================== "
        }
        

      approveFordistributor() {
        setGlobals distributor 1
        set -x
        peer lifecycle chaincode approveformyorg -o localhost:7050 \
            --ordererTLSHostnameOverride orderer1.com --tls \
            --cafile $ORDERER_CA --channelID ${CHANNEL_NAME} \
            --name ${CC_NAME} --version ${VERSION} \
            --package-id ${PACKAGE_ID} \
            --sequence ${SEQUENCE}
        set +x
    
        echo "===================== chaincode approved from org 1 ===================== "
    
           }
      

      approveForpharmacy() {
        setGlobals pharmacy 1
        set -x
        peer lifecycle chaincode approveformyorg -o localhost:7050 \
            --ordererTLSHostnameOverride orderer1.com --tls \
            --cafile $ORDERER_CA --channelID ${CHANNEL_NAME} \
            --name ${CC_NAME} --version ${VERSION} \
            --package-id ${PACKAGE_ID} \
            --sequence ${SEQUENCE}
        set +x
    
        echo "===================== chaincode approved from org 1 ===================== "
    
           }
      

      approveForregulator() {
        setGlobals regulator 1
        set -x
        peer lifecycle chaincode approveformyorg -o localhost:7050 \
            --ordererTLSHostnameOverride orderer1.com --tls \
            --cafile $ORDERER_CA --channelID ${CHANNEL_NAME} \
            --name ${CC_NAME} --version ${VERSION} \
            --package-id ${PACKAGE_ID} \
            --sequence ${SEQUENCE}
        set +x
    
        echo "===================== chaincode approved from org 1 ===================== "
    
           }
      

        checkCommitReadyness() {
          setGlobals  distributor 1
          peer lifecycle chaincode checkcommitreadiness \
              --channelID ${CHANNEL_NAME} --name ${CC_NAME} --version ${VERSION} \
              --sequence ${SEQUENCE} --output json
          echo "===================== checking commit readyness from org 1 ===================== "
      }
    

    commitChaincodeDefination() {
      setGlobals distributor 1
      peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer1.com \
          --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
          --channelID ${CHANNEL_NAME} --name ${CC_NAME} \
          --version ${VERSION} --sequence ${SEQUENCE} \
          --peerAddresses localhost:8051 --tlsRootCertFiles $distributor_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $pharmacy_CA \
        --peerAddresses localhost:10051 --tlsRootCertFiles $regulator_CA \
        
  }
    

    chaincodeInvoke() {
      setGlobals distributor 1
  
      # Create Car
      peer chaincode invoke -o localhost:7050 \
          --ordererTLSHostnameOverride orderer1.com \
          --tls $CORE_PEER_TLS_ENABLED \
          --cafile $ORDERER_CA \
          -C ${CHANNEL_NAME} -n ${CC_NAME}  \
          -c '{"function": "CreateAsset","Args":["{\"id\":\"6\", \"test\":\"updated data\"}"]}' \
          --peerAddresses localhost:8051 --tlsRootCertFiles $distributor_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $pharmacy_CA \
        --peerAddresses localhost:10051 --tlsRootCertFiles $regulator_CA \
        
          
  }
    

  chaincodeQuery() {
    setGlobals distributor 1
    peer chaincode query -C ${CHANNEL_NAME} -n ${CC_NAME} -c '{"function": "getAssetByID","Args":["6"]}'
}
    
presetup
packageChaincode
installChaincode
queryInstalled
approveFordistributor
approveForpharmacy
approveForregulator
checkCommitReadyness
commitChaincodeDefination
chaincodeInvoke
sleep 3
chaincodeQuery
