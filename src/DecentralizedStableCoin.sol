// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {OFT} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oft/OFT.sol";
import {ILayerZeroComposer} from "@layerzerolabs/lz-evm-protocol-v2/contracts/interfaces/ILayerZeroComposer.sol";

contract DecentralizedStableCoin is OFT, ILayerZeroComposer {
    error DecentralizedStableCoin__AmountMustBeMoreThanZero();
    error DecentralizedStableCoin__BurnAmountExceedsBalance();
    error DecentralizedStableCoin__NotZeroAddress();

    constructor(string memory oftName, string memory oftSymbol, address lzEndpoint, address vault, address _owner)
        OFT(oftName, oftSymbol, lzEndpoint, _owner)
    {
        _transferOwnership(_owner);
    }

    function burn(address _from, uint256 _amount) public onlyOwner {
        uint256 balance = balanceOf(msg.sender);
        if (_amount <= 0) {
            revert DecentralizedStableCoin__AmountMustBeMoreThanZero();
        }
        if (balance < _amount) {
            revert DecentralizedStableCoin__BurnAmountExceedsBalance();
        }
        _burn(_from, _amount);
    }

    function mint(address _to, uint256 _amount) external onlyOwner returns (bool) {
        if (_to == address(0)) {
            revert DecentralizedStableCoin__NotZeroAddress();
        }
        if (_amount <= 0) {
            revert DecentralizedStableCoin__AmountMustBeMoreThanZero();
        }
        _mint(_to, _amount);
        return true;
    }

    function lzCompose(address _oApp, bytes32 _guid, bytes calldata _message, address, bytes calldata)
        external
        payable
        override
    {
        // Decode the payload to get the message
        (uint256 amountDscToMint, address recipient) = abi.decode(_message, (uint256, address));

        // mint tokens to recipient
        _mint(recipient, amountDscToMint);
    }
}
