// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract DecentralizedFinance is ERC20 {
    using Counters for Counters.Counter;
    struct Loan {
        uint256 deadline;
        uint256 amount;
        address lender;
        address borrower;
        bool isBasedNft;
        uint256 nftContract;
        uint256 nftId;
    }
    address owner;
    uint256 maxLoanDuration;
    uint256 dexSwapRate;
    uint256 balance;
    Counters.Counter public tokenIdCounter;
    mapping(uint256 => Loan) loans;

    
    event loanCreated(address indexed borrower, uint256 amount, uint256 deadline);

    constructor() ERC20("DEX", "DEX") {
        owner = msg.sender;
        _mint(address(this), 10**18);
        // TODO: initialize
    }

    function buyDex() external payable {
        require(msg.value > 0, "The value needs to be superior to 0.");
        uint256 quantityDEX = msg.value / dexSwapRate;
        _mint(msg.sender, quantityDEX);
        balance += (quantityDEX * dexSwapRate);
    }

    function sellDex(uint256 dexAmount) external {
        // TODO: implement this
    }

    function loan(uint256 dexAmount, uint256 deadline) external {
        // TODO: implement this

       // emit loanCreated(msg.sender, loanAmount, deadline);
    }

    function returnLoan(uint256 ethAmount) external {
        // TODO: implement this
    }

    function getBalance() public view returns (uint256) {
        require(msg.sender == owner, "Only the owner of the contract can observe the balance.");
        return balance;
    }

    function setDexSwapRate(uint256 rate) external {
        require(msg.sender == owner, "Only the owner of the contract can change the dex swap rate.");
        dexSwapRate = rate;
    }

    function getDexBalance() public view returns (uint256) {
        // TODO: implement this
    }

    function makeLoanRequestByNft(IERC721 nftContract, uint256 nftId, uint256 loanAmount, uint256 deadline) external {
        // TODO: implement this
    }

    function cancelLoanRequestByNft(IERC721 nftContract, uint256 nftId) external {
        // TODO: implement this
    }

    function loanByNft(IERC721 nftContract, uint256 nftId) external {
        // TODO: implement this

        //emit loanCreated(msg.sender, loanAmount, deadline);
    }

    function checkLoan(uint256 loanId) external {
        // TODO: implement this
    }
}