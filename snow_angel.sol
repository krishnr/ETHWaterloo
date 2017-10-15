pragma solidity ^0.4.11;

library Set {
  struct Data { mapping(address => bool) flags; }

  function insert(Data storage self, address value)
      returns (bool)
  {
      if (self.flags[value])
        return false; // already there
      self.flags[value] = true;
      return true;
  }

  function remove(Data storage self, address value)
      returns (bool)
  {
      if (!self.flags[value])
          return false; // not there
      self.flags[value] = false;
      return true;
  }

  function contains(Data storage self, address value)
      returns (bool)
  {
      return self.flags[value];
  }
}

contract SnowAngel {

    using Set for Set.Data;
    Set.Data liars;

    // Each household in the community should have a struct associated
    // with it. 
    struct HouseHold { 
        uint score; // running score/points collected by household
        bytes32 name;
        bool isCleaned;
    }
    
    uint public expiryTime;
    address public government; 
  
    mapping(address => Household) public households;
    
    function SnowAngel() {
        government = msg.sender; 
    }  
    
    function registerHousehold(address owner, byte32 name) {
        require(msg.sender == government);
        household = Household({
                        score:0,
                        name:name,
                        isCleaned:false
                        });
        households[owner] = household;
    }

    function getHoushold(address owner) 
        returns (bytes32 name)
    {
        name = households[owner].name;
    }

    function setExpiryTime(uint time) {
        expiryTime = time + 72*60*60;
    }
    
    function getExpiryTime() 
        returns (uint time)
    {
        time = expiryTime;
    }
 }
