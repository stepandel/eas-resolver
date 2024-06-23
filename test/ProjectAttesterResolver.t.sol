// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ProjectAttesterResolver} from "../src/ProjectAttesterResolver.sol";
import {SchemaRegistry} from "eas-contracts/SchemaRegistry.sol";
import {EAS} from "eas-contracts/EAS.sol";
import {AttestationRequestData, AttestationRequest} from "eas-contracts/IEAS.sol";
import {Utils} from "test/utils/Utils.sol";

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
            "string name, string description",
            projectAttesterResolver,
            true
        );
    }

    function test_Attest() public {
        vm.expectEmit();
        emit Attested(
            address(Utils.alice),
            0,
            0x0,
            address(this),
            true,
            abi.encodeWithSignature(
                "string name, string description",
                "Test",
                "Test"
            )
        );

        eas.attest(
            AttestationRequest({
                schema: _testSchemaUID,
                data: AttestationRequestData({
                    recipient: address(Utils.alice),
                    expirationTime: 0,
                    refUID: 0x0,
                    revocable: true,
                    data: abi.encodeWithSignature(
                        "string name, string description",
                        "Test",
                        "Test"
                    ),
                    value: 0
                })
            })
        );
    }

    function test_InvalidAttester() public {
        vm.expectRevert(InvalidAttester.selector);

        vm.prank(address(Utils.alice));
        eas.attest(
            AttestationRequest({
                schema: _testSchemaUID,
                data: AttestationRequestData({
                    recipient: address(Utils.alice),
                    expirationTime: 0,
                    refUID: 0x0,
                    revocable: true,
                    data: abi.encodeWithSignature(
                        "string name, string description",
                        "Test",
                        "Test"
                    ),
                    value: 0
                })
            })
        );
    }
}
