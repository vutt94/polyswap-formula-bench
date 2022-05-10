// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenC is ERC20 {
  constructor() ERC20("TokenC", "TKC") {
    _mint(msg.sender, 1000000000000000 * 10**decimals());
  }
}
