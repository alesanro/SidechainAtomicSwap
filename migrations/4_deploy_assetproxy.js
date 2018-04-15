const ChronoBankAssetProxy = artifacts.require("ChronoBankAssetProxy")
const ChronoBankPlatform = artifacts.require("ChronoBankPlatform")
const path = require("path")

module.exports = (deployer, network) => {
	switch (network) {

		case "sidechain": {
			deployer.then(async () => {
				const LH_SYMBOL = 'LHMOON'
				const LH_NAME = 'LH Moon Token'
				const LH_DESCRIPTION = 'ChronoBank LH Moon Token'

				const BASE_UNIT = 12
				const IS_REISSUABLE = true
				// const IS_NOT_REISSUABLE = false

				await deployer.deploy(ChronoBankAssetProxy)

				const platform = await ChronoBankPlatform.deployed()
				await platform.issueAsset(LH_SYMBOL, 2000000000000, LH_NAME, LH_DESCRIPTION, BASE_UNIT, IS_REISSUABLE)

				const proxy = await ChronoBankAssetProxy.deployed()
				await proxy.init(platform.address, LH_SYMBOL, LH_NAME)
				await platform.setProxy(proxy.address, LH_SYMBOL)

				console.log(`[MIGRATION] [${parseInt(path.basename(__filename))}] ChronoBankAssetProxy: #done`)
			})
			break
		}
		default: {
			console.log(`[MIGRATION] [${parseInt(path.basename(__filename))}]: #skip`)
		}
	}
}
