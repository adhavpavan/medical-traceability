const httpStatus = require('http-status');
const catchAsync = require('../utils/catchAsync');
const { getSuccessResponse } = require('../utils/Response');
const { 
  createProduct, 
  updateProduct, 
  getProductById, 
  queryProductsWithPagination, 
  getProductHistory 
} = require('../services/product.service');

const createNewProduct = catchAsync(async (req, res) => {
  let { user } = req.loggerInfo;
  const result = await createProduct(req.body, user);
  res.status(httpStatus.CREATED).send(getSuccessResponse(httpStatus.CREATED, 'Product created successfully', result));
});

const updateExistingProduct = catchAsync(async (req, res) => {
  const { id } = req.params;
  let { user } = req.loggerInfo;
  const result = await updateProduct(id, req.body, user);
  res.status(httpStatus.OK).send(getSuccessResponse(httpStatus.OK, 'Product updated successfully', result));
});

const getProduct = catchAsync(async (req, res) => {
  const { id } = req.params;
  let { user } = req.loggerInfo;
  const data = await getProductById(id, user);
  res.status(httpStatus.OK).send(getSuccessResponse(httpStatus.OK, 'Product fetched successfully', data));
});

const getProducts = catchAsync(async (req, res) => {
  let { user } = req.loggerInfo;
  const filter = {
    searchTerm: req.query.searchTerm,
    status: req.query.status,
    pageSize: parseInt(req.query.pageSize) || 20,
    bookmark: req.query.bookmark
  };
  
  const data = await queryProductsWithPagination(filter, user);
  res.status(httpStatus.OK).send(getSuccessResponse(httpStatus.OK, 'Products fetched successfully', data));
});

const getHistoryById = catchAsync(async (req, res) => {
  const { id } = req.params;
  let { user } = req.loggerInfo;
  const data = await getProductHistory(id, user);
  res.status(httpStatus.OK).send(getSuccessResponse(httpStatus.OK, 'Product history fetched successfully', data));
});

module.exports = {
  createNewProduct,
  updateExistingProduct,
  getProduct,
  getProducts,
  getHistoryById
};