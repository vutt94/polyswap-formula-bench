pragma solidity 0.8.9;

import { PolySwapHelper } from "./libraries/PolySwapHelper.sol";
import "hardhat/console.sol";

interface IERC20 {
  function totalSupply() external view returns (uint256);

  function balanceOf(address who) external view returns (uint256);

  function transfer(address to, uint256 value) external returns (bool);

  function transferFrom(
    address from,
    address to,
    uint256 value
  ) external returns (bool);

  function approve(address spender, uint256 value) external returns (bool);

  function allowance(address owner, address spender)
    external
    view
    returns (uint256);
}

contract PolySwap {
  struct SwapExactTokenForTokenParams {
    address tokenIn;
    address tokenOut;
    uint256 amountTokenIn;
    uint256 amountTokenOutMin;
  }

  address[] public tokens;
  mapping(IERC20 => uint256) public ratioTokens;
  mapping(IERC20 => uint256) public reserveTokens;
  mapping(IERC20 => uint160) public minimumPriceTokens;
  mapping(IERC20 => uint160) public maximumPriceTokens;
  uint128 public liquidity;
  uint128 public supply;
  uint16 public fee;
  uint16 public singleFee;
  uint160 public feeThreshold;
  uint16 internal constant BPS = 10000;

  constructor(
    address[] memory _tokens,
    uint160[] memory _initPrices,
    uint160[] memory _minPrices,
    uint160[] memory _maxPrices,
    uint256[] memory _reverves,
    uint128 _liquidity,
    uint128 _supply,
    uint16 _fee,
    uint16 _singleFee,
    uint160 _feeThreshold
  ) public {
    uint256 tokenLength = _tokens.length;
    for (uint256 i = 0; i < tokenLength; ++i) {
      tokens.push(_tokens[i]);
      ratioTokens[IERC20(_tokens[i])] = PolySwapHelper.calculateRatio(
        _reverves[i],
        _initPrices[i],
        _maxPrices[i],
        _liquidity
      );

      reserveTokens[IERC20(_tokens[i])] = _reverves[i];
      minimumPriceTokens[IERC20(_tokens[i])] = _minPrices[i];
      maximumPriceTokens[IERC20(_tokens[i])] = _maxPrices[i];
      liquidity = _liquidity;
      supply = _supply;
      fee = _fee;
      singleFee = _singleFee;
      feeThreshold = _feeThreshold;
    }
  }

  function swapExactTokenForToken(SwapExactTokenForTokenParams calldata params)
    external
  {
    IERC20 tokenIn = IERC20(params.tokenIn);
    IERC20 tokenOut = IERC20(params.tokenOut);

    console.log("liqTokenIn is %s", ratioTokens[tokenIn] * liquidity);

    uint160 curPriceTokenIn = PolySwapHelper.calculateTokenPrice(
      ratioTokens[tokenIn] * liquidity,
      maximumPriceTokens[tokenIn],
      reserveTokens[tokenIn]
    );

    console.log("curPriceTokenIn is %s", curPriceTokenIn);

    uint160 resultPriceTokenIn = PolySwapHelper.calculateTokenResultPrice(
      ratioTokens[tokenIn] * liquidity,
      curPriceTokenIn,
      params.amountTokenIn
    );

    console.log("resultPriceTokenIn is %s", resultPriceTokenIn);

    require(
      resultPriceTokenIn >= minimumPriceTokens[tokenIn],
      "insufficient liquidity"
    );

    uint256 deltaIndexTokenOut = PolySwapHelper.calculateDeltaIndexTokenOut(
      ratioTokens[tokenIn] * liquidity,
      resultPriceTokenIn,
      curPriceTokenIn
    );

    console.log("deltaIndexTokenOut is %s", deltaIndexTokenOut);

    uint256 deltaIndexTokenIn = PolySwapHelper.calculateDeltaIndexTokenIn(
      deltaIndexTokenOut,
      fee,
      BPS
    );

    console.log("deltaIndexTokenIn is %s", deltaIndexTokenIn);

    uint160 curPriceTokenOut = PolySwapHelper.calculateTokenPrice(
      ratioTokens[tokenOut] * liquidity,
      maximumPriceTokens[tokenOut],
      reserveTokens[tokenOut]
    );

    console.log("curPriceTokenOut is %s", curPriceTokenOut);

    uint160 resultPriceTokenOut = PolySwapHelper.calculateTokenPriceByIndex(
      ratioTokens[tokenOut] * liquidity,
      curPriceTokenOut,
      deltaIndexTokenIn
    );

    console.log("resultPriceTokenOut is %s", resultPriceTokenOut);

    require(
      resultPriceTokenOut <= maximumPriceTokens[tokenOut],
      "insufficient liquidity"
    );

    uint256 amountTokenOut = PolySwapHelper.calculateAmountTokenOut(
      ratioTokens[tokenOut] * liquidity,
      curPriceTokenOut,
      resultPriceTokenOut
    );

    require(
      amountTokenOut >= params.amountTokenOutMin,
      "not fit user's desired tokenOut amount"
    );

    console.log("amountTokenOut is %s", amountTokenOut);

    tokenIn.transferFrom(msg.sender, address(this), params.amountTokenIn);
    tokenOut.transfer(msg.sender, amountTokenOut);

    _verifyReserve(
      tokenIn,
      reserveTokens[tokenIn] + params.amountTokenIn,
      tokenOut,
      reserveTokens[tokenOut] - amountTokenOut
    );

    // uint256 reserveTokenIndex;
    // for (uint256 i = 0; i < tokens.length; ++i) {
    //   reserveTokenIndex += PolySwapHelper.calculateReserveIndexOfToken(
    //     ratioTokens[IERC20(tokens[i])] * liquidity,
    //     maximumPriceTokens
    //   );
    // }
  }

  function _verifyReserve(
    IERC20 tokenIn,
    uint256 reserveTokenInShouldBe,
    IERC20 tokenOut,
    uint256 reserveTokenOutShouldBe
  ) internal view {
    assert(reserveTokenInShouldBe <= tokenIn.balanceOf(address(this)));
    assert(reserveTokenOutShouldBe <= tokenOut.balanceOf(address(this)));
  }
}
