const { assertRevert } = require('openzeppelin-solidity/test/helpers/assertRevert')
const { increaseTime } = require('openzeppelin-solidity/test/helpers/increaseTime')
const expectEvent = require('openzeppelin-solidity/test/helpers/expectEvent')

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

    it('should deploy properly', async function () {
        assert.notEqual(this.rewardContract, null)
    })

    describe('claimReward()', async function () {
        const userId = '123'

        const reward = 100
        const nonce = Math.floor(Date.now() / 1000)
        const rewardAddress = accounts[1]

        const { hash, data } = utils.generateHash(reward, rewardAddress, nonce, userId, cryptoControlPrivateKey)


        beforeEach(async function () {
            this.result = await this.rewardContract.claimReward(
                reward,
                nonce,
                userId,

                utils.bufferToHex(data),
                hash.v, utils.bufferToHex(hash.r), utils.bufferToHex(hash.s), {
                    from: rewardAddress
                }
            )
        })


        it('should mint tokens', async function () {
            assert.notEqual(true, null)
        })


        it('should emit RewardClaimed() event with the right parameters', async function () {
            const event = await expectEvent.inLogs(this.result.logs, 'RewardClaimed')
            assert.equal(event.args.dest, rewardAddress)
            assert.equal(event.args.amount, reward)
            assert.equal(event.args.nonce, nonce)
        })


        it('should revert a second claim reward with same nonce', async function () {
            await assertRevert(
                this.rewardContract.claimReward(
                    reward, nonce, userId, utils.bufferToHex(data),
                    hash.v, utils.bufferToHex(hash.r), utils.bufferToHex(hash.s), {
                        from: rewardAddress
                    }
                )
            );
        })


        it('should revert a second claim reward with higher nonce but at the same time', async function () {
            const newNonce = nonce + 60 * 5
            const { hash, data } = utils.generateHash(reward, rewardAddress, newNonce, userId, cryptoControlPrivateKey)

            await assertRevert(
                this.rewardContract.claimReward(
                    reward, newNonce, userId, utils.bufferToHex(data),
                    hash.v, utils.bufferToHex(hash.r), utils.bufferToHex(hash.s), {
                        from: rewardAddress
                    }
                )
            );
        })


        it('should not revert a second claim reward with higher nonce at later time', async function () {
            const newNonce = nonce + 60 * 5
            const { hash, data } = utils.generateHash(reward, rewardAddress, newNonce, userId, cryptoControlPrivateKey)

            await increaseTime(60 * 5 + 1);

            const result = this.rewardContract.claimReward(
                reward, newNonce, userId, utils.bufferToHex(data),
                hash.v, utils.bufferToHex(hash.r), utils.bufferToHex(hash.s), {
                    from: rewardAddress
                }
            )

            assert.notEqual(result, null)
        })
    })
})
