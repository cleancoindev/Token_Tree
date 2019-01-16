var NatureRegistry = artifacts.require('contracts/NatureRegistry.sol');

module.exports = async function(deployer, network, accounts) {

  if (network == "main") {


  } else if (network == "rinkeby" || network == "ropsten") {

    deployer.deploy(NatureRegistry).then(function() {})

  } else if (network == "development") {

    deployer.deploy(NatureRegistry, {from: accounts[0]}).then(function() {})

  }

}
