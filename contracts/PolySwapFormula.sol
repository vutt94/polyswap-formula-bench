pragma solidity 0.8.9;

import { FullMath } from "./libraries/FullMath.sol";
import "hardhat/console.sol";

contract PolySwapFormula {
  function standardFormulaNewton(
    uint256[2][] calldata parameters,
    uint256 k,
    uint256 initialX
  ) external pure returns (uint256[] memory results) {
    results = new uint256[](100);
    uint256 nextX = FullMath.toPrecision(initialX, 18);
    uint256 curX;
    uint256 count = 0;
    do {
      curX = nextX;
      (uint256 fx, ) = f(parameters, k, curX, 36, 18);
      uint256 derivativeFx = derivativeF(parameters, curX, 54, 18);

      nextX = curX + FullMath.toPrecision(fx, 18) / derivativeFx;
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
      (uint256 fx, bool isNegative) = f(parameters, k, curX, 36, 18);
      uint256 derivativeFx = derivativeF(parameters, curX, 55, 18);
      uint256 doubleDerivativeFx = doubleDerivativeF(parameters, curX, 74, 18);
      uint256 upperPart = 2 * fx * derivativeFx;
      uint256 lowerPart;

      if (isNegative) {
        lowerPart = 2 * FullMath.pow2(derivativeFx) + fx * doubleDerivativeFx;
        nextX = curX - FullMath.toPrecision(upperPart, 19) / lowerPart;
      } else {
        lowerPart = 2 * FullMath.pow2(derivativeFx) - fx * doubleDerivativeFx;
        nextX = curX + FullMath.toPrecision(upperPart, 19) / lowerPart;
      }

      results[count] = nextX;
      count++;
    } while (curX != nextX);
  }

  function appFormulaNewton(uint256[2][] calldata parameters, uint256 initialX)
    external
    pure
    returns (uint256[] memory results)
  {
    results = new uint256[](100);
    // uint256 nextX = FullMath.toPrecision(initialX, 18);
    // uint256 curX;
    // uint256 count = 0;
    // do {
    //   curX = nextX;
    //   (uint256 fx, ) = f(parameters, k, curX, 36, 18);
    //   uint256 derivativeFx = derivativeF(parameters, curX, 54, 18);

    //   nextX = curX + FullMath.toPrecision(fx, 18) / derivativeFx;
    //   results[count] = nextX;
    //   count++;
    // } while (curX != nextX);

    uint256 curX = FullMath.toPrecision(initialX, 18);
    (uint256 positiveF, uint256 negativeF) = appF(parameters, curX, 36, 18);
    (uint256 positiveDerivativeF, uint256 negativeDerivativeF) = appDerivativeF(
      parameters,
      curX,
      55,
      18
    );
    (
      uint256 positiveDoubleDerivativeFx,
      uint256 negativeDoubleDerivativeFx
    ) = appDoubleDerivativeF(parameters, curX, 73, 18);

    results[0] = positiveF;
    results[1] = negativeF;

    results[2] = positiveDerivativeF;
    results[3] = negativeDerivativeF;

    results[4] = positiveDoubleDerivativeFx;
    results[5] = negativeDoubleDerivativeFx;

    unchecked {
      if (
        (positiveF > negativeF && positiveDerivativeF > negativeDerivativeF) ||
        (positiveF < negativeF && positiveDerivativeF < negativeDerivativeF)
      ) {
        results[6] =
          curX +
          FullMath.toPrecision(FullMath.subAbs(positiveF, negativeF), 19) /
          FullMath.subAbs(positiveDerivativeF, negativeDerivativeF);
      } else {
        results[6] =
          curX -
          FullMath.toPrecision(FullMath.subAbs(positiveF, negativeF), 19) /
          FullMath.subAbs(positiveDerivativeF, negativeDerivativeF);
      }
    }
  }

  function f(
    uint256[2][] calldata parameters,
    uint256 k,
    uint256 x,
    uint256 decimals1,
    uint256 decimals2
  ) public pure returns (uint256 result, bool isNegative) {
    uint256 length = parameters.length;

    for (uint256 i = 0; i < length; i++) {
      result += FullMath.divTotalOfSum(
        FullMath.toPrecision(parameters[i][0], decimals1),
        FullMath.toPrecision(parameters[i][1], decimals2),
        x
      );
    }

    uint256 kInPrecision = FullMath.toPrecision(k, 18);

    if (result < kInPrecision) {
      result = kInPrecision - result;
      isNegative = true;
    } else {
      result = result - kInPrecision;
      isNegative = false;
    }
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
  ) public pure returns (uint256 positive, uint256 negative) {
    for (uint256 i = 1; i < parameters.length; i++) {
      (uint256 subtraction, bool isNegative) = FullMath.sub(
        parameters[0][1],
        parameters[i][1]
      );

      unchecked {
        isNegative
          ? negative += FullMath.mulDiv(
            FullMath.toPrecision(parameters[i][0], decimals1),
            subtraction,
            FullMath.add(FullMath.toPrecision(parameters[i][1], decimals2), x)
          )
          : positive += FullMath.mulDiv(
          FullMath.toPrecision(parameters[i][0], decimals1),
          subtraction,
          FullMath.add(FullMath.toPrecision(parameters[i][1], decimals2), x)
        );

        positive += FullMath.toPrecision(parameters[i][0], decimals2);
      }
    }

    unchecked {
      positive += FullMath.toPrecision(parameters[0][0], decimals2);
      negative += (x + FullMath.toPrecision(parameters[0][1], decimals2));
    }
  }

  function appDerivativeF(
    uint256[2][] calldata parameters,
    uint256 x,
    uint256 decimals1,
    uint256 decimals2
  ) public pure returns (uint256 positive, uint256 negative) {
    for (uint256 i = 1; i < parameters.length; i++) {
      (uint256 subtraction, bool isNegative) = FullMath.sub(
        parameters[0][1],
        parameters[i][1]
      );

      unchecked {
        isNegative
          ? positive += FullMath.mulDiv(
            FullMath.toPrecision(parameters[i][0], decimals1),
            subtraction,
            FullMath.pow2(
              FullMath.add(FullMath.toPrecision(parameters[i][1], decimals2), x)
            )
          )
          : negative += FullMath.mulDiv(
          FullMath.toPrecision(parameters[i][0], decimals1),
          subtraction,
          FullMath.pow2(
            FullMath.add(FullMath.toPrecision(parameters[i][1], decimals2), x)
          )
        );
      }
    }
    unchecked {
      negative += FullMath.toPrecision(1, decimals2 + 1);
    }
  }

  function appDoubleDerivativeF(
    uint256[2][] calldata parameters,
    uint256 x,
    uint256 decimals1,
    uint256 decimals2
  ) public pure returns (uint256 positive, uint256 negative) {
    for (uint256 i = 1; i < parameters.length; i++) {
      (uint256 subtraction, bool isNegative) = FullMath.sub(
        parameters[0][1],
        parameters[i][1]
      );

      unchecked {
        isNegative
          ? negative += FullMath.mulDiv(
            2 * FullMath.toPrecision(parameters[i][0], decimals1),
            subtraction,
            FullMath.pow3(
              FullMath.add(FullMath.toPrecision(parameters[i][1], decimals2), x)
            )
          )
          : positive += FullMath.mulDiv(
          2 * FullMath.toPrecision(parameters[i][0], decimals1),
          subtraction,
          FullMath.pow3(
            FullMath.add(FullMath.toPrecision(parameters[i][1], decimals2), x)
          )
        );
      }
    }
  }
}
