// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {BadgeholderResolver} from "../src/BadgeholderResolver.sol";
import {SchemaRegistry} from "eas-contracts/SchemaRegistry.sol";
import {EAS} from "eas-contracts/EAS.sol";
import {AttestationRequestData, AttestationRequest, RevocationRequest, RevocationRequestData} from "eas-contracts/IEAS.sol";
import {Utils} from "test/utils/Utils.sol";

contract BadgeholderResolverTest is Test {
    error InvalidAttester();

    event Attested(
        address indexed recipient,
        uint64 expirationTime,
        bytes32 refUID,
        address attester,
        bool revocable,
        bytes data
    );

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    SchemaRegistry public schemaRegistry;
    EAS public eas;
    BadgeholderResolver public badgeholderResolver;

    bytes32 private _testSchemaUID;

    function setUp() public {
        schemaRegistry = new SchemaRegistry();
        eas = new EAS(schemaRegistry);
        badgeholderResolver = new BadgeholderResolver(eas, address(this));

        _testSchemaUID = schemaRegistry.register(
            "string name, string description",
            badgeholderResolver,
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

        emit Transfer(address(0), address(Utils.alice), 0);

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

    function test_Revoke() public {
        bytes32 uid = eas.attest(
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

        vm.expectEmit();

        emit Transfer(address(Utils.alice), address(0), 0);

        eas.revoke(
            RevocationRequest({
                schema: _testSchemaUID,
                data: RevocationRequestData({uid: uid, value: 0})
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
