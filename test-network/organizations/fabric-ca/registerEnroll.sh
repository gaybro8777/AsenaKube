

function createOrg1 {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/peerOrganizations/org1.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-org1 --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/peerOrganizations/org1.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-org1 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-org1 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-org1 --id.name org1admin --id.secret org1adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x

	mkdir -p organizations/peerOrganizations/org1.com/peers
  mkdir -p organizations/peerOrganizations/org1.com/peers/peer0.org1.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.com/peers/peer0.org1.com/msp --csr.hosts peer0.org1.com --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org1.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.com/peers/peer0.org1.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.com/peers/peer0.org1.com/tls --enrollment.profile tls --csr.hosts peer0.org1.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x


  cp ${PWD}/organizations/peerOrganizations/org1.com/peers/peer0.org1.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.com/peers/peer0.org1.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org1.com/peers/peer0.org1.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.com/peers/peer0.org1.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org1.com/peers/peer0.org1.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.com/peers/peer0.org1.com/tls/server.key

  mkdir ${PWD}/organizations/peerOrganizations/org1.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org1.com/peers/peer0.org1.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/organizations/peerOrganizations/org1.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/org1.com/peers/peer0.org1.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.com/tlsca/tlsca.org1.com-cert.pem

  mkdir ${PWD}/organizations/peerOrganizations/org1.com/ca
  cp ${PWD}/organizations/peerOrganizations/org1.com/peers/peer0.org1.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org1.com/ca/ca.org1.com-cert.pem

  mkdir -p organizations/peerOrganizations/org1.com/users
  mkdir -p organizations/peerOrganizations/org1.com/users/User1@org1.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.com/users/User1@org1.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x

  mkdir -p organizations/peerOrganizations/org1.com/users/Admin@org1.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://org1admin:org1adminpw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.com/users/Admin@org1.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org1.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.com/users/Admin@org1.com/msp/config.yaml

echo
	echo "Register peer1"
  echo
  set -x
	fabric-ca-client register --caname ca-org1 --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x

	mkdir -p organizations/peerOrganizations/org1.com/peers
  mkdir -p organizations/peerOrganizations/org1.com/peers/peer1.org1.com

  echo
  echo "## Generate the peer1 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.com/peers/peer1.org1.com/msp --csr.hosts peer1.org1.com --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org1.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.com/peers/peer1.org1.com/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.com/peers/peer1.org1.com/tls --enrollment.profile tls --csr.hosts peer1.org1.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x


  cp ${PWD}/organizations/peerOrganizations/org1.com/peers/peer1.org1.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.com/peers/peer1.org1.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org1.com/peers/peer1.org1.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.com/peers/peer1.org1.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org1.com/peers/peer1.org1.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.com/peers/peer1.org1.com/tls/server.key

  mkdir -p organizations/peerOrganizations/org1.com/users
  mkdir -p organizations/peerOrganizations/org1.com/users/User1@org1.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.com/users/User1@org1.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x

  mkdir -p organizations/peerOrganizations/org1.com/users/Admin@org1.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://org1admin:org1adminpw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.com/users/Admin@org1.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org1.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.com/users/Admin@org1.com/msp/config.yaml

}


