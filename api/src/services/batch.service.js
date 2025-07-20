const { getContractObject, getDataWithPagination } = require('../utils/blockchainUtils');
const {
  NETWORK_ARTIFACTS_DEFAULT,
  BLOCKCHAIN_DOC_TYPE,
} = require('../utils/Constants');
const { getUUID } = require('../utils/uuid');

const utf8Decoder = new TextDecoder();

const createBatch = async (batchData, user) => {
  let gateway;
  let client;
  try {
    let dateTime = new Date();
    let orgName = user?.orgName || `org${user.orgId}`;

    if (parseInt(user.orgId) !== 1) {
      throw new Error('You are not authorized to create batches. Only manufacturers can create batches.');
    }

    let batch = {
      id: 'BATCH-' + getUUID(),
      docType: BLOCKCHAIN_DOC_TYPE.BATCH,
      batchNumber: batchData.batchNumber,
      productId: batchData.productId,
      manufacturingDate: batchData.manufacturingDate,
      expirationDate: batchData.expirationDate,
      quantity: batchData.quantity,
      unit: batchData.unit,
      serialNumbers: batchData.serialNumbers || [],
      gs1Code: batchData.gs1Code,
      manufacturingSite: {
        siteCode: batchData.manufacturingSiteCode,
        siteName: batchData.manufacturingSiteName,
        address: batchData.manufacturingSiteAddress
      },
      qualityCertificates: {
        gmpApproval: batchData.gmpApproval,
        batchReleaseNumber: batchData.batchReleaseNumber,
        qualityControlDate: batchData.qualityControlDate,
        qualityControlPassed: batchData.qualityControlPassed || true
      },
      storageInstructions: {
        temperature: batchData.storageTemperature,
        humidity: batchData.storageHumidity,
        lightConditions: batchData.storageLightConditions,
        specialInstructions: batchData.storageSpecialInstructions
      },
      transportInstructions: {
        temperature: batchData.transportTemperature,
        humidity: batchData.transportHumidity,
        handlingInstructions: batchData.transportHandlingInstructions
      },
      status: 'manufactured',
      availableQuantity: batchData.quantity,
      reservedQuantity: 0,
      shippedQuantity: 0,
      createdAt: dateTime,
      updatedAt: dateTime,
      createdBy: user.email,
      updatedBy: user.email
    };

    const contract = await getContractObject(
      orgName,
      user.email,
      NETWORK_ARTIFACTS_DEFAULT.CHANNEL_NAME,
      NETWORK_ARTIFACTS_DEFAULT.CHAINCODE_NAME,
      gateway,
      client
    );

    await contract.submitTransaction('CreateAsset', JSON.stringify(batch));

    return batch;
  } catch (error) {
    console.log(error);
    throw error;
  } finally {
    if (gateway) {
      gateway.close();
    }
    if (client) {
      client.close();
    }
  }
};

const updateBatch = async (batchId, updateData, user) => {
  let gateway;
  let client;
  try {
    let dateTime = new Date();
    let orgName = `org${user.orgId}`;

    const contract = await getContractObject(
      orgName,
      user.email,
      NETWORK_ARTIFACTS_DEFAULT.CHANNEL_NAME,
      NETWORK_ARTIFACTS_DEFAULT.CHAINCODE_NAME,
      gateway,
      client
    );

    let batch = await contract.submitTransaction('getAssetByID', batchId);
    let batchJSON = JSON.parse(utf8Decoder.decode(batch));

    if (batchJSON.docType !== BLOCKCHAIN_DOC_TYPE.BATCH) {
      throw new Error('Invalid batch ID');
    }

    if (parseInt(user.orgId) !== 1 && updateData.status) {
      throw new Error('Only manufacturers can update batch status');
    }

    Object.assign(batchJSON, updateData, {
      updatedAt: dateTime,
      updatedBy: user.email
    });

    await contract.submitTransaction('UpdateBatch', JSON.stringify(batchJSON));

    return batchJSON;
  } catch (error) {
    console.log(error);
    throw error;
  } finally {
    if (gateway) {
      gateway.close();
    }
    if (client) {
      client.close();
    }
  }
};

const getBatchById = async (batchId, user) => {
  let gateway;
  let client;
  try {
    let orgName = `org${user.orgId}`;

    const contract = await getContractObject(
      orgName,
      user.email,
      NETWORK_ARTIFACTS_DEFAULT.CHANNEL_NAME,
      NETWORK_ARTIFACTS_DEFAULT.CHAINCODE_NAME,
      gateway,
      client
    );

    let result = await contract.submitTransaction('getAssetByID', batchId);
    result = JSON.parse(utf8Decoder.decode(result));

    if (result.docType !== BLOCKCHAIN_DOC_TYPE.BATCH) {
      throw new Error('Batch not found');
    }

    return result;
  } catch (error) {
    console.log(error);
    throw error;
  } finally {
    if (gateway) {
      gateway.close();
    }
    if (client) {
      client.close();
    }
  }
};

