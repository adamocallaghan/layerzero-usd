// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {OFT} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oft/OFT.sol";
import {ILayerZeroComposer} from "@layerzerolabs/lz-evm-protocol-v2/contracts/interfaces/ILayerZeroComposer.sol";

contract Token is OFT, ILayerZeroComposer {
    address public vault;

    event Mint(address recipient, uint256 amount);

    constructor(string memory oftName, string memory oftSymbol, address lzEndpoint, address vault, address _owner)
        OFT(oftName, oftSymbol, lzEndpoint, _owner)
    {
        _transferOwnership(_owner);
    }

    function lzCompose(address _oApp, bytes32 _guid, bytes calldata _message, address, bytes calldata)
        external
        payable
        override
    {
        // Decode the payload to get the message
        (uint256 amount, address recipient, uint8 choice) = abi.decode(_message, (uint256, address, uint8));

        // mint tokens to recipient
        _mint(recipient, amount);
    }

    function mint(address _recipient, uint256 _amount) external {
        _mint(_recipient, _amount);
        emit Mint(_recipient, _amount);
    }

    function setVault(address _vault) external onlyOwner {
        vault = _vault;
    }
}
