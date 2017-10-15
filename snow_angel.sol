pragma solidity ^0.4.11;

library Set {
    struct Data { 
        mapping(address => bool) flags;
        uint length;
        address[] list;
    }

    function insert(Data storage self, address value)
        returns (bool)
    {
        if (self.flags[value])
            return false; // already there
        self.flags[value] = true;
        self.length++;
        self.list.push(value);
        return true;
    }
}

contract SnowAngel {

    using Set for Set.Data;
    Set.Data liars;
    Set.Data truthers;

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
    address[] public ownersList;
    
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
        
        ownersList.push(owner);
    }

    function getHouseholdName(address owner) 
        returns (string name)
    {
        name = households[owner].name;
    }

    function getHouseholdScore(address owner) 
        returns (uint score)
    {
        score = households[owner].score;
    }

    function registerSnowfall() {
        require(msg.sender == government);
        expiryTime = now + 72*60*60;
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

    function resolveScore() {
        Household h;
        address owner;
        for (uint i = 0; i < ownersList.length; i++) {
            owner = ownersList[i];
            h = households[owner];
            if (h.cleanedBy.length > 1) {
                liars.insert(owner);
            } else {
                truthers.insert(owner);
            }
        }

        uint numLiars = liars.length;
        uint liarsScore = 100-10*numLiars;

        address[] liarsList; 
        liarsList = liars.list;
        address[] truthersList; 
        truthersList = truthers.list;

        for (i = 0; i < liarsList.length; i++) {
            owner = ownersList[i];
            h = households[owner];
            h.score += liarsScore;
            h.cleanedBy = new address[](0);
            h.hasCleaned = new address[](0);
        }

        uint trutherScore;
        for (i = 0; i < truthersList.length; i++) {
            owner = ownersList[i];
            h = households[owner];
            trutherScore = 100*h.hasCleaned.length + 10;
            h.score += trutherScore;
            h.cleanedBy = new address[](0);
            h.hasCleaned = new address[](0);
        }
    }

 }
