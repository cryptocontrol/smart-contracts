const ethUtil = require('ethereumjs-util')
const createHash = require('create-hash')


const generateHash = (amount, dest, nonce, userId, privateKey) => {
    const privkeyBuffer = new Buffer(privateKey, 'hex')
    const data = createHash('sha256')
        .update(numberToUint8(amount))
        .update(ethUtil.toBuffer(dest))
        // .update(ethUtil.toBuffer(nonce))
        .update(numberToUint8(nonce))
        .update(ethUtil.toBuffer(userId))
        .digest()

    const hash = ethUtil.ecsign(data, privkeyBuffer)
    const publicKey = ethUtil.ecrecover(data, hash.v, hash.r, hash.s)

    return {
        publicKey,
        data,
        hash
    }
}


const numberToUint8 = num => ethUtil.toBuffer(num & 255)


const bufferToHex = buffer => `0x${buffer.toString('hex')}`


module.exports = {
    generateHash,
    bufferToHex
}