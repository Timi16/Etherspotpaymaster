// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Script.sol";
import "../src/paymaster/EtherspotPaymaster.sol";

contract DeployEtherspotPaymaster is Script {
    function run() external {
        // Load the EntryPoint address for the chain you're deploying to
        // For 0G Network, you'll need to check if they have an EntryPoint deployed
        // or deploy one first. This is a placeholder address.
        address entryPointAddress = vm.envOr("ENTRYPOINT_ADDRESS", address(0x0000000071727De22E5E9d8BAf0edAc6f37da032));
        
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("Deploying EtherspotPaymaster...");
        console.log("Deployer address:", deployer);
        console.log("EntryPoint address:", entryPointAddress);

        vm.startBroadcast(deployerPrivateKey);

        // Deploy EtherspotPaymaster
        EtherspotPaymaster paymaster = new EtherspotPaymaster(
            IEntryPoint(entryPointAddress)
        );

        vm.stopBroadcast();

        console.log("===========================================");
        console.log("EtherspotPaymaster deployed at:", address(paymaster));
        console.log("Owner:", paymaster.owner());
        console.log("EntryPoint:", address(paymaster.entryPoint()));
        console.log("===========================================");
        
        // Save deployment info
        string memory deploymentInfo = string.concat(
            "EtherspotPaymaster: ", vm.toString(address(paymaster)), "\n",
            "EntryPoint: ", vm.toString(entryPointAddress), "\n",
            "Owner: ", vm.toString(deployer), "\n",
            "Chain ID: ", vm.toString(block.chainid), "\n",
            "Block Number: ", vm.toString(block.number)
        );
        
        // vm.writeFile("deployments/latest.txt", deploymentInfo);
        // console.log("\nDeployment info saved to deployments/latest.txt");
    }
}