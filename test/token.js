const CryptoControlToken = artifacts.require('CryptoControlToken')


contract('CryptoControlToken', function (accounts) {
    beforeEach(async function () {
        this.token = await CryptoControlToken.new()
    })


    it('should deploy properly', async function () {
        const instance = await CryptoControlToken.deployed()
        assert.notEqual(instance, null)
    })


    it('name, symbol and demicals should be set properly', async function () {
        assert.equal(await this.token.name(), 'CryptoControl')
        assert.equal(await this.token.symbol(), 'CC')
        assert.equal(await this.token.decimals(), 18)
    })
})
