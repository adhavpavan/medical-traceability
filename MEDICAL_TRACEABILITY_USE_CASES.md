# Medical Traceability System - Use Cases

## Overview

This medical traceability system is built on Hyperledger Fabric blockchain technology to ensure end-to-end transparency and security in the pharmaceutical supply chain. The system tracks medicines from manufacturing through distribution to retail, ensuring product authenticity, monitoring storage conditions, and preventing counterfeiting.

## System Architecture

### Organizations
1. **Manufacturer** (OrgID: 1) - Pharmaceutical companies that produce medicines
2. **Distributor** (OrgID: 2) - Wholesale distributors who handle bulk shipments
3. **Pharmacy** (OrgID: 3) - Retail pharmacies that sell to end consumers
4. **Regulator** (OrgID: 4) - Government regulatory bodies for compliance monitoring

### Blockchain Channels
1. **producer-distributor-channel** 
   - **Organizations**: Manufacturer, Distributor, Regulator
   - **Purpose**: Handles product creation and batch manufacturing
2. **distributor-retailer-channel**
   - **Organizations**: Distributor, Pharmacy, Regulator
   - **Purpose**: Manages shipments and IoT sensor data

### Smart Contracts (Chaincode)
- **Chaincode 1** (producer-distributor-channel): Product and batch management
- **Chaincode 2** (distributor-retailer-channel): Shipment tracking and IoT data with incident detection

## Detailed Use Cases

### 1. Product Registration and Management

**Primary Actor**: Manufacturer  
**Channel**: producer-distributor-channel

**Description**: Manufacturers register new pharmaceutical products with comprehensive details including formulation, storage requirements, and regulatory approvals.

**Process Flow**:
1. Manufacturer logs into the system
2. Creates new product with details:
   - Product name, barcode, QR code
   - Pharmaceutical form and strength
   - Active ingredients
   - Storage conditions (temperature, humidity)
   - Transport conditions
   - GMP approval and registration numbers
3. Product is recorded on blockchain with unique ID
4. Product status set to "active"

**Key Features**:
- Immutable product registry
- Complete audit trail of product modifications
- Query products by name, barcode, or status

### 2. Batch Manufacturing and Quality Control

**Primary Actor**: Manufacturer  
**Channel**: producer-distributor-channel

**Description**: Track production batches with quality certificates and expiration dates.

**Process Flow**:
1. Manufacturer creates batch linked to registered product
2. Records batch details:
   - Batch number and manufacturing date
   - Expiration date
   - Quantity and serial numbers
   - Manufacturing site details
   - Quality control certificates
   - Storage and transport instructions with temperature/humidity ranges
3. Batch receives unique blockchain ID
4. Initial status: "manufactured"

**Key Features**:
- Batch quantity tracking (available, reserved, shipped)
- Quality certificate management
- Expiration date monitoring
- Temperature/humidity threshold definition for transport

### 3. Shipment Creation and Tracking

**Primary Actor**: Distributor  
**Channel**: distributor-retailer-channel

**Description**: Create and track shipments from distributor to pharmacy with real-time monitoring.

**Process Flow**:
1. Distributor creates shipment for specific batch
2. Defines shipment parameters:
   - Origin and destination
   - Transport mode
   - Expected pickup/delivery timestamps
   - Transport conditions
   - Milestones
3. Shipment status: "pending" → "in_transit" → "delivered"
4. Stakeholder tracking throughout journey

**Key Features**:
- Multi-stakeholder visibility
- Status tracking with timestamps
- Comment/note system for updates
- Integration with batch transport requirements

### 4. IoT Device Integration and Monitoring

**Primary Actor**: Carrier/Distributor  
**Channel**: distributor-retailer-channel

**Description**: Register IoT devices and collect real-time sensor data during transport.

**Process Flow**:
1. Register IoT device with specifications
2. Link device to shipment
3. Continuously collect sensor data:
   - Temperature readings
   - Humidity levels
   - Device battery status
4. Store all readings on blockchain
5. Real-time monitoring dashboard

**Key Features**:
- Device registry management
- Continuous data collection
- Battery level monitoring
- Historical data retrieval

### 5. Automated Incident Detection

**Primary Actor**: System (Automated)  
**Channel**: distributor-retailer-channel

**Description**: Automatically detect and record incidents when sensor readings breach defined thresholds.

**Process Flow**:
1. System receives IoT sensor data
2. Compares against batch transport requirements
3. If breach detected:
   - Creates incident record
   - Links to shipment, batch, and event
   - Records breach details (actual vs. required values)
   - Timestamps incident
4. Incident stored on blockchain
5. Alerts sent to stakeholders

**Incident Types**:
- Temperature breach (too high/low)
- Humidity breach (too high/low)

