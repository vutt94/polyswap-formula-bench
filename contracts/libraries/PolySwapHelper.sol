// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

library PolySwapHelper {
  function calculateRatio(
    uint256 reserve,
    uint160 initPrice,
    uint160 maxPrice,
    uint256 liquidity
  ) internal pure returns (uint256 ratio) {
    assembly {
      ratio := div(
        div(mul(mul(reserve, initPrice), maxPrice), sub(maxPrice, initPrice)),
        liquidity
      )
    }
  }

  function calculateTokenPrice(
    uint256 liquidity,
    uint160 maxPrice,
    uint256 reserve
  ) internal pure returns (uint160 price) {
    assembly {
      price := div(
        mul(liquidity, maxPrice),
        add(mul(reserve, maxPrice), liquidity)
      )
    }
  }

  function calculateTokenPriceByIndex(
    uint256 liquidity,
    uint160 maxPrice,
    uint256 deltaTokenIndexIn
  ) internal pure returns (uint160 price) {
    assembly {
      price := div(add(mul(liquidity, maxPrice), deltaTokenIndexIn), liquidity)
    }
  }

  function calculateDeltaIndexTokenOut(
    uint256 liquidity,
    uint160 resultPrice,
    uint160 currentPrice
  ) internal pure returns (uint256 deltaIndexTokenOut) {
    assembly {
      deltaIndexTokenOut := mul(liquidity, sub(currentPrice, resultPrice))
    }
  }

  function calculateDeltaIndexTokenIn(
    uint256 deltaIndexTokenOut,
    uint16 fee,
    uint16 bps
  ) internal pure returns (uint256 deltaIndexTokenIn) {
    assembly {
      deltaIndexTokenIn := div(mul(deltaIndexTokenOut, sub(bps, fee)), bps)
    }
  }

  function calculateAmountTokenOut(
    uint256 liquidity,
    uint160 curPrice,
    uint160 resultPrice
  ) internal pure returns (uint256 amountTokenOut) {
    assembly {
      amountTokenOut := sub(
        div(liquidity, curPrice),
        div(liquidity, resultPrice)
      )
    }
  }

  function calculateReserveIndexToken(
    uint256 liquidity,
    uint160 maxPrice,
    uint160 curPrice
  ) internal pure returns (uint256 reserveIndexToken) {
    assembly {
      reserveIndexToken := mul(liquidity, sub(maxPrice, curPrice))
    }
  }
}
