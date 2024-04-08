-include .env
 test:; forge test
 deploy-sepolia:;forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvvv
bast:; forge test --mt testWithdrawWithSingleFunder
nun:; forge snapshot
forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY -vvvvv