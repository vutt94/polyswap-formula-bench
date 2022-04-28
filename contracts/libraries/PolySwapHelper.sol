// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

library PolySwapHelper {
  function calculateLiquidity(
    uint256 reserve,
    uint160 initPrice,
    uint160 maxPrice
  ) internal pure returns (uint256 liquidity) {
    liquidity = (reserve * initPrice * maxPrice) / (maxPrice - initPrice);
  }

  function calculateTokenPrice(
    uint256 liquidity,
    uint160 maxPrice,
    uint256 reserve
  ) internal pure returns (uint160 price) {
    price = uint160(
      (uint256(liquidity) * maxPrice) / (reserve * maxPrice + liquidity)
    );
  }

  function calculateTokenPriceByIndex(
    uint256 liquidity,
    uint160 maxPrice,
    uint256 deltaTokenIndexIn
  ) internal pure returns (uint160 price) {
    price = uint160(
      (uint256(liquidity) * maxPrice + deltaTokenIndexIn) / liquidity
    );
  }

  function calculateDeltaIndexTokenOut(
    uint256 liquidity,
    uint160 resultPrice,
    uint160 currentPrice,
    uint16 fee,
    uint16 bps
  ) internal pure returns (uint256 deltaIndexTokenOut) {
    deltaIndexTokenOut =
      (liquidity * (currentPrice - resultPrice) * (bps - fee)) /
      bps;
  }
}
