var NatureRegistry = artifacts.require('contracts/NatureRegistry.sol');

contract('NatureRegistry', function(accounts) {

    let registry;

    beforeEach(async () => {

      registry = await NatureRegistry.new({from: accounts[0]});

    })

    it("should add a manager correctly", async () => {

      await registry.addManager(accounts[1], {from: accounts[0]})

      assert.equal(await registry.isManager(accounts[1]), true)

    })

    it("should not add manager if the caller is not already a manager", async () => {

      try {

        await registry.addManager(accounts[1], {from: accounts[2]})

      } catch (err) {

        assert(err != undefined)

      }

    })

    it("should add an area only if the caller is a manager", async () => {

      await registry.addArea("IPFS_PATH", "48.2775° N, 8.1860° E", {from: accounts[0]})

      assert.equal(await registry.getAllAreas(), "IPFS_PATH")

      assert.equal(await registry.isAreaAvailable("48.2775° N, 8.1860° E"), true)

      try {

        await registry.addArea("IPFS_PATH", "3.4653° S, 62.2159° W", {from: accounts[1]})

      } catch (err) {

        assert(err != undefined)

      }

    })

    it("should add a resource and toggle the protection", async () => {

      await registry.addArea("IPFS_PATH", "48.2775° N, 8.1860° E", {from: accounts[0]})

      await registry.
        addResource("48.2775° N, 8.1860° E", "Rare Tree", "48.2775° N, 8.1862° E", {from: accounts[0]})

      var resourceData = await registry.getResourceFromArea("48.2775° N, 8.1860° E", 0);

      assert.equal(resourceData[1], "48.2775° N, 8.1862° E")

      assert.equal(resourceData[2], true)

      await registry.toggleProtection("48.2775° N, 8.1860° E", 0, {from: accounts[0]})

      resourceData = await registry.getResourceFromArea("48.2775° N, 8.1860° E", 0);

      assert.equal(resourceData[2], false)

    })

})
