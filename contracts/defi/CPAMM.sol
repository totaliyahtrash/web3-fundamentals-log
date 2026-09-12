// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ManualToken} from "../tokens/ManualToken.sol";

// -----------------------------------------------------------------------
// Custom Errors
// -----------------------------------------------------------------------
error CPAMM__ZeroAmount();
error CPAMM__ZeroLiquidity();
error CPAMM__InvalidToken();
error CPAMM__SlippageExceeded();
error CPAMM__TransferFailed();

/**
 * @title Constant Product Automated Market Maker (CPAMM / Uniswap v2 Core)
 * @author totaliyahtrash
 * @notice Decentralized exchange protocol executing automated token swaps via x * y = k invariant.
 * @dev Manages liquidity provider (LP) shares, reserves, fee calculation (0.3%), and price curves.
 */
contract CPAMM {
    ManualToken public immutable token0;
    ManualToken public immutable token1;

    uint256 public reserve0;
    uint256 public reserve1;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    event Swap(address indexed sender, address indexed tokenIn, uint256 amountIn, uint256 amountOut);
    event AddLiquidity(address indexed provider, uint256 amount0, uint256 amount1, uint256 shares);
    event RemoveLiquidity(address indexed provider, uint256 amount0, uint256 amount1, uint256 shares);

    constructor(address _token0, address _token1) {
        token0 = ManualToken(_token0);
        token1 = ManualToken(_token1);
    }

    // -----------------------------------------------------------------------
    // Internal Mint & Burn for LP Shares
    // -----------------------------------------------------------------------
    function _mint(address _to, uint256 _amount) private {
        balanceOf[_to] += _amount;
        totalSupply += _amount;
    }

    function _burn(address _from, uint256 _amount) private {
        balanceOf[_from] -= _amount;
        totalSupply -= _amount;
    }

    // -----------------------------------------------------------------------
    // Core Swap Function (x * y = k)
    // -----------------------------------------------------------------------
    /**
     * @notice Swaps tokenIn for the counter-pair token along the constant product curve.
     * @param _tokenIn Address of the token being sold (must be token0 or token1).
     * @param _amountIn Amount of tokenIn to deposit.
     * @return amountOut The quantity of the opposing token purchased.
     */
    function swap(address _tokenIn, uint256 _amountIn) external returns (uint256 amountOut) {
        if (_amountIn == 0) revert CPAMM__ZeroAmount();
        if (_tokenIn != address(token0) && _tokenIn != address(token1)) revert CPAMM__InvalidToken();

        bool isToken0 = _tokenIn == address(token0);
        (ManualToken tokenIn, ManualToken tokenOut, uint256 reserveIn, uint256 reserveOut) = isToken0
            ? (token0, token1, reserve0, reserve1)
            : (token1, token0, reserve1, reserve0);

        // Pull tokens from user
        bool pullSuccess = tokenIn.transferFrom(msg.sender, address(this), _amountIn);
        if (!pullSuccess) revert CPAMM__TransferFailed();

        // 0.3% trading fee: amountInWithFee = amountIn * 997 / 1000
        uint256 amountInWithFee = (_amountIn * 997) / 1000;
        
        // Output formula derived from: (x + dx) * (y - dy) = x * y
        // dy = (y * dx) / (x + dx)
        amountOut = (reserveOut * amountInWithFee) / (reserveIn + amountInWithFee);

        if (amountOut == 0) revert CPAMM__ZeroAmount();

        // Push tokens to user
        bool pushSuccess = tokenOut.transfer(msg.sender, amountOut);
        if (!pushSuccess) revert CPAMM__TransferFailed();

        // Update reserves
        _updateReserves(token0.balanceOf(address(this)), token1.balanceOf(address(this)));
        emit Swap(msg.sender, _tokenIn, _amountIn, amountOut);
    }

    // -----------------------------------------------------------------------
    // Liquidity Provisioning
    // -----------------------------------------------------------------------
    /**
     * @notice Adds liquidity to the pool in proportion to existing reserves.
     */
    function addLiquidity(uint256 _amount0, uint256 _amount1) external returns (uint256 shares) {
        if (_amount0 == 0 || _amount1 == 0) revert CPAMM__ZeroAmount();

        token0.transferFrom(msg.sender, address(this), _amount0);
        token1.transferFrom(msg.sender, address(this), _amount1);

        if (totalSupply == 0) {
            // First liquidity deposit: shares = sqrt(x * y)
            shares = _sqrt(_amount0 * _amount1);
        } else {
            // Proportional shares: min((dx / x) * T, (dy / y) * T)
            uint256 shares0 = (_amount0 * totalSupply) / reserve0;
            uint256 shares1 = (_amount1 * totalSupply) / reserve1;
            shares = shares0 < shares1 ? shares0 : shares1;
        }

        if (shares == 0) revert CPAMM__ZeroLiquidity();
        _mint(msg.sender, shares);

        _updateReserves(token0.balanceOf(address(this)), token1.balanceOf(address(this)));
        emit AddLiquidity(msg.sender, _amount0, _amount1, shares);
    }

    /**
     * @notice Burns LP shares and redeems the underlying token pair proportionally.
     */
    function removeLiquidity(uint256 _shares) external returns (uint256 amount0, uint256 amount1) {
        if (_shares == 0) revert CPAMM__ZeroAmount();

        amount0 = (_shares * reserve0) / totalSupply;
        amount1 = (_shares * reserve1) / totalSupply;

        if (amount0 == 0 || amount1 == 0) revert CPAMM__ZeroAmount();

        _burn(msg.sender, _shares);
        _updateReserves(reserve0 - amount0, reserve1 - amount1);

        token0.transfer(msg.sender, amount0);
        token1.transfer(msg.sender, amount1);

        emit RemoveLiquidity(msg.sender, amount0, amount1, _shares);
    }

    // -----------------------------------------------------------------------
    // Internal Math Helpers
    // -----------------------------------------------------------------------
    function _updateReserves(uint256 _reserve0, uint256 _reserve1) private {
        reserve0 = _reserve0;
        reserve1 = _reserve1;
    }

    function _sqrt(uint256 y) private pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}
