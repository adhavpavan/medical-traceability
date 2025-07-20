
  'use strict';

  const { WorkloadModuleBase } = require('@hyperledger/caliper-core');
  const { assetIdArray } = require('./createAsset');

  class QueryDeviceWorkload extends WorkloadModuleBase {
      constructor() {
          super();
          this.txIndex = 0;
          this.limitIndex = 0;
      }

      async submitTransaction() {
          const randomIndex = Math.floor(Math.random() * assetIdArray.length);

          let assetId= assetIdArray[randomIndex]
          console.log("-----------------------------------", assetId)
          let args = {
              contractId: "producer-distributor-channel-chaincode",
              contractVersion: 'v1',
              contractFunction: 'getAssetByID',
              contractArguments: [assetId],
              timeout: 30,
              readOnly: true
          };

          await this.sutAdapter.sendRequests(args);
      }
  }

  function createWorkloadModule() {
      return new QueryDeviceWorkload();
  }

  module.exports.createWorkloadModule = createWorkloadModule;
  
  