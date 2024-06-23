// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ProjectAttesterResolver} from "../src/ProjectAttesterResolver.sol";
import {SchemaRegistry} from "eas-contracts/SchemaRegistry.sol";
import {EAS, Attestation} from "eas-contracts/EAS.sol";

// EASRegistry

// EAS

contract ProjectAttesterResolverTest is Test {
    error InvalidAttester();

    event Attested(
        address indexed recipient,
        uint64 expirationTime,
        bytes32 refUID,
        address attester,
        bool revocable,
        bytes data
    );

    SchemaRegistry public schemaRegistry;
    EAS public eas;
    ProjectAttesterResolver public projectAttesterResolver;

    bytes32 private _testSchemaUID;

    function setUp() public {
        schemaRegistry = new SchemaRegistry();
        eas = new EAS(schemaRegistry);
        projectAttesterResolver = new ProjectAttesterResolver(
            eas,
            address(this)
        );

        _testSchemaUID = schemaRegistry.register(
            "test",
            projectAttesterResolver,
            true
        );
    }

    function test_Attest() public {
        Attestation memory attestation = Attestation({
            recipient: address(Utils.alice),
            expirationTime: 0,
            refUID: 0x0,
            attester: address(this),
            revocable: true,
            data: ""
        });

        projectAttesterResolver.attest(attestation);

        vm.expectEmit();

        emit Attested(
            attestation.recipient,
            attestation.expirationTime,
            attestation.refUID,
            attestation.attester,
            attestation.revocable,
            attestation.data
        );
    }
}
