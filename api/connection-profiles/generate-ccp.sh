#!/bin/bash 
function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

  function json_ccp {
      local PP=$(one_line_pem $4)
      local CP=$(one_line_pem $5)
      sed -e "s/\${ORG}/$1/" \
          -e "s/\${P0PORT}/$2/" \
          -e "s/\${CAPORT}/$3/" \
          -e "s#\${PEERPEM}#$PP#" \
          -e "s#\${CAPEM}#$CP#" \
          ./ccp-template.json
  }

  function json_ccp_caliper {
      local PP=$(one_line_pem $4)
      local CP=$(one_line_pem $5)
      sed -e "s/\${ORG}/$1/" \
          -e "s/\${P0PORT}/$2/" \
          -e "s/\${CAPORT}/$3/" \
          -e "s#\${PEERPEM}#$PP#" \
          -e "s#\${CAPEM}#$CP#" \
          ./ccp-template-caliper.json
  }
  

      #------------------This section is used for Caliper connection profile---------------------------
      ORG=manufacturer
      P0PORT=7051
      CAPORT=7054
      PEERPEM=../../blockchain/artifacts/channel/crypto-config/peerOrganizations/manufacturer.com/peers/peer1.manufacturer.com/tls/tlscacerts/tls-localhost-7054-ca-manufacturer-com.pem
      CAPEM=../../blockchain/artifacts/channel/crypto-config/peerOrganizations/manufacturer.com/msp/tlscacerts/ca.crt
  
      echo "$(json_ccp_caliper $ORG $P0PORT $CAPORT $PEERPEM $CAPEM )" > connection-manufacturer-caliper.json
      #------------------This section is used for Caliper connection profile---------------------------

    
    
    ORG=manufacturer
    P0PORT=7051
    CAPORT=7054
    PEERPEM=../../blockchain/artifacts/channel/crypto-config/peerOrganizations/manufacturer.com/peers/peer1.manufacturer.com/tls/tlscacerts/tls-localhost-7054-ca-manufacturer-com.pem
    CAPEM=../../blockchain/artifacts/channel/crypto-config/peerOrganizations/manufacturer.com/msp/tlscacerts/ca.crt

    echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM )" > connection-manufacturer.json
    
    
    
    ORG=distributor
    P0PORT=8051
    CAPORT=8054
    PEERPEM=../../blockchain/artifacts/channel/crypto-config/peerOrganizations/distributor.com/peers/peer1.distributor.com/tls/tlscacerts/tls-localhost-8054-ca-distributor-com.pem
    CAPEM=../../blockchain/artifacts/channel/crypto-config/peerOrganizations/distributor.com/msp/tlscacerts/ca.crt

    echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM )" > connection-distributor.json
    
    
    
    ORG=pharmacy
    P0PORT=9051
    CAPORT=9054
    PEERPEM=../../blockchain/artifacts/channel/crypto-config/peerOrganizations/pharmacy.com/peers/peer1.pharmacy.com/tls/tlscacerts/tls-localhost-9054-ca-pharmacy-com.pem
    CAPEM=../../blockchain/artifacts/channel/crypto-config/peerOrganizations/pharmacy.com/msp/tlscacerts/ca.crt

    echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM )" > connection-pharmacy.json
    
    
    
    ORG=regulator
    P0PORT=10051
    CAPORT=10054
    PEERPEM=../../blockchain/artifacts/channel/crypto-config/peerOrganizations/regulator.com/peers/peer1.regulator.com/tls/tlscacerts/tls-localhost-10054-ca-regulator-com.pem
    CAPEM=../../blockchain/artifacts/channel/crypto-config/peerOrganizations/regulator.com/msp/tlscacerts/ca.crt

    echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM )" > connection-regulator.json
    
    