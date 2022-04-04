pragma solidity 0.8.9;

import { FullMath } from "./libraries/FullMath.sol";
import "hardhat/console.sol";

contract PolySwapFormula {
  function standardFormulaNewton(
    uint256[2][] calldata parameters,
    uint256 k,
    uint256 initialX
  ) external view returns (uint256[] memory results) {
    results = new uint256[](100);
    uint256 nextX = FullMath.toPrecision(initialX, 18);
    uint256 curX;
    uint256 count = 0;
    do {
      curX = nextX;
      (uint256 fx, bool isFxNegative) = f(parameters, k, curX, 36, 18);

      if (isFxNegative) {
        break;
      }

      uint256 dFx = derivativeF(parameters, curX, 54, 18);

      nextX = curX + FullMath.toPrecision(fx, 18) / dFx;

      results[count] = nextX;
      count++;
    } while (curX != nextX);
  }

  function standardFormulaHalley(
    uint256[2][] calldata parameters,
    uint256 k,
    uint256 initialX
  ) external view returns (uint256[] memory results) {
    results = new uint256[](100);
    uint256 nextX = FullMath.toPrecision(initialX, 18);
    uint256 curX;
    uint256 count = 0;
    do {
      curX = nextX;
      (uint256 fx, bool isFxNegative) = f(parameters, k, curX, 36, 18);
      uint256 derivativeFx = derivativeF(parameters, curX, 55, 18);
      uint256 doubleDerivativeFx = doubleDerivativeF(parameters, curX, 74, 18);

      uint256 upperPart = 2 * fx * derivativeFx;
      uint256 lowerPart;
      bool lowerPartNegative;

      if (isFxNegative) {
        if (fx * doubleDerivativeFx >= 2 * FullMath.pow2(derivativeFx)) {
          lowerPartNegative = false;
        } else {
          lowerPartNegative = true;
        }

        lowerPart = FullMath.subAbs(
          fx * doubleDerivativeFx,
          2 * FullMath.pow2(derivativeFx)
        );
      } else {
        if (2 * FullMath.pow2(derivativeFx) >= fx * doubleDerivativeFx) {
          lowerPartNegative = false;
        } else {
          lowerPartNegative = true;
        }

        lowerPart = FullMath.subAbs(
          2 * FullMath.pow2(derivativeFx),
          fx * doubleDerivativeFx
        );
      }

      if (lowerPartNegative) {
        nextX = curX - FullMath.toPrecision(upperPart, 19) / lowerPart;
      } else {
        nextX = curX + FullMath.toPrecision(upperPart, 19) / lowerPart;
      }

      results[count] = nextX;
      count++;
    } while (curX != nextX);
  }

  function appFormulaNewton(uint256[2][] calldata parameters, uint256 initialX)
    external
    view
    returns (uint256[] memory results)
  {
    results = new uint256[](100);
    uint256 nextX = FullMath.toPrecision(initialX, 18);
    uint256 curX;
    uint256 count = 0;
    do {
      curX = nextX;
      (uint256 f, bool isFNegative) = appF(parameters, curX, 36, 18);
      uint256 dF = appDerivativeF(parameters, curX, 55, 18);

      if (isFNegative) {
        unchecked {
          nextX = curX - FullMath.toPrecision(f, 19) / dF;
        }
      } else {
        nextX = curX + FullMath.toPrecision(f, 19) / dF;
      }

      results[count] = nextX;
      count++;
    } while (curX != nextX);
  }

  function appFormulaHalley(uint256[2][] calldata parameters, uint256 initialX)
    external
    view
    returns (uint256[] memory results)
  {
    results = new uint256[](100);
    uint256 nextX = FullMath.toPrecision(initialX, 18);
    uint256 curX;
    uint256 count = 0;
    do {
      curX = nextX;
      (uint256 fx, bool isFxNegative) = appF(parameters, curX, 36, 18);
      uint256 derivativeFx = appDerivativeF(parameters, curX, 55, 18);
      uint256 doubleDerivativeFx = appDoubleDerivativeF(
        parameters,
        curX,
        74,
        18
      );

      uint256 upperPart = 2 * fx * derivativeFx;
      uint256 lowerPart;
      bool lowerPartNegative;

      if (isFxNegative) {
        if (fx * doubleDerivativeFx >= 2 * FullMath.pow2(derivativeFx)) {
          lowerPartNegative = false;
        } else {
          lowerPartNegative = true;
        }

        lowerPart = FullMath.subAbs(
          fx * doubleDerivativeFx,
          2 * FullMath.pow2(derivativeFx)
        );
      } else {
        if (2 * FullMath.pow2(derivativeFx) >= fx * doubleDerivativeFx) {
          lowerPartNegative = false;
        } else {
          lowerPartNegative = true;
        }

        lowerPart = FullMath.subAbs(
          2 * FullMath.pow2(derivativeFx),
          fx * doubleDerivativeFx
        );
      }

      if (lowerPartNegative) {
        nextX = curX - FullMath.toPrecision(upperPart, 19) / lowerPart;
      } else {
        nextX = curX + FullMath.toPrecision(upperPart, 19) / lowerPart;
      }

      results[count] = nextX;
      count++;
    } while (curX != nextX);
  }

  function f(
    uint256[2][] calldata parameters,
    uint256 k,
    uint256 x,
    uint256 decimals1,
    uint256 decimals2
  ) public view returns (uint256 result, bool isNegative) {
    uint256 length = parameters.length;

    for (uint256 i = 0; i < length; i++) {
      result += FullMath.divTotalOfSum(
        FullMath.toPrecision(parameters[i][0], decimals1),
        FullMath.toPrecision(parameters[i][1], decimals2),
        x
      );
    }

    if (result >= FullMath.toPrecision(k, decimals2 - 1)) {
      isNegative = false;
    } else {
      isNegative = true;
    }

    result = FullMath.subAbs(result, FullMath.toPrecision(k, decimals2 - 1));
  }

  function derivativeF(
    uint256[2][] calldata parameters,
    uint256 x,
    uint256 decimals1,
    uint256 decimals2
  ) public pure returns (uint256 result) {
    uint256 length = parameters.length;

    for (uint256 i = 0; i < length; i++) {
      result += FullMath.divPow2OfTotalOfSum(
        FullMath.toPrecision(parameters[i][0], decimals1),
        FullMath.toPrecision(parameters[i][1], decimals2),
        x
      );
    }
  }

  function doubleDerivativeF(
    uint256[2][] calldata parameters,
    uint256 x,
    uint256 decimals1,
    uint256 decimals2
  ) public pure returns (uint256 result) {
    uint256 length = parameters.length;

    for (uint256 i = 0; i < length; i++) {
      result += FullMath.divPow3OfTotalOfSum(
        FullMath.toPrecision(parameters[i][0], decimals1),
        FullMath.toPrecision(parameters[i][1], decimals2),
        x
      );
    }

    result = result * 2;
  }

  function appF(
    uint256[2][] calldata parameters,
    uint256 x,
    uint256 decimals1,
    uint256 decimals2
  ) public view returns (uint256 result, bool isNegative) {
    for (uint256 i = 1; i < parameters.length; i++) {
      result += FullMath.mulDiv(
        FullMath.toPrecision(parameters[i][0], decimals1),
        parameters[0][1] - parameters[i][1],
        FullMath.add(FullMath.toPrecision(parameters[i][1], decimals2), x)
      );
      result += FullMath.toPrecision(parameters[i][0], decimals2);
    }

    if (
      result + FullMath.toPrecision(parameters[0][0], decimals2) >=
      x + FullMath.toPrecision(parameters[0][1], decimals2)
    ) {
      isNegative = false;
    } else {
      isNegative = true;
    }

    result = FullMath.subAbs(
      result + FullMath.toPrecision(parameters[0][0], decimals2),
      x + FullMath.toPrecision(parameters[0][1], decimals2)
    );
  }

  function appDerivativeF(
    uint256[2][] calldata parameters,
    uint256 x,
    uint256 decimals1,
    uint256 decimals2
  ) public pure returns (uint256 result) {
    for (uint256 i = 1; i < parameters.length; i++) {
      result += FullMath.mulDiv(
        FullMath.toPrecision(parameters[i][0], decimals1),
        parameters[0][1] - parameters[i][1],
        FullMath.pow2(
          FullMath.add(FullMath.toPrecision(parameters[i][1], decimals2), x)
        )
      );
    }
    result += FullMath.toPrecision(1, decimals2 + 1);
  }

  function appDoubleDerivativeF(
    uint256[2][] calldata parameters,
    uint256 x,
    uint256 decimals1,
    uint256 decimals2
  ) public pure returns (uint256 result) {
    for (uint256 i = 1; i < parameters.length; i++) {
      result += FullMath.mulDiv(
        2 * FullMath.toPrecision(parameters[i][0], decimals1),
        parameters[0][1] - parameters[i][1],
        FullMath.pow3(
          FullMath.add(FullMath.toPrecision(parameters[i][1], decimals2), x)
        )
      );
    }
  }
}
