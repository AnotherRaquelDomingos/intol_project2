Afonso Santos - FC56368
Raquel Domingos - FC56378
Miguel Faísco - FC56954

HOW TO RUN THE PROJECT
-To run the project, the nft.sol file and the DecentralizedFinance.sol file should be added to Remix and using Metamask (Injected Provider), the contracts should be deployed to the Sepolia Testnet.
-Then, on the folder where the js and html files are located, an HTTP server should be started with: python -m http.server 8080
-Open a browser (Ensure that it is connected to the Metamask account) and access http://localhost:8080/
-In the above URL, you should be able to interact with the DecentralizedFinance.sol contract.
-If you need to mint an NFT, you can do it via Remix with the SimpleNFT contract that was deployed.
-When a NFT is minted by a user, this must execute the setApproveForAll function with the address of the DecentralizedFinance contract and value true.

ADJUSTMENT RULE FOR THE DEXT TO WEI EXCHANGE RATE
-The adjustment rule can be seen at the adjustDexSwapRate() function in the DecentralizedFinance.sol contract. This function is called when DEX is bought or sold and in the loan, returnLoan and loanByNFT functions.
-The base rule is that swapRate = balance / dexBalance. 
-This way, when the dexBalance of the contract gets lower, the swapRate increases, therefore making a DEX more expensive.
