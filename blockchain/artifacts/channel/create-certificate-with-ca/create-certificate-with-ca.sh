#!/bin/bash
echo "Hello, this is a shell script created with Node.js!"


    CreateCertificatesFormanufacturer() {
  
    echo
    echo "Enroll the CA admin"
    echo
    mkdir -p ../crypto-config/peerOrganizations/manufacturer.com/
    export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/manufacturer.com/
  
  
     
    fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca.manufacturer.com --tls.certfiles ${PWD}/fabric-ca/manufacturer/tls-cert.pem
     
  
    echo 'NodeOUs:
    Enable: true
    ClientOUIdentifier:
      Certificate: cacerts/localhost-7054-ca-manufacturer-com.pem
      OrganizationalUnitIdentifier: client
    PeerOUIdentifier:
      Certificate: cacerts/localhost-7054-ca-manufacturer-com.pem
      OrganizationalUnitIdentifier: peer
    AdminOUIdentifier:
      Certificate: cacerts/localhost-7054-ca-manufacturer-com.pem
      OrganizationalUnitIdentifier: admin
    OrdererOUIdentifier:
      Certificate: cacerts/localhost-7054-ca-manufacturer-com.pem
      OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/manufacturer.com/msp/config.yaml
  
    echo
    echo "Register user"
    echo
    fabric-ca-client register --caname ca.manufacturer.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/manufacturer/tls-cert.pem
  
    echo
    echo "Register the org admin"
    echo
    fabric-ca-client register --caname ca.manufacturer.com --id.name manufactureradmin --id.secret manufactureradminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/manufacturer/tls-cert.pem
  
    mkdir -p ../crypto-config/peerOrganizations/manufacturer.com/peers
  
  
  
  
    


      echo
      echo "Register peer1"
      echo
      fabric-ca-client register --caname ca.manufacturer.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/manufacturer/tls-cert.pem
    
      
      echo
      echo "## Generate the peer1 msp"
      echo
      fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca.manufacturer.com -M ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peer1.manufacturer.com/msp --csr.hosts peer1.manufacturer.com --tls.certfiles ${PWD}/fabric-ca/manufacturer/tls-cert.pem

      cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peer1.manufacturer.com/msp/config.yaml


      
      echo
      echo "## Generate the peer1-tls certificates"
      echo
      fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca.manufacturer.com -M ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peer1.manufacturer.com/tls --enrollment.profile tls --csr.hosts peer1.manufacturer.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/manufacturer/tls-cert.pem
  
      cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peer1.manufacturer.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peer1.manufacturer.com/tls/ca.crt
      cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peer1.manufacturer.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peer1.manufacturer.com/tls/server.crt
      cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peer1.manufacturer.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peer1.manufacturer.com/tls/server.key
  
      mkdir ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/msp/tlscacerts
      cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peer1.manufacturer.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/msp/tlscacerts/ca.crt
  
      mkdir ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/tlsca
      cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peer1.manufacturer.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/tlsca/tlsca.manufacturer.com-cert.pem
  
      mkdir ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/ca
      cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/peers/peer1.manufacturer.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/ca/ca.manufacturer.com-cert.pem
  
      # --------------------------------------------------------------------------------------------------
  
      mkdir -p ../crypto-config/peerOrganizations/manufacturer.com/users
      mkdir -p ../crypto-config/peerOrganizations/manufacturer.com/users/User1@manufacturer.com
  
      


  
    mkdir -p ../crypto-config/peerOrganizations/manufacturer.com/users
    mkdir -p ../crypto-config/peerOrganizations/manufacturer.com/users/User1@manufacturer.com
  
    echo
    echo "## Generate the user msp"
    echo
    fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca.manufacturer.com -M ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/users/User1@manufacturer.com/msp --tls.certfiles ${PWD}/fabric-ca/manufacturer/tls-cert.pem
    cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/users/User1@manufacturer.com/msp/keystore/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/users/User1@manufacturer.com/msp/keystore/priv_sk
    mkdir -p ../crypto-config/peerOrganizations/manufacturer.com/users/Admin@manufacturer.com
  
    echo
    echo "## Generate the org admin msp"
    echo
    fabric-ca-client enroll -u https://manufactureradmin:manufactureradminpw@localhost:7054 --caname ca.manufacturer.com -M ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/users/Admin@manufacturer.com/msp --tls.certfiles ${PWD}/fabric-ca/manufacturer/tls-cert.pem
    cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/users/Admin@manufacturer.com/msp/keystore/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/users/Admin@manufacturer.com/msp/keystore/priv_sk
    cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/manufacturer.com/users/Admin@manufacturer.com/msp/config.yaml
  
    
}

    CreateCertificatesFordistributor() {
  
    echo
    echo "Enroll the CA admin"
    echo
    mkdir -p ../crypto-config/peerOrganizations/distributor.com/
    export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/distributor.com/
  
  
     
    fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca.distributor.com --tls.certfiles ${PWD}/fabric-ca/distributor/tls-cert.pem
     
  
    echo 'NodeOUs:
    Enable: true
    ClientOUIdentifier:
      Certificate: cacerts/localhost-8054-ca-distributor-com.pem
      OrganizationalUnitIdentifier: client
    PeerOUIdentifier:
      Certificate: cacerts/localhost-8054-ca-distributor-com.pem
      OrganizationalUnitIdentifier: peer
    AdminOUIdentifier:
      Certificate: cacerts/localhost-8054-ca-distributor-com.pem
      OrganizationalUnitIdentifier: admin
    OrdererOUIdentifier:
      Certificate: cacerts/localhost-8054-ca-distributor-com.pem
      OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/distributor.com/msp/config.yaml
  
    echo
    echo "Register user"
    echo
    fabric-ca-client register --caname ca.distributor.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/distributor/tls-cert.pem
  
    echo
    echo "Register the org admin"
    echo
    fabric-ca-client register --caname ca.distributor.com --id.name distributoradmin --id.secret distributoradminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/distributor/tls-cert.pem
  
    mkdir -p ../crypto-config/peerOrganizations/distributor.com/peers
  
  
  
  
    


      echo
      echo "Register peer1"
      echo
      fabric-ca-client register --caname ca.distributor.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/distributor/tls-cert.pem
    
      
      echo
      echo "## Generate the peer1 msp"
      echo
      fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca.distributor.com -M ${PWD}/../crypto-config/peerOrganizations/distributor.com/peers/peer1.distributor.com/msp --csr.hosts peer1.distributor.com --tls.certfiles ${PWD}/fabric-ca/distributor/tls-cert.pem

      cp ${PWD}/../crypto-config/peerOrganizations/distributor.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/distributor.com/peers/peer1.distributor.com/msp/config.yaml


      
      echo
      echo "## Generate the peer1-tls certificates"
      echo
      fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca.distributor.com -M ${PWD}/../crypto-config/peerOrganizations/distributor.com/peers/peer1.distributor.com/tls --enrollment.profile tls --csr.hosts peer1.distributor.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/distributor/tls-cert.pem
  
      cp ${PWD}/../crypto-config/peerOrganizations/distributor.com/peers/peer1.distributor.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/distributor.com/peers/peer1.distributor.com/tls/ca.crt
      cp ${PWD}/../crypto-config/peerOrganizations/distributor.com/peers/peer1.distributor.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/distributor.com/peers/peer1.distributor.com/tls/server.crt
      cp ${PWD}/../crypto-config/peerOrganizations/distributor.com/peers/peer1.distributor.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/distributor.com/peers/peer1.distributor.com/tls/server.key
  
      mkdir ${PWD}/../crypto-config/peerOrganizations/distributor.com/msp/tlscacerts
      cp ${PWD}/../crypto-config/peerOrganizations/distributor.com/peers/peer1.distributor.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/distributor.com/msp/tlscacerts/ca.crt
  
      mkdir ${PWD}/../crypto-config/peerOrganizations/distributor.com/tlsca
      cp ${PWD}/../crypto-config/peerOrganizations/distributor.com/peers/peer1.distributor.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/distributor.com/tlsca/tlsca.distributor.com-cert.pem
  
      mkdir ${PWD}/../crypto-config/peerOrganizations/distributor.com/ca
      cp ${PWD}/../crypto-config/peerOrganizations/distributor.com/peers/peer1.distributor.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/distributor.com/ca/ca.distributor.com-cert.pem
  
      # --------------------------------------------------------------------------------------------------
  
      mkdir -p ../crypto-config/peerOrganizations/distributor.com/users
      mkdir -p ../crypto-config/peerOrganizations/distributor.com/users/User1@distributor.com
  
      


  
    mkdir -p ../crypto-config/peerOrganizations/distributor.com/users
    mkdir -p ../crypto-config/peerOrganizations/distributor.com/users/User1@distributor.com
  
    echo
    echo "## Generate the user msp"
    echo
    fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca.distributor.com -M ${PWD}/../crypto-config/peerOrganizations/distributor.com/users/User1@distributor.com/msp --tls.certfiles ${PWD}/fabric-ca/distributor/tls-cert.pem
    cp ${PWD}/../crypto-config/peerOrganizations/distributor.com/users/User1@distributor.com/msp/keystore/* ${PWD}/../crypto-config/peerOrganizations/distributor.com/users/User1@distributor.com/msp/keystore/priv_sk
    mkdir -p ../crypto-config/peerOrganizations/distributor.com/users/Admin@distributor.com
  
    echo
    echo "## Generate the org admin msp"
    echo
    fabric-ca-client enroll -u https://distributoradmin:distributoradminpw@localhost:8054 --caname ca.distributor.com -M ${PWD}/../crypto-config/peerOrganizations/distributor.com/users/Admin@distributor.com/msp --tls.certfiles ${PWD}/fabric-ca/distributor/tls-cert.pem
    cp ${PWD}/../crypto-config/peerOrganizations/distributor.com/users/Admin@distributor.com/msp/keystore/* ${PWD}/../crypto-config/peerOrganizations/distributor.com/users/Admin@distributor.com/msp/keystore/priv_sk
    cp ${PWD}/../crypto-config/peerOrganizations/distributor.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/distributor.com/users/Admin@distributor.com/msp/config.yaml
  
    
}

    CreateCertificatesForpharmacy() {
  
    echo
    echo "Enroll the CA admin"
    echo
    mkdir -p ../crypto-config/peerOrganizations/pharmacy.com/
    export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/pharmacy.com/
  
  
     
    fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca.pharmacy.com --tls.certfiles ${PWD}/fabric-ca/pharmacy/tls-cert.pem
     
  
    echo 'NodeOUs:
    Enable: true
    ClientOUIdentifier:
      Certificate: cacerts/localhost-9054-ca-pharmacy-com.pem
      OrganizationalUnitIdentifier: client
    PeerOUIdentifier:
      Certificate: cacerts/localhost-9054-ca-pharmacy-com.pem
      OrganizationalUnitIdentifier: peer
    AdminOUIdentifier:
      Certificate: cacerts/localhost-9054-ca-pharmacy-com.pem
      OrganizationalUnitIdentifier: admin
    OrdererOUIdentifier:
      Certificate: cacerts/localhost-9054-ca-pharmacy-com.pem
      OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/pharmacy.com/msp/config.yaml
  
    echo
    echo "Register user"
    echo
    fabric-ca-client register --caname ca.pharmacy.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/pharmacy/tls-cert.pem
  
    echo
    echo "Register the org admin"
    echo
    fabric-ca-client register --caname ca.pharmacy.com --id.name pharmacyadmin --id.secret pharmacyadminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/pharmacy/tls-cert.pem
  
    mkdir -p ../crypto-config/peerOrganizations/pharmacy.com/peers
  
  
  
  
    


      echo
      echo "Register peer1"
      echo
      fabric-ca-client register --caname ca.pharmacy.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/pharmacy/tls-cert.pem
    
      
      echo
      echo "## Generate the peer1 msp"
      echo
      fabric-ca-client enroll -u https://peer1:peer1pw@localhost:9054 --caname ca.pharmacy.com -M ${PWD}/../crypto-config/peerOrganizations/pharmacy.com/peers/peer1.pharmacy.com/msp --csr.hosts peer1.pharmacy.com --tls.certfiles ${PWD}/fabric-ca/pharmacy/tls-cert.pem

      cp ${PWD}/../crypto-config/peerOrganizations/pharmacy.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/pharmacy.com/peers/peer1.pharmacy.com/msp/config.yaml


      
      echo
      echo "## Generate the peer1-tls certificates"
      echo
      fabric-ca-client enroll -u https://peer1:peer1pw@localhost:9054 --caname ca.pharmacy.com -M ${PWD}/../crypto-config/peerOrganizations/pharmacy.com/peers/peer1.pharmacy.com/tls --enrollment.profile tls --csr.hosts peer1.pharmacy.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/pharmacy/tls-cert.pem
  
      cp ${PWD}/../crypto-config/peerOrganizations/pharmacy.com/peers/peer1.pharmacy.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/pharmacy.com/peers/peer1.pharmacy.com/tls/ca.crt
      cp ${PWD}/../crypto-config/peerOrganizations/pharmacy.com/peers/peer1.pharmacy.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/pharmacy.com/peers/peer1.pharmacy.com/tls/server.crt
      cp ${PWD}/../crypto-config/peerOrganizations/pharmacy.com/peers/peer1.pharmacy.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/pharmacy.com/peers/peer1.pharmacy.com/tls/server.key
  
      mkdir ${PWD}/../crypto-config/peerOrganizations/pharmacy.com/msp/tlscacerts
      cp ${PWD}/../crypto-config/peerOrganizations/pharmacy.com/peers/peer1.pharmacy.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/pharmacy.com/msp/tlscacerts/ca.crt
  
      mkdir ${PWD}/../crypto-config/peerOrganizations/pharmacy.com/tlsca
      cp ${PWD}/../crypto-config/peerOrganizations/pharmacy.com/peers/peer1.pharmacy.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/pharmacy.com/tlsca/tlsca.pharmacy.com-cert.pem
  
      mkdir ${PWD}/../crypto-config/peerOrganizations/pharmacy.com/ca
      cp ${PWD}/../crypto-config/peerOrganizations/pharmacy.com/peers/peer1.pharmacy.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/pharmacy.com/ca/ca.pharmacy.com-cert.pem
  
      # --------------------------------------------------------------------------------------------------
  
      mkdir -p ../crypto-config/peerOrganizations/pharmacy.com/users
      mkdir -p ../crypto-config/peerOrganizations/pharmacy.com/users/User1@pharmacy.com
  
      


  
    mkdir -p ../crypto-config/peerOrganizations/pharmacy.com/users
    mkdir -p ../crypto-config/peerOrganizations/pharmacy.com/users/User1@pharmacy.com
  
    echo
    echo "## Generate the user msp"
    echo
    fabric-ca-client enroll -u https://user1:user1pw@localhost:9054 --caname ca.pharmacy.com -M ${PWD}/../crypto-config/peerOrganizations/pharmacy.com/users/User1@pharmacy.com/msp --tls.certfiles ${PWD}/fabric-ca/pharmacy/tls-cert.pem
    cp ${PWD}/../crypto-config/peerOrganizations/pharmacy.com/users/User1@pharmacy.com/msp/keystore/* ${PWD}/../crypto-config/peerOrganizations/pharmacy.com/users/User1@pharmacy.com/msp/keystore/priv_sk
    mkdir -p ../crypto-config/peerOrganizations/pharmacy.com/users/Admin@pharmacy.com
  
    echo
    echo "## Generate the org admin msp"
    echo
    fabric-ca-client enroll -u https://pharmacyadmin:pharmacyadminpw@localhost:9054 --caname ca.pharmacy.com -M ${PWD}/../crypto-config/peerOrganizations/pharmacy.com/users/Admin@pharmacy.com/msp --tls.certfiles ${PWD}/fabric-ca/pharmacy/tls-cert.pem
    cp ${PWD}/../crypto-config/peerOrganizations/pharmacy.com/users/Admin@pharmacy.com/msp/keystore/* ${PWD}/../crypto-config/peerOrganizations/pharmacy.com/users/Admin@pharmacy.com/msp/keystore/priv_sk
    cp ${PWD}/../crypto-config/peerOrganizations/pharmacy.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/pharmacy.com/users/Admin@pharmacy.com/msp/config.yaml
  
    
}

    CreateCertificatesForregulator() {
  
    echo
    echo "Enroll the CA admin"
    echo
    mkdir -p ../crypto-config/peerOrganizations/regulator.com/
    export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/regulator.com/
  
  
     
    fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca.regulator.com --tls.certfiles ${PWD}/fabric-ca/regulator/tls-cert.pem
     
  
    echo 'NodeOUs:
    Enable: true
    ClientOUIdentifier:
      Certificate: cacerts/localhost-10054-ca-regulator-com.pem
      OrganizationalUnitIdentifier: client
    PeerOUIdentifier:
      Certificate: cacerts/localhost-10054-ca-regulator-com.pem
      OrganizationalUnitIdentifier: peer
    AdminOUIdentifier:
      Certificate: cacerts/localhost-10054-ca-regulator-com.pem
      OrganizationalUnitIdentifier: admin
    OrdererOUIdentifier:
      Certificate: cacerts/localhost-10054-ca-regulator-com.pem
      OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/regulator.com/msp/config.yaml
  
    echo
    echo "Register user"
    echo
    fabric-ca-client register --caname ca.regulator.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/regulator/tls-cert.pem
  
    echo
    echo "Register the org admin"
    echo
    fabric-ca-client register --caname ca.regulator.com --id.name regulatoradmin --id.secret regulatoradminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/regulator/tls-cert.pem
  
    mkdir -p ../crypto-config/peerOrganizations/regulator.com/peers
  
  
  
  
    


      echo
      echo "Register peer1"
      echo
      fabric-ca-client register --caname ca.regulator.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/regulator/tls-cert.pem
    
      
      echo
      echo "## Generate the peer1 msp"
      echo
      fabric-ca-client enroll -u https://peer1:peer1pw@localhost:10054 --caname ca.regulator.com -M ${PWD}/../crypto-config/peerOrganizations/regulator.com/peers/peer1.regulator.com/msp --csr.hosts peer1.regulator.com --tls.certfiles ${PWD}/fabric-ca/regulator/tls-cert.pem

      cp ${PWD}/../crypto-config/peerOrganizations/regulator.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/regulator.com/peers/peer1.regulator.com/msp/config.yaml


      
      echo
      echo "## Generate the peer1-tls certificates"
      echo
      fabric-ca-client enroll -u https://peer1:peer1pw@localhost:10054 --caname ca.regulator.com -M ${PWD}/../crypto-config/peerOrganizations/regulator.com/peers/peer1.regulator.com/tls --enrollment.profile tls --csr.hosts peer1.regulator.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/regulator/tls-cert.pem
  
      cp ${PWD}/../crypto-config/peerOrganizations/regulator.com/peers/peer1.regulator.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/regulator.com/peers/peer1.regulator.com/tls/ca.crt
      cp ${PWD}/../crypto-config/peerOrganizations/regulator.com/peers/peer1.regulator.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/regulator.com/peers/peer1.regulator.com/tls/server.crt
      cp ${PWD}/../crypto-config/peerOrganizations/regulator.com/peers/peer1.regulator.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/regulator.com/peers/peer1.regulator.com/tls/server.key
  
      mkdir ${PWD}/../crypto-config/peerOrganizations/regulator.com/msp/tlscacerts
      cp ${PWD}/../crypto-config/peerOrganizations/regulator.com/peers/peer1.regulator.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/regulator.com/msp/tlscacerts/ca.crt
  
      mkdir ${PWD}/../crypto-config/peerOrganizations/regulator.com/tlsca
      cp ${PWD}/../crypto-config/peerOrganizations/regulator.com/peers/peer1.regulator.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/regulator.com/tlsca/tlsca.regulator.com-cert.pem
  
      mkdir ${PWD}/../crypto-config/peerOrganizations/regulator.com/ca
      cp ${PWD}/../crypto-config/peerOrganizations/regulator.com/peers/peer1.regulator.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/regulator.com/ca/ca.regulator.com-cert.pem
  
      # --------------------------------------------------------------------------------------------------
  
      mkdir -p ../crypto-config/peerOrganizations/regulator.com/users
      mkdir -p ../crypto-config/peerOrganizations/regulator.com/users/User1@regulator.com
  
      


  
    mkdir -p ../crypto-config/peerOrganizations/regulator.com/users
    mkdir -p ../crypto-config/peerOrganizations/regulator.com/users/User1@regulator.com
  
    echo
    echo "## Generate the user msp"
    echo
    fabric-ca-client enroll -u https://user1:user1pw@localhost:10054 --caname ca.regulator.com -M ${PWD}/../crypto-config/peerOrganizations/regulator.com/users/User1@regulator.com/msp --tls.certfiles ${PWD}/fabric-ca/regulator/tls-cert.pem
    cp ${PWD}/../crypto-config/peerOrganizations/regulator.com/users/User1@regulator.com/msp/keystore/* ${PWD}/../crypto-config/peerOrganizations/regulator.com/users/User1@regulator.com/msp/keystore/priv_sk
    mkdir -p ../crypto-config/peerOrganizations/regulator.com/users/Admin@regulator.com
  
    echo
    echo "## Generate the org admin msp"
    echo
    fabric-ca-client enroll -u https://regulatoradmin:regulatoradminpw@localhost:10054 --caname ca.regulator.com -M ${PWD}/../crypto-config/peerOrganizations/regulator.com/users/Admin@regulator.com/msp --tls.certfiles ${PWD}/fabric-ca/regulator/tls-cert.pem
    cp ${PWD}/../crypto-config/peerOrganizations/regulator.com/users/Admin@regulator.com/msp/keystore/* ${PWD}/../crypto-config/peerOrganizations/regulator.com/users/Admin@regulator.com/msp/keystore/priv_sk
    cp ${PWD}/../crypto-config/peerOrganizations/regulator.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/regulator.com/users/Admin@regulator.com/msp/config.yaml
  
    
}

    CreateCertificatesFororderer() {

    echo
    echo "Enroll the CA admin"
    echo
    mkdir -p ../crypto-config/ordererOrganizations/orderer.com/
    export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/ordererOrganizations/orderer.com/

    fabric-ca-client enroll -u https://admin:adminpw@localhost:11054 --caname ca.orderer.com --tls.certfiles ${PWD}/fabric-ca/orderer/tls-cert.pem
  
    echo 'NodeOUs:
    Enable: true
    ClientOUIdentifier:
      Certificate: cacerts/localhost-11054-ca-orderer-com.pem
      OrganizationalUnitIdentifier: client
    PeerOUIdentifier:
      Certificate: cacerts/localhost-11054-ca-orderer-com.pem
      OrganizationalUnitIdentifier: peer
    AdminOUIdentifier:
      Certificate: cacerts/localhost-11054-ca-orderer-com.pem
      OrganizationalUnitIdentifier: admin
    OrdererOUIdentifier:
      Certificate: cacerts/localhost-11054-ca-orderer-com.pem
      OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/ordererOrganizations/orderer.com/msp/config.yaml
  
    echo
    echo "Register the org admin"
    echo
    fabric-ca-client register --caname ca.orderer.com --id.name ordereradmin --id.secret ordereradminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/orderer/tls-cert.pem
  
    mkdir -p ../crypto-config/ordererOrganizations/orderer.com/orderers
  
  
    

      echo
      echo "Register orderer1"
      echo
       
      fabric-ca-client register --caname ca.orderer.com --id.name orderer1 --id.secret orderer1pw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/orderer/tls-cert.pem
       
      # ---------------------------------------------------------------------------
      #  orderer

      mkdir -p ../crypto-config/ordererOrganizations/orderer.com/orderers/orderer1.com

      echo
      echo "## Generate the  orderer1 msp"
      echo
      
      fabric-ca-client enroll -u https://orderer1:orderer1pw@localhost:11054 --caname ca.orderer.com -M ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer1.com/msp --csr.hosts orderer1.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/orderer/tls-cert.pem
      

      cp ${PWD}/../crypto-config/ordererOrganizations/orderer.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer1.com/msp/config.yaml

      echo
      echo "## Generate the orderer1-tls certificates"
      echo
      
      fabric-ca-client enroll -u https://orderer1:orderer1pw@localhost:11054 --caname ca.orderer.com -M ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer1.com/tls --enrollment.profile tls --csr.hosts orderer1.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/orderer/tls-cert.pem
      

      cp ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer1.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer1.com/tls/ca.crt
      cp ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer1.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer1.com/tls/server.crt
      cp ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer1.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer1.com/tls/server.key

      mkdir ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer1.com/msp/tlscacerts
      cp ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer1.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer1.com/msp/tlscacerts/tlsca.orderer.com-cert.pem

      mkdir ${PWD}/../crypto-config/ordererOrganizations/orderer.com/msp/tlscacerts
      cp ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer1.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/orderer.com/msp/tlscacerts/tlsca.orderer.com-cert.pem

      


      echo
      echo "Register orderer2"
      echo
       
      fabric-ca-client register --caname ca.orderer.com --id.name orderer2 --id.secret orderer2pw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/orderer/tls-cert.pem
       
      # ---------------------------------------------------------------------------
      #  orderer

      mkdir -p ../crypto-config/ordererOrganizations/orderer.com/orderers/orderer2.com

      echo
      echo "## Generate the  orderer2 msp"
      echo
      
      fabric-ca-client enroll -u https://orderer2:orderer2pw@localhost:11054 --caname ca.orderer.com -M ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer2.com/msp --csr.hosts orderer2.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/orderer/tls-cert.pem
      

      cp ${PWD}/../crypto-config/ordererOrganizations/orderer.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer2.com/msp/config.yaml

      echo
      echo "## Generate the orderer2-tls certificates"
      echo
      
      fabric-ca-client enroll -u https://orderer2:orderer2pw@localhost:11054 --caname ca.orderer.com -M ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer2.com/tls --enrollment.profile tls --csr.hosts orderer2.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/orderer/tls-cert.pem
      

      cp ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer2.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer2.com/tls/ca.crt
      cp ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer2.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer2.com/tls/server.crt
      cp ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer2.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer2.com/tls/server.key

      mkdir ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer2.com/msp/tlscacerts
      cp ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer2.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer2.com/msp/tlscacerts/tlsca.orderer.com-cert.pem

      mkdir ${PWD}/../crypto-config/ordererOrganizations/orderer.com/msp/tlscacerts
      cp ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer2.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/orderer.com/msp/tlscacerts/tlsca.orderer.com-cert.pem

      


      echo
      echo "Register orderer3"
      echo
       
      fabric-ca-client register --caname ca.orderer.com --id.name orderer3 --id.secret orderer3pw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/orderer/tls-cert.pem
       
      # ---------------------------------------------------------------------------
      #  orderer

      mkdir -p ../crypto-config/ordererOrganizations/orderer.com/orderers/orderer3.com

      echo
      echo "## Generate the  orderer3 msp"
      echo
      
      fabric-ca-client enroll -u https://orderer3:orderer3pw@localhost:11054 --caname ca.orderer.com -M ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer3.com/msp --csr.hosts orderer3.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/orderer/tls-cert.pem
      

      cp ${PWD}/../crypto-config/ordererOrganizations/orderer.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer3.com/msp/config.yaml

      echo
      echo "## Generate the orderer3-tls certificates"
      echo
      
      fabric-ca-client enroll -u https://orderer3:orderer3pw@localhost:11054 --caname ca.orderer.com -M ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer3.com/tls --enrollment.profile tls --csr.hosts orderer3.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/orderer/tls-cert.pem
      

      cp ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer3.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer3.com/tls/ca.crt
      cp ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer3.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer3.com/tls/server.crt
      cp ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer3.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer3.com/tls/server.key

      mkdir ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer3.com/msp/tlscacerts
      cp ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer3.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer3.com/msp/tlscacerts/tlsca.orderer.com-cert.pem

      mkdir ${PWD}/../crypto-config/ordererOrganizations/orderer.com/msp/tlscacerts
      cp ${PWD}/../crypto-config/ordererOrganizations/orderer.com/orderers/orderer3.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/orderer.com/msp/tlscacerts/tlsca.orderer.com-cert.pem

      


      mkdir -p ../crypto-config/ordererOrganizations/orderer.com/users
      mkdir -p ../crypto-config/ordererOrganizations/orderer.com/users/Admin@orderer.com

      echo
      echo "## Generate the admin msp"
      echo
      
      fabric-ca-client enroll -u https://ordereradmin:ordereradminpw@localhost:11054 --caname ca.orderer.com -M ${PWD}/../crypto-config/ordererOrganizations/orderer.com/users/Admin@orderer.com/msp --tls.certfiles ${PWD}/fabric-ca/orderer/tls-cert.pem
      

      cp ${PWD}/../crypto-config/ordererOrganizations/orderer.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/orderer.com/users/Admin@orderer.com/msp/config.yaml

        
}
 



  createConnectionProfile() {
    cd ../../../../api/connection-profiles && ./generate-ccp.sh

    cp connection-manufacturer-caliper.json ../../blockchain/artifacts/channel/crypto-config/peerOrganizations/manufacturer.com/
  } 
  
  
CreateCertificatesFormanufacturer
CreateCertificatesFordistributor
CreateCertificatesForpharmacy
CreateCertificatesForregulator
CreateCertificatesFororderer

createConnectionProfile