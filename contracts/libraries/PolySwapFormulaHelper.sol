// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

library PolySwapFormulaHelper {
  function divTotalOfSum(
    uint256 a,
    uint256 b,
    uint256 c
  ) internal pure returns (uint256 result) {
    assembly {
      let total := add(b, c)
      result := div(a, total)
    }
  }

  function divPow2OfTotalOfSum(
    uint256 a,
    uint256 b,
    uint256 c
  ) internal pure returns (uint256 result) {
    assembly {
      let total := add(b, c)
      let totalPow2 := mul(total, total)
      result := div(a, totalPow2)
    }
  }

  function divPow3OfTotalOfSum(
    uint256 a,
    uint256 b,
    uint256 c
  ) internal pure returns (uint256 result) {
    assembly {
      let total := add(b, c)
      let totalPow2 := mul(total, total)
      let totalPow3 := mul(totalPow2, total)
      result := div(a, totalPow3)
    }
  }

  function toPrecision(uint256 a, uint256 decimals)
    internal
    pure
    returns (uint256 result)
  {
    uint256 decimal = 10**decimals;
    assembly {
      result := mul(a, decimal)
    }
  }

  function pow2(uint256 a) internal pure returns (uint256 result) {
    assembly {
      result := mul(a, a)
    }
  }

  function mul(uint256 a, uint256 b) internal pure returns (uint256 result) {
    assembly {
      result := mul(a, b)
    }
  }

  function sub(uint256 a, uint256 b)
    internal
    pure
    returns (uint256 result, bool isNegative)
  {
    if (a >= b) {
      isNegative = false;
      result = a - b;
    } else {
      isNegative = true;
      result = b - a;
    }
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256 result) {
    assembly {
      result := add(a, b)
    }
  }

  function mulDiv(
    uint256 a,
    uint256 b,
    uint256 c
  ) internal pure returns (uint256 result) {
    assembly {
      result := mul(a, b)
      result := div(result, c)
    }
  }

  function pow3(uint256 a) internal pure returns (uint256 result) {
    assembly {
      result := mul(a, a)
      result := mul(result, a)
    }
  }

  function subAbs(uint256 a, uint256 b) internal pure returns (uint256 result) {
    if (a >= b) {
      result = a - b;
    } else {
      result = b - a;
    }
  }
}
