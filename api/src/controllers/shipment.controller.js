const httpStatus = require('http-status');
const catchAsync = require('../utils/catchAsync');
const { getSuccessResponse } = require('../utils/Response');
const { 
  addShipment,
  sendShipment,
  updateShipment,
  addIOTData,
  addIOTDeviceData,
  queryAssetsWithPagination,
  queryHistoryById,
  getDocSignedURL
} = require('../services/shipment.service');

const createShipment = catchAsync(async (req, res) => {
  let { user } = req.loggerInfo;
  const result = await addShipment(req.body, user);
  res.status(httpStatus.CREATED).send(getSuccessResponse(httpStatus.CREATED, 'Shipment created successfully', result));
});

const shipmentSend = catchAsync(async (req, res) => {
  let { user } = req.loggerInfo;
  const result = await sendShipment(req.body, user);
  res.status(httpStatus.OK).send(getSuccessResponse(httpStatus.OK, 'Shipment sent successfully', result));
});

const shipmentUpdate = catchAsync(async (req, res) => {
  let { user } = req.loggerInfo;
  const result = await updateShipment(req.body, user);
  res.status(httpStatus.OK).send(getSuccessResponse(httpStatus.OK, 'Shipment updated successfully', result));
});

const addSensorData = catchAsync(async (req, res) => {
  let { user } = req.loggerInfo;
  const result = await addIOTData(req.body, user);
  res.status(httpStatus.CREATED).send(getSuccessResponse(httpStatus.CREATED, 'Sensor data added successfully', result));
});

const addDevice = catchAsync(async (req, res) => {
  let { user } = req.loggerInfo;
  const result = await addIOTDeviceData(req.body, user);
  res.status(httpStatus.CREATED).send(getSuccessResponse(httpStatus.CREATED, 'IoT device added successfully', result));
});

const getShipments = catchAsync(async (req, res) => {
  let { user } = req.loggerInfo;
  const filter = {
    assetType: req.query.assetType || 'shipment',
    shipmentId: req.query.shipmentId,
    orgName: `org${user.orgId}`,
    pageSize: parseInt(req.query.pageSize) || 20,
    bookmark: req.query.bookmark
  };
  
  const data = await queryAssetsWithPagination(filter, user);
  res.status(httpStatus.OK).send(getSuccessResponse(httpStatus.OK, 'Assets fetched successfully', data));
});

const getHistoryById = catchAsync(async (req, res) => {
  const { id } = req.params;
  let { user } = req.loggerInfo;
  const data = await queryHistoryById(id, user);
  res.status(httpStatus.OK).send(getSuccessResponse(httpStatus.OK, 'History fetched successfully', data));
});

const getSignedURL = catchAsync(async (req, res) => {
  const { docId } = req.params;
  let { user } = req.loggerInfo;
  const url = await getDocSignedURL(docId, user);
  res.status(httpStatus.OK).send(getSuccessResponse(httpStatus.OK, 'Signed URL generated successfully', { url }));
});

module.exports = {
  createShipment,
  shipmentSend,
  shipmentUpdate,
  addSensorData,
  addDevice,
  getShipments,
  getHistoryById,
  getSignedURL
};