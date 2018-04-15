const AtomicSwapERC20 = artifacts.require("AtomicSwapERC20")
const path = require("path")

module.exports = (deployer, network) => {
	switch (network) {
		case "rinkeby":
		case "sidechain": {
			deployer.then(async () => {
				await deployer.deploy(AtomicSwapERC20)

				console.log(`[MIGRATION] [${parseInt(path.basename(__filename))}] Atomic Swap ERC20 deploy: #done`)
			})
			break
		}
		default: {
			console.log(`[MIGRATION] [${parseInt(path.basename(__filename))}]: #skip`)
		}
	}
}
