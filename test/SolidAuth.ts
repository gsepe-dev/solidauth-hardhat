import { expect } from "chai";
import { ethers } from "hardhat";

describe("SolidAuth Smart Contract", function () {
  let solidAuth: any;
  let admin: any, user: any;

  beforeEach(async function () {
    // Otteniamo gli account di test
    [admin, user] = await ethers.getSigners();

    // Ottieni il contratto SolidAuth
    const SolidAuth = await ethers.getContractFactory("SolidAuth");

    // Distribuisci il contratto e attendi il risultato
    solidAuth = await SolidAuth.deploy();  // Deploy del contratto
    await solidAuth.deployed();  // Assicurati che il contratto sia effettivamente distribuito
  });

  it("Dovrebbe assegnare l'admin correttamente", async function () {
    expect(await solidAuth.admin()).to.equal(admin.address);
  });

  it("L'admin può impostare i permessi", async function () {
    const webId = "https://alice.solid.community/profile/card#me";
    const resource = "/documents/report.pdf";

    // Assegna permessi tramite setPermissions
    await solidAuth.setPermissions(webId, resource, true, false, false, false, false);
    

    // Verifica se i permessi sono stati impostati correttamente
    expect(await solidAuth.isAuthorized(webId, resource, 0)).to.equal(true);  // READ
    expect(await solidAuth.isAuthorized(webId, resource, 1)).to.equal(false); // WRITE
  });

  it("Un utente NON admin NON può impostare i permessi", async function () {
    const webId = "https://bob.solid.community/profile/card#me";
    const resource = "/documents/secret.pdf";

    await expect(
      solidAuth.connect(user).setPermissions(webId, resource, true, true, false, false, false)
    ).to.be.revertedWith("Access denied: Admin only");
  });

  it("isAuthorized restituisce il valore corretto", async function () {
    const webId = "https://alice.solid.community/profile/card#me";
    const resource = "/documents/report.pdf";

    // L'admin assegna permessi a Alice (con 'delPermission')
    await solidAuth.setPermissions(webId, resource, true, false, true, false, false);

    // Verifica permessi
    expect(await solidAuth.isAuthorized(webId, resource, 0)).to.equal(true);  // READ
    expect(await solidAuth.isAuthorized(webId, resource, 1)).to.equal(false); // WRITE
    expect(await solidAuth.isAuthorized(webId, resource, 2)).to.equal(true);  // APPEND
  });
});
