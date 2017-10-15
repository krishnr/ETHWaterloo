pragma solidity ^0.4.11;

contract SnowAngel {

    address[] public liars;
    address[] public truthers;

    // Each household in the community should have a struct associated
    // with it. 
    struct Household { 
        uint score; // running score/points collected by household
        string name;
        address[] hasCleaned;
        address[] cleanedBy;
        bool hasLied;
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
                        cleanedBy: new address[](0),
                        hasLied: false
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
                for (uint j = 0; j < h.cleanedBy.length; j++) {
                    if (!households[h.cleanedBy[j].hasLied){
                        liars.push(h.cleanedBy[j]);
                        households[h.cleanedBy[j]].hasLied = true;
                    }
                }
            }
        }

        uint liarsScore = 100-(10*liars.length);

        for (i = 0; i < liars.length; i++) {
            owner = ownersList[i];
            h = households[owner];
            h.score += liarsScore;
            delete h.cleanedBy;
            delete h.hasCleaned;
        }
        
        uint trutherScore;
        for (i = 0; i < ownersList.length; i++) {
            owner = ownersList[i];
            if (!households[owner].hasLied) {
                h = households[owner];
                trutherScore = 100*h.hasCleaned.length + 10;
                h.score += trutherScore;
                delete h.cleanedBy;
                delete h.hasCleaned;
            }
            households[owner].hasLied = false;
        }
    }

 }
