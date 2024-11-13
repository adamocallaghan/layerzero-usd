pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {Vault} from "../src/Vault.sol";
import {Token} from "../src/Token.sol";

contract DeployToArbitrum is Script {
    function run() external {
        // ===================
        // === SCRIPT VARS ===
        // ===================

        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        string memory ARBITRUM_LZ_ENDPOINT = "ARBITRUM_SEPOLIA_LZ_ENDPOINT";
        string memory DEPLOYER_PUBLIC_ADDRESS = "DEPLOYER_PUBLIC_ADDRESS";

        // ============================
        // === ARBITRUM DEPLOYMENTS ===
        // ============================

        console2.log("###########################################");
        console2.log("########## Deploying to Arbitrum ##########");
        console2.log("###########################################");

        vm.createSelectFork("arbitrum");

        vm.startBroadcast(deployerPrivateKey);

        // deploy Vault OAPP contract
        Vault arbOapp =
            new Vault{salt: "xyz"}(vm.envAddress(ARBITRUM_LZ_ENDPOINT), vm.envAddress(DEPLOYER_PUBLIC_ADDRESS));
        console2.log("Vault OAPP Address: ", address(arbOapp));

        // deploy Reward Token OFT contract
        Token arbOft = new Token{salt: "xyz"}(
            "Reward Token",
            "ReOFT",
            vm.envAddress(ARBITRUM_LZ_ENDPOINT),
            address(arbOapp),
            vm.envAddress(DEPLOYER_PUBLIC_ADDRESS)
        );
        console2.log("OFT Reward Token Address: ", address(arbOft));

        // set the Token address on the Vault Oapp
        arbOapp.setToken(address(arbOft));

        vm.stopBroadcast();
    }
}
