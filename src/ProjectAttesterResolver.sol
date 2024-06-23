// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {SchemaResolver} from "eas-contracts/resolver/SchemaResolver.sol";
import {IEAS, Attestation} from "eas-contracts/IEAS.sol";

contract ProjectAttesterResolver is SchemaResolver {
    error InvalidAttester();

    event Attested(
        address indexed recipient,
        uint64 expirationTime,
        bytes32 refUID,
        address attester,
        bool revocable,
        bytes data
    );

    address public attester;

    constructor(IEAS eas, address initialAttester) {
        attester = initialAttester;
    }

    function onAttest(
        Attestation calldata attestation,
        uint256 /*value*/
    ) internal view override returns (bool) {
        if (attestation.attester != attester) {
            revert InvalidAttester();
        }

        emit Attested(
            attestation.recipient,
            attestation.expirationTime,
            attestation.refUID,
            attestation.attester,
            attestation.revocable,
            attestation.data
        );

        return true;
    }

    function onRevoke(
        Attestation calldata /*attestation*/,
        uint256 /*value*/
    ) internal pure override returns (bool) {
        return true;
    }
}
