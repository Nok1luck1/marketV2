use std::env;
use std::str::FromStr;

use secp256k1::SecretKey;
use web3::api::Accounts;
use web3::contract::tokens::Tokenize;
use web3::contract::{Contract, Options};
use web3::types::{Address, Bytes, TransactionParameters, H160, U256};

#[tokio::main]
async fn main() -> web3::Result<()> {
    // let websocket = web3::transports::WebSocket::new(&env::var("INFURA_Goerli").unwrap()).await?;
    // let web3s = web3::Web3::new(websocket);

    // let wei_conv: U256 = U256::exp10(18);
    // for account in accounts {
    //     let balance = web3s.eth().balance(account, None).await?;
    //     println!(
    //         "Eth balance of {:?}: {}",
    //         account,
    //         balance.checked_div(wei_conv).unwrap()
    //     );
    // }

    //

    // let Token_addr = Address::from_str("0x7B7de810E50c58950b85fE4E3003C985f968FeAb").unwrap();
    // let token_contract = Contract::from_json(
    //     web3s.eth(),
    //     Token_addr,
    //     include_bytes!("../bin/contracts/Token.abi"),
    // )
    // .unwrap();
    // let nft_addr = Address::from_str("0x9ea9E1FB8d3B458407f2F348f93574f270d1a529").unwrap();
    // let nft_contract = Contract::from_json(
    //     web3s.eth(),
    //     Token_addr,
    //     include_bytes!("../bin/contracts/NFT.abi"),
    // )
    // .unwrap();

    // let collection_addr = Address::from_str("0x9ea9E1FB8d3B458407f2F348f93574f270d1a529").unwrap();
    // let collection_contract = Contract::from_json(
    //     web3s.eth(),
    //     Token_addr,
    //     include_bytes!("../bin/contracts/Collection.abi"),
    // )
    // .unwrap();

    // let querymarket: Address = market_contract
    //     .query("paymentToken", (), None, Options::default(), None)
    //     .await
    //     .unwrap();
    // println!("{} address token", querymarket);
    // println!("{} addres token from contract", Token_addr);

    // let changetokenmarket = TransactionParameters {
    //     nonce: None,
    //     to: Some(market_addr),
    //     value: U256::exp10(18).checked_div(20.into()).unwrap(),
    //     gas_price: None,
    //     gas: U256::exp10(18).checked_div(20.into()).unwrap(),
    //     data: Bytes(datamarket),
    //     ..Default::default()
    // };
    // let signed_chgn_token_market = web3s
    //     .accounts()
    //     .sign_transaction(changetokenmarket, &private_key)
    //     .await
    //     .unwrap();
    //println!("Signed transction {:?}", signed_chgn_token_market);
    /////////////////////////////

    pub async fn transactionToMarket(_namefunc: String, _parametrs: String) -> web3::Result<()> {
        dotenv::dotenv().ok();
        let websockets =
            web3::transports::WebSocket::new(&env::var("INFURA_Goerli").unwrap()).await?;
        let web3z = web3::Web3::new(websockets);
        let mut accounts = web3z.eth().accounts().await?;
        accounts.push(H160::from_str(&env::var("Owner").unwrap()).unwrap());
        let gas_prize = web3z.eth().gas_price().await.unwrap();
        let nonces = web3z
            .eth()
            .transaction_count(accounts[0], None)
            .await
            .unwrap();
        ///////////////////////////////////////////
        let market_addr = Address::from_str("0x94a16B549659bd5d8Fbfb1d2AD06DdF63d100e0A").unwrap();
        let market_contract = Contract::from_json(
            web3z.eth(),
            market_addr,
            include_bytes!("../bin/contracts/Market.abi"),
        )
        .unwrap();

        let _data = market_contract
            .abi()
            .function(&_namefunc)
            .unwrap()
            .encode_input(&(_parametrs).into_tokens())
            .unwrap();
        let newtrasns = TransactionParameters {
            nonce: None,
            to: Some(market_addr),
            value: U256::exp10(18),
            gas_price: Some(gas_prize),
            gas: U256::exp10(18),
            data: Bytes(_data),
            ..Default::default()
        };

        let private_key = SecretKey::from_str(&env::var("PRIVATE_KEY").unwrap()).unwrap();
        let sendTrans = web3z
            .accounts()
            .sign_transaction(newtrasns, &private_key)
            .await
            .unwrap();
        println!("SEnded transction {:?}", sendTrans);
        Ok(())
    }
    let changeToken = transactionToMarket(
        ("changePaymentToken").to_string(),
        ("0x7B7de810E50c58950b85fE4E3003C985f968FeAb").to_string(),
    )
    .await
    .unwrap();
    println!("{:?}", changeToken);
    ///////////////////////////////////////////
    Ok(())
}
