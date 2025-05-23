//SPDX-License-Identifier: MIT 
pragma solidity 0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {LinkToken} from "../test/mocks/LinkToken.sol";

abstract contract CodeConstants {
    /** VRF Mock Values */
    uint96 public constant MOCK_BASE_FEE = 0.25 ether;
    uint96 public constant MOCK_GAS_PRICE_LINK = 1e9;
    int256 public constant MOCK_WEI_PER_UNIT_LINK = 4e15;

    uint256 public constant ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant LOCAL_CHAIN_ID = 31337;

}

contract HelperConfig is CodeConstants, Script {

    // errors
    error HelperConfig__InvalidChainId();


    struct NetworkConfig {
        uint256 entranceFee;
        uint256 interval;
        address vrfCoordinator;
        bytes32 gasLane;
        uint256 subscriptionId;
        uint32 callbackGasLimit;
        address link;
        address account;
    }

    NetworkConfig public localNetworkConfig;
    mapping(uint256 chainId => NetworkConfig) public networkConfigs;

    constructor() {
        networkConfigs[ETH_SEPOLIA_CHAIN_ID] = getSepoliaEthConfig();
    }

    function getConfigByChainID(uint256 chainId) public returns(NetworkConfig memory) {
        if (networkConfigs[chainId].vrfCoordinator != address(0)) {
            return networkConfigs[chainId];
        } else if (chainId == LOCAL_CHAIN_ID) { 
            return getOrCreateAnvilEthConfig(); 
        } else {
            revert HelperConfig__InvalidChainId();
        }
    } 

    function getConfig() public returns(NetworkConfig memory) {
        console.log("Getting config for chainId: ", block.chainid);
        return getConfigByChainID(block.chainid);
    }

    function getSepoliaEthConfig() public pure returns(NetworkConfig memory) {
        return NetworkConfig({
            entranceFee: 0.01 ether,
            interval: 30, // 30 seconds
            vrfCoordinator: 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B,
            gasLane: 0x9e1344a1247c8a1785d0a4681a27152bffdb43666ae5bf7d14d24a5efd44bf71,
            callbackGasLimit: 500000, // 500,000 gas
            // subscriptionId: 0,
            subscriptionId: 63731689100132312348923206041633614019149628932749180741438871113102653844622,
            link: 0x779877A7B0D9E8603169DdbD7836e478b4624789,
            account: 0x849702b57B37E79c50dbe87a53EF2107f2c5e253
        });
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (localNetworkConfig.vrfCoordinator != address(0)) {
            return localNetworkConfig;
        }

        // Deploy mocks
        vm.startBroadcast();
        VRFCoordinatorV2_5Mock vrfCoordinator = new VRFCoordinatorV2_5Mock(
            MOCK_BASE_FEE,
            MOCK_GAS_PRICE_LINK,
            MOCK_WEI_PER_UNIT_LINK
        );
        LinkToken linkToken = new LinkToken();
        vm.stopBroadcast();

        // Create subscription
        vm.startBroadcast();
        uint256 subscriptionId = vrfCoordinator.createSubscription();
        vm.stopBroadcast();

        localNetworkConfig = NetworkConfig({
            entranceFee: 0.01 ether,
            interval: 30,
            vrfCoordinator: address(vrfCoordinator),
            gasLane: 0x9e1344a1247c8a1785d0a4681a27152bffdb43666ae5bf7d14d24a5efd44bf71,
            callbackGasLimit: 500000,
            subscriptionId: subscriptionId,
            link: address(linkToken),
            account: 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38 
        });
        return localNetworkConfig;
    }


    
}