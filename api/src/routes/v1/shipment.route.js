const express = require('express');
const { auth } = require('../../middlewares/auth');
const { 
  createShipment,
  shipmentSend,
  shipmentUpdate,
  addSensorData,
  addDevice,
  getShipments,
  getHistoryById,
  getSignedURL,
  getShipmentById
} = require('../../controllers/shipment.controller');

const router = express.Router();



router
  .route('/send')
  .post(auth, shipmentSend);

router
  .route('/update')
  .put(auth, shipmentUpdate);

router
  .route('/sensor-data')
  .post(auth, addSensorData);

router
  .route('/device')
  .post(auth, addDevice);

router
  .route('/history/:id')
  .get(auth, getHistoryById);

router
  .route('/doc/:docId/url')
  .get(auth, getSignedURL);

  router.route('/:id').get(auth, getShipmentById);

  router
  .route('/')
  .get(auth, getShipments)
  .post(auth, createShipment);

module.exports = router;