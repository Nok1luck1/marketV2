// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Token is Ownable,Pausable,ERC20("TOKENoT","TKT"){



constructor(){
    transferOwnership(msg.sender);
    mint(msg.sender,10000000*(10**18));
}
function mint(address to,uint _amount) public onlyOwner{
    _mint(to,_amount);
}
function pause()public onlyOwner whenNotPaused{
    _pause();
}
function unpause()public onlyOwner whenPaused{
    _unpause();
}
}