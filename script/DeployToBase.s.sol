pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {Vault} from "../src/Vault.sol";
import {Token} from "../src/Token.sol";

contract DeployToBase is Script {
    function run() external {
        // ===================
        // === SCRIPT VARS ===
        // ===================

        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        string memory BASE_LZ_ENDPOINT = "BASE_SEPOLIA_LZ_ENDPOINT";
        string memory DEPLOYER_PUBLIC_ADDRESS = "DEPLOYER_PUBLIC_ADDRESS";

        // ========================
        // === BASE DEPLOYMENTS ===
        // ========================

        console2.log("#######################################");
        console2.log("########## Deploying to Base ##########");
        console2.log("#######################################");

        vm.createSelectFork("base");

        vm.startBroadcast(deployerPrivateKey);

        // deploy Vault OAPP contract
        Vault baseOapp = new Vault{salt: "xyz"}(vm.envAddress(BASE_LZ_ENDPOINT), vm.envAddress(DEPLOYER_PUBLIC_ADDRESS));
        console2.log("Vault OAPP Address: ", address(baseOapp));

        // transfer ownership to deployer
        // baseOapp.transferOwnership(vm.envAddress(DEPLOYER_PUBLIC_ADDRESS));

        // deploy Reward Token OFT contract
        Token baseOft = new Token{salt: "xyz"}(
            "Reward Token",
            "ReOFT",
            vm.envAddress(BASE_LZ_ENDPOINT),
            address(baseOapp),
            vm.envAddress(DEPLOYER_PUBLIC_ADDRESS)
        );
        console2.log("OFT Reward Token Address: ", address(baseOft));

        // transfer ownership to deployer
        // baseOft.transferOwnership(vm.envAddress(DEPLOYER_PUBLIC_ADDRESS));

        // set the Token address on the Vault Oapp
        baseOapp.setToken(address(baseOft));

        vm.stopBroadcast();
    }
}
