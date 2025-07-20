# Blockchain Network Setup Guide

## Overview

This repository contains a complete blockchain network implementation with API integration, performance testing tools, and network explorer. The setup includes comprehensive tooling for development, monitoring, and testing of blockchain applications.

## 📁 Repository Structure

```
.
├── api/                 # Basic CRUD operation API structure
├── blockchain/
│   ├── artifacts/      # Network configuration for all services
│   ├── Explorer/       # Blockchain Explorer implementation
│   ├── performance-tool/# Performance testing tools
│   └── scripts/        # Channel creation and chaincode deployment scripts
```

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed (latest version)
- Node.js and npm installed (v20)
- MongoDB (for API integration) (latest version)
- Hyperledger fabric: v2.5

### Standard Network Creation Steps

1. CA Creation
2. Cryptomaterial creation
3. Create artifacts
4. Run all services
5. Create Channel
6. Deploy Chaincode

## 🔧 Detailed Setup Instructions

### Blockchain Network Setup

1. Set appropriate permissions for home repo
```bash
sudo chmod -R 777 *
```

2. Create certificates with CA
```bash
cd blockchain/artifacts/channel/create-certificate-with-ca
docker compose up -d
./create-certificate-with-ca.sh
```

3. Create artifacts
```bash
cd ../
./create-artifacts.sh
```

4. Start network services
```bash
cd ../
docker compose up -d
```

5. Create channel and deploy chaincode, here mentioning for the first channel and its chaincode
```bash
cd ../scripts
./create-mychannel1.sh
./deploy-chaincode1.sh
```

6. You an access CouchDB here
- URL: `http://127.0.0.1:5984/_utils/`
- Credentials:
  - Username: `admin`
  - Password: `adminpw`

### 🔍 Explorer Setup

1. Launch Explorer
```bash
cd blockchain/Explorer
docker compose up -d
```

2. Access Explorer Dashboard
- URL: `http://localhost:8081`
- Credentials:
  - Username: `exploreradmin`
  - Password: `exploreradminpw`

### ⚡ Performance Testing (Caliper)

1. Install dependencies
```bash
cd blockchain/performance-tool/caliper/caliper-benchmarks-local
npm install
```

2. Run Caliper
```bash
cd ..
docker compose up -d
```

3. Monitor progress
```bash
docker logs caliper -f
```

The benchmark report will be generated as `report.html` upon completion.

### 🖥️ API Setup

1. Install dependencies
```bash
cd api
npm install
```

2. Configure environment
- Copy `.env.sample` to `.env`
- Add MongoDB credentials

3. Install nodemon globally
```bash
sudo npm i -g nodemon
```

4. Start the server
```bash
nodemon app.js
```

The API server will run on `localhost:3000`

### 📝 API Documentation

- Postman collections are available at `api/src/postman/`
- The bootstrap script (`bootstrap.js`) handles:
  - Organization and user seeding in MongoDB
  - User credential creation using CA
  - Wallet storage

## 📌 Important Notes

- Explorer and Caliper are configured for the first channel of the first organization
- API includes connection configurations for all organizations
- Users can switch between organizations using different users defined in `bootstrap.js`

## 🎓 Additional Resources

For detailed setup instructions and configuration modifications, please refer to our YouTube video tutorial.

## 💡 Customization

Feel free to modify the Explorer and Caliper configurations according to your specific requirements. The API connection configurations support multiple organizations and can be customized as needed.

---

For questions or support, please check our video tutorial or raise an issue in the repository.