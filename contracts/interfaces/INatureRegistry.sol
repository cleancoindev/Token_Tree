pragma solidity 0.4.25;

contract INatureRegistry {

  event AddedManager(address caller, address newManager);

  event AddedArea(address caller, string allAreas, string newArea);

  event AddedResource(string area, string resourceName, string geoPosition);

  event ToggledProtection(address caller, string area, uint256 resource);


  function addManager(address manager) public;

  function addArea(string _allAreas, string newArea) public;

  function addResource(string area, string resourceName, string geoPosition) public;

  function toggleProtection(string area, uint256 resourcePosition) public;


  function getAllAreas() public view returns (string);

  function isManager(address manager) public view returns (bool);

  function isAreaAvailable(string area) public view returns (bool);

  function getResourceFromArea(string area, uint256 resourcePosition)
    public view returns (address, string, bool);

}
