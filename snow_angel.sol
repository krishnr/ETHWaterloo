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
    struct Household { 
        uint score; // running score/points collected by household
        string name;
        address[] hasCleaned;
        address[] cleanedBy;
    }
    
    uint public expiryTime;
    address public government; 
  
    mapping(address => Household) public households;
    
    function SnowAngel() {
        government = msg.sender; 
    }  
    
    function registerHousehold(address owner, string name) {
        require(msg.sender == government);
        households[owner] = Household({
                        score:0,
                        name:name,
                        hasCleaned: new address[](0),
                        cleanedBy: new address[](0)
                        });
    }

    function getHousehold(address owner) 
        returns (string name)
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

    function registerRemoval(address cleaner, address[] hasCleaned) {
        Household cleanerHousehold;
        cleanerHousehold = households[cleaner];
        cleanerHousehold.hasCleaned = hasCleaned;

        Household h;
        for (uint i = 0; i < hasCleaned.length; i++) {  
            h = households[hasCleaned[i]];
            h.cleanedBy.push(cleaner);
        }
    }

 }
