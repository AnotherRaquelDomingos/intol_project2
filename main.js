const web3 = new Web3(window.ethereum);

// the part is related to the DecentralizedFinance smart contract
const defi_contractAddress = "0xbC1f73c8713dad95c04CE54246217Df41365872A";
import { defi_abi } from "./abi_decentralized_finance.js";
const defi_contract = new web3.eth.Contract(defi_abi, defi_contractAddress);

// the part is related to the the SimpleNFT smart contract
const nft_contractAddress = "0xF9B25B38f5FDadbC98Dfbe073A218D3Ea17ef631";
import { nft_abi } from "./abi_nft.js";
const nft_contract = new web3.eth.Contract(nft_abi, nft_contractAddress);

async function connectMetaMask() {
    if (window.ethereum) {
        try {
            const accounts = await window.ethereum.request({
                method: "eth_requestAccounts",
            });
            console.log("Connected account:", accounts[0]);
        } catch (error) {
            console.error("Error connecting to MetaMask:", error);
        }
    } else {
        console.error("MetaMask not found. Please install the MetaMask extension.");
    }
}

async function setRateEthToDex(rate) {
    try {
        const fromAddress = await (await window.ethereum.request({method: "eth_accounts",}))[0];
        await defi_contract.methods.setDexSwapRate(rate).call({from: fromAddress,});
    } catch (error) {
        console.error("Error setting RateEthToDex:", error);
    }
}

async function listenToLoanCreation() {
    // TODO: implement this
}

async function checkLoanStatus() {
    // TODO: implement this
}

async function buyDex(quantityWei) {
    try {
        const fromAddress = await (await window.ethereum.request({method: "eth_accounts",}))[0];
        await defi_contract.methods.buyDex().send({
            from: fromAddress,
            value: quantityWei,
        });
        console.log("DEX bought successfully");
    } catch (error) {
        console.error("Error buying DEX:", error);
    }
}

async function getDex() {
    try {
        const fromAddress = await (await window.ethereum.request({method: "eth_accounts",}))[0];
        var totalDEXAmount = await defi_contract.methods.getDexBalance().call({from: fromAddress,});
        var elem = document.getElementById("totalDEX");
        elem.innerText = totalDEXAmount.toString();
    } catch (error) {
        console.error("Error getting DEX Balance:", error);
    }
}

async function sellDex(dexAmount) {
    try {
        const fromAddress = await (await window.ethereum.request({method: "eth_accounts",}))[0];
        await defi_contract.methods.sellDex(dexAmount).send({from: fromAddress,});
        console.log("DEX sold successfully");
    } catch (error) {
        console.error("Error selling DEX:", error);
    }
}

async function loan(dexAmount, deadline) {
    try {
        const fromAddress = await (await window.ethereum.request({method: "eth_accounts",}))[0];
        await defi_contract.methods.loan(dexAmount, deadline).send({from: fromAddress,});
        console.log("Loan created successfully");
    } catch (error) {
        console.error("Error creating loan:", error);
    }
}

async function returnLoan(loanId, quantityWei) {
    try {
        const fromAddress = await (await window.ethereum.request({method: "eth_accounts",}))[0];
        await defi_contract.methods.returnLoan(loanId).send({
            from: fromAddress,
            value: quantityWei,
        });
        console.log("Loan returned successfully");
    } catch (error) {
        console.error("Error returning loan:", error);
    }
}

async function getEthTotalBalance() {
    try {
        const fromAddress = await (await window.ethereum.request({method: "eth_accounts",}))[0];
        const contractBalance = await defi_contract.methods.getBalance().call({from: fromAddress,});
        var elem = document.getElementById("contractBalance");
        elem.innerText = contractBalance;
    } catch (error) {
        console.error("Error getting contract total balance:", error);
    }
}

async function getRateEthToDex() {
    try {
        const dexSwapRate = await defi_contract.methods.getDexSwapRate().call();
        var elem = document.getElementById("getDexSwapRate");
        elem.innerText = dexSwapRate;
    } catch (error) {
        console.error("Error getting RateEthToDex:", error);
    }
}

async function getAvailableNfts() {
    // TODO: implement this
}

async function getTotalBorrowedAndNotPaidBackEth() {
    // TODO: implement this
}

async function makeLoanRequestByNft(nftContract, nftId, loanAmount, deadline) {
    try {
        const fromAddress = await (await window.ethereum.request({method: "eth_accounts",}))[0];
        await defi_contract.methods.makeLoanRequestByNft(nftContract, nftId, loanAmount, deadline).send({from: fromAddress});
        console.log("Loan requested successfully");
    } catch (error) {
        console.error("Error requesting loan:", error);
    }
}

async function cancelLoanRequestByNft(nftContract, nftId) {
    try {
        const fromAddress = await (await window.ethereum.request({method: "eth_accounts",}))[0];
        await defi_contract.methods.cancelLoanRequestByNft(nftContract, nftId).send({from: fromAddress});
        console.log("Loan cancelled successfully");
    } catch (error) {
        console.error("Error canceling loan:", error);
    }
}

async function loanByNft() {
    // TODO: implement this
}

async function checkLoan() {
    // TODO: implement this
}

// async function listenToLoanCreation() {
//     // TODO: implement this
// }

async function getAllTokenURIs() {
    // TODO: implement this
}

window.connectMetaMask = connectMetaMask;
window.buyDex = buyDex;
window.getDex = getDex;
window.sellDex = sellDex;
window.loan = loan;
window.returnLoan = returnLoan;
window.getEthTotalBalance = getEthTotalBalance;
window.setRateEthToDex = setRateEthToDex;
window.getRateEthToDex = getRateEthToDex;
window.makeLoanRequestByNft = makeLoanRequestByNft;
window.cancelLoanRequestByNft = cancelLoanRequestByNft;
// window.loanByNft = loanByNft;
// window.checkLoan = checkLoan;
// window.listenToLoanCreation = listenToLoanCreation;
// window.getAvailableNfts = getAvailableNfts;
// windows.getTotalBorrowedAndNotPaidBackEth = getTotalBorrowedAndNotPaidBackEth;
// windows.checkLoanStatus = checkLoanStatus;
// windows.getAllTokenURIs = getAllTokenURIs;