**Key Features**:
- Real-time threshold monitoring
- Automatic incident creation
- Complete traceability to specific events
- Compliance reporting support

### 6. Supply Chain Visibility and Compliance

**Primary Actor**: Regulator  
**Channels**: Both channels (read access)

**Description**: Regulators monitor the entire supply chain for compliance and safety.

**Capabilities**:
1. View all products and batches
2. Track shipment history
3. Review incident reports
4. Audit quality certificates
5. Verify transport conditions
6. Generate compliance reports

**Key Features**:
- Read-only access to all data
- Historical audit trails
- Incident analysis
- Compliance verification

### 7. Product Authentication and Anti-Counterfeiting

**Primary Actor**: Pharmacy/End User  
**Channels**: Both channels

**Description**: Verify product authenticity using blockchain records.

**Process Flow**:
1. Scan product QR code or barcode
2. System queries blockchain
3. Returns:
   - Product details and manufacturer
   - Batch information and expiry
   - Complete supply chain history
   - Any incidents during transport
4. Verification of authenticity

**Key Features**:
- Instant verification
- Complete chain of custody
- Incident transparency
- Counterfeit detection

## Security and Access Control

### Role-Based Permissions
- **Manufacturer**: Create products/batches, view own data
- **Distributor**: Create shipments, manage IoT devices, view relevant data
- **Pharmacy**: Receive shipments, verify products, view history
- **Regulator**: Read-only access to entire system

### Blockchain Security Features
- Immutable transaction history
- Cryptographic signatures
- Consensus-based validation
- Private data collections for sensitive information

## Technical Implementation Details

### Data Models

**Product**:
```javascript
{
  id: "PRODUCT-xxx",
  docType: "product",
  barcode: "xxx",
  productName: "xxx",
  manufacturer: {...},
  storageConditions: {...},
  transportConditions: {...},
  status: "active"
}
```

**Batch**:
```javascript
{
  id: "BATCH-xxx",
  docType: "batch",
  productId: "PRODUCT-xxx",
  quantity: 1000,
  transportInstructions: {
    temperatureHigh: 25,
    temperatureLow: 2,
    humidityHigh: 60,
    humidityLow: 30
  }
}
```

**Incident**:
```javascript
{
  id: "Incident-xxx",
  docType: "INCIDENT",
  shipmentId: "xxx",
  batchId: "xxx",
  incidentType: "Temperature Breach",
  data: {
    value: 28,
    minValue: 2,
    maxValue: 25
  }
}
```

### API Endpoints

**Product Management**:
- POST /api/v1/products - Create product
- GET /api/v1/products/:id - Get product details
- GET /api/v1/products - Query products with pagination

**Batch Management**:
- POST /api/v1/batches - Create batch
- GET /api/v1/batches/:id - Get batch details
- PUT /api/v1/batches/:id/quantity - Update batch quantity

**Shipment Management**:
- POST /api/v1/shipments - Create shipment
- PUT /api/v1/shipments/:id/send - Update to in-transit
- PUT /api/v1/shipments/:id/deliver - Mark as delivered

**IoT Integration**:
- POST /api/v1/devices - Register IoT device
- POST /api/v1/iot-data - Submit sensor readings

## Benefits

1. **Transparency**: Complete visibility across supply chain
2. **Security**: Tamper-proof blockchain records
3. **Compliance**: Automated regulatory reporting
4. **Quality Assurance**: Real-time condition monitoring
5. **Efficiency**: Reduced paperwork and manual processes
6. **Trust**: Verified product authenticity
7. **Safety**: Immediate incident detection and response

## Architecture Diagrams

The system architecture is visualized through several draw.io diagrams:

1. **Network Architecture Diagram** (`diagrams/network-architecture.drawio`)
   - Shows the complete blockchain network structure
   - Illustrates channel organization membership
   - Displays peer nodes, orderer cluster, and client applications

2. **Data Flow Diagram** (`diagrams/data-flow.drawio`)
   - Demonstrates the complete data flow through the system
   - Shows three phases: Product/Batch Creation, Shipment/Distribution, and Verification/Delivery
   - Highlights incident detection and monitoring

3. **Sequence Diagrams** (`diagrams/sequence-diagrams.drawio`)
   - **Product Creation Flow**: Shows how manufacturers create products on Channel 1
   - **Shipment with IoT Monitoring**: Illustrates shipment tracking and automated incident detection on Channel 2
   - **Product Verification Flow**: Demonstrates pharmacy verification process accessing both channels

## Future Enhancements

1. Integration with external regulatory databases
2. AI-powered predictive analytics for incident prevention
3. Mobile applications for field verification
4. Extended IoT sensor types (location, shock, light exposure)
5. Smart contract automation for payments and penalties
6. Multi-language support for global deployment