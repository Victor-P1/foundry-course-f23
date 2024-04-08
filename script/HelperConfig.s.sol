// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {


     networkConfig public activeNetworkConfig ;
      uint8 public constant DECIMAL= 8;
      int256 public constant INITIAL_PRICE = 2000e8;

    struct networkConfig{
    address priceFeed;

    }
    constructor(){
    if (block.chainid == 11155111){
        activeNetworkConfig = getSepoliaEthConfig(); 
    }else if (block.chainid == 1){
        activeNetworkConfig = getMainnetEthConfig();
    }
    else{
        activeNetworkConfig = getAnvilEthConfig();
    }
    }
     function getSepoliaEthConfig () public pure returns(networkConfig memory) {
      networkConfig memory sepoliaConfig = networkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
      return sepoliaConfig;
     }
     function getMainnetEthConfig() public pure returns (networkConfig memory){
        networkConfig memory ethMainnetConfig = networkConfig({priceFeed:0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return ethMainnetConfig;
     }

     function getAnvilEthConfig() public returns(networkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)){
        return activeNetworkConfig;
        }
      vm.startBroadcast();
      MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(DECIMAL, INITIAL_PRICE);
      vm.stopBroadcast();
      networkConfig memory anvilConfig = networkConfig({priceFeed: address(mockV3Aggregator)});
      return anvilConfig;
     }
      

}
