// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract GatekeeperOne {

  address public entrant;

  modifier gateOne() {
    console.log(gasleft());
    require(msg.sender != tx.origin);
    console.log(gasleft());
    _;
  }

  modifier gateTwo() {
    console.log(gasleft());
    require(gasleft() % 8191 == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
      console.logBytes8(_gateKey);
      require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
      require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
      require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}

contract Middle {
    GatekeeperOne gatekeeperOne;
    constructor(address _gatekeeperOne) {
        gatekeeperOne = GatekeeperOne(_gatekeeperOne);
    }

    function enter(bytes8 _gateKey) public returns(bool) {
        bool entered = false;
        do {
            try gatekeeperOne.enter(_gateKey) returns (bool) {
                entered = true;
            }
            catch {}
        } while (!entered);
        return entered;
    }
}

contract Log {
  constructor() {}

  function logging(bytes8 _gateKey) public view {
    console.log(uint32(uint64(_gateKey)));
    console.log(uint16(uint64(_gateKey)));

    console.log(uint32(uint64(_gateKey)));
    console.log(uint64(_gateKey));
    
    console.log(uint32(uint64(_gateKey)));
    console.log(uint160(tx.origin));
    console.log(uint16(uint160(tx.origin)));
    // require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
    // require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
    // require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
  }

}