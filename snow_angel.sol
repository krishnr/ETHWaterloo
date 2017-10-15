pragma solidity ^0.4.17;

contract SnowAngel {
    
    // Each household in the community should have a struct associated
    // with it. 
    struct HouseHold { 
        uint score; // running score/points collected by household
        byte32 name;
        bool isCleaned;
    }
    
    uint public lastSnowTime;
    address public government; 
  
    mapping(address => Household) public households;
    
    function SnowAngel(){
        government = msg.sender; 
    }  
    
    function registerHousehold(address owner, byte32 name){
        requre(msg.sender == government);
        household = Household({
                        score:0,
                        name:name,
                        isCleaned:false;})
        households[owner] = household;
    }
    
}
