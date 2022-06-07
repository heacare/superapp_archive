//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

// OpenZepplin imports
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Commitment {

  // USDC Contract address
  IERC20 public immutable i_currency;

  struct UserCommitment {
    address healer;
    address referee;
    uint16 healerSplit;
    uint256 totalCheckpoints;

    uint256 currentCheckpoint;
    uint256 deposit;
  }

  mapping(address => UserCommitment) private s_commitments;

  constructor(address _currencyTokenAddr) {
    i_currency = IERC20(_currencyTokenAddr);
  }

  function makeCommitment(
    address _h, 
    address _r, 
    uint16 _healerSplit, 
    uint256 _totalCheckpoints, 
    uint256 _deposit) public {
    // Transfer the currency token to contract
    _safeTransferFrom(i_currency, msg.sender, address(this), _deposit);

    // Init commitment
    UserCommitment memory c;
    c.healer = _h;
    c.referee = _r;
    c.healerSplit = _healerSplit;
    c.totalCheckpoints = _totalCheckpoints;
    c.deposit = _deposit;
    c.currentCheckpoint = 0;

    // Assign commitment to user
    s_commitments[msg.sender] = c;
  }

  function checkClaimableUser(address _u) public view returns(uint256, uint256) {
    UserCommitment memory c = s_commitments[_u];
    uint256 totalClaimable = (c.currentCheckpoint / c.totalCheckpoints) * c.deposit;
    uint256 healerClaim = (c.healerSplit / 100) * totalClaimable;

    return(totalClaimable - healerClaim, healerClaim);
  }

  function getUserCommitment(address _u) public view returns(UserCommitment memory) {
    return s_commitments[_u];
  }

  function _safeTransferFrom(
    IERC20 token, 
    address sender, 
    address reciever, 
    uint256 amount) private {
    bool sent = token.transferFrom(sender, reciever, amount);
    require(sent, "Unable to pay deposit");
  }
}
