// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import "forge-std/Test.sol";
import {console2} from "forge-std/Test.sol";
import {OptionsBuilder} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/libs/OptionsBuilder.sol";

contract StableEngineTest is Test {
    using OptionsBuilder for bytes;

    function setUp() external {}

    // lZ Compose: A - B1 - B2
    function test_Build_LzCompose_Options() public pure {
        bytes memory options =
            OptionsBuilder.newOptions().addExecutorLzReceiveOption(700000, 0).addExecutorLzComposeOption(0, 700000, 0);
        console2.log("Lz Compose Message Options: ", vm.toString(options));
    }

    function test_Build_LzReceive_Options() public pure {
        bytes memory options = OptionsBuilder.newOptions().addExecutorLzReceiveOption(200000, 0);
        console2.log("Lz Receive Message Options: ", vm.toString(options));
    }
}
