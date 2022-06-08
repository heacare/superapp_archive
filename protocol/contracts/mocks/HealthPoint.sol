// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract HealthPoint is ERC20 {
  constructor() ERC20("Health Point", "HP") {
    _mint(msg.sender, 1e10);
  }
}
