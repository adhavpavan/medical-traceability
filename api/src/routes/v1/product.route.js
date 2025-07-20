const express = require('express');
const { auth } = require('../../middlewares/auth');
const { 
  createNewProduct, 
  updateExistingProduct, 
  getProduct, 
  getProducts, 
  getHistoryById 
} = require('../../controllers/product.controller');

const router = express.Router();

router
  .route('/')
  .get(auth, getProducts)
  .post(auth, createNewProduct);

router
  .route('/:id')
  .get(auth, getProduct)
  .put(auth, updateExistingProduct);

router
  .route('/history/:id')
  .get(auth, getHistoryById);

module.exports = router;