function createOrg2 {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/peerOrganizations/org2.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org2.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-org2 --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/peerOrganizations/org2.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-org2 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-org2 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-org2 --id.name org2admin --id.secret org2adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x

	mkdir -p organizations/peerOrganizations/org2.com/peers
  mkdir -p organizations/peerOrganizations/org2.com/peers/peer0.org2.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.com/peers/peer0.org2.com/msp --csr.hosts peer0.org2.com --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org2.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.com/peers/peer0.org2.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.com/peers/peer0.org2.com/tls --enrollment.profile tls --csr.hosts peer0.org2.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x


  cp ${PWD}/organizations/peerOrganizations/org2.com/peers/peer0.org2.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.com/peers/peer0.org2.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org2.com/peers/peer0.org2.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org2.com/peers/peer0.org2.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org2.com/peers/peer0.org2.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org2.com/peers/peer0.org2.com/tls/server.key

  mkdir ${PWD}/organizations/peerOrganizations/org2.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org2.com/peers/peer0.org2.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/organizations/peerOrganizations/org2.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/org2.com/peers/peer0.org2.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.com/tlsca/tlsca.org2.com-cert.pem

  mkdir ${PWD}/organizations/peerOrganizations/org2.com/ca
  cp ${PWD}/organizations/peerOrganizations/org2.com/peers/peer0.org2.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org2.com/ca/ca.org2.com-cert.pem

  mkdir -p organizations/peerOrganizations/org2.com/users
  mkdir -p organizations/peerOrganizations/org2.com/users/User1@org2.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.com/users/User1@org2.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x

  mkdir -p organizations/peerOrganizations/org2.com/users/Admin@org2.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://org2admin:org2adminpw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.com/users/Admin@org2.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org2.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.com/users/Admin@org2.com/msp/config.yaml

echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/peerOrganizations/org2.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org2.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-org2 --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/peerOrganizations/org2.com/msp/config.yaml

  echo
	echo "Register peer1"
  echo
  set -x
	fabric-ca-client register --caname ca-org2 --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x

	mkdir -p organizations/peerOrganizations/org2.com/peers
  mkdir -p organizations/peerOrganizations/org2.com/peers/peer1.org2.com

  echo
  echo "## Generate the peer1 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.com/peers/peer1.org2.com/msp --csr.hosts peer1.org2.com --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org2.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.com/peers/peer1.org2.com/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.com/peers/peer1.org2.com/tls --enrollment.profile tls --csr.hosts peer1.org2.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x


  cp ${PWD}/organizations/peerOrganizations/org2.com/peers/peer1.org2.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.com/peers/peer1.org2.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org2.com/peers/peer1.org2.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org2.com/peers/peer1.org2.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org2.com/peers/peer1.org2.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org2.com/peers/peer1.org2.com/tls/server.key

  mkdir -p organizations/peerOrganizations/org2.com/users
  mkdir -p organizations/peerOrganizations/org2.com/users/User1@org2.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.com/users/User1@org2.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x

  mkdir -p organizations/peerOrganizations/org2.com/users/Admin@org2.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://org2admin:org2adminpw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.com/users/Admin@org2.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org2.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.com/users/Admin@org2.com/msp/config.yaml

}

function createOrderer {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/ordererOrganizations/org0.com

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/org0.com
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/ordererOrganizations/org0.com/msp/config.yaml


  echo
	echo "Register orderer"
  echo
  set -x
	fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
    set +x

  echo
  echo "Register the orderer admin"
  echo
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

	mkdir -p organizations/ordererOrganizations/org0.com/orderers
  mkdir -p organizations/ordererOrganizations/org0.com/orderers/org0.com

  mkdir -p organizations/ordererOrganizations/org0.com/orderers/orderer.org0.com

  echo
  echo "## Generate the orderer msp"
  echo
  set -x
	fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/org0.com/orderers/orderer.org0.com/msp --csr.hosts orderer.org0.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/org0.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/org0.com/orderers/orderer.org0.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/org0.com/orderers/orderer.org0.com/tls --enrollment.profile tls --csr.hosts orderer.org0.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/org0.com/orderers/orderer.org0.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/org0.com/orderers/orderer.org0.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/org0.com/orderers/orderer.org0.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/org0.com/orderers/orderer.org0.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/org0.com/orderers/orderer.org0.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/org0.com/orderers/orderer.org0.com/tls/server.key

  mkdir ${PWD}/organizations/ordererOrganizations/org0.com/orderers/orderer.org0.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/org0.com/orderers/orderer.org0.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/org0.com/orderers/orderer.org0.com/msp/tlscacerts/tlsca.org0.com-cert.pem

  mkdir ${PWD}/organizations/ordererOrganizations/org0.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/org0.com/orderers/orderer.org0.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/org0.com/msp/tlscacerts/tlsca.org0.com-cert.pem

  mkdir -p organizations/ordererOrganizations/org0.com/users
  mkdir -p organizations/ordererOrganizations/org0.com/users/Admin@org0.com

  echo
  echo "## Generate the admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/org0.com/users/Admin@org0.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/org0.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/org0.com/users/Admin@org0.com/msp/config.yaml


}
