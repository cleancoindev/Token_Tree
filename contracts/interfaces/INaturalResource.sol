pragma solidity 0.4.25;

contract INaturalResource {

  event ProposedObjective(string objName, string details, uint256 neededFunding);

  event Tipped(string objName, uint256 money);

  event ClaimedMoney(string objName, uint256 money);


  function proposeObjective(string updatedIPFSList, string objName,
      string details, uint256 neededFunding);

  function tip(string objName) public payable;

  function claim(string objName) public;


  function getResourceName() public view returns (string);

  function getObjectiveResolver(string objName) public view returns (address);

  function getObjectiveDetails(string objName) public view returns (string);

  function objectiveIsClaimed(string objName) public view returns (bool);

  function getObjectiveFundingLevels(string objName) public view returns (uint256, uint256);

}
