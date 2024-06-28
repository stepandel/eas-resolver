// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {SchemaRegistry} from "eas-contracts/SchemaRegistry.sol";
import {ProjectAttesterResolver} from "../src/ProjectAttesterResolver.sol";

contract CreateNewEASSchemaScript is Script {
    SchemaRegistry schemaRegistry =
        SchemaRegistry(payable(0x0a7E2Ff54e76B8E6659aedc9103FB21c038050D0));
    ProjectAttesterResolver projectAttesterResolver =
        ProjectAttesterResolver(
            payable(0x2582FDA2Ba366a035e8Ca8b65f6dB360ccf8c5Ab)
        );

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Create new EAS schema
        bytes32 schemaId = schemaRegistry.register(
            "string name, string description",
            projectAttesterResolver,
            true
        );
        vm.stopBroadcast();
    }
}
