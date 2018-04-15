const ChronoBankPlatform = artifacts.require("ChronoBankPlatform")
const MultiEventsHistory = artifacts.require("MultiEventsHistory")
const path = require("path")

module.exports = (deployer, network) => {
	switch (network) {
		case "sidechain": {
			deployer.then(async () => {
				await deployer.deploy(ChronoBankPlatform)

				const platform = await ChronoBankPlatform.deployed()
				const history = await MultiEventsHistory.deployed()
				await history.authorize(platform.address)
				await platform.setupEventsHistory(history.address)

				console.log(`[MIGRATION] [${parseInt(path.basename(__filename))}] ChronoBankPlatform: #done`)
			})
			break;
		}
		default: {
			console.log(`[MIGRATION] [${parseInt(path.basename(__filename))}]: #skip`)
		}
	}
}
