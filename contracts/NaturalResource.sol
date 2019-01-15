pragma solidity 0.4.25;

/**
 * @title NaturalResource
 * A NaturalResource has many needs. In this contract we call these needs 'objectives'
   Each objective has a team that will accomplish it (the resolver) and a minimum level of funds which need to be gathered
 */

import "contracts/zeppelin/ownership/Ownable.sol";
import "contracts/zeppelin/SafeMath.sol";

import "contracts/interfaces/INaturalResource.sol";

contract NaturalResource is INaturalResource, Ownable {

    using SafeMath for uint256;

    struct Objective {

      address resolver;

      //IPFS address to the details of the objective

      string objDetails;

      //Funding data

      uint256 currentFunding;

      uint256 necessaryFunding;

      bool claimed;

    }

    //IPFS hash where all objectives are stored

    string objectivesList;

    //What type of natural resource is this?

    string naturalResourceType;

    /**

    We use this to determine if an objective is already taken because if we check with
    objectiveData, web3 might through an error with uninitialized objectives

    **/

    mapping (string => bool) objectiveTaken;

    mapping (string => Objective) objectiveData;

    modifier onlyObjectiveCreator(string objName) {

      require(msg.sender == objectiveData[objName].resolver, "The sender is not the resolver of the objective");

      _;

    }

    modifier alreadyClaimed(string objName) {

      require(objectiveData[objName].claimed == false, "The objective was already fully funded and claimed");

      _;

    }

    /**
     * @dev The constructor sets the original `trigger` of the contract to the sender
     * account.
     */

    constructor(string resourceName) public {

      naturalResourceType = resourceName;

    }

    /**
     * @dev Propose a new objective for this resource
     * @param updatedIPFSList The new IPFS hash of the list of objectives
     * @param objName The name of the objective
     * @param details The IPFS hash where the details of this objective are stored
     * @param neededFunding How much money this object needs
     */

    function proposeObjective(string updatedIPFSList, string objName,
        string details, uint256 neededFunding) public {

      require(objectiveTaken[objName] == false, "This objective has already been taken");

      objectiveTaken[objName] = true;

      Objective memory newObjective = Objective(msg.sender, details, 0, neededFunding, false);

      objectiveData[objName] = newObjective;

      emit ProposedObjective(objName, details, neededFunding);

    }

    /**
     * @dev Propose a new objective for this resource
     * @param objName The name of the objective to tip
     */

    function tip(string objName) public payable alreadyClaimed(objName) {

      objectiveData[objName].currentFunding = objectiveData[objName].currentFunding.add(msg.value);

      emit Tipped(objName, msg.value);

    }

    /**
     * @dev Claim the money for an objective
     * @param objName The name of the objective to tip
     */

    function claim(string objName) public alreadyClaimed(objName) onlyObjectiveCreator(objName) {

      require(objectiveData[objName].currentFunding >= objectiveData[objName].necessaryFunding,
          "You do not have enough money gathered yet");

      objectiveData[objName].claimed = true;

      msg.sender.transfer(objectiveData[objName].currentFunding);

      emit ClaimedMoney(objName, objectiveData[objName].currentFunding);

    }

    //GETTERS

    function getResourceName() public view returns (string) {

      return naturalResourceType;

    }

    function getObjectiveResolver(string objName) public view returns (address) {

      return objectiveData[objName].resolver;

    }

    function getObjectiveDetails(string objName) public view returns (string) {

      return objectiveData[objName].objDetails;

    }

    function objectiveIsClaimed(string objName) public view returns (bool) {

      return objectiveData[objName].claimed;

    }

    function getObjectiveFundingLevels(string objName) public view returns (uint256, uint256) {

      return (objectiveData[objName].currentFunding, objectiveData[objName].necessaryFunding);

    }

}
