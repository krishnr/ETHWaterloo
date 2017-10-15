Web3 = require('web3')
solc = require('solc')
fs = require('fs')


web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
code = fs.readFileSync('Voting.sol').toString()
compiledCode = solc.compile(code)

abiDefinition = JSON.parse(compiledCode.contracts[':Voting'].interface)

VotingContract = web3.eth.contract(abiDefinition)
byteCode = compiledCode.contracts[':Voting'].bytecode

deployedContract = VotingContract.new(['Superman','Batman','Wonder Woman'],{data: byteCode, from: web3.eth.accounts[0], gas: 4700000})

contractInstance = VotingContract.at(deployedContract.address)

console.log("Successfully deployed! Remember to change the contract address in your index.js file!")