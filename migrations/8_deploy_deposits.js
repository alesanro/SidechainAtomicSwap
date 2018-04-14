const Deposits = artifacts.require("Deposits")
const MultiEventsHistory = artifacts.require("MultiEventsHistory")
const path = require("path")

module.exports = (deployer, network) => {
	switch (network) {
		case "rinkeby": {
			deployer.then(async () => {
				await deployer.deploy(Deposits)
				
				const deposits = await Deposits.deployed()
				const history = await MultiEventsHistory.deployed()
				await history.authorize(deposits.address)
				await deposits.setupEventsHistory(history.address)

				console.log(`[MIGRATION] [${parseInt(path.basename(__filename))}] Deposits deploy: #done`)
			})
			break
		}
		default: {
			console.log(`[MIGRATION] [${parseInt(path.basename(__filename))}]: #skip`)
		}
	}
}
