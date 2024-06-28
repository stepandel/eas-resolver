// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {BadgeholderResolver} from "../src/BadgeholderResolver.sol";
import {EAS} from "eas-contracts/EAS.sol";

contract DeployBadgeholderResolverScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        address initialAttester = 0xA18D0226043A76683950f3BAabf0a87Cfb32E1Cb;

        EAS eas = EAS(0xC2679fBD37d54388Ce493F1DB75320D236e1815e);

        // Deploy BadgeholderResolver contract
        BadgeholderResolver badgeholderResolver = new BadgeholderResolver(
            eas,
            initialAttester
        );

        console.log(
            "Deployed BadgeholderResolver at address:",
            address(badgeholderResolver)
        );

        vm.stopBroadcast();
    }
}
