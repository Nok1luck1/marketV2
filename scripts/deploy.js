//npx hardhat run scripts/deploy.js --network nameOfNetwork

const { ethers, network } = require('hardhat')


//const USDT = '0xdAC17F958D2ee523a2206206994597C13D831ec7' mainnet
const Owner ='0x3f4F5d9971c265a7485540207023EA4B68Af6dc6'
const Token = '0xF28b5b9995C052a0e4EC1b848EafA6D3b29a7724'
const main = async () => {
    const [deployer] = await ethers.getSigners()
    console.log(`Deployer address: ${deployer.address}`)
    //let nonce = await network.provider.send('eth_getTransactionCount', [deployer.address, 'latest']) - 1
    const NFT = await ethers.getContractFactory('NFT')
    const nFT = await NFT.deploy("PTRK","PTR",Owner,0)
    await nFT.deployed();
    console.log(`Token address : ${nFT.address}`)

    const Collection = await ethers.getContractFactory('Collection')
    const collection = await Collection.deploy()
    await collection.deployed();
    console.log(`Token address : ${collection.address}`)



    const Market = await ethers.getContractFactory('Market')
    const market = await Market.deploy(Token,Owner)
    await market.deployed();

    console.log(`Market deployed to: ${market.address}`)


    
}


// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
