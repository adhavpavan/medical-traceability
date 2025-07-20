
const USER_STATUS = {
  ACTIVE: 'active',
  INACTIVE: 'inactive',
  OTHER: 'other'
}
const USER_TYPE = {
  ADMIN: 'admin',
  USER: 'user'
}
const BLOCKCHAIN_DOC_TYPE = {
  AGREEMENT: 'asset',
  DOCUMENT: 'document',
  SHIPMENT: 'shipment',
  DEVICE: 'device',
  EVENT: 'event',
  INCIDENT: 'incident',
  PRODUCT: 'product',
  BATCH: 'batch'
}
const SHIPMENT_STATUS = {
  PENDING: 'pending',
  IN_TRANSIT: 'in_transit',
  DELIVERED: 'delivered',
  REJECTED: 'rejected'
}
const NETWORK_ARTIFACTS_DEFAULT ={
  CHANNEL_NAME: 'producer-distributor-channel',
  CHAINCODE_NAME: 'producer-distributor-channel-chaincode',
  QSCC:'qscc'
}
module.exports = {
  USER_STATUS,
  USER_TYPE,
  NETWORK_ARTIFACTS_DEFAULT,
  BLOCKCHAIN_DOC_TYPE,
  SHIPMENT_STATUS
}