const queryBatchesWithPagination = async (filter, user) => {
  try {
    let query;
    
    if (filter.productId) {
      query = `{"selector":{"docType": "${BLOCKCHAIN_DOC_TYPE.BATCH}", "productId": "${filter.productId}"}}`;
    } else if (filter.status) {
      query = `{"selector":{"docType": "${BLOCKCHAIN_DOC_TYPE.BATCH}", "status": "${filter.status}"}}`;
    } else if (filter.batchNumber) {
      query = `{"selector":{"docType": "${BLOCKCHAIN_DOC_TYPE.BATCH}", "batchNumber": {"$regex": "(?i)${filter.batchNumber}"}}}`;
    } else if (filter.expiringBefore) {
      query = `{"selector":{"docType": "${BLOCKCHAIN_DOC_TYPE.BATCH}", "expirationDate": {"$lt": "${filter.expiringBefore}"}}}`;
    } else {
      query = `{"selector":{"docType": "${BLOCKCHAIN_DOC_TYPE.BATCH}"}}`;
    }

    let data = await getDataWithPagination(
      query,
      filter.pageSize || 20,
      filter.bookmark || '',
      user?.orgName || `org${user.orgId}`,
      user.email,
      NETWORK_ARTIFACTS_DEFAULT.CHANNEL_NAME,
      NETWORK_ARTIFACTS_DEFAULT.CHAINCODE_NAME
    );

    return data;
  } catch (error) {
    console.log('error--------------', error);
    throw error;
  }
};

const getBatchHistory = async (batchId, user) => {
  let gateway;
  let client;
  try {
    let orgName = `org${user.orgId}`;
    const contract = await getContractObject(
      orgName,
      user.email,
      NETWORK_ARTIFACTS_DEFAULT.CHANNEL_NAME,
      NETWORK_ARTIFACTS_DEFAULT.CHAINCODE_NAME,
      gateway,
      client
    );

    let result = await contract.submitTransaction('getAssetHistory', batchId);
    result = JSON.parse(utf8Decoder.decode(result));
    
    if (result) {
      result = result?.map(elm => {
        return { 
          txId: elm?.txId, 
          IsDelete: elm.IsDelete, 
          ...elm.Value, 
          timeStamp: elm?.Timestamp?.seconds?.low * 1000 
        };
      });
    }
    
    return result;
  } catch (error) {
    console.log(error);
    throw error;
  } finally {
    if (gateway) {
      gateway.close();
    }
    if (client) {
      client.close();
    }
  }
};

const updateBatchQuantity = async (batchId, quantityUpdate, user) => {
  let gateway;
  let client;
  try {
    let dateTime = new Date();
    let orgName = `org${user.orgId}`;

    const contract = await getContractObject(
      orgName,
      user.email,
      NETWORK_ARTIFACTS_DEFAULT.CHANNEL_NAME,
      NETWORK_ARTIFACTS_DEFAULT.CHAINCODE_NAME,
      gateway,
      client
    );

    let batch = await contract.submitTransaction('getAssetByID', batchId);
    let batchJSON = JSON.parse(utf8Decoder.decode(batch));

    if (batchJSON.docType !== BLOCKCHAIN_DOC_TYPE.BATCH) {
      throw new Error('Invalid batch ID');
    }

    if (quantityUpdate.type === 'reserve') {
      if (batchJSON.availableQuantity < quantityUpdate.quantity) {
        throw new Error('Insufficient available quantity');
      }
      batchJSON.availableQuantity -= quantityUpdate.quantity;
      batchJSON.reservedQuantity += quantityUpdate.quantity;
    } else if (quantityUpdate.type === 'ship') {
      if (batchJSON.reservedQuantity < quantityUpdate.quantity) {
        throw new Error('Insufficient reserved quantity');
      }
      batchJSON.reservedQuantity -= quantityUpdate.quantity;
      batchJSON.shippedQuantity += quantityUpdate.quantity;
    } else if (quantityUpdate.type === 'release') {
      if (batchJSON.reservedQuantity < quantityUpdate.quantity) {
        throw new Error('Insufficient reserved quantity');
      }
      batchJSON.reservedQuantity -= quantityUpdate.quantity;
      batchJSON.availableQuantity += quantityUpdate.quantity;
    }

    batchJSON.updatedAt = dateTime;
    batchJSON.updatedBy = user.email;

    await contract.submitTransaction('UpdateBatch', JSON.stringify(batchJSON));

    return batchJSON;
  } catch (error) {
    console.log(error);
    throw error;
  } finally {
    if (gateway) {
      gateway.close();
    }
    if (client) {
      client.close();
    }
  }
};

module.exports = {
  createBatch,
  updateBatch,
  getBatchById,
  queryBatchesWithPagination,
  getBatchHistory,
  updateBatchQuantity
};