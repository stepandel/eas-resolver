// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import {SchemaResolver} from "eas-contracts/resolver/SchemaResolver.sol";
import {IEAS, Attestation} from "eas-contracts/IEAS.sol";
import {ERC721EASWrapper} from "./ERC721EASWrapper.sol";

contract BadgeholderResolver is SchemaResolver, ERC721EASWrapper {
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

    constructor(
        IEAS eas,
        address initialAttester
    ) ERC721EASWrapper() SchemaResolver(eas) {
        attester = initialAttester;
    }

    function onAttest(
        Attestation calldata attestation,
        uint256 /*value*/
    ) internal override returns (bool) {
        if (attestation.attester != attester) {
            revert InvalidAttester();
        }

        _safeMint(attestation.recipient, uint256(attestation.refUID));

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
