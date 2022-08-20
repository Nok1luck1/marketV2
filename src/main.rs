use std::env;
use std::str::FromStr;

use web3::contract::{Contract, Options};
use web3::types::{Address, H160, U256};

#[tokio::main]
async fn main() -> web3::Result<()> {
    dotenv::dotenv().ok();

    let websocket = web3::transports::WebSocket::new(&env::var("INFURA_Goerli").unwrap()).await?;
    let web3s = web3::Web3::new(websocket);

    let mut accounts = web3s.eth().accounts().await?;
    accounts.push(H160::from_str(&env::var("Owner").unwrap()).unwrap());

    let wei_conv: U256 = U256::exp10(18);
    for account in accounts {
        let balance = web3s.eth().balance(account, None).await?;
        println!(
            "Eth balance of {:?}: {}",
            account,
            balance.checked_div(wei_conv).unwrap()
        );
    }
    let market_addr = Address::from_str("0xC1E5531D98093831300E9E17fC1f4fAeC1D51772");
    Ok(())
}
