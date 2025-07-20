const { getContractObject, getDataWithPagination } = require('../utils/blockchainUtils');
const {
  NETWORK_ARTIFACTS_DEFAULT,
  BLOCKCHAIN_DOC_TYPE,
} = require('../utils/Constants');
const { getUUID } = require('../utils/uuid');

const utf8Decoder = new TextDecoder();

const createProduct = async (productData, user) => {
  let gateway;
  let client;
  try {
    let dateTime = new Date();
    console.log(user,"user")
    let orgName = user?.orgName || `org${user.orgId}`

    if (parseInt(user.orgId) !== 1) {
      throw new Error('You are not authorized to create products. Only manufacturers can create products.');
    }

    let product = {
      id: 'PRODUCT-' + getUUID(),
      docType: BLOCKCHAIN_DOC_TYPE.PRODUCT,
      barcode: productData.barcode,
      qrCode: productData.qrCode,
      productName: productData.productName,
      pharmaceuticalForm: productData.pharmaceuticalForm,
      strength: productData.strength,
      packSize: productData.packSize,
      manufacturer: {
        companyName: productData.manufacturerName,
        siteCode: productData.manufacturerSiteCode,
        licenseNumber: productData.manufacturerLicenseNumber
      },
      gmpApproval: productData.gmpApproval || null,
      therapeuticCategory: productData.therapeuticCategory,
      activeIngredients: productData.activeIngredients || [],
      storageConditions: productData.storageConditions,
      transportConditions: {
        temperature: productData.transportTemperature,
        humidity: productData.transportHumidity
      },
      registrationNumber: productData.registrationNumber,
      status: 'active',
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

    await contract.submitTransaction('CreateAsset', JSON.stringify(product));

    return product;
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

const updateProduct = async (productId, updateData, user) => {
  let gateway;
  let client;
  try {
    let dateTime = new Date();
    let orgName = `org${user.orgId}`;

    if (parseInt(user.orgId) !== 1) {
      throw new Error('You are not authorized to update products. Only manufacturers can update products.');
    }

    const contract = await getContractObject(
      orgName,
      user.email,
      NETWORK_ARTIFACTS_DEFAULT.CHANNEL_NAME,
      NETWORK_ARTIFACTS_DEFAULT.CHAINCODE_NAME,
      gateway,
      client
    );

    let product = await contract.submitTransaction('CreateAsset', productId);
    let productJSON = JSON.parse(utf8Decoder.decode(product));

    if (productJSON.docType !== BLOCKCHAIN_DOC_TYPE.PRODUCT) {
      throw new Error('Invalid product ID');
    }

    Object.assign(productJSON, updateData, {
      updatedAt: dateTime,
      updatedBy: user.email
    });

    await contract.submitTransaction('UpdateProduct', JSON.stringify(productJSON));

    return productJSON;
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

const getProductById = async (productId, user) => {
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

    let result = await contract.submitTransaction('getAssetByID', productId);
    result = JSON.parse(utf8Decoder.decode(result));

    if (result.docType !== BLOCKCHAIN_DOC_TYPE.PRODUCT) {
      throw new Error('Product not found');
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

const queryProductsWithPagination = async (filter, user) => {
  try {
    let query;
    
    if (filter.searchTerm) {
      query = `{"selector":{"docType": "${BLOCKCHAIN_DOC_TYPE.PRODUCT}", "$or": [{"productName": {"$regex": "(?i)${filter.searchTerm}"}}, {"barcode": {"$regex": "(?i)${filter.searchTerm}"}}]}}`;
    } else if (filter.status) {
      query = `{"selector":{"docType": "${BLOCKCHAIN_DOC_TYPE.PRODUCT}", "status": "${filter.status}"}}`;
    } else {
      query = `{"selector":{"docType": "${BLOCKCHAIN_DOC_TYPE.PRODUCT}"}}`;
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

const getProductHistory = async (productId, user) => {
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

    let result = await contract.submitTransaction('getAssetHistory', productId);
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

module.exports = {
  createProduct,
  updateProduct,
  getProductById,
  queryProductsWithPagination,
  getProductHistory
};