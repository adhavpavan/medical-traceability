#!/bin/bash
# imports  



export FABRIC_CFG_PATH=${PWD}/../../blockchain/artifacts/channel/config

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../artifacts/channel/crypto-config/ordererOrganizations/orderer.com/orderers/orderer1.com/msp/tlscacerts/tlsca.orderer.com-cert.pem

    export ORDERER1_ADMIN_TLS_SIGN_CERT=${PWD}/../artifacts/channel/crypto-config/ordererOrganizations/orderer.com/orderers/orderer1.com/tls/server.crt
    export ORDERER1_ADMIN_TLS_PRIVATE_KEY=${PWD}/../artifacts/channel/crypto-config/ordererOrganizations/orderer.com/orderers/orderer1.com/tls/server.key

    export ORDERER2_ADMIN_TLS_SIGN_CERT=${PWD}/../artifacts/channel/crypto-config/ordererOrganizations/orderer.com/orderers/orderer2.com/tls/server.crt
    export ORDERER2_ADMIN_TLS_PRIVATE_KEY=${PWD}/../artifacts/channel/crypto-config/ordererOrganizations/orderer.com/orderers/orderer2.com/tls/server.key

    export ORDERER3_ADMIN_TLS_SIGN_CERT=${PWD}/../artifacts/channel/crypto-config/ordererOrganizations/orderer.com/orderers/orderer3.com/tls/server.crt
    export ORDERER3_ADMIN_TLS_PRIVATE_KEY=${PWD}/../artifacts/channel/crypto-config/ordererOrganizations/orderer.com/orderers/orderer3.com/tls/server.key
    export manufacturer_CA=${PWD}/../artifacts/channel/crypto-config/peerOrganizations/manufacturer.com/peers/peer1.manufacturer.com/tls/ca.crt
    export distributor_CA=${PWD}/../artifacts/channel/crypto-config/peerOrganizations/distributor.com/peers/peer1.distributor.com/tls/ca.crt
    export pharmacy_CA=${PWD}/../artifacts/channel/crypto-config/peerOrganizations/pharmacy.com/peers/peer1.pharmacy.com/tls/ca.crt
    export regulator_CA=${PWD}/../artifacts/channel/crypto-config/peerOrganizations/regulator.com/peers/peer1.regulator.com/tls/ca.crt


C_RESET='\033[0m'
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_BLUE='\033[0;34m'
C_YELLOW='\033[1;33m'
# println echos string
function println() {
  echo -e "$1"
}

# errorln echos i red color
function errorln() {
  println "${C_RED}${1}${C_RESET}"
}

# successln echos in green color
function successln() {
  println "${C_GREEN}${1}${C_RESET}"
}

# infoln echos in blue color
function infoln() {
  println "${C_BLUE}${1}${C_RESET}"
}

# warnln echos in yellow color
function warnln() {
  println "${C_YELLOW}${1}${C_RESET}"
}

# fatalln echos in red color and exits with fail status
function fatalln() {
  errorln "$1"
  exit 1
}



  # Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  local OVERRIDE_PEER=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
    USING_PEER=$2
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  if [ -z "$OVERRIDE_PEER" ]; then
  USING_PEER=$2
  else
    USING_PEER="${OVERRIDE_PEER}"
  fi
  

  case $USING_ORG in
        manufacturer)
          export CORE_PEER_LOCALMSPID="manufacturerMSP"
          export CORE_PEER_TLS_ROOTCERT_FILE=$manufacturer_CA
          export CORE_PEER_MSPCONFIGPATH=${PWD}/../artifacts/channel/crypto-config/peerOrganizations/manufacturer.com/users/Admin@manufacturer.com/msp

          case $USING_PEER in
              1)
                export CORE_PEER_ADDRESS=localhost:7051 ;;
            default)
              export CORE_PEER_ADDRESS=localhost:7051  ;;
            *)
              errorln "Peer number $USING_PEER is invalid, using default peer 1"
              export CORE_PEER_ADDRESS=localhost:7051 ;;
          esac ;;
        distributor)
          export CORE_PEER_LOCALMSPID="distributorMSP"
          export CORE_PEER_TLS_ROOTCERT_FILE=$distributor_CA
          export CORE_PEER_MSPCONFIGPATH=${PWD}/../artifacts/channel/crypto-config/peerOrganizations/distributor.com/users/Admin@distributor.com/msp

          case $USING_PEER in
              1)
                export CORE_PEER_ADDRESS=localhost:8051 ;;
            default)
              export CORE_PEER_ADDRESS=localhost:8051  ;;
            *)
              errorln "Peer number $USING_PEER is invalid, using default peer 1"
              export CORE_PEER_ADDRESS=localhost:8051 ;;
          esac ;;
        pharmacy)
          export CORE_PEER_LOCALMSPID="pharmacyMSP"
          export CORE_PEER_TLS_ROOTCERT_FILE=$pharmacy_CA
          export CORE_PEER_MSPCONFIGPATH=${PWD}/../artifacts/channel/crypto-config/peerOrganizations/pharmacy.com/users/Admin@pharmacy.com/msp

          case $USING_PEER in
              1)
                export CORE_PEER_ADDRESS=localhost:9051 ;;
            default)
              export CORE_PEER_ADDRESS=localhost:9051  ;;
            *)
              errorln "Peer number $USING_PEER is invalid, using default peer 1"
              export CORE_PEER_ADDRESS=localhost:9051 ;;
          esac ;;
        regulator)
          export CORE_PEER_LOCALMSPID="regulatorMSP"
          export CORE_PEER_TLS_ROOTCERT_FILE=$regulator_CA
          export CORE_PEER_MSPCONFIGPATH=${PWD}/../artifacts/channel/crypto-config/peerOrganizations/regulator.com/users/Admin@regulator.com/msp

          case $USING_PEER in
              1)
                export CORE_PEER_ADDRESS=localhost:10051 ;;
            default)
              export CORE_PEER_ADDRESS=localhost:10051  ;;
            *)
              errorln "Peer number $USING_PEER is invalid, using default peer 1"
              export CORE_PEER_ADDRESS=localhost:10051 ;;
          esac ;;
          esac
}