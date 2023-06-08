// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MagicNum {

  address public solver;

  constructor() {}

  function setSolver(address _solver) public {
    solver = _solver;
  }

  /*
    ____________/\\\_______/\\\\\\\\\_____        
     __________/\\\\\_____/\\\///////\\\___       
      ________/\\\/\\\____\///______\//\\\__      
       ______/\\\/\/\\\______________/\\\/___     
        ____/\\\/__\/\\\___________/\\\//_____    
         __/\\\\\\\\\\\\\\\\_____/\\\//________   
          _\///////////\\\//____/\\\/___________  
           ___________\/\\\_____/\\\\\\\\\\\\\\\_ 
            ___________\///_____\///////////////__
  */
}

contract SolverFactory {
    event Deploy(address indexed solver)
    
    function deploy() {
        bytes memory bytecode = hex"69602A60805260206080F3600052600A6016F3";
        address solver;
        // bytecode contains length of bytecode so offset by 32 bytes with add()
        // length of bytecode is 38chars/2 = 19 bytes, 19 bytes in hex is 0x13
        assembly {
            solver := create(0, add(bytecode, 0x20), 0x13)
        }
        require(solver != address(0), "Deployment failed");
        emit Deploy(solver);
    }
}

interface IContract {
    function getMeaningOfLife() external view returns (uint256);
}