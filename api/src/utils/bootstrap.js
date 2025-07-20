
const config = require('../config/config');
const Organization = require('../models/organization.model');
const User = require('../models/user.model');
const { ORG_DEPARTMENT, USER_STATUS, USER_TYPE } = require('./Constants');
const { registerUser } = require('./blockchainUtils');
const staticUser = [
  {
    "name": "max",
    "email": "user1@gmail.com",
    "orgId": 1,
    "orgName": "manufacturer",
    "password": "Admin@12345"
  },
  {
    "name": "max",
    "email": "user2@gmail.com",
    "orgId": 2,
    "orgName": "distributor",
    "password": "Admin@12345"
  },
  {
    "name": "max",
    "email": "user3@gmail.com",
    "orgId": 3,
    "orgName": "pharmacy",
    "password": "Admin@12345"
  },
  {
    "name": "max",
    "email": "user4@gmail.com",
    "orgId": 4,
    "orgName": "regulator",
    "password": "Admin@12345"
  }
]

const ingestBootstrapData = async () => {
  const staticOrgData = [
  {
    "orgName": "manufacturer",
    "id": 1,
    "parentId": 1
  },
  {
    "orgName": "distributor",
    "id": 2,
    "parentId": 1
  },
  {
    "orgName": "pharmacy",
    "id": 3,
    "parentId": 1
  },
  {
    "orgName": "regulator",
    "id": 4,
    "parentId": 1
  }
]
  
  //org data
  for (let org of staticOrgData) {
    let orgData = await Organization.findOne({ id: org.id });
    if (!orgData) {
      let o = new Organization({
        id: org.id,
        orgName: org.orgName,
        parentId: org.parentId,
      });
      await o.save();
      console.log('Ingesting static org data', org.name);
    } else {
      console.log('organization already exist', org.name);
    }
  }

  //user data
  for (let user of staticUser) {
    let userData = await User.findOne({ email: user.email });
    // console.log('user data is---', userData);
    if (!userData) {
      let newUser = new User({
        name: user.name,
        email: user.email,
        orgId: user.orgId,
        password: user.password,
        status: USER_STATUS.ACTIVE,
        type: USER_TYPE.ADMIN,
      });
      try {
        //Blockchain Registration and Enrollment call
        let secret = await registerUser(`${user.orgName}`, user.email);
        newUser.secret = secret;
        newUser.isVerified = true;
      } catch (error) {
        console.log("-----Error occured while registring user-----", error)
      }
     
      await newUser.save();

      console.log('----ingest static user data--', user.email);
    } else {
      console.log('user email already exist', user.email);
    }
  }
};
module.exports = { ingestBootstrapData, staticUser };
