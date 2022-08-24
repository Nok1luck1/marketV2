// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
// import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
// import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
//import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
//import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./Collection.sol";
import "./NFT.sol";


contract Market is AccessControl,Pausable{
    using SafeERC20 for IERC20;
    enum Status{
       SelledPart,Listed
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

    address public paymentToken;    
    uint private feePercent;
    bytes32 public constant ADMIN = keccak256("ADMIN");

    event CreatedOrder(address seller,Type typeToken,uint amount,address token,bytes32 hashOrder);
    event BoughtOrder(address buyer,Type typeToken,uint amount,address token,bytes32 hashOrder);
    event CancelOrderByAdmin(bytes32 hashOrder,uint timestamp);


    constructor(address _paymentT,uint _feePercent){
        feePercent = _feePercent;
        paymentToken = _paymentT;
        _grantRole(ADMIN, msg.sender);
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function pause() private whenNotPaused{
        _pause();
    }
    function unpause()private whenPaused{
        _unpause();
    }
    function createOrder(string calldata _type,uint _price,address _target,uint _id,uint _amount,bytes calldata _data) public whenNotPaused returns(bytes32){
        bytes32 hashOrder = keccak256(abi.encode(_type,_price,_target));
        Order storage _order = orderByHash[hashOrder];
        _order.seller = msg.sender;
        _order.target = _target;
        _order.typeToken = matchType(_type);
        _order.amount = _amount;
        _order.id = _id;
        _order.price = _price;
        _order.data = _data;
        _order.status = Status.Listed;
        if (_order.typeToken == Type.ERC721){
            IERC721(_target).safeTransferFrom(address(msg.sender), address(this), _id, _data);
        }
        else if  (_order.typeToken == Type.ERC1155){
            IERC1155(_target).safeTransferFrom(address(msg.sender),address(this),_id,_amount,_data);
        }
        else{
            revert("Must be fail earlier");
        }
        emit CreatedOrder(msg.sender, _order.typeToken, _amount, _target, hashOrder);
        return hashOrder;
    }
    function cancelOrder(bytes32 _hashOrder) public {
        require(hasRole(ADMIN, msg.sender));
        Order storage _order = orderByHash[_hashOrder];
        if (_order.typeToken == Type.ERC721){
            IERC721(_order.target).safeTransferFrom(address(msg.sender), address(this), _order.id, _order.data);
        }
        else if  (_order.typeToken == Type.ERC1155){
            IERC1155(_order.target).safeTransferFrom(address(msg.sender),address(this),_order.id,_order.amount,_order.data);
        }
        else{
            revert("Must be fail earlier");
        }
        emit CancelOrderByAdmin(_hashOrder, block.timestamp);
        delete orderByHash[_hashOrder];
        
    }
    function buyFromOrder(bytes32 hashOrder,uint amount) public {
        Order storage _order = orderByHash[hashOrder];
        require(_order.amount > 0,"Order is empty/WHAT?!");
        require(_order.amount >= amount,"Not enough token in order, rewrite amount");
        uint paymentToBuyer = _order.price *amount;
        IERC20(paymentToken).safeTransferFrom(address(msg.sender),address(this),paymentToBuyer);
        uint paymentToSeller = calculateFeeFromOrder(paymentToBuyer);
        IERC20(paymentToken).safeTransfer(msg.sender, paymentToSeller);
        if (_order.typeToken == Type.ERC721){
            IERC721(_order.target).safeTransferFrom(address(this),address(msg.sender), _order.id);
            delete orderByHash[hashOrder];
        }
        else if  (_order.typeToken == Type.ERC1155){
            IERC1155(_order.target).safeTransferFrom(address(this),address(msg.sender),_order.id, _order.amount, _order.data);
            _order.amount = _order.amount - amount;
            if( _order.amount == 0){
                delete orderByHash[hashOrder];
            }
        }
        else{
            revert("Must be fail earlier");
        }
        emit BoughtOrder(msg.sender, _order.typeToken, amount, _order.target, hashOrder); 
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
    function calculateFeeFromOrder(uint _price) internal  view returns(uint){
        uint amountToService = (_price / 1000) * feePercent ;
        uint amountToUser = _price - amountToService;
        return amountToUser;
    }
    function changePaymentToken(address token)public returns(address){
        require(hasRole(ADMIN, msg.sender));
        paymentToken = token;
        return paymentToken;
    }
    function changeFeePercent(uint _amount)public {
        require(hasRole(ADMIN, msg.sender));
        feePercent = _amount;
    }
    function onERC1155Received(address, address, uint256, uint256, bytes memory) public virtual returns (bytes4) {
        return this.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(address, address, uint256[] memory, uint256[] memory, bytes memory) public virtual returns (bytes4) {
        return this.onERC1155BatchReceived.selector;
    }

    function onERC721Received(address, address, uint256, bytes memory) public virtual returns (bytes4) {
        return this.onERC721Received.selector;
    }   
}

