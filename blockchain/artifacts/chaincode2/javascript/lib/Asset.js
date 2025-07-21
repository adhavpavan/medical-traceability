"use strict";

const { Contract, Transaction } = require("fabric-contract-api");
class Performance extends Contract {

  async CreateAsset(ctx, assetData) {
    try {
      let asset = JSON.parse(assetData)
      await ctx.stub.putState(asset.id, assetData);
      return ctx.stub.getTxID();
    } catch (err) {
      throw new Error(err.stack);
    }    
  }

  async CreateAsset1(ctx, id, color, size, owner, appraisedValue) {
    console.log("----Create Asset with id-", id)
    const asset = {
        ID: id,
        Color: color,
        Size: size,
        Owner: owner,
        AppraisedValue: appraisedValue,
    };
    // we insert data in alphabetic order using 'json-stringify-deterministic' and 'sort-keys-recursive'
    await ctx.stub.putState(id, Buffer.from(JSON.stringify(asset)));
    return JSON.stringify(asset);
}

async AddIOTEvent(ctx, iotDeviceEventData) {
  try {
   

    // const event = await ctx.stub.getState(iotDeviceEventData);
    let eventJSON = JSON.parse(iotDeviceEventData);

    const batch = await ctx.stub.getState(eventJSON.batchId);
    let batchtJSON = JSON.parse(batch);

    // Adding event here
    await ctx.stub.putState(eventJSON.id, iotDeviceEventData);

    // Verifying if any incident with this data
    if(batchtJSON?.shipmentConditionType == 'Temperature'){
      console.log("--------inside temperarture---------",batchtJSON?.shipmentCondition, eventJSON )
      if (batchtJSON?.shipmentCondition.minTemperature > eventJSON?.value?.temperature ||
        batchtJSON?.shipmentCondition.maxTemperature < eventJSON?.value?.temperature ){

          let incident = {
            "id": 'Incident:'+batchtJSON.id+'-' +eventJSON.id,
            docType:'INCIDENT',
            shipmentId:eventJSON.shipmentId,
            batchId:eventJSON.batchId,
            eventId:eventJSON.id,
            data:{
                value: eventJSON.value.temperature,
                minValue: batchtJSON?.shipmentCondition.minTemperature,
                maxValue: batchtJSON?.shipmentCondition.maxTemperature
            },
            "incidentType": "Temperatrure Breach",
            "creationTime": eventJSON.createAt,
            "closingTime": eventJSON.closingTime,
          }
          // Adding incident
          await ctx.stub.putState(incident.id, Buffer.from(JSON.stringify(incident)))
        }else {
          console.log("--------satisfying condition temperarture---------", )
        }
    }
    return ctx.stub.getTxID();
  } catch (err) {
    throw new Error(err.stack);
  }
}

  // ReadAsset returns the asset stored in the world state with given id.
  async getAssetByID(ctx, id) {
    try {
      const assetJSON = await ctx.stub.getState(id);
      if (!assetJSON || assetJSON.length === 0) {
        throw new Error(`The asset ${id} does not exist`);
      }
      return assetJSON.toString();
    } catch (err) {
      throw new Error(err.stack);
    }
  }

  // assetExists returns true when asset with given ID exists in world state.
  async assetExists(ctx, id) {
    try {
      const assetJSON = await ctx.stub.getState(id);
      return assetJSON && assetJSON.length > 0;
    } catch (err) {
      return new Error(err.stack);
    }
  }

  /**
   * Function getAllResults
   * @param {resultsIterator} iterator within scope passed in
   * @param {Boolean} isHistory query string created prior to calling this fn
   */
  async getAllResults(iterator, isHistory) {
    try {
      let allResults = [];
      while (true) {
        let res = await iterator.next();
        console.log(res.value);

        if (res.value && res.value.value.toString()) {
          let jsonRes = {};
          console.log(res.value.value.toString("utf8"));

          if (isHistory && isHistory === true) {
            jsonRes.txId = res.value.txId;
            jsonRes.Timestamp = res.value.timestamp;
            jsonRes.IsDelete = res.value.is_delete
              ? res.value.is_delete.toString()
              : "false";
            try {
              jsonRes.Value = JSON.parse(res.value.value.toString("utf8"));
            } catch (err) {
              console.log(err);
              jsonRes.Value = res.value.value.toString("utf8");
            }
          } else {
            jsonRes.Key = res.value.key;
            try {
              jsonRes.Record = JSON.parse(res.value.value.toString("utf8"));
            } catch (err) {
              console.log(err);
              jsonRes.Record = res.value.value.toString("utf8");
            }
          }
          allResults.push(jsonRes);
        }
        if (res.done) {
          console.log("end of data");
          await iterator.close();
          console.info("allResults : ", allResults);
          return allResults;
        }
      }
    } catch (err) {
      return new Error(err.message);
    }
  }

  /**
   * Function getQueryResultForQueryString
   * getQueryResultForQueryString woerk function executes the passed-in query string.
   * Result set is built and returned as a byte array containing the JSON results.
   * @param {Context} ctx the transaction context
   * @param {any}  self within scope passed in
   * @param {String} the query string created prior to calling this fn
   */
  async getDataForQuery(ctx, queryString) {
    try {
      console.log(
        "- getQueryResultForQueryString queryString:\n" + queryString
      );

      const resultsIterator = await ctx.stub.getQueryResult(queryString);
      let results = await this.getAllResults(resultsIterator, false);

      return results;
    } catch (err) {
      return new Error(err.message);
    }
  }

  /**
   * getAssetHistory takes the asset ID as arg, returns results as JSON
   * @param {String} id the asset ID
   */
  async getAssetHistory(ctx, id) {
    try {
      let resultsIterator = await ctx.stub.getHistoryForKey(id);
      let results = await this.getAllResults(resultsIterator, true);
      console.log("results : ", results);

      return results;
    } catch (err) {
      return new Error(err.stack);
    }
  }

  async getDataWithPagination(ctx, queryString, pageSize, bookmark) {
    try {
      const pageSizeInt = parseInt(pageSize, 10);
      const { iterator, metadata } =
        await ctx.stub.getQueryResultWithPagination(
          queryString,
          pageSizeInt,
          bookmark
        );
      const results = await this.getAllResults(iterator, false);
      let finalData = {
        data: results,
        metadata: {
          RecordsCount: metadata.fetchedRecordsCount,
          Bookmark: metadata.bookmark,
        },
      };
      return finalData;
    } catch (err) {
      return new Error(err.message);
    }
  }
}

module.exports = Performance;
