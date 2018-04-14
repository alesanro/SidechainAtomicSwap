const path = require("path")

module.exports = (deployer, network) => {
	switch (network) {
		case "rinkeby": {
			deployer.then(async () => {
				await deployer.deploy(Migrations)
			})
			break
		}
		default: {
			console.log(`[MIGRATION] [${parseInt(path.basename(__filename))}]: #skip`)
		}
	}
}
