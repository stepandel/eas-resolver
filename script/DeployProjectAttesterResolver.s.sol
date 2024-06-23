// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {ProjectAttesterResolver} from "../src/ProjectAttesterResolver.sol";
import {EAS} from "eas-contracts/EAS.sol";

contract DeployProjectAttesterResolverScript is Script {
    function run() external {
        vm.startBroadcast();

        EAS eas = EAS(0xC2679fBD37d54388Ce493F1DB75320D236e1815e);
        address initialAttester = 0xA18D0226043A76683950f3BAabf0a87Cfb32E1Cb;

        ProjectAttesterResolver projectAttesterResolver = new ProjectAttesterResolver(
                eas,
                initialAttester
            );

        vm.stopBroadcast();
    }
}
