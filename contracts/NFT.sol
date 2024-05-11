// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFT is ERC721, ReentrancyGuard {
    
    uint256 public totalSupply = 0;
    uint256 public price = 1 ether; // ether = 1^18;
    uint256 public limitPerUser = 3;
    mapping(address => uint) public balances;
    mapping(address => bool) public whitelist;

    address public owner;

    constructor() ERC721("NFT", "nft") {
        owner = msg.sender;
    }

    modifier mintChecks(
        uint amount,
        uint funds,
        address to
    ) {
        require(amount > 0, "mint: amount is 0");
        require(funds >= price * amount, "mint:funds sent not enough");
        require(balances[to] + amount <= limitPerUser, "mint: limit reached");
        _;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "onlyOwner: unathorized");
        _;
    }

    function mint(
        address to,
        uint amount
    ) external payable nonReentrant mintChecks(amount, msg.value, to) {
        _handleRefund(msg.value, price, amount);
        balances[to] += amount;
        for (uint i = 0; i < amount; i++) _mint(to, totalSupply++);
    }

    function _handleRefund(uint funds, uint price, uint amount) internal {
        if (funds > price * amount) {
            uint refund = msg.value - price;
            (bool status, ) = (msg.sender).call{value: refund}("");
            require(status, "_handleRefund: refund failed");
        }
    }

    function withdraw() external onlyOwner {
       uint balance = address(this).balance;
       (bool status,) = (owner).call{value: balance}("");
       require(status, "withdraw: trasnfer failed");
    }

}
