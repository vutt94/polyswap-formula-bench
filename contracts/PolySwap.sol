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

  mapping(IERC20 => address) public tokens;
  mapping(IERC20 => uint256) public liquidityTokens;
  mapping(IERC20 => uint256) public reserveTokens;
  mapping(IERC20 => uint160) public minimumPriceTokens;
  mapping(IERC20 => uint160) public maximumPriceTokens;
  uint128 public liquidity;
  uint128 public supply;
  uint16 public fee;
  uint16 public singleFee;
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
    uint16 _singleFee
  ) public {
    uint256 tokenLength = _tokens.length;
    for (uint256 i = 0; i < tokenLength; ++i) {
      tokens[IERC20(_tokens[i])] = _tokens[i];
      liquidityTokens[IERC20(_tokens[i])] = PolySwapHelper.calculateLiquidity(
        _reverves[i],
        _initPrices[i],
        _maxPrices[i]
      );

      reserveTokens[IERC20(_tokens[i])] = _reverves[i];
      minimumPriceTokens[IERC20(_tokens[i])] = _minPrices[i];
      maximumPriceTokens[IERC20(_tokens[i])] = _maxPrices[i];
      liquidity = _liquidity;
      supply = _supply;
      fee = _fee;
      singleFee = _singleFee;
    }
  }

  function swapExactTokenForToken(SwapExactTokenForTokenParams calldata params)
    external
  {
    IERC20 tokenIn = IERC20(params.tokenIn);
    IERC20 tokenOut = IERC20(params.tokenOut);

    uint160 curPriceTokenIn = PolySwapHelper.calculateTokenPrice(
      liquidityTokens[tokenIn],
      maximumPriceTokens[tokenIn],
      reserveTokens[tokenIn]
    );
    uint160 resultPriceTokenIn = PolySwapHelper.calculateTokenPrice(
      liquidityTokens[tokenIn],
      curPriceTokenIn,
      params.amountTokenIn
    );
    require(
      resultPriceTokenIn >= minimumPriceTokens[tokenIn],
      "insufficient liquidity"
    );
    uint256 deltaIndexTokenIn = PolySwapHelper.calculateDeltaIndexTokenOut(
      liquidityTokens[tokenIn],
      resultPriceTokenIn,
      curPriceTokenIn,
      fee,
      BPS
    );
    uint160 curPriceTokenOut = PolySwapHelper.calculateTokenPrice(
      liquidityTokens[tokenOut],
      maximumPriceTokens[tokenOut],
      reserveTokens[tokenOut]
    );
    uint256 resultPriceTokenOut = PolySwapHelper.calculateTokenPriceByIndex(
      liquidityTokens[tokenOut],
      curPriceTokenOut,
      deltaIndexTokenIn
    );
    require(
      resultPriceTokenOut <= maximumPriceTokens[tokenOut],
      "insufficient liquidity"
    );
    uint256 amountTokenOut = (liquidityTokens[tokenOut] / curPriceTokenOut) -
      (liquidityTokens[tokenOut] / resultPriceTokenOut);
    require(
      amountTokenOut >= params.amountTokenOutMin,
      "not fit user's desired tokenOut amount"
    );

    tokenIn.transferFrom(msg.sender, address(this), params.amountTokenIn);
    tokenOut.transfer(msg.sender, amountTokenOut);

    _verifyReserve(
      tokenIn,
      reserveTokens[tokenIn] + params.amountTokenIn,
      tokenOut,
      reserveTokens[tokenOut] - amountTokenOut
    );
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
