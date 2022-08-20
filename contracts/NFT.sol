//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT is ERC721,Ownable {



    constructor (string memory name_,string memory symbol_,address newOwner,uint tokenID) ERC721(name_,symbol_)  {
        
        mint(newOwner, tokenID);
        transferOwnership(newOwner);
    }

    function mint(address to, uint256 tokenId) public returns (bool) {
        _mint(to, tokenId);
        return true;
    }

}