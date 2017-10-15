pragma solidity ^0.4.11;

contract SnowAngel {

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
    
    uint public householdsReported; 
    bool public isResolved;
    
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
        isResolved = false;
    }
    
    function getExpiryTime() 
        returns (uint time)
    {
        time = expiryTime;
    }

    function getisResolved() 
        returns (bool isresolve)
    {
        isresolve = isResolved;
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
        householdsReported++;
    }
    
    function resolveScore() {
        require(householdsReported == ownersList.length);

        Household h;
        address owner;
        uint numLiars = 0;

        for (uint i = 0; i < ownersList.length; i++) {
            owner = ownersList[i];
            h = households[owner];
            if (h.cleanedBy.length > 1) {
                for (uint j = 0; j < h.cleanedBy.length; j++) {
                    if (!households[h.cleanedBy[j]].hasLied) {
                        households[h.cleanedBy[j]].hasLied = true;
                        numLiars++;
                    }
                }
            }
        }

        uint liarsScore = 100-(10*numLiars);
        uint trutherScore;

        for (i = 0; i < ownersList.length; i++) {
            owner = ownersList[i];
            h = households[owner];
            if (households[owner].hasLied) {
                h.score += liarsScore;
            } else {
                trutherScore = 100*h.hasCleaned.length + 10;
                h.score += trutherScore;
            }
            delete h.cleanedBy;
            delete h.hasCleaned;
            households[owner].hasLied = false;
        }
        isResolved = true;
    }
    
 }
