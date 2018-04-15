const ChronoBankPlatform = artifacts.require("ChronoBankPlatform")
const ChronoBankAssetProxy = artifacts.require("ChronoBankAssetProxy")
const ChronoBankAsset = artifacts.require("ChronoBankAsset")
const path = require("path")

module.exports = (deployer, network) => {
	switch (network) {
		case "sidechain": {
			deployer.then(async () => {
				const chronoBankAssetProxy = await ChronoBankAssetProxy.deployed()
				await chronoBankAssetProxy.proposeUpgrade(ChronoBankAsset.address)

				console.log(`[MIGRATION] [${parseInt(path.basename(__filename))}] Final token setup: #done`)
			})
			break
		}
		default: {
			console.log(`[MIGRATION] [${parseInt(path.basename(__filename))}]: #skip`)
		}
	}
}
