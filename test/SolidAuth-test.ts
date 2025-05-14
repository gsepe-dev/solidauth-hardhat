import { expect } from "chai";
import { ethers } from "hardhat";

describe("SolidAuth", function () {
  let admin: any, user: any, anotherUser: any;
  let contract: any;

  beforeEach(async function () {
    [admin, user, anotherUser] = await ethers.getSigners();
    const Contract = await ethers.getContractFactory("SolidAuth");
    contract = await Contract.deploy();
    await contract.deployed();
  });

  it("It should correctly initialise the admin", async function () {
    expect(await contract.admin()).to.equal(admin.address);
  });

  it("It should allow the admin to transfer ownership", async function () {
    await contract.connect(admin).transferAdmin(user.address);
    expect(await contract.admin()).to.equal(user.address);
  });

  it("It should assign a wallet to a WebID", async function () {
    const webId = "https://example.com/profile#me";
    await contract.connect(admin).assignWalletToWebId(user.address, webId);
    expect(await contract.getWalletByWebId(webId)).to.equal(user.address);
  });

  it("Should set permissions correctly", async function () {
    const resource = "https://example.com/data";
    const permissions = {
      read: true,
      write: false,
      append: false,
      create: true,
      del: false,
    };

    await contract.connect(admin).setPermissions(user.address, resource, permissions);
    const fetchedPermissions = await contract.getPermissions(user.address, resource);

    expect(fetchedPermissions.read).to.be.true;
    expect(fetchedPermissions.write).to.be.false;
    expect(fetchedPermissions.append).to.be.false;
    expect(fetchedPermissions.create).to.be.true;
    expect(fetchedPermissions.del).to.be.false;
  });

  it("Should remove permissions correctly", async function () {
    const resource = "https://example.com/data";
    await contract.connect(admin).removePermissions(user.address, resource);
    const fetchedPermissions = await contract.getPermissions(user.address, resource);

    expect(fetchedPermissions.read).to.be.false;
    expect(fetchedPermissions.write).to.be.false;
    expect(fetchedPermissions.append).to.be.false;
    expect(fetchedPermissions.create).to.be.false;
    expect(fetchedPermissions.del).to.be.false;
  });

  it("It should correctly verify the authorisation", async function () {
    const resource = "https://example.com/data";
    await contract.connect(admin).setPermissions(user.address, resource, { read: true, write: false, append: false, create: true, del: false });

    expect(await contract.isAuthorized(user.address, resource, 0)).to.be.true; // READ
    expect(await contract.isAuthorized(user.address, resource, 1)).to.be.false; // WRITE
  });
});