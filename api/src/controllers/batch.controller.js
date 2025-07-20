const httpStatus = require('http-status');
const catchAsync = require('../utils/catchAsync');
const { getSuccessResponse } = require('../utils/Response');
const { 
  createBatch, 
  updateBatch, 
  getBatchById, 
  queryBatchesWithPagination, 
  getBatchHistory,
  updateBatchQuantity
} = require('../services/batch.service');

const createNewBatch = catchAsync(async (req, res) => {
  let { user } = req.loggerInfo;
  const result = await createBatch(req.body, user);
  res.status(httpStatus.CREATED).send(getSuccessResponse(httpStatus.CREATED, 'Batch created successfully', result));
});

const updateExistingBatch = catchAsync(async (req, res) => {
  const { id } = req.params;
  let { user } = req.loggerInfo;
  const result = await updateBatch(id, req.body, user);
  res.status(httpStatus.OK).send(getSuccessResponse(httpStatus.OK, 'Batch updated successfully', result));
});

const getBatch = catchAsync(async (req, res) => {
  const { id } = req.params;
  let { user } = req.loggerInfo;
  const data = await getBatchById(id, user);
  res.status(httpStatus.OK).send(getSuccessResponse(httpStatus.OK, 'Batch fetched successfully', data));
});

const getBatches = catchAsync(async (req, res) => {
  let { user } = req.loggerInfo;
  const filter = {
    productId: req.query.productId,
    status: req.query.status,
    batchNumber: req.query.batchNumber,
    expiringBefore: req.query.expiringBefore,
    pageSize: parseInt(req.query.pageSize) || 20,
    bookmark: req.query.bookmark
  };
  
  const data = await queryBatchesWithPagination(filter, user);
  res.status(httpStatus.OK).send(getSuccessResponse(httpStatus.OK, 'Batches fetched successfully', data));
});

const getHistoryById = catchAsync(async (req, res) => {
  const { id } = req.params;
  let { user } = req.loggerInfo;
  const data = await getBatchHistory(id, user);
  res.status(httpStatus.OK).send(getSuccessResponse(httpStatus.OK, 'Batch history fetched successfully', data));
});

const updateQuantity = catchAsync(async (req, res) => {
  const { id } = req.params;
  let { user } = req.loggerInfo;
  const quantityUpdate = {
    type: req.body.type, // 'reserve', 'ship', 'release'
    quantity: req.body.quantity
  };
  
  const result = await updateBatchQuantity(id, quantityUpdate, user);
  res.status(httpStatus.OK).send(getSuccessResponse(httpStatus.OK, 'Batch quantity updated successfully', result));
});

module.exports = {
  createNewBatch,
  updateExistingBatch,
  getBatch,
  getBatches,
  getHistoryById,
  updateQuantity
};