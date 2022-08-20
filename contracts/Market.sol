// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

contract Market is AccessControl,Pausable{
    enum Status{
       Selled,Listed
    }
    enum Type{
        ERC721,ERC1155
    }
    struct Order{
        address seller;
        address target;
        uint amount;
        uint id;
        uint price;
        bytes data;
        Type typeToken;
        Status status;        
    }

    mapping (bytes32=> Order) public orderByHash;

    address private reseiverSender;
    uint private feePercent;

    event CreatedOrder(address seller,Type typeToken,uint amount,address token,bytes32 hashOrder);
    event CloseOrder(address buyer,Type typeToken,uint amount,address token,bytes32 hashOrder);

    constructor(address _receiverSender,uint _feePercent){
        reseiverSender = _receiverSender;
        feePercent = _feePercent;
    }
    function pause() private whenNotPaused{
        _pause();
    }
    function unpause()private whenPaused{
        _unpause();

    }
    function createOrder(string calldata _type,uint _price,address _token,uint _id,uint _amount,bytes calldata _data) public whenNotPaused {
        bytes32 hashOrder = keccak256(abi.encode(_type,_price,_token));
        Order storage _order = orderByHash[hashOrder];
        _order.seller = msg.sender;
        _order.target = _token;
        _order.typeToken = matchType(_type);
        _order.amount = _amount;
        _order.id = _id;
        _order.price = _price;
        _order.data = _data;
        _order.status = Status.Listed;
        if (_order.typeToken == Type.ERC721){
            IERC721(_token).safeTransferFrom(address(msg.sender), address(this), _id, _data);
        }
        else if  (_order.typeToken == Type.ERC1155){
            IERC1155(_token).safeTransferFrom(address(msg.sender),address(this),_id,_amount,_data);
        }
        else{
            revert("Must be fail earlier");
        }
        emit CreatedOrder(msg.sender, _order.typeToken, _amount, _token, hashOrder);
    }


    function matchType(string memory _name)internal pure returns(Type) {
        if (keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked("ERC721"))){
            return Type.ERC721;
        }
        else if (keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked("ERC1155"))){
            return Type.ERC1155;
        }
        else{
            revert("Wrong name of token type");
        }

    }
    


}

