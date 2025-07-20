const express = require('express');
const { auth } = require('../../middlewares/auth');
const { 
  createNewBatch, 
  updateExistingBatch, 
  getBatch, 
  getBatches, 
  getHistoryById,
  updateQuantity
} = require('../../controllers/batch.controller');

const router = express.Router();

router
  .route('/')
  .get(auth, getBatches)
  .post(auth, createNewBatch);

router
  .route('/:id')
  .get(auth, getBatch)
  .put(auth, updateExistingBatch);

router
  .route('/history/:id')
  .get(auth, getHistoryById);

router
  .route('/:id/quantity')
  .patch(auth, updateQuantity);

module.exports = router;