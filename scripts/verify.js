const hre = require('hardhat');
const { ethers } = require(`hardhat`);
const NFT = '0x9ea9E1FB8d3B458407f2F348f93574f270d1a529'
const Collection = '0xe7cfb8a49214DD3D47459D27cfcE7aa5C1053a8B'
const Market = '0xD1Ded8dA1c2768EcCCCE1d7421F9C4031A8ef40A'
const Owner ='0x0d8Bb1797162fF49d3777c4367f22b49EbBA7be6'
const Token = '0xF28b5b9995C052a0e4EC1b848EafA6D3b29a7724'

async function main() {
    // console.log(`Verify NFT contract`);
    // res0 = await hre.run("verify:verify", {
    //     address: NFT,
    //     constructorArguments: ["PTRK","PTR",Owner,0
    //     ],
    //     optimizationFlag: true
    // })
    // console.log(res0);

    // console.log(`Verify Collection contract`);
    // res1 = await hre.run("verify:verify", {
    //     address: Collection,
    //     constructorArguments: [ ],
    //     optimizationFlag: true
    // })
    // console.log(res1);


    console.log(`Verify MArket contract`);
    res2 = await hre.run("verify:verify", {
        address: Market,
        constructorArguments: [Token,40],
        optimizationFlag: true
    })
    console.log(res2);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });