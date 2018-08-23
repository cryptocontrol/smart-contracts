// var expectRevert = require('./helpers/expectRevert')

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


    // it('prevent suicideContract() by a non-owner', async function () {
    //     // const instance = await Suicidable.deployed()

    //     // // attempt to suicide the contract
    //     // await expectRevert(this.suicidable.suicideContract({
    //     //     from: accounts[1]
    //     // }))
    // })


    // it('allow suicideContract() by a previous owner', async function () {
    //     // // Transfer ownership to account[1]
    //     // await this.suicidable.transferOwnership(accounts[1])

    //     // // attempt to suicide the contract
    //     // this.suicidable.suicideContract({
    //     //     from: accounts[0]
    //     // })

    //     // // check the suicide flag
    //     // const hasSuicided = await this.suicidable.hasSuicided()
    //     // assert.equal(hasSuicided, true)
    // })
})
