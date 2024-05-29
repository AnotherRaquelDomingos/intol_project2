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
        IERC721 nftContract;
        uint256 nftId;
    }
    address owner;
    uint256 maxLoanDuration;
    uint256 dexSwapRate;
    uint256 balance; //In Wei
    Counters.Counter public loanIdCounter;
    mapping(uint256 => Loan) public loans;
    mapping(uint256 => Loan) public loanRequests;
    
    event loanCreated(address indexed borrower, uint256 amount, uint256 deadline);

    constructor() ERC20("DEX", "DEX") {
        owner = msg.sender;
        maxLoanDuration = 5 * 1 days; //check
        _mint(address(this), 10**18);
        dexSwapRate = 1; //1 wei gives you 10 DEX tokens
        balance = 0;
    }

    function buyDex() external payable {
        require(msg.value > 0, "The value needs to be superior to 0.");
        uint256 quantityDEX = msg.value / dexSwapRate;
        uint256 remainder = msg.value % dexSwapRate;
        balance += (msg.value - remainder);
        payable(msg.sender).transfer(remainder);
        _transfer(address(this), msg.sender, quantityDEX);
    }

    function sellDex(uint256 dexAmount) external {
        require(dexAmount <= getDexBalance(), "Not enough DEX tokens owned.");
        uint256 quantityWei = dexAmount * dexSwapRate;
        require(balance >= quantityWei, "Balance of contract is too low.");

        //take tokens from seller
        _transfer(msg.sender, address(this), dexAmount);

        //pay to seller
        payable(msg.sender).transfer(quantityWei);
        balance -= quantityWei;
    }

    function loan(uint256 dexAmount, uint256 deadline) external returns (uint256) {
        require(deadline <= maxLoanDuration, "Deadline exceeds the max duration for a loan.");

        uint256 loanAmount = (dexAmount * dexSwapRate) / deadline; //to confirm

        Loan memory createdLoan = Loan(deadline, loanAmount, owner, msg.sender, false, IERC721(address(0)), 0);

        require(balance >= loanAmount, "Balance of contract is too low.");
        balance -= (loanAmount/2);
        payable(msg.sender).transfer(loanAmount/2);

        _burn(msg.sender, dexAmount);

        loanIdCounter.increment();
        uint256 loanId = loanIdCounter.current();
        loans[loanId] = createdLoan;

        emit loanCreated(msg.sender, loanAmount, deadline);
        return loanId;
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

    function getDexBalanceOfContract() public view returns (uint256) {
        return balanceOf(address(this));
    }

    function getDexBalance() public view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function makeLoanRequestByNft(IERC721 nftContract, uint256 nftId, uint256 loanAmount, uint256 deadline) external {
        require(deadline <= maxLoanDuration, "Deadline exceeds maxLoanDuration.");

        Loan memory loanRequestCreated = Loan(deadline, loanAmount, address(0), msg.sender, true, nftContract, nftId);

        loanRequests[nftId] = loanRequestCreated; //or save the id of a loan
        //take nft from account

        emit loanCreated(msg.sender, loanAmount, deadline); //verify
    }

    function cancelLoanRequestByNft(IERC721 nftContract, uint256 nftId) external {
        require(loanRequests[nftId].nftId != nftId, "No request created for that nftId");   
        require(loanRequests[nftId].nftContract != nftContract, "No request created for that nftContract");

        loanRequests[nftId] = Loan(0, 0, address(0), address(0), false, IERC721(address(0)), 0); //default loan
    }

    function loanByNft(IERC721 nftContract, uint256 nftId) external {
        require(loanRequests[nftId].nftId != nftId, "No request created for that nftId");   
        require(loanRequests[nftId].nftContract != nftContract, "No request created for that nftContract");

        Loan memory loanToEmit = loanRequests[nftId];
        loanToEmit.lender = msg.sender;

        uint256 amountDEX = loanToEmit.amount / dexSwapRate;
        _burn(msg.sender, amountDEX); 

        loanIdCounter.increment();
        uint256 loanId = loanIdCounter.current();
        loans[loanId] = loanToEmit;

        loanRequests[nftId] = Loan(0, 0, address(0), address(0), false, IERC721(address(0)), 0); //default loan

        emit loanCreated(msg.sender, loanToEmit.amount, loanToEmit.deadline);
    }

    function checkLoan(uint256 loanId) external {
        // TODO: implement this
    }
}