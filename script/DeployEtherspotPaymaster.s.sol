// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Script.sol";
import "../src/paymaster/EtherspotPaymaster.sol";

contract DeployEtherspotPaymaster is Script {
    function run() external {
        // Load the EntryPoint address for 0G Network
        address entryPointAddress = vm.envOr("ENTRYPOINT_ADDRESS", address(0x58F33cEBF1FF088Cc1c0cD5B440EB2fDf5a60438));
        
        // New owner address
        address newOwner = 0x492deFEA4C0CA5DD819dE868357081B46adC1F04;
        
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("Deploying EtherspotPaymaster...");
        console.log("Deployer address:", deployer);
        console.log("EntryPoint address:", entryPointAddress);
        console.log("New Owner address:", newOwner);

        vm.startBroadcast(deployerPrivateKey);

        // Deploy EtherspotPaymaster
        EtherspotPaymaster paymaster = new EtherspotPaymaster(
            IEntryPoint(entryPointAddress)
        );

        // Transfer ownership to the new owner if different from deployer
        if (deployer != newOwner) {
            console.log("Transferring ownership to:", newOwner);
            paymaster.transferOwnership(newOwner);
        }

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
            "Owner: ", vm.toString(newOwner), "\n",
            "Deployer: ", vm.toString(deployer), "\n",
            "Chain ID: ", vm.toString(block.chainid), "\n",
            "Block Number: ", vm.toString(block.number)
        );
        
        // vm.writeFile("deployments/latest.txt", deploymentInfo);
        // console.log("\nDeployment info saved to deployments/latest.txt");
    }
}