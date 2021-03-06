pragma solidity ^0.4.24;

import 'openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import 'openzeppelin-solidity/contracts/math/SafeMath.sol';
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';
import './Project.sol';
import './ProjectCatalog.sol';

contract DonationWallet is Ownable {
  using SafeMath for uint256;

  ProjectCatalog projectCatalog;

  constructor(ProjectCatalog _projectCatalog) public {
    projectCatalog = _projectCatalog;
  }

  function donate(uint _amount, string _projectName) public onlyOwner {
    address projectAddress = projectCatalog.getProjectAddress(_projectName);
    require(projectAddress != address(0));
    ERC20 token = Project(projectAddress).getToken();

    token.approve(projectAddress, _amount);
    Project(projectAddress).donateFromWallet(_amount);
  }

  function refund(ERC20 _token, uint _amount) public onlyOwner {
    _token.transfer(owner, _amount);
  }

  function balance(ERC20 _token) public view returns(uint256){
    return _token.balanceOf(this);
  }

}