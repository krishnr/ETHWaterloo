Web3 = require('web3')
solc = require('solc')
fs = require('fs')

function deployContract() {
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
    code = fs.readFileSync('snow_angel.sol').toString()
    compiledCode = solc.compile(code)

    abiDefinition = JSON.parse(compiledCode.contracts[':SnowAngel'].interface)

    snowAngelContract = web3.eth.contract(abiDefinition)
    byteCode = compiledCode.contracts[':SnowAngel'].bytecode

    deployedContract = snowAngelContract.new([],{data: byteCode, from: web3.eth.accounts[0], gas: 4700000})

    contractInstance = snowAngelContract.at(deployedContract.address)

    console.log("Successfully deployed! Remember to change the contract address in your index.js file!")

    return contractInstance
}

function testAddingHousehold(contractInstance) {
    console.log('Testing stuff now...')

    console.log('Adding Bob to contract')
    contractInstance.registerHousehold(web3.eth.accounts[1],
                                      'Bob',
                {'from': web3.eth.accounts[0]})
    name = contractInstance.getHousehold.call(web3.eth.accounts[1])
    console.log('Contract name:')
    console.log(name)
}

function testSettingTime(contractInstance) {
    contractInstance.setExpiryTime(
               {'from': web3.eth.accounts[0]})
    expiry_time = contractInstance.getExpiryTime().toLocaleString()
    console.log(expiry_time)
}

contractInstance = deployContract()
