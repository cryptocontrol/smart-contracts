const CryptoControlToken = artifacts.require('CryptoControlToken')
const CryptoControlClaimReward = artifacts.require('CryptoControlClaimReward')

const utils = require('./utils')

const cryptoControlPublicKey = '0x0f4f2ac550a1b4e2280d04c21cea7ebd822934b5'
const cryptoControlPrivateKey = 'aa3680d5d48a8283413f7a108367c7299ca73f553735860a87b08f39395618b7'


contract('CryptoControlClaimReward', function (accounts) {
    beforeEach(async function () {
        this.token = await CryptoControlToken.new()
        this.rewardContract = await CryptoControlClaimReward.new(cryptoControlPublicKey)

        await this.rewardContract.setTokenAddress(this.token.address)
        await this.token.addMinter(this.rewardContract.address)

    })


    // beforeEach(async function () {
    //     this.token = await CryptoControlToken.new()

    //     this.rewardContract = await CryptoControlClaimReward.new()
    //     await this.rewardContract.setTokenAddress(this.token)
    // })


    it('should deploy properly', async function () {
        assert.notEqual(this.rewardContract, null)
    })


    // it('test the verifyECDSA() function', async function () {
    //     const data = '0x1c8aff950685c2ed4bc3174f3472287b56d9517b9c948127319a09a7a36deac8'
    //     const v = 28
    //     const r = '0xcc731914de74a532d7f514b8367fd8cc0ea396ab6b8b1c3996ccbff74fc4e729'
    //     const s = '0x737db5e7ba1c3933327232ff6f9c75057fe7bd4e01aa6af992acb8b6d6a21241'

    //     const p = '0x6B3Ae23e0801C5ff0A91921036Dd2ADf0C1512f6'.toLowerCase()

    //     const result = await this.rewardContract.verifyECDSA(data, v, r, s)
    //     assert.equal(result, p)
    // })


    describe('claimReward()', async function () {
        const userId = '123'

        const reward = 100
        const nonce = Math.floor(Date.now() / 1000)
        const rewardAddress = accounts[1]

        const { hash, data } = utils.generateHash(reward, rewardAddress, nonce, userId, cryptoControlPrivateKey)

        it('should not revert if the inputs are correct', async function () {
            const result = await this.rewardContract.claimReward(
                reward,
                nonce,
                userId,

                utils.bufferToHex(data),
                hash.v, utils.bufferToHex(hash.r), utils.bufferToHex(hash.s),
                { from: rewardAddress }
            )

            assert.notEqual(result, null)
        })


        // it('should break if inputs are incorrect', async function () {
        //     const result = await this.rewardContract.claimReward(
        //         reward,
        //         rewardAddress,
        //         nonce,

        //         hash,
        //         v, r, s
        //     )
        //     // assert.equal(result, true)
        // })


        // it('should mint tokens if everything is correct', async function () {
        //     await this.rewardContract.claimReward(
        //         reward,
        //         rewardAddress,
        //         nonce,

        //         hash,
        //         v, r, s
        //     )

        //     const n = await this.token.balanceOf(rewardAddress)
        //     assert.equal(n, 100)
        //     // assert.equal(result, true)
        // })
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
