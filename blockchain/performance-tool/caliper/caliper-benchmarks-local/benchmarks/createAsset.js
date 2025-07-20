
    'use strict';

      const { WorkloadModuleBase } = require('@hyperledger/caliper-core');
      const { v1: uuidv4 } = require('uuid')

      let assetIdArray = [];

      class CreateDeviceWorkload extends WorkloadModuleBase {
          constructor() {
              super();
          }

          async submitTransaction() {
              let id = uuidv4()
              assetIdArray.push(id)

              let assetData = {
                  id: id,
                  Color: "White",
                  Size: "Large",
                  Owner: "Pavan",
                  AppraisedValue: "2000000",
              };


              let args = {
                  contractId: "producer-distributor-channel-chaincode",
                  contractVersion: 'v1',
                  contractFunction: 'CreateAsset',
                  contractArguments: [JSON.stringify(assetData)],
                  timeout: 30
              };

              await this.sutAdapter.sendRequests(args);
          }
      }

      function createWorkloadModule() {
          return new CreateDeviceWorkload();
      }

      module.exports.createWorkloadModule = createWorkloadModule;
      module.exports.assetIdArray = assetIdArray;

    