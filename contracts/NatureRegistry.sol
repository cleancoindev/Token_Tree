pragma solidity 0.4.25;

/**
 * @title NatureRegistry
 * A registry with natural resources in particular geographical areas
 */

import "contracts/NaturalResource.sol";
import "contracts/interfaces/INatureRegistry.sol";

contract NatureRegistry is INatureRegistry {

  struct Resource {

    address resourceContract;

    string resourceGeoPosition;

    //Used to denote if a resource is still unharmed or if it was destroyed

    bool protected;

  }

  //IPFS hash where all areas data is stored

  string allAreas;

  mapping(address => bool) managers;

  mapping(string => bool) availableAreas;

  mapping(string => Resource[]) areas;

  modifier onlyManager() {

    require(managers[msg.sender] == true, "The caller is not a manager");

    _;

  }

  constructor() public {

    managers[msg.sender] = true;

  }

  function addManager(address manager) public onlyManager {

    require(managers[manager] == false, "This address is already a manager");

    managers[manager] = true;

    emit AddedManager(msg.sender, manager);

  }

  function addArea(string _allAreas, string newArea) public onlyManager {

    allAreas = _allAreas;

    availableAreas[newArea] = true;

    emit AddedArea(msg.sender, _allAreas, newArea);

  }

  function addResource(string area, string resourceName, string geoPosition) public onlyManager {

    require(availableAreas[area] == true, "This area is not registered");

    address _resource = new NaturalResource(resourceName);

    Resource memory newResource = Resource(_resource, geoPosition, true);

    areas[area].push(newResource);

    emit AddedResource(area, resourceName, geoPosition);

  }

  function toggleProtection(string area, uint256 resourcePosition) public onlyManager {

    require(availableAreas[area] == true, "This area is not registered");
    require(areas[area].length > resourcePosition, "The resource position is not within bounds");

    areas[area][resourcePosition].protected = !areas[area][resourcePosition].protected;

    emit ToggledProtection(msg.sender, area, resourcePosition);

  }

  //GETTERS

  function getAllAreas() public view returns (string) {

    return allAreas;

  }

  function isManager(address manager) public view returns (bool) {

    return managers[manager];

  }

  function isAreaAvailable(string area) public view returns (bool) {

    return availableAreas[area];

  }

  function getResourceFromArea(string area, uint256 resourcePosition)
    public view returns (address, string, bool) {

    require(resourcePosition < areas[area].length, "You did not call with a permitted position");

    return (
            areas[area][resourcePosition].resourceContract,
            areas[area][resourcePosition].resourceGeoPosition,
            areas[area][resourcePosition].protected
           );

  }

}
