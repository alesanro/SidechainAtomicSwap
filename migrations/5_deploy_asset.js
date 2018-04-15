const ChronoBankAsset = artifacts.require("ChronoBankAsset")
const ChronoBankAssetProxy = artifacts.require("ChronoBankAssetProxy")
const path = require("path")

module.exports = (deployer, network) => {
	switch (network) {
		case "sidechain": {
			deployer.then(async () => {
				await deployer.deploy(ChronoBankAsset)
				const asset = await ChronoBankAsset.deployed()
				await asset.init(ChronoBankAssetProxy.address)

				console.log(`[MIGRATION] [${parseInt(path.basename(__filename))}] ChronoBankAsset: #done`)
			})
			break
		}
		default: {
			console.log(`[MIGRATION] [${parseInt(path.basename(__filename))}]: #skip`)
		}
	}
}
