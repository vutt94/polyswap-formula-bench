pragma solidity 0.8.9;

import { PolySwapFormulaHelper } from "./libraries/PolySwapFormulaHelper.sol";
import "hardhat/console.sol";

contract PolySwapFormula {
  uint256 public standardNewtonResult;
  uint256 public standardHalleyResult;
  uint256 public appNewtonResult;
  uint256 public appHalleyResult;

  function standardFormulaNewton(
    uint256[2][] calldata parameters,
    uint256 k,
    uint256 initialX
  ) external {
    uint256 nextX = PolySwapFormulaHelper.toPrecision(initialX, 18);
    uint256 curX;
    do {
      curX = nextX;
      (uint256 fx, bool isFxNegative) = f(parameters, k, curX, 36, 18);

      if (isFxNegative) {
        break;
      }

      uint256 dFx = derivativeF(parameters, curX, 54, 18);

      nextX = curX + PolySwapFormulaHelper.toPrecision(fx, 18) / dFx;
    } while (curX != nextX);

    standardNewtonResult = nextX;
  }

  function standardFormulaHalley(
    uint256[2][] calldata parameters,
    uint256 k,
    uint256 initialX
  ) external {
    uint256 nextX = PolySwapFormulaHelper.toPrecision(initialX, 18);
    uint256 curX;
    do {
      curX = nextX;
      (uint256 fx, bool isFxNegative) = f(parameters, k, curX, 36, 18);
      uint256 derivativeFx = derivativeF(parameters, curX, 55, 18);
      uint256 doubleDerivativeFx = doubleDerivativeF(parameters, curX, 74, 18);

      uint256 upperPart = 2 * fx * derivativeFx;
      uint256 lowerPart;
      bool lowerPartNegative;

      if (isFxNegative) {
        if (
          fx * doubleDerivativeFx >=
          2 * PolySwapFormulaHelper.pow2(derivativeFx)
        ) {
          lowerPartNegative = false;
        } else {
          lowerPartNegative = true;
        }

        lowerPart = PolySwapFormulaHelper.subAbs(
          fx * doubleDerivativeFx,
          2 * PolySwapFormulaHelper.pow2(derivativeFx)
        );
      } else {
        if (
          2 * PolySwapFormulaHelper.pow2(derivativeFx) >=
          fx * doubleDerivativeFx
        ) {
          lowerPartNegative = false;
        } else {
          lowerPartNegative = true;
        }

        lowerPart = PolySwapFormulaHelper.subAbs(
          2 * PolySwapFormulaHelper.pow2(derivativeFx),
          fx * doubleDerivativeFx
        );
      }

      if (lowerPartNegative) {
        nextX =
          curX -
          PolySwapFormulaHelper.toPrecision(upperPart, 19) /
          lowerPart;
      } else {
        nextX =
          curX +
          PolySwapFormulaHelper.toPrecision(upperPart, 19) /
          lowerPart;
      }
    } while (curX != nextX);

    standardHalleyResult = nextX;
  }

  function appFormulaNewton(uint256[2][] calldata parameters, uint256 initialX)
    external
  {
    uint256 nextX = PolySwapFormulaHelper.toPrecision(initialX, 18);
    uint256 curX;
    do {
      curX = nextX;
      (uint256 f, bool isFNegative) = appF(parameters, curX, 36, 18);
      uint256 dF = appDerivativeF(parameters, curX, 55, 18);

      if (isFNegative) {
        unchecked {
          nextX = curX - PolySwapFormulaHelper.toPrecision(f, 19) / dF;
        }
      } else {
        nextX = curX + PolySwapFormulaHelper.toPrecision(f, 19) / dF;
      }
    } while (curX != nextX);

    appNewtonResult = nextX;
  }

  function appFormulaHalley(uint256[2][] calldata parameters, uint256 initialX)
    external
  {
    uint256 nextX = PolySwapFormulaHelper.toPrecision(initialX, 18);
    uint256 curX;
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
        if (
          fx * doubleDerivativeFx >=
          2 * PolySwapFormulaHelper.pow2(derivativeFx)
        ) {
          lowerPartNegative = false;
        } else {
          lowerPartNegative = true;
        }

        lowerPart = PolySwapFormulaHelper.subAbs(
          fx * doubleDerivativeFx,
          2 * PolySwapFormulaHelper.pow2(derivativeFx)
        );
      } else {
        if (
          2 * PolySwapFormulaHelper.pow2(derivativeFx) >=
          fx * doubleDerivativeFx
        ) {
          lowerPartNegative = false;
        } else {
          lowerPartNegative = true;
        }

        lowerPart = PolySwapFormulaHelper.subAbs(
          2 * PolySwapFormulaHelper.pow2(derivativeFx),
          fx * doubleDerivativeFx
        );
      }

      if (lowerPartNegative) {
        nextX =
          curX -
          PolySwapFormulaHelper.toPrecision(upperPart, 19) /
          lowerPart;
      } else {
        nextX =
          curX +
          PolySwapFormulaHelper.toPrecision(upperPart, 19) /
          lowerPart;
      }
    } while (curX != nextX);

    appHalleyResult = nextX;
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
      result += PolySwapFormulaHelper.divTotalOfSum(
        PolySwapFormulaHelper.toPrecision(parameters[i][0], decimals1),
        PolySwapFormulaHelper.toPrecision(parameters[i][1], decimals2),
        x
      );
    }

    if (result >= PolySwapFormulaHelper.toPrecision(k, decimals2 - 1)) {
      isNegative = false;
    } else {
      isNegative = true;
    }

    result = PolySwapFormulaHelper.subAbs(
      result,
      PolySwapFormulaHelper.toPrecision(k, decimals2 - 1)
    );
  }

  function derivativeF(
    uint256[2][] calldata parameters,
    uint256 x,
    uint256 decimals1,
    uint256 decimals2
  ) public pure returns (uint256 result) {
    uint256 length = parameters.length;

    for (uint256 i = 0; i < length; i++) {
      result += PolySwapFormulaHelper.divPow2OfTotalOfSum(
        PolySwapFormulaHelper.toPrecision(parameters[i][0], decimals1),
        PolySwapFormulaHelper.toPrecision(parameters[i][1], decimals2),
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
      result += PolySwapFormulaHelper.divPow3OfTotalOfSum(
        PolySwapFormulaHelper.toPrecision(parameters[i][0], decimals1),
        PolySwapFormulaHelper.toPrecision(parameters[i][1], decimals2),
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
      result += PolySwapFormulaHelper.mulDiv(
        PolySwapFormulaHelper.toPrecision(parameters[i][0], decimals1),
        parameters[0][1] - parameters[i][1],
        PolySwapFormulaHelper.add(
          PolySwapFormulaHelper.toPrecision(parameters[i][1], decimals2),
          x
        )
      );
      result += PolySwapFormulaHelper.toPrecision(parameters[i][0], decimals2);
    }

    if (
      result + PolySwapFormulaHelper.toPrecision(parameters[0][0], decimals2) >=
      x + PolySwapFormulaHelper.toPrecision(parameters[0][1], decimals2)
    ) {
      isNegative = false;
    } else {
      isNegative = true;
    }

    result = PolySwapFormulaHelper.subAbs(
      result + PolySwapFormulaHelper.toPrecision(parameters[0][0], decimals2),
      x + PolySwapFormulaHelper.toPrecision(parameters[0][1], decimals2)
    );
  }

  function appDerivativeF(
    uint256[2][] calldata parameters,
    uint256 x,
    uint256 decimals1,
    uint256 decimals2
  ) public pure returns (uint256 result) {
    for (uint256 i = 1; i < parameters.length; i++) {
      result += PolySwapFormulaHelper.mulDiv(
        PolySwapFormulaHelper.toPrecision(parameters[i][0], decimals1),
        parameters[0][1] - parameters[i][1],
        PolySwapFormulaHelper.pow2(
          PolySwapFormulaHelper.add(
            PolySwapFormulaHelper.toPrecision(parameters[i][1], decimals2),
            x
          )
        )
      );
    }
    result += PolySwapFormulaHelper.toPrecision(1, decimals2 + 1);
  }

  function appDoubleDerivativeF(
    uint256[2][] calldata parameters,
    uint256 x,
    uint256 decimals1,
    uint256 decimals2
  ) public pure returns (uint256 result) {
    for (uint256 i = 1; i < parameters.length; i++) {
      result += PolySwapFormulaHelper.mulDiv(
        2 * PolySwapFormulaHelper.toPrecision(parameters[i][0], decimals1),
        parameters[0][1] - parameters[i][1],
        PolySwapFormulaHelper.pow3(
          PolySwapFormulaHelper.add(
            PolySwapFormulaHelper.toPrecision(parameters[i][1], decimals2),
            x
          )
        )
      );
    }
  }
}
