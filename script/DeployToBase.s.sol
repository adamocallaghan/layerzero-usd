// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {DecentralizedStableCoin} from "../src/DecentralizedStableCoin.sol";
import {DSCEngine} from "../src/DSCEngine.sol";

contract DeployToBase is Script {
    function run() external {
        // ===================
        // === SCRIPT VARS ===
        // ===================

        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        string memory BASE_LZ_ENDPOINT = "BASE_SEPOLIA_LZ_ENDPOINT";
        string memory DEPLOYER_PUBLIC_ADDRESS = "DEPLOYER_PUBLIC_ADDRESS";
        string memory BASE_WETH_ADDRESS = "BASE_WETH_ADDRESS";
        string memory BASE_WETH_USD_ORACLE = "BASE_WETH_USD_ORACLE";

        // ========================
        // === BASE DEPLOYMENTS ===
        // ========================

        console2.log("#######################################");
        console2.log("########## Deploying to Base ##########");
        console2.log("#######################################");

        vm.createSelectFork("base");

        vm.startBroadcast(deployerPrivateKey);

        // ==============
        // OFT Stablecoin
        // ==============
        DecentralizedStableCoin baseOft = new DecentralizedStableCoin{salt: "xyz"}(
            "Reward Token", "ReOFT", vm.envAddress(BASE_LZ_ENDPOINT), vm.envAddress(DEPLOYER_PUBLIC_ADDRESS)
        );
        console2.log("OFT Stablecoin Address: ", address(baseOft));

        // =================
        // OAPP StableEngine
        // =================

        // create and assign our tokenCollateral & priceFeed address arrays
        address[] memory tokenAddresses;
        address[] memory priceFeedAddresses;
        tokenAddresses[0] = (vm.envAddress(BASE_WETH_ADDRESS));
        priceFeedAddresses[0] = (vm.envAddress(BASE_WETH_USD_ORACLE));

        DSCEngine baseOapp = new DSCEngine{salt: "xyz"}(
            vm.envAddress(BASE_LZ_ENDPOINT),
            vm.envAddress(DEPLOYER_PUBLIC_ADDRESS),
            tokenAddresses,
            priceFeedAddresses,
            address(baseOft)
        );
        console2.log("OAPP StableEngine Address: ", address(baseOapp));

        // transfer ownership of OFT to OAPP
        baseOft.transferOwnership(address(baseOapp));

        vm.stopBroadcast();
    }
}
