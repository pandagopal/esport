pragma solidity ^0.4.18;

contract DTTAgreement {
// @dev Structure of a team member
    struct TeamMember {
        uint256 paySlab; // weekly, biweekly , monthly 
        address memberWallet;
        string name;
        string email;
    }

// @dev Structure of a Team Owner , note Teamowner has collection of team members
    struct TeamOwner {
        address wallet;
        mapping (uint256 => TeamMember) teamMembers; 
    }
    
    mapping (uint256 => TeamOwner) public teamOwners;

    event TeamOwnerCreated(uint256 indexed teamId , address indexed teamOwnderWallet );
    event TeamMemberAdded(uint256 indexed teamId , address indexed memberOwnderWallet );

// @dev This method is to create a team
    function createTeam(uint256 _teamID, address _teamOwnerWallet) public {
        TeamOwner storage to = teamOwners[_teamID];
        to.wallet = _teamOwnerWallet;
        TeamOwnerCreated(_teamID,_teamOwnerWallet);
    }
// @dev This method will add member to exisitng TeamOwner,
	function addMember(uint256 _teamID,uint256 _paySlab,address _memberWallet,string _name, string _email,uint256 memberId ) public {
        TeamOwner storage c = teamOwners[_teamID];
        if (c.wallet != 0) { 
            c.teamMembers[memberId] = TeamMember({paySlab:_paySlab,memberWallet:_memberWallet,name:_name,email:_email});
        }
        TeamMemberAdded(_teamID,_memberWallet);
       
    }
// @Dev This method will give us the contract which was signed by both the parties.
	function getAgreement(uint256 _teamId, uint256 _memberId) public returns (uint256,uint256,address,string,string) {
        TeamOwner storage c = teamOwners[_teamId];
	    TeamMember storage team = c.teamMembers[_memberId];
        return (_teamId,team.paySlab,team.memberWallet,team.name,team.email); 
	}
	
    function payteam(address _teamid, address _memberId , uint256 _amount ); 
    //Todo : make payment based on Address using multisig
    //Payment from GAS account
    //Charge for AutoProloange
}