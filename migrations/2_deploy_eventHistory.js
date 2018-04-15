var MultiEventsHistory = artifacts.require("MultiEventsHistory")
const path = require("path")

module.exports = (deployer, network) => {
	switch (network) {
		case "rinkeby":
		case "sidechain": {
			deployer.then(async () => {
				await deployer.deploy(MultiEventsHistory)

				console.log(`[MIGRATION] [${parseInt(path.basename(__filename))}] Events History: #done`)
			})
			break
		}
		default: {
			console.log(`[MIGRATION] [${parseInt(path.basename(__filename))}]: #skip`)
		}
	}
}
