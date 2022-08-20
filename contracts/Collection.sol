//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;


import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Collection is ERC1155,Ownable {
    // uint public constant XXX = 0;
    // uint public constant Bones = 1;
    // uint public constant Pepp = 2;
    // uint public constant SCAR = 3; 

 
constructor() ERC1155 ("https://bafybeicl5wux3yohl4zui7xa6dpytg4el3e3qbal25wlysupcv5knjt4mm.ipfs.nftstorage.link/{id}.jpg"){
    mint(msg.sender,0, 10**18,"https://bafybeicl5wux3yohl4zui7xa6dpytg4el3e3qbal25wlysupcv5knjt4mm.ipfs.nftstorage.link/0.jpg");
    mint(msg.sender,1, 10**18,"https://bafybeicl5wux3yohl4zui7xa6dpytg4el3e3qbal25wlysupcv5knjt4mm.ipfs.nftstorage.link/1.jpg");
    mint(msg.sender,2, 10**18,"https://bafybeicl5wux3yohl4zui7xa6dpytg4el3e3qbal25wlysupcv5knjt4mm.ipfs.nftstorage.link/2.jpg");
    mint(msg.sender,3, 10**18,"https://bafybeicl5wux3yohl4zui7xa6dpytg4el3e3qbal25wlysupcv5knjt4mm.ipfs.nftstorage.link/3.jpg");

}

function mint(address _to, uint256 _tokenId, uint256 _amount,bytes memory _data) public {
    _mint(_to, _tokenId, _amount, _data);

}
function mint(address to, uint256 tokenId, uint256 amount) public returns (bool) {
		_mint(to, tokenId, amount, "");
		return true;
	}

}