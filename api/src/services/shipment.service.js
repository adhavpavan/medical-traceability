const httpStatus = require('http-status');
const { User } = require('../models');
const mongoose = require('mongoose');

const ApiError = require('../utils/ApiError');
const { Gateway, Wallets } = require('fabric-network');
const { getContractObject, getDataWithPagination } = require('../utils/blockchainUtils');
const { NETWORK_ARTIFACTS_DEFAULT, BLOCKCHAIN_DOC_TYPE, SHIPMENT_STATUS } = require('../utils/Constants');
const { getUUID } = require('../utils/uuid');

// If we are sure that max records are limited, we can use any max number
const DEFAULT_MAX_RECORDS = 100;
const utf8Decoder = new TextDecoder();
let stakeholder = [
  { orgName: 'Shipper', orgId: 1 },
  { orgName: 'Carrier', orgId: 2 },
  { orgName: 'Consinee', orgId: 3 },
];

const addShipment = async (shipmentData, user) => {
  console.log('----------addshipment--------------', shipmentData, user);
  let gateway;
  let client;
  let id = new mongoose.Types.ObjectId();
  try {
    let dateTime = new Date();
    let orgName = user.orgName || `org${user.orgId}`;
    console.log("--------------------------------", user)
    if (parseInt(user.orgId) != 2) {
      throw new Error('You are not authorized to create shipment');
    }

    let shipment = {
      id: 'Shipment-' + getUUID(),
      description: shipmentData.description,
      docType: BLOCKCHAIN_DOC_TYPE.SHIPMENT,
      status: SHIPMENT_STATUS.PENDING,
      batchId: shipmentData.batchId,
      transportConditions: shipmentData.transportConditions,
      stakeholders: stakeholder,
      shipmentCondition: shipmentData.shipmentCondition,
      milestones: shipmentData.milestones,
      pickupTimestamp: shipmentData.pickupTimestamp,
      deliveryTimestamp: shipmentData.deliveryTimestamp,
      origin: shipmentData.origin,
      destination: shipmentData.destination,
      mode: shipmentData.mode,
      comment: [
        {
          title: 'Shipment Creation',
          description: `Shipment has been created by ${user.email}`,
          createdBy: user.email,
          createAt: dateTime,
        },
      ],
      currentylyWith: parseInt(user.orgId),
      createAt: dateTime,
      updatedAt: dateTime,
      createBy: user.email,
      updatedBy: user.email,
    };

    const contract = await getContractObject(
      orgName,
      user.email,
      NETWORK_ARTIFACTS_DEFAULT.CHANNEL_NAME_2,
      NETWORK_ARTIFACTS_DEFAULT.CHAINCODE_NAME_2,
      gateway,
      client
    );
    console.log('------shipment-------', shipment);

    await contract.submitTransaction('CreateAsset', JSON.stringify(shipment));

    return shipment;
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

const queryShipmentById = async (id, user) => {
  let gateway;
  let client;
  try {
    let orgName =user.orgName || `org${user.orgId}`;
    const contract = await getContractObject(
      orgName,
      user.email, 
      NETWORK_ARTIFACTS_DEFAULT.CHANNEL_NAME_2,
      NETWORK_ARTIFACTS_DEFAULT.CHAINCODE_NAME_2,
      gateway,
      client
    );
    let result = await contract.submitTransaction('getAssetByID', id);
    result = JSON.parse(utf8Decoder.decode(result));
    return result;
  } catch (error) {
    console.log(error);
  } finally {
    if (gateway) {
      gateway.close();
    }
    if (client) {
      client.close();
    }
  }
};

const queryAssetsWithPagination = async (filter, user) => {
  try {
    let query;
    if (filter.assetType == BLOCKCHAIN_DOC_TYPE.SHIPMENT) {
      query = `{\"selector\":{ \"docType\": \"${BLOCKCHAIN_DOC_TYPE.SHIPMENT}\"}}`;
    } else if (filter.assetType == BLOCKCHAIN_DOC_TYPE.DEVICE) {
      query = `{\"selector\":{ \"docType\": \"${BLOCKCHAIN_DOC_TYPE.DEVICE}\"}}`;
    } else if (filter.assetType == BLOCKCHAIN_DOC_TYPE.SENSOR_DATA) {
      query = `{\"selector\":{ \"docType\": \"${BLOCKCHAIN_DOC_TYPE.SENSOR_DATA}\",  \"shipmentId\": \"${filter.shipmentId}\"}}`;
    } else if (filter.assetType == BLOCKCHAIN_DOC_TYPE.INCIDENT) {
      query = `{\"selector\":{ \"docType\": \"${BLOCKCHAIN_DOC_TYPE.INCIDENT}\", \"shipmentId\": \"${filter.shipmentId}\"}}`;
    } else {
      query = `{\"selector\":{ \"docType\": \"${BLOCKCHAIN_DOC_TYPE.SHIPMENT}\"}}`;
    }

    console.log('==========================filter type', filter, query);

    // query = `{\"selector\":{\"orgId\": ${filter.orgId},\"status\":\"${filter.filterType}\", \"docType\": \"${BLOCKCHAIN_DOC_TYPE.AGREEMENT}\"}, \"sort\":[{\"updatedAt\":\"desc\"}], \"use_index\":[\"_design/indexOrgDoc\", \"indexDoc\"]}}`;
    console.log('filters--------------', filter, query);
    let data = await getDataWithPagination(
      query,
      filter.pageSize,
      filter.bookmark || '',
      user.orgName || filter.orgName,
      user.email,
      NETWORK_ARTIFACTS_DEFAULT.CHANNEL_NAME_2,
      NETWORK_ARTIFACTS_DEFAULT.CHAINCODE_NAME_2
    );

    return data;
  } catch (error) {
    console.log('error--------------', error);
  }
};

const sendShipment = async (shipmentData, user) => {
  console.log('----------addshipment--------------', shipmentData, user);
  let gateway;
  let client;
  let id = new mongoose.Types.ObjectId();
  try {
    let dateTime = new Date();
    let orgName = user.orgName || `org${user.orgId}`;

    if (user.orgId != 2) {
      throw new Error('You are not authorized to create shipment');
    }

    const contract = await getContractObject(
      orgName,
      user.email,
      NETWORK_ARTIFACTS_DEFAULT.CHANNEL_NAME_2,
      NETWORK_ARTIFACTS_DEFAULT.CHAINCODE_NAME_2,
      gateway,
      client
    );

    // let ownership = await contract.submitTransaction('', ownershipId)
    let shipment = await contract.submitTransaction('getAssetByID', shipmentData.id);
    let shipmentJSON = JSON.parse(utf8Decoder.decode(shipment));

    (shipmentJSON.currentylyWith = 2), (shipmentJSON.status = SHIPMENT_STATUS.IN_TRANSIT);
    shipmentJSON.updatedAt = dateTime;
    shipmentJSON.updatedBy = user.email;
    shipmentJSON.pickupTimestamp = dateTime;

    shipmentJSON.comment = shipmentJSON.comment || [];
    shipmentJSON.comment.push({
      title: 'Shipment Sent via Carrier',
      description: `Shipment has been sent viw Carrier`,
      createdBy: user.email,
      createAt: dateTime,
    });

    await contract.submitTransaction('CreateAsset', JSON.stringify(shipmentJSON));
    return shipmentJSON;
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

const updateShipment = async (shipmentData, user) => {
  console.log('----------addshipment--------------', shipmentData, user);
  let gateway;
  let client;
  let id = new mongoose.Types.ObjectId();
  try {
    let dateTime = new Date();
    let orgName = user.orgName || `org${user.orgId}`;

    if (user.orgId != 3) {
      throw new Error('You are not authorized to create shipment');
    }

    const contract = await getContractObject(
      orgName,
      user.email,
      NETWORK_ARTIFACTS_DEFAULT.CHANNEL_NAME_2,
      NETWORK_ARTIFACTS_DEFAULT.CHAINCODE_NAME_2,
      gateway,
      client
    );

    // let ownership = await contract.submitTransaction('', ownershipId)
    let shipment = await contract.submitTransaction('getAssetByID', shipmentData.id);
    let shipmentJSON = JSON.parse(utf8Decoder.decode(shipment));

    (shipmentJSON.currentylyWith = 3), (shipmentJSON.status = SHIPMENT_STATUS.DELIVERED);
    shipmentJSON.updatedAt = dateTime;
    shipmentJSON.updatedBy = user.email;
    shipmentJSON.deliveryTimestamp = dateTime;

    shipmentJSON.comment = shipmentJSON.comment || [];
    shipmentJSON.comment.push({
      title: 'Shipment Delivered',
      description: `All event checked and verified, hence marking this shipment as delivered`,
      createdBy: user.email,
      createAt: dateTime,
    });

    await contract.submitTransaction('CreateAsset', JSON.stringify(shipmentJSON));
    return shipmentJSON;
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

const addIOTData = async (iotData, user) => {
  // console.log('----------addIOTData--------------', iotData, user);
  let gateway;
  let client;
  let id = new mongoose.Types.ObjectId();
  try {
    let dateTime = new Date();
    let orgName = user.orgName || `org${user.orgId}`;

    // if(user.orgId != 2){
    //   throw new Error('You are not authorized to create shipment')
    // }

    const contract = await getContractObject(
      orgName,
      user.email,
      NETWORK_ARTIFACTS_DEFAULT.CHANNEL_NAME_2,
      NETWORK_ARTIFACTS_DEFAULT.CHAINCODE_NAME_2,
      gateway,
      client
    );

    const contract2 = await getContractObject(
      orgName,
      user.email,
      NETWORK_ARTIFACTS_DEFAULT.CHANNEL_NAME,
      NETWORK_ARTIFACTS_DEFAULT.CHAINCODE_NAME,
      gateway,
      client
    );

    let batchData = await contract2.submitTransaction('getAssetByID', iotData.batchId);
    batchData = JSON.parse(utf8Decoder.decode(batchData));
    if (!batchData) {
      throw new Error('Batch not found');
    }

    let devieData = await contract.submitTransaction('getAssetByID', iotData.deviceId);
    if (!devieData) {
      throw new Error('Device not found');
    }
    let shipmentData = await contract.submitTransaction('getAssetByID', iotData.shipmentId);
    if (!shipmentData) {
      throw new Error('Shipment not found');
    }
    console.log("-----------batchData---------------------", batchData)

    let eventId = 'EVENT-' + getUUID();
    if (
      batchData?.transportInstructions?.temperatureHigh < iotData.value.temperature ||
      batchData?.transportInstructions?.temperatureLow > iotData.value.temperature
    ) {
      let incident = {
        id: 'Incident-Temperature:' + batchData.id + '-' + eventId,
        docType: 'INCIDENT',
        shipmentId: iotData.shipmentId,
        batchId: iotData.batchId,
        eventId: eventId,
        data: {
          value: iotData.value.temperature,
          minValue: batchData?.transportInstructions.temperatureLow,
          maxValue: batchData?.transportInstructions.temperatureHigh,
        },
        incidentType: 'Temperatrure Breach',
        creationTime: dateTime,
        closingTime: dateTime,
      };
      contract.submitTransaction('CreateAsset', JSON.stringify(incident));
    }
    if (
      batchData?.transportInstructions?.humidityHigh < iotData.value.humidity ||
      batchData?.transportInstructions?.humidityLow > iotData.value.humidity
    ) {
      let incident = {
        id: 'Incident-Humidity:' + batchData.id + '-' + eventId,
        docType: 'INCIDENT',
        shipmentId: iotData.shipmentId,
        batchId: iotData.batchId,
        eventId: eventId,
        data: {
          value: iotData.value.humidity,
          minValue: batchData?.transportInstructions.humidityLow,
          maxValue: batchData?.transportInstructions.humidityHigh,
        },
        incidentType: 'Humidity Breach',
        creationTime: dateTime,
        closingTime: dateTime,
      };
       contract.submitTransaction('CreateAsset', JSON.stringify(incident));
    }

    let iotDataJSON = {
      id: 'EVENT-' + getUUID(),
      docType: BLOCKCHAIN_DOC_TYPE.SENSOR_DATA,
      deviceID: iotData.deviceID,
      shipmentId: iotData.shipmentId,
      batchId: iotData.batchId,
      type: iotData.type,
      temperature: iotData.value.temperature,
      humidity: iotData.value.humidity,
      createAt: dateTime,
      closingTime: dateTime,
      status: iotData.status,
      batteryLevel: iotData.batteryLevel,
    };

    // let ownership = await contract.submitTransaction('', ownershipId)
    contract.submitTransaction('CreateAsset', JSON.stringify(iotDataJSON));
    return iotDataJSON;
  } catch (error) {
    // console.log("==============error====details===========", error?.details[0]?.message);
    // console.log("==============error====message===========", error?.message);
    // console.log("==============error====stack===========", error?.stack);
    // console.log("==============error====name===========", error?.name);
    // console.log("==============error====code===========", error?.code);
    // console.log("==============error====cause===========", error?.cause);
    // console.log("==============error====syscall===========", error?.syscall);
    // console.log("==============error====stack===========", error?.stack);
    throw new ApiError(httpStatus.BAD_REQUEST,  error?.details[0]?.message || error?.message ||  error);
  } finally {
    if (gateway) {
      gateway.close();
    }
    if (client) {
      client.close();
    }
  }
};

const addIOTDeviceData = async (iotDeviceData, user) => {
  // console.log('----------addIOTDeviceData--------------', iotDeviceData, user);
  let gateway;
  let client;
  let id = new mongoose.Types.ObjectId();
  try {
    let dateTime = new Date();
    let orgName = user.orgName || `org${user.orgId}`;

    // if(user.orgId != 2){
    //   throw new Error('You are not authorized to create device, only carrier can add device')
    // }

    console.log(orgName, user)
    const contract = await getContractObject(
      orgName,
      user.email,
      NETWORK_ARTIFACTS_DEFAULT.CHANNEL_NAME_2,
      NETWORK_ARTIFACTS_DEFAULT.CHAINCODE_NAME_2,
      gateway,
      client
    );

    iotDeviceData.createAt = dateTime;
    iotDeviceData.docType = BLOCKCHAIN_DOC_TYPE.DEVICE;
    iotDeviceData.updatedAt = dateTime;
    iotDeviceData.createBy = user.email;
    iotDeviceData.updatedBy = user.email;

    await contract.submitTransaction('CreateAsset', JSON.stringify(iotDeviceData));
    return iotDeviceData;
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

const queryHistoryById = async (id, user) => {
  let gateway;
  let client;
  try {
    let orgName = `org${user.orgId}`;
    const contract = await getContractObject(
      orgName,
      user.email,
      NETWORK_ARTIFACTS_DEFAULT.CHANNEL_NAME_2,
      NETWORK_ARTIFACTS_DEFAULT.CHAINCODE_NAME_2,
      gateway,
      client
    );
    let result = await contract.submitTransaction('getAssetHistory', id);
    // result = JSON.parse(result.toString());
    result = JSON.parse(utf8Decoder.decode(result));
    if (result) {
      result = result?.map((elm) => {
        return { txId: elm?.txId, IsDelete: elm.IsDelete, ...elm.Value, timeStamp: elm?.Timestamp?.seconds?.low * 1000 };
      });
    }
    return result;
  } catch (error) {
    console.log(error);
  } finally {
    if (gateway) {
      gateway.close();
    }
    if (client) {
      client.close();
    }
  }
};

/**
 * Get user by email
 * @param {string} email
 * @returns {Promise<User>}
 */
const getUserByEmail = async (email) => {
  return User.findOne({ email });
};

/**
 * Update user by id
 * @param {ObjectId} userId
 * @param {Object} updateBody
 * @returns {Promise<User>}
 */
const updateUserById = async (userId, updateBody) => {
  const user = await getUserById(userId);
  if (!user) {
    throw new ApiError(httpStatus.NOT_FOUND, 'User not found');
  }
  if (updateBody.email && (await User.isEmailTaken(updateBody.email, userId))) {
    throw new ApiError(httpStatus.BAD_REQUEST, 'Email already taken');
  }
  Object.assign(user, updateBody);
  await user.save();
  return user;
};

/**
 * Delete user by id
 * @param {ObjectId} userId
 * @returns {Promise<User>}
 */
const deleteUserById = async (userId) => {
  const user = await getUserById(userId);
  if (!user) {
    throw new ApiError(httpStatus.NOT_FOUND, 'User not found');
  }
  await user.remove();
  return user;
};

module.exports = {
  addShipment,
  sendShipment,
  addIOTData,
  addIOTDeviceData,
  queryAssetsWithPagination,
  updateShipment,
  queryShipmentById,
  getUserByEmail,
  updateUserById,
  deleteUserById,

  queryHistoryById,
};
