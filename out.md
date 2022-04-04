// Sources flattened with hardhat v2.9.1 https://hardhat.org

// File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.4.1

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Library for managing
 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
 * types.
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 *
 * ```
 * contract Example {
 *     // Add the library methods
 *     using EnumerableSet for EnumerableSet.AddressSet;
 *
 *     // Declare a set state variable
 *     EnumerableSet.AddressSet private mySet;
 * }
 * ```
 *
 * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
 * and `uint256` (`UintSet`) are supported.
 */
library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;

        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping (bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) { // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.

            bytes32 lastvalue = set._values[lastIndex];

            // Move the last value to the index where the value to delete is
            set._values[toDeleteIndex] = lastvalue;
            // Update the index for the moved value
            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        require(set._values.length > index, "EnumerableSet: index out of bounds");
        return set._values[index];
    }

    // Bytes32Set

    struct Bytes32Set {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }


    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }
}


// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


// File contracts/interfaces/IDMMFactory.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.6.12;

interface IDMMFactory {
    function createPool(
        IERC20 tokenA,
        IERC20 tokenB,
        uint32 ampBps
    ) external returns (address pool);

    function setFeeConfiguration(address feeTo, uint16 governmentFeeBps) external;

    function setFeeToSetter(address) external;

    function getFeeConfiguration() external view returns (address feeTo, uint16 governmentFeeBps);

    function feeToSetter() external view returns (address);

    function allPools(uint256) external view returns (address pool);

    function allPoolsLength() external view returns (uint256);

    function getUnamplifiedPool(IERC20 token0, IERC20 token1) external view returns (address);

    function getPools(IERC20 token0, IERC20 token1)
        external
        view
        returns (address[] memory _tokenPools);

    function isPool(
        IERC20 token0,
        IERC20 token1,
        address pool
    ) external view returns (bool);
}


// File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}


// File @openzeppelin/contracts/math/Math.sol@v3.4.1

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}


// File @openzeppelin/contracts/utils/ReentrancyGuard.sol@v3.4.1

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor () internal {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}


// File @openzeppelin/contracts/utils/Address.sol@v3.4.1

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.2 <0.8.0;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}


// File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.4.1

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;



/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}


// File contracts/libraries/MathExt.sol

// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

library MathExt {
    using SafeMath for uint256;

    uint256 public constant PRECISION = (10**18);

    /// @dev Returns x*y in precision
    function mulInPrecision(uint256 x, uint256 y) internal pure returns (uint256) {
        return x.mul(y) / PRECISION;
    }

    /// @dev source: dsMath
    /// @param xInPrecision should be < PRECISION, so this can not overflow
    /// @return zInPrecision = (x/PRECISION) ^k * PRECISION
    function unsafePowInPrecision(uint256 xInPrecision, uint256 k)
        internal
        pure
        returns (uint256 zInPrecision)
    {
        require(xInPrecision <= PRECISION, "MathExt: x > PRECISION");
        zInPrecision = k % 2 != 0 ? xInPrecision : PRECISION;

        for (k /= 2; k != 0; k /= 2) {
            xInPrecision = (xInPrecision * xInPrecision) / PRECISION;

            if (k % 2 != 0) {
                zInPrecision = (zInPrecision * xInPrecision) / PRECISION;
            }
        }
    }

    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
    function sqrt(uint256 y) internal pure returns (uint256 z) {
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


// File contracts/libraries/FeeFomula.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.6.12;

library FeeFomula {
    using SafeMath for uint256;
    using MathExt for uint256;

    uint256 private constant PRECISION = 10**18;
    uint256 private constant R0 = 1477405064814996100; // 1.4774050648149961

    uint256 private constant C0 = (60 * PRECISION) / 10000;

    uint256 private constant A = uint256(PRECISION * 20000) / 27;
    uint256 private constant B = uint256(PRECISION * 250) / 9;
    uint256 private constant C1 = uint256(PRECISION * 985) / 27;
    uint256 private constant U = (120 * PRECISION) / 100;

    uint256 private constant G = (836 * PRECISION) / 1000;
    uint256 private constant F = 5 * PRECISION;
    uint256 private constant L = (2 * PRECISION) / 10000;
    // C2 = 25 * PRECISION - (F * (PRECISION - G)**2) / ((PRECISION - G)**2 + L * PRECISION)
    uint256 private constant C2 = 20036905816356657810;

    /// @dev calculate fee from rFactorInPrecision, see section 3.2 in dmmSwap white paper
    /// @dev fee in [15, 60] bps
    /// @return fee percentage in Precision
    function getFee(uint256 rFactorInPrecision) internal pure returns (uint256) {
        if (rFactorInPrecision >= R0) {
            return C0;
        } else if (rFactorInPrecision >= PRECISION) {
            // C1 + A * (r-U)^3 + b * (r -U)
            if (rFactorInPrecision > U) {
                uint256 tmp = rFactorInPrecision - U;
                uint256 tmp3 = tmp.unsafePowInPrecision(3);
                return (C1.add(A.mulInPrecision(tmp3)).add(B.mulInPrecision(tmp))) / 10000;
            } else {
                uint256 tmp = U - rFactorInPrecision;
                uint256 tmp3 = tmp.unsafePowInPrecision(3);
                return C1.sub(A.mulInPrecision(tmp3)).sub(B.mulInPrecision(tmp)) / 10000;
            }
        } else {
            // [ C2 + sign(r - G) *  F * (r-G) ^2 / (L + (r-G) ^2) ] / 10000
            uint256 tmp = (
                rFactorInPrecision > G ? (rFactorInPrecision - G) : (G - rFactorInPrecision)
            );
            tmp = tmp.unsafePowInPrecision(2);
            uint256 tmp2 = F.mul(tmp).div(tmp.add(L));
            if (rFactorInPrecision > G) {
                return C2.add(tmp2) / 10000;
            } else {
                return C2.sub(tmp2) / 10000;
            }
        }
    }
}


// File @openzeppelin/contracts/utils/Context.sol@v3.4.1

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


// File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.4.1

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;



/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name_, string memory symbol_) public {
        _name = name_;
        _symbol = symbol_;
        _decimals = 18;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
     * called.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Sets {decimals} to a value other than the default one of 18.
     *
     * WARNING: This function should only be called from the constructor. Most
     * applications that interact with token contracts will not expect
     * {decimals} to ever change, and may work incorrectly if it does.
     */
    function _setupDecimals(uint8 decimals_) internal virtual {
        _decimals = decimals_;
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}


// File contracts/interfaces/IERC20Permit.sol

// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

interface IERC20Permit is IERC20 {
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;
}


// File contracts/libraries/ERC20Permit.sol

// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

/// @dev https://eips.ethereum.org/EIPS/eip-2612
contract ERC20Permit is ERC20, IERC20Permit {
    /// @dev To make etherscan auto-verify new pool, this variable is not immutable
    bytes32 public domainSeparator;
    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    bytes32
        public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;

    mapping(address => uint256) public nonces;

    constructor(
        string memory name,
        string memory symbol,
        string memory version
    ) public ERC20(name, symbol) {
        uint256 chainId;
        assembly {
            chainId := chainid()
        }
        domainSeparator = keccak256(
            abi.encode(
                keccak256(
                    "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
                ),
                keccak256(bytes(name)),
                keccak256(bytes(version)),
                chainId,
                address(this)
            )
        );
    }

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external override {
        require(deadline >= block.timestamp, "ERC20Permit: EXPIRED");
        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                domainSeparator,
                keccak256(
                    abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline)
                )
            )
        );
        address recoveredAddress = ecrecover(digest, v, r, s);
        require(
            recoveredAddress != address(0) && recoveredAddress == owner,
            "ERC20Permit: INVALID_SIGNATURE"
        );
        _approve(owner, spender, value);
    }
}


// File contracts/interfaces/IDMMCallee.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.6.12;

interface IDMMCallee {
    function dmmSwapCall(
        address sender,
        uint256 amount0,
        uint256 amount1,
        bytes calldata data
    ) external;
}


// File contracts/interfaces/IDMMPool.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.6.12;

interface IDMMPool {
    function mint(address to) external returns (uint256 liquidity);

    function burn(address to) external returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function sync() external;

    function getReserves() external view returns (uint112 reserve0, uint112 reserve1);

    function getTradeInfo()
        external
        view
        returns (
            uint112 _vReserve0,
            uint112 _vReserve1,
            uint112 reserve0,
            uint112 reserve1,
            uint256 feeInPrecision
        );

    function token0() external view returns (IERC20);

    function token1() external view returns (IERC20);

    function ampBps() external view returns (uint32);

    function factory() external view returns (IDMMFactory);

    function kLast() external view returns (uint256);
}


// File contracts/interfaces/IERC20Metadata.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}


// File contracts/VolumeTrendRecorder.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.6.12;

/// @dev contract to calculate volume trend. See secion 3.1 in the white paper
/// @dev EMA stands for Exponential moving average
/// @dev https://en.wikipedia.org/wiki/Moving_average
contract VolumeTrendRecorder {
    using MathExt for uint256;
    using SafeMath for uint256;

    uint256 private constant MAX_UINT128 = 2**128 - 1;
    uint256 internal constant PRECISION = 10**18;
    uint256 private constant SHORT_ALPHA = (2 * PRECISION) / 5401;
    uint256 private constant LONG_ALPHA = (2 * PRECISION) / 10801;

    uint128 internal shortEMA;
    uint128 internal longEMA;
    // total volume in current block
    uint128 internal currentBlockVolume;
    uint128 internal lastTradeBlock;

    event UpdateEMA(uint256 shortEMA, uint256 longEMA, uint128 lastBlockVolume, uint256 skipBlock);

    constructor(uint128 _emaInit) public {
        shortEMA = _emaInit;
        longEMA = _emaInit;
        lastTradeBlock = safeUint128(block.number);
    }

    function getVolumeTrendData()
        external
        view
        returns (
            uint128 _shortEMA,
            uint128 _longEMA,
            uint128 _currentBlockVolume,
            uint128 _lastTradeBlock
        )
    {
        _shortEMA = shortEMA;
        _longEMA = longEMA;
        _currentBlockVolume = currentBlockVolume;
        _lastTradeBlock = lastTradeBlock;
    }

    /// @dev records a new trade, update ema and returns current rFactor for this trade
    /// @return rFactor in Precision for this trade
    function recordNewUpdatedVolume(uint256 blockNumber, uint256 value)
        internal
        returns (uint256)
    {
        // this can not be underflow because block.number always increases
        uint256 skipBlock = blockNumber - lastTradeBlock;
        if (skipBlock == 0) {
            currentBlockVolume = safeUint128(
                uint256(currentBlockVolume).add(value),
                "volume exceeds valid range"
            );
            return calculateRFactor(uint256(shortEMA), uint256(longEMA));
        }
        uint128 _currentBlockVolume = currentBlockVolume;
        uint256 _shortEMA = newEMA(shortEMA, SHORT_ALPHA, currentBlockVolume);
        uint256 _longEMA = newEMA(longEMA, LONG_ALPHA, currentBlockVolume);
        // ema = ema * (1-aplha) ^(skipBlock -1)
        _shortEMA = _shortEMA.mulInPrecision(
            (PRECISION - SHORT_ALPHA).unsafePowInPrecision(skipBlock - 1)
        );
        _longEMA = _longEMA.mulInPrecision(
            (PRECISION - LONG_ALPHA).unsafePowInPrecision(skipBlock - 1)
        );
        shortEMA = safeUint128(_shortEMA);
        longEMA = safeUint128(_longEMA);
        currentBlockVolume = safeUint128(value);
        lastTradeBlock = safeUint128(blockNumber);

        emit UpdateEMA(_shortEMA, _longEMA, _currentBlockVolume, skipBlock);

        return calculateRFactor(_shortEMA, _longEMA);
    }

    /// @return rFactor in Precision for this trade
    function getRFactor(uint256 blockNumber) internal view returns (uint256) {
        // this can not be underflow because block.number always increases
        uint256 skipBlock = blockNumber - lastTradeBlock;
        if (skipBlock == 0) {
            return calculateRFactor(shortEMA, longEMA);
        }
        uint256 _shortEMA = newEMA(shortEMA, SHORT_ALPHA, currentBlockVolume);
        uint256 _longEMA = newEMA(longEMA, LONG_ALPHA, currentBlockVolume);
        _shortEMA = _shortEMA.mulInPrecision(
            (PRECISION - SHORT_ALPHA).unsafePowInPrecision(skipBlock - 1)
        );
        _longEMA = _longEMA.mulInPrecision(
            (PRECISION - LONG_ALPHA).unsafePowInPrecision(skipBlock - 1)
        );
        return calculateRFactor(_shortEMA, _longEMA);
    }

    function calculateRFactor(uint256 _shortEMA, uint256 _longEMA)
        internal
        pure
        returns (uint256)
    {
        if (_longEMA == 0) {
            return 0;
        }
        return (_shortEMA * MathExt.PRECISION) / _longEMA;
    }

    /// @dev return newEMA value
    /// @param ema previous ema value in wei
    /// @param alpha in Precicion (required < Precision)
    /// @param value current value to update ema
    /// @dev ema and value is uint128 and alpha < Percison
    /// @dev so this function can not overflow and returned ema is not overflow uint128
    function newEMA(
        uint128 ema,
        uint256 alpha,
        uint128 value
    ) internal pure returns (uint256) {
        assert(alpha < PRECISION);
        return ((PRECISION - alpha) * uint256(ema) + alpha * uint256(value)) / PRECISION;
    }

    function safeUint128(uint256 v) internal pure returns (uint128) {
        require(v <= MAX_UINT128, "overflow uint128");
        return uint128(v);
    }

    function safeUint128(uint256 v, string memory errorMessage) internal pure returns (uint128) {
        require(v <= MAX_UINT128, errorMessage);
        return uint128(v);
    }
}


// File contracts/DMMPool.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.6.12;










contract DMMPool is IDMMPool, ERC20Permit, ReentrancyGuard, VolumeTrendRecorder {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    uint256 internal constant MAX_UINT112 = 2**112 - 1;
    uint256 internal constant BPS = 10000;

    struct ReserveData {
        uint256 reserve0;
        uint256 reserve1;
        uint256 vReserve0;
        uint256 vReserve1; // only used when isAmpPool = true
    }

    uint256 public constant MINIMUM_LIQUIDITY = 10**3;
    /// @dev To make etherscan auto-verify new pool, these variables are not immutable
    IDMMFactory public override factory;
    IERC20 public override token0;
    IERC20 public override token1;

    /// @dev uses single storage slot, accessible via getReservesData
    uint112 internal reserve0;
    uint112 internal reserve1;
    uint32 public override ampBps;
    /// @dev addition param only when amplification factor > 1
    uint112 internal vReserve0;
    uint112 internal vReserve1;

    /// @dev vReserve0 * vReserve1, as of immediately after the most recent liquidity event
    uint256 public override kLast;

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to,
        uint256 feeInPrecision
    );
    event Sync(uint256 vReserve0, uint256 vReserve1, uint256 reserve0, uint256 reserve1);

    constructor() public ERC20Permit("KyberDMM LP", "DMM-LP", "1") VolumeTrendRecorder(0) {
        factory = IDMMFactory(msg.sender);
    }

    // called once by the factory at time of deployment
    function initialize(
        IERC20 _token0,
        IERC20 _token1,
        uint32 _ampBps
    ) external {
        require(msg.sender == address(factory), "DMM: FORBIDDEN");
        token0 = _token0;
        token1 = _token1;
        ampBps = _ampBps;
    }

    /// @dev this low-level function should be called from a contract
    ///                 which performs important safety checks
    function mint(address to) external override nonReentrant returns (uint256 liquidity) {
        (bool isAmpPool, ReserveData memory data) = getReservesData();
        ReserveData memory _data;
        _data.reserve0 = token0.balanceOf(address(this));
        _data.reserve1 = token1.balanceOf(address(this));
        uint256 amount0 = _data.reserve0.sub(data.reserve0);
        uint256 amount1 = _data.reserve1.sub(data.reserve1);

        bool feeOn = _mintFee(isAmpPool, data);
        uint256 _totalSupply = totalSupply(); // gas savings, must be defined here since totalSupply can update in _mintFee
        if (_totalSupply == 0) {
            if (isAmpPool) {
                uint32 _ampBps = ampBps;
                _data.vReserve0 = _data.reserve0.mul(_ampBps) / BPS;
                _data.vReserve1 = _data.reserve1.mul(_ampBps) / BPS;
            }
            liquidity = MathExt.sqrt(amount0.mul(amount1)).sub(MINIMUM_LIQUIDITY);
            _mint(address(-1), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens
        } else {
            liquidity = Math.min(
                amount0.mul(_totalSupply) / data.reserve0,
                amount1.mul(_totalSupply) / data.reserve1
            );
            if (isAmpPool) {
                uint256 b = liquidity.add(_totalSupply);
                _data.vReserve0 = Math.max(data.vReserve0.mul(b) / _totalSupply, _data.reserve0);
                _data.vReserve1 = Math.max(data.vReserve1.mul(b) / _totalSupply, _data.reserve1);
            }
        }
        require(liquidity > 0, "DMM: INSUFFICIENT_LIQUIDITY_MINTED");
        _mint(to, liquidity);

        _update(isAmpPool, _data);
        if (feeOn) kLast = getK(isAmpPool, _data);
        emit Mint(msg.sender, amount0, amount1);
    }

    /// @dev this low-level function should be called from a contract
    /// @dev which performs important safety checks
    /// @dev user must transfer LP token to this contract before call burn
    function burn(address to)
        external
        override
        nonReentrant
        returns (uint256 amount0, uint256 amount1)
    {
        (bool isAmpPool, ReserveData memory data) = getReservesData(); // gas savings
        IERC20 _token0 = token0; // gas savings
        IERC20 _token1 = token1; // gas savings

        uint256 balance0 = _token0.balanceOf(address(this));
        uint256 balance1 = _token1.balanceOf(address(this));
        require(balance0 >= data.reserve0 && balance1 >= data.reserve1, "DMM: UNSYNC_RESERVES");
        uint256 liquidity = balanceOf(address(this));

        bool feeOn = _mintFee(isAmpPool, data);
        uint256 _totalSupply = totalSupply(); // gas savings, must be defined here since totalSupply can update in _mintFee
        amount0 = liquidity.mul(balance0) / _totalSupply; // using balances ensures pro-rata distribution
        amount1 = liquidity.mul(balance1) / _totalSupply; // using balances ensures pro-rata distribution
        require(amount0 > 0 && amount1 > 0, "DMM: INSUFFICIENT_LIQUIDITY_BURNED");
        _burn(address(this), liquidity);
        _token0.safeTransfer(to, amount0);
        _token1.safeTransfer(to, amount1);
        ReserveData memory _data;
        _data.reserve0 = _token0.balanceOf(address(this));
        _data.reserve1 = _token1.balanceOf(address(this));
        if (isAmpPool) {
            uint256 b = Math.min(
                _data.reserve0.mul(_totalSupply) / data.reserve0,
                _data.reserve1.mul(_totalSupply) / data.reserve1
            );
            _data.vReserve0 = Math.max(data.vReserve0.mul(b) / _totalSupply, _data.reserve0);
            _data.vReserve1 = Math.max(data.vReserve1.mul(b) / _totalSupply, _data.reserve1);
        }
        _update(isAmpPool, _data);
        if (feeOn) kLast = getK(isAmpPool, _data); // data are up-to-date
        emit Burn(msg.sender, amount0, amount1, to);
    }

    /// @dev this low-level function should be called from a contract
    /// @dev which performs important safety checks
    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata callbackData
    ) external override nonReentrant {
        require(amount0Out > 0 || amount1Out > 0, "DMM: INSUFFICIENT_OUTPUT_AMOUNT");
        (bool isAmpPool, ReserveData memory data) = getReservesData(); // gas savings
        require(
            amount0Out < data.reserve0 && amount1Out < data.reserve1,
            "DMM: INSUFFICIENT_LIQUIDITY"
        );

        ReserveData memory newData;
        {
            // scope for _token{0,1}, avoids stack too deep errors
            IERC20 _token0 = token0;
            IERC20 _token1 = token1;
            require(to != address(_token0) && to != address(_token1), "DMM: INVALID_TO");
            if (amount0Out > 0) _token0.safeTransfer(to, amount0Out); // optimistically transfer tokens
            if (amount1Out > 0) _token1.safeTransfer(to, amount1Out); // optimistically transfer tokens
            if (callbackData.length > 0)
                IDMMCallee(to).dmmSwapCall(msg.sender, amount0Out, amount1Out, callbackData);
            newData.reserve0 = _token0.balanceOf(address(this));
            newData.reserve1 = _token1.balanceOf(address(this));
            if (isAmpPool) {
                newData.vReserve0 = data.vReserve0.add(newData.reserve0).sub(data.reserve0);
                newData.vReserve1 = data.vReserve1.add(newData.reserve1).sub(data.reserve1);
            }
        }
        uint256 amount0In = newData.reserve0 > data.reserve0 - amount0Out
            ? newData.reserve0 - (data.reserve0 - amount0Out)
            : 0;
        uint256 amount1In = newData.reserve1 > data.reserve1 - amount1Out
            ? newData.reserve1 - (data.reserve1 - amount1Out)
            : 0;
        require(amount0In > 0 || amount1In > 0, "DMM: INSUFFICIENT_INPUT_AMOUNT");
        uint256 feeInPrecision = verifyBalanceAndUpdateEma(
            amount0In,
            amount1In,
            isAmpPool ? data.vReserve0 : data.reserve0,
            isAmpPool ? data.vReserve1 : data.reserve1,
            isAmpPool ? newData.vReserve0 : newData.reserve0,
            isAmpPool ? newData.vReserve1 : newData.reserve1
        );

        _update(isAmpPool, newData);
        emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to, feeInPrecision);
    }

    /// @dev force balances to match reserves
    function skim(address to) external nonReentrant {
        token0.safeTransfer(to, token0.balanceOf(address(this)).sub(reserve0));
        token1.safeTransfer(to, token1.balanceOf(address(this)).sub(reserve1));
    }

    /// @dev force reserves to match balances
    function sync() external override nonReentrant {
        (bool isAmpPool, ReserveData memory data) = getReservesData();
        bool feeOn = _mintFee(isAmpPool, data);
        ReserveData memory newData;
        newData.reserve0 = IERC20(token0).balanceOf(address(this));
        newData.reserve1 = IERC20(token1).balanceOf(address(this));
        // update virtual reserves if this is amp pool
        if (isAmpPool) {
            uint256 _totalSupply = totalSupply();
            uint256 b = Math.min(
                newData.reserve0.mul(_totalSupply) / data.reserve0,
                newData.reserve1.mul(_totalSupply) / data.reserve1
            );
            newData.vReserve0 = Math.max(data.vReserve0.mul(b) / _totalSupply, newData.reserve0);
            newData.vReserve1 = Math.max(data.vReserve1.mul(b) / _totalSupply, newData.reserve1);
        }
        _update(isAmpPool, newData);
        if (feeOn) kLast = getK(isAmpPool, newData);
    }

    /// @dev returns data to calculate amountIn, amountOut
    function getTradeInfo()
        external
        virtual
        override
        view
        returns (
            uint112 _reserve0,
            uint112 _reserve1,
            uint112 _vReserve0,
            uint112 _vReserve1,
            uint256 feeInPrecision
        )
    {
        // gas saving to read reserve data
        _reserve0 = reserve0;
        _reserve1 = reserve1;
        uint32 _ampBps = ampBps;
        _vReserve0 = vReserve0;
        _vReserve1 = vReserve1;
        if (_ampBps == BPS) {
            _vReserve0 = _reserve0;
            _vReserve1 = _reserve1;
        }
        uint256 rFactorInPrecision = getRFactor(block.number);
        feeInPrecision = getFinalFee(FeeFomula.getFee(rFactorInPrecision), _ampBps);
    }

    /// @dev returns reserve data to calculate amount to add liquidity
    function getReserves() external override view returns (uint112 _reserve0, uint112 _reserve1) {
        _reserve0 = reserve0;
        _reserve1 = reserve1;
    }

    function name() public override view returns (string memory) {
        IERC20Metadata _token0 = IERC20Metadata(address(token0));
        IERC20Metadata _token1 = IERC20Metadata(address(token1));
        return string(abi.encodePacked("KyberDMM LP ", _token0.symbol(), "-", _token1.symbol()));
    }

    function symbol() public override view returns (string memory) {
        IERC20Metadata _token0 = IERC20Metadata(address(token0));
        IERC20Metadata _token1 = IERC20Metadata(address(token1));
        return string(abi.encodePacked("DMM-LP ", _token0.symbol(), "-", _token1.symbol()));
    }

    function verifyBalanceAndUpdateEma(
        uint256 amount0In,
        uint256 amount1In,
        uint256 beforeReserve0,
        uint256 beforeReserve1,
        uint256 afterReserve0,
        uint256 afterReserve1
    ) internal virtual returns (uint256 feeInPrecision) {
        // volume = beforeReserve0 * amount1In / beforeReserve1 + amount0In (normalized into amount in token 0)
        uint256 volume = beforeReserve0.mul(amount1In).div(beforeReserve1).add(amount0In);
        uint256 rFactorInPrecision = recordNewUpdatedVolume(block.number, volume);
        feeInPrecision = getFinalFee(FeeFomula.getFee(rFactorInPrecision), ampBps);
        // verify balance update matches with fomula
        uint256 balance0Adjusted = afterReserve0.mul(PRECISION);
        balance0Adjusted = balance0Adjusted.sub(amount0In.mul(feeInPrecision));
        balance0Adjusted = balance0Adjusted / PRECISION;
        uint256 balance1Adjusted = afterReserve1.mul(PRECISION);
        balance1Adjusted = balance1Adjusted.sub(amount1In.mul(feeInPrecision));
        balance1Adjusted = balance1Adjusted / PRECISION;
        require(
            balance0Adjusted.mul(balance1Adjusted) >= beforeReserve0.mul(beforeReserve1),
            "DMM: K"
        );
    }

    /// @dev update reserves
    function _update(bool isAmpPool, ReserveData memory data) internal {
        reserve0 = safeUint112(data.reserve0);
        reserve1 = safeUint112(data.reserve1);
        if (isAmpPool) {
            assert(data.vReserve0 >= data.reserve0 && data.vReserve1 >= data.reserve1); // never happen
            vReserve0 = safeUint112(data.vReserve0);
            vReserve1 = safeUint112(data.vReserve1);
        }
        emit Sync(data.vReserve0, data.vReserve1, data.reserve0, data.reserve1);
    }

    /// @dev if fee is on, mint liquidity equivalent to configured fee of the growth in sqrt(k)
    function _mintFee(bool isAmpPool, ReserveData memory data) internal returns (bool feeOn) {
        (address feeTo, uint16 governmentFeeBps) = factory.getFeeConfiguration();
        feeOn = feeTo != address(0);
        uint256 _kLast = kLast; // gas savings
        if (feeOn) {
            if (_kLast != 0) {
                uint256 rootK = MathExt.sqrt(getK(isAmpPool, data));
                uint256 rootKLast = MathExt.sqrt(_kLast);
                if (rootK > rootKLast) {
                    uint256 numerator = totalSupply().mul(rootK.sub(rootKLast)).mul(
                        governmentFeeBps
                    );
                    uint256 denominator = rootK.add(rootKLast).mul(5000);
                    uint256 liquidity = numerator / denominator;
                    if (liquidity > 0) _mint(feeTo, liquidity);
                }
            }
        } else if (_kLast != 0) {
            kLast = 0;
        }
    }

    /// @dev gas saving to read reserve data
    function getReservesData() internal view returns (bool isAmpPool, ReserveData memory data) {
        data.reserve0 = reserve0;
        data.reserve1 = reserve1;
        isAmpPool = ampBps != BPS;
        if (isAmpPool) {
            data.vReserve0 = vReserve0;
            data.vReserve1 = vReserve1;
        }
    }

    function getFinalFee(uint256 feeInPrecision, uint32 _ampBps) internal pure returns (uint256) {
        if (_ampBps <= 20000) {
            return feeInPrecision;
        } else if (_ampBps <= 50000) {
            return (feeInPrecision * 20) / 30;
        } else if (_ampBps <= 200000) {
            return (feeInPrecision * 10) / 30;
        } else {
            return (feeInPrecision * 4) / 30;
        }
    }

    function getK(bool isAmpPool, ReserveData memory data) internal pure returns (uint256) {
        return isAmpPool ? data.vReserve0 * data.vReserve1 : data.reserve0 * data.reserve1;
    }

    function safeUint112(uint256 x) internal pure returns (uint112) {
        require(x <= MAX_UINT112, "DMM: OVERFLOW");
        return uint112(x);
    }
}


// File contracts/DMMFactory.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.6.12;


contract DMMFactory is IDMMFactory {
    using EnumerableSet for EnumerableSet.AddressSet;

    uint256 internal constant BPS = 10000;

    address private feeTo;
    uint16 private governmentFeeBps;
    address public override feeToSetter;

    mapping(IERC20 => mapping(IERC20 => EnumerableSet.AddressSet)) internal tokenPools;
    mapping(IERC20 => mapping(IERC20 => address)) public override getUnamplifiedPool;
    address[] public override allPools;

    event PoolCreated(
        IERC20 indexed token0,
        IERC20 indexed token1,
        address pool,
        uint32 ampBps,
        uint256 totalPool
    );
    event SetFeeConfiguration(address feeTo, uint16 governmentFeeBps);
    event SetFeeToSetter(address feeToSetter);

    constructor(address _feeToSetter) public {
        feeToSetter = _feeToSetter;
    }

    function createPool(
        IERC20 tokenA,
        IERC20 tokenB,
        uint32 ampBps
    ) external override returns (address pool) {
        require(tokenA != tokenB, "DMM: IDENTICAL_ADDRESSES");
        (IERC20 token0, IERC20 token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(address(token0) != address(0), "DMM: ZERO_ADDRESS");
        require(ampBps >= BPS, "DMM: INVALID_BPS");
        // only exist 1 unamplified pool of a pool.
        require(
            ampBps != BPS || getUnamplifiedPool[token0][token1] == address(0),
            "DMM: UNAMPLIFIED_POOL_EXISTS"
        );
        pool = address(new DMMPool());
        DMMPool(pool).initialize(token0, token1, ampBps);
        // populate mapping in the reverse direction
        tokenPools[token0][token1].add(pool);
        tokenPools[token1][token0].add(pool);
        if (ampBps == BPS) {
            getUnamplifiedPool[token0][token1] = pool;
            getUnamplifiedPool[token1][token0] = pool;
        }
        allPools.push(pool);

        emit PoolCreated(token0, token1, pool, ampBps, allPools.length);
    }

    function setFeeConfiguration(address _feeTo, uint16 _governmentFeeBps) external override {
        require(msg.sender == feeToSetter, "DMM: FORBIDDEN");
        require(_governmentFeeBps > 0 && _governmentFeeBps < 2000, "DMM: INVALID FEE");
        feeTo = _feeTo;
        governmentFeeBps = _governmentFeeBps;

        emit SetFeeConfiguration(_feeTo, _governmentFeeBps);
    }

    function setFeeToSetter(address _feeToSetter) external override {
        require(msg.sender == feeToSetter, "DMM: FORBIDDEN");
        feeToSetter = _feeToSetter;

        emit SetFeeToSetter(_feeToSetter);
    }

    function getFeeConfiguration()
        external
        override
        view
        returns (address _feeTo, uint16 _governmentFeeBps)
    {
        _feeTo = feeTo;
        _governmentFeeBps = governmentFeeBps;
    }

    function allPoolsLength() external override view returns (uint256) {
        return allPools.length;
    }

    function getPools(IERC20 token0, IERC20 token1)
        external
        override
        view
        returns (address[] memory _tokenPools)
    {
        uint256 length = tokenPools[token0][token1].length();
        _tokenPools = new address[](length);
        for (uint256 i = 0; i < length; i++) {
            _tokenPools[i] = tokenPools[token0][token1].at(i);
        }
    }

    function getPoolsLength(IERC20 token0, IERC20 token1) external view returns (uint256) {
        return tokenPools[token0][token1].length();
    }

    function getPoolAtIndex(
        IERC20 token0,
        IERC20 token1,
        uint256 index
    ) external view returns (address pool) {
        return tokenPools[token0][token1].at(index);
    }

    function isPool(
        IERC20 token0,
        IERC20 token1,
        address pool
    ) external override view returns (bool) {
        return tokenPools[token0][token1].contains(pool);
    }
}


// File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol@v1.1.0-beta.0

pragma solidity >=0.6.2;

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}


// File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol@v1.1.0-beta.0

pragma solidity >=0.6.2;

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}


// File contracts/interfaces/IWETH.sol

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.6.12;

interface IWETH is IERC20 {
    function deposit() external payable;

    function withdraw(uint256) external;
}


// File contracts/libraries/DMMLibrary.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.6.12;


library DMMLibrary {
    using SafeMath for uint256;

    uint256 public constant PRECISION = 1e18;

    // returns sorted token addresses, used to handle return values from pools sorted in this order
    function sortTokens(IERC20 tokenA, IERC20 tokenB)
        internal
        pure
        returns (IERC20 token0, IERC20 token1)
    {
        require(tokenA != tokenB, "DMMLibrary: IDENTICAL_ADDRESSES");
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(address(token0) != address(0), "DMMLibrary: ZERO_ADDRESS");
    }

    /// @dev fetch the reserves and fee for a pool, used for trading purposes
    function getTradeInfo(
        address pool,
        IERC20 tokenA,
        IERC20 tokenB
    )
        internal
        view
        returns (
            uint256 reserveA,
            uint256 reserveB,
            uint256 vReserveA,
            uint256 vReserveB,
            uint256 feeInPrecision
        )
    {
        (IERC20 token0, ) = sortTokens(tokenA, tokenB);
        uint256 reserve0;
        uint256 reserve1;
        uint256 vReserve0;
        uint256 vReserve1;
        (reserve0, reserve1, vReserve0, vReserve1, feeInPrecision) = IDMMPool(pool).getTradeInfo();
        (reserveA, reserveB, vReserveA, vReserveB) = tokenA == token0
            ? (reserve0, reserve1, vReserve0, vReserve1)
            : (reserve1, reserve0, vReserve1, vReserve0);
    }

    /// @dev fetches the reserves for a pool, used for liquidity adding
    function getReserves(
        address pool,
        IERC20 tokenA,
        IERC20 tokenB
    ) internal view returns (uint256 reserveA, uint256 reserveB) {
        (IERC20 token0, ) = sortTokens(tokenA, tokenB);
        (uint256 reserve0, uint256 reserve1) = IDMMPool(pool).getReserves();
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }

    // given some amount of an asset and pool reserves, returns an equivalent amount of the other asset
    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) internal pure returns (uint256 amountB) {
        require(amountA > 0, "DMMLibrary: INSUFFICIENT_AMOUNT");
        require(reserveA > 0 && reserveB > 0, "DMMLibrary: INSUFFICIENT_LIQUIDITY");
        amountB = amountA.mul(reserveB) / reserveA;
    }

    // given an input amount of an asset and pool reserves, returns the maximum output amount of the other asset
    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut,
        uint256 vReserveIn,
        uint256 vReserveOut,
        uint256 feeInPrecision
    ) internal pure returns (uint256 amountOut) {
        require(amountIn > 0, "DMMLibrary: INSUFFICIENT_INPUT_AMOUNT");
        require(reserveIn > 0 && reserveOut > 0, "DMMLibrary: INSUFFICIENT_LIQUIDITY");
        uint256 amountInWithFee = amountIn.mul(PRECISION.sub(feeInPrecision)).div(PRECISION);
        uint256 numerator = amountInWithFee.mul(vReserveOut);
        uint256 denominator = vReserveIn.add(amountInWithFee);
        amountOut = numerator.div(denominator);
        require(reserveOut > amountOut, "DMMLibrary: INSUFFICIENT_LIQUIDITY");
    }

    // given an output amount of an asset and pool reserves, returns a required input amount of the other asset
    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut,
        uint256 vReserveIn,
        uint256 vReserveOut,
        uint256 feeInPrecision
    ) internal pure returns (uint256 amountIn) {
        require(amountOut > 0, "DMMLibrary: INSUFFICIENT_OUTPUT_AMOUNT");
        require(reserveIn > 0 && reserveOut > amountOut, "DMMLibrary: INSUFFICIENT_LIQUIDITY");
        uint256 numerator = vReserveIn.mul(amountOut);
        uint256 denominator = vReserveOut.sub(amountOut);
        amountIn = numerator.div(denominator).add(1);
        // amountIn = floor(amountIN *PRECISION / (PRECISION - feeInPrecision));
        numerator = amountIn.mul(PRECISION);
        denominator = PRECISION.sub(feeInPrecision);
        amountIn = numerator.add(denominator - 1).div(denominator);
    }

    // performs chained getAmountOut calculations on any number of pools
    function getAmountsOut(
        uint256 amountIn,
        address[] memory poolsPath,
        IERC20[] memory path
    ) internal view returns (uint256[] memory amounts) {
        amounts = new uint256[](path.length);
        amounts[0] = amountIn;
        for (uint256 i; i < path.length - 1; i++) {
            (
                uint256 reserveIn,
                uint256 reserveOut,
                uint256 vReserveIn,
                uint256 vReserveOut,
                uint256 feeInPrecision
            ) = getTradeInfo(poolsPath[i], path[i], path[i + 1]);
            amounts[i + 1] = getAmountOut(
                amounts[i],
                reserveIn,
                reserveOut,
                vReserveIn,
                vReserveOut,
                feeInPrecision
            );
        }
    }

    // performs chained getAmountIn calculations on any number of pools
    function getAmountsIn(
        uint256 amountOut,
        address[] memory poolsPath,
        IERC20[] memory path
    ) internal view returns (uint256[] memory amounts) {
        amounts = new uint256[](path.length);
        amounts[amounts.length - 1] = amountOut;
        for (uint256 i = path.length - 1; i > 0; i--) {
            (
                uint256 reserveIn,
                uint256 reserveOut,
                uint256 vReserveIn,
                uint256 vReserveOut,
                uint256 feeInPrecision
            ) = getTradeInfo(poolsPath[i - 1], path[i - 1], path[i]);
            amounts[i - 1] = getAmountIn(
                amounts[i],
                reserveIn,
                reserveOut,
                vReserveIn,
                vReserveOut,
                feeInPrecision
            );
        }
    }
}


// File contracts/examples/ExampleFlashSwap.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.12;






contract ExampleFlashSwap is IDMMCallee {
    using SafeERC20 for IERC20;

    address public immutable factory;
    IWETH public immutable weth;
    IUniswapV2Router02 public uniswapRounter02;

    constructor(IUniswapV2Router02 _uniswapRounter02, address _factory) public {
        uniswapRounter02 = _uniswapRounter02;
        weth = IWETH(_uniswapRounter02.WETH());
        factory = _factory;
    }

    receive() external payable {}

    // gets tokens/WETH via a dmm flash swap, swaps for the WETH/tokens on uniswapV2, repays dmm, and keeps the rest!
    function dmmSwapCall(
        address sender,
        uint256 amount0,
        uint256 amount1,
        bytes calldata data
    ) external override {
        IERC20[] memory path = new IERC20[](2);
        address[] memory path2 = new address[](2);
        address[] memory poolsPath = new address[](1);
        poolsPath[0] = msg.sender;

        uint256 amountToken;
        uint256 amountETH;
        {
            // scope for token{0,1}, avoids stack too deep errors
            IERC20 token0 = IDMMPool(msg.sender).token0();
            IERC20 token1 = IDMMPool(msg.sender).token1();
            assert(IDMMFactory(factory).isPool(token0, token1, msg.sender));
            assert(amount0 == 0 || amount1 == 0); // this strategy is unidirectional
            path[0] = amount0 == 0 ? token0 : token1;
            path[1] = amount0 == 0 ? token1 : token0;
            path2[0] = address(path[1]);
            path2[1] = address(path[0]);

            amountToken = token0 == IERC20(weth) ? amount1 : amount0;
            amountETH = token0 == IERC20(weth) ? amount0 : amount1;
        }
        assert(path[0] == IERC20(weth) || path[1] == IERC20(weth)); // this strategy only works with a V2 WETH pool

        if (amountToken > 0) {
            uint256 minETH = abi.decode(data, (uint256)); // slippage parameter for V1, passed in by caller
            uint256 amountRequired = DMMLibrary.getAmountsIn(amountToken, poolsPath, path)[0];
            path[1].safeApprove(address(uniswapRounter02), amountToken);
            uint256[] memory amounts = uniswapRounter02.swapExactTokensForTokens(
                amountToken,
                minETH,
                path2,
                address(this),
                uint256(-1)
            );
            uint256 amountReceived = amounts[amounts.length - 1];
            assert(amountReceived > amountRequired); // fail if we didn't get enough ETH back to repay our flash loan

            weth.transfer(msg.sender, amountRequired);
            weth.withdraw(amountReceived - amountRequired);
            (bool success, ) = sender.call{value: amountReceived - amountRequired}(new bytes(0));
            require(success, "transfer eth failed");
        } else {
            weth.withdraw(amountETH);
            uint256 amountRequired = DMMLibrary.getAmountsIn(amountETH, poolsPath, path)[0];
            uint256[] memory amounts = uniswapRounter02.swapETHForExactTokens{value: amountETH}(
                amountRequired,
                path2,
                address(this),
                uint256(-1)
            );

            path[0].safeTransfer(msg.sender, amountRequired);
            assert(amountETH > amounts[0]); // fail if we didn't get enough tokens back to repay our flash loan
            (bool success, ) = sender.call{value: amountETH - amounts[0]}(new bytes(0));
            require(success, "transfer eth failed");
        }
    }
}


// File contracts/interfaces/IDMMExchangeRouter.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.6.12;

/// @dev an simple interface for integration dApp to swap
interface IDMMExchangeRouter {
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function getAmountsOut(
        uint256 amountIn,
        address[] calldata poolsPath,
        IERC20[] calldata path
    ) external view returns (uint256[] memory amounts);

    function getAmountsIn(
        uint256 amountOut,
        address[] calldata poolsPath,
        IERC20[] calldata path
    ) external view returns (uint256[] memory amounts);
}


// File contracts/interfaces/IDMMLiquidityRouter.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.6.12;

/// @dev an simple interface for integration dApp to contribute liquidity
interface IDMMLiquidityRouter {
    /**
     * @param tokenA address of token in the pool
     * @param tokenB address of token in the pool
     * @param pool the address of the pool
     * @param amountADesired the amount of tokenA users want to add to the pool
     * @param amountBDesired the amount of tokenB users want to add to the pool
     * @param amountAMin bounds to the extents to which amountB/amountA can go up
     * @param amountBMin bounds to the extents to which amountB/amountA can go down
     * @param vReserveRatioBounds bounds to the extents to which vReserveB/vReserveA can go (precision: 2 ** 112)
     * @param to Recipient of the liquidity tokens.
     * @param deadline Unix timestamp after which the transaction will revert.
     */
    function addLiquidity(
        IERC20 tokenA,
        IERC20 tokenB,
        address pool,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        uint256[2] calldata vReserveRatioBounds,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityNewPool(
        IERC20 tokenA,
        IERC20 tokenB,
        uint32 ampBps,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityNewPoolETH(
        IERC20 token,
        uint32 ampBps,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    /**
     * @param token address of token in the pool
     * @param pool the address of the pool
     * @param amountTokenDesired the amount of token users want to add to the pool
     * @dev   msg.value equals to amountEthDesired
     * @param amountTokenMin bounds to the extents to which WETH/token can go up
     * @param amountETHMin bounds to the extents to which WETH/token can go down
     * @param vReserveRatioBounds bounds to the extents to which vReserveB/vReserveA can go (precision: 2 ** 112)
     * @param to Recipient of the liquidity tokens.
     * @param deadline Unix timestamp after which the transaction will revert.
     */
    function addLiquidityETH(
        IERC20 token,
        address pool,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        uint256[2] calldata vReserveRatioBounds,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    /**
     * @param tokenA address of token in the pool
     * @param tokenB address of token in the pool
     * @param pool the address of the pool
     * @param liquidity the amount of lp token users want to burn
     * @param amountAMin the minimum token retuned after burning
     * @param amountBMin the minimum token retuned after burning
     * @param to Recipient of the returned tokens.
     * @param deadline Unix timestamp after which the transaction will revert.
     */
    function removeLiquidity(
        IERC20 tokenA,
        IERC20 tokenB,
        address pool,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    /**
     * @param tokenA address of token in the pool
     * @param tokenB address of token in the pool
     * @param pool the address of the pool
     * @param liquidity the amount of lp token users want to burn
     * @param amountAMin the minimum token retuned after burning
     * @param amountBMin the minimum token retuned after burning
     * @param to Recipient of the returned tokens.
     * @param deadline Unix timestamp after which the transaction will revert.
     * @param approveMax whether users permit the router spending max lp token or not.
     * @param r s v Signature of user to permit the router spending lp token
     */
    function removeLiquidityWithPermit(
        IERC20 tokenA,
        IERC20 tokenB,
        address pool,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    /**
     * @param token address of token in the pool
     * @param pool the address of the pool
     * @param liquidity the amount of lp token users want to burn
     * @param amountTokenMin the minimum token retuned after burning
     * @param amountETHMin the minimum eth in wei retuned after burning
     * @param to Recipient of the returned tokens.
     * @param deadline Unix timestamp after which the transaction will revert
     */
    function removeLiquidityETH(
        IERC20 token,
        address pool,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    /**
     * @param token address of token in the pool
     * @param pool the address of the pool
     * @param liquidity the amount of lp token users want to burn
     * @param amountTokenMin the minimum token retuned after burning
     * @param amountETHMin the minimum eth in wei retuned after burning
     * @param to Recipient of the returned tokens.
     * @param deadline Unix timestamp after which the transaction will revert
     * @param approveMax whether users permit the router spending max lp token
     * @param r s v signatures of user to permit the router spending lp token.
     */
    function removeLiquidityETHWithPermit(
        IERC20 token,
        address pool,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    /**
     * @param amountA amount of 1 side token added to the pool
     * @param reserveA current reserve of the pool
     * @param reserveB current reserve of the pool
     * @return amountB amount of the other token added to the pool
     */
    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);
}


// File contracts/interfaces/IDMMRouter01.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.6.12;



/// @dev full interface for router
interface IDMMRouter01 is IDMMExchangeRouter, IDMMLiquidityRouter {
    function factory() external pure returns (address);

    function weth() external pure returns (IWETH);
}


// File contracts/interfaces/IDMMRouter02.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.6.12;

interface IDMMRouter02 is IDMMRouter01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        IERC20 token,
        address pool,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        IERC20 token,
        address pool,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external;
}


// File contracts/interfaces/IKSExchangeRouter.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.6.12;

/// @dev an simple interface for integration dApp to swap
interface IKSExchangeRouter {
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function getAmountsOut(
        uint256 amountIn,
        address[] calldata poolsPath,
        IERC20[] calldata path
    ) external view returns (uint256[] memory amounts);

    function getAmountsIn(
        uint256 amountOut,
        address[] calldata poolsPath,
        IERC20[] calldata path
    ) external view returns (uint256[] memory amounts);
}


// File contracts/interfaces/IKSFactory.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.6.12;

interface IKSFactory {
    function createPool(
        IERC20 tokenA,
        IERC20 tokenB,
        uint32 ampBps,
        uint16 feeBps
    ) external returns (address pool);

    function setFeeConfiguration(address feeTo, uint16 governmentFeeBps) external;

    function enableFeeOption(uint16 feeBps) external;

    function disableFeeOption(uint16 feeBps) external;

    function setFeeToSetter(address) external;

    function getFeeConfiguration() external view returns (address feeTo, uint16 governmentFeeBps);

    function feeToSetter() external view returns (address);

    function allPools(uint256) external view returns (address pool);

    function allPoolsLength() external view returns (uint256);

    function getUnamplifiedPool(IERC20 token0, IERC20 token1) external view returns (address);

    function getPools(IERC20 token0, IERC20 token1)
        external
        view
        returns (address[] memory _tokenPools);

    function isPool(
        IERC20 token0,
        IERC20 token1,
        address pool
    ) external view returns (bool);
}


// File contracts/interfaces/IKSLiquidityRouter.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.6.12;

/// @dev an simple interface for integration dApp to contribute liquidity
interface IKSLiquidityRouter {
    /**
     * @param tokenA address of token in the pool
     * @param tokenB address of token in the pool
     * @param pool the address of the pool
     * @param amountADesired the amount of tokenA users want to add to the pool
     * @param amountBDesired the amount of tokenB users want to add to the pool
     * @param amountAMin bounds to the extents to which amountB/amountA can go up
     * @param amountBMin bounds to the extents to which amountB/amountA can go down
     * @param vReserveRatioBounds bounds to the extents to which vReserveB/vReserveA can go (precision: 2 ** 112)
     * @param to Recipient of the liquidity tokens.
     * @param deadline Unix timestamp after which the transaction will revert.
     */
    function addLiquidity(
        IERC20 tokenA,
        IERC20 tokenB,
        address pool,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        uint256[2] calldata vReserveRatioBounds,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityNewPool(
        IERC20 tokenA,
        IERC20 tokenB,
        uint32[2] memory ampBpsAndFeeBps,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityNewPoolETH(
        IERC20 token,
        uint32[2] memory ampBpsAndFeeBps,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    /**
     * @param token address of token in the pool
     * @param pool the address of the pool
     * @param amountTokenDesired the amount of token users want to add to the pool
     * @dev   msg.value equals to amountEthDesired
     * @param amountTokenMin bounds to the extents to which WETH/token can go up
     * @param amountETHMin bounds to the extents to which WETH/token can go down
     * @param vReserveRatioBounds bounds to the extents to which vReserveB/vReserveA can go (precision: 2 ** 112)
     * @param to Recipient of the liquidity tokens.
     * @param deadline Unix timestamp after which the transaction will revert.
     */
    function addLiquidityETH(
        IERC20 token,
        address pool,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        uint256[2] calldata vReserveRatioBounds,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    /**
     * @param tokenA address of token in the pool
     * @param tokenB address of token in the pool
     * @param pool the address of the pool
     * @param liquidity the amount of lp token users want to burn
     * @param amountAMin the minimum token retuned after burning
     * @param amountBMin the minimum token retuned after burning
     * @param to Recipient of the returned tokens.
     * @param deadline Unix timestamp after which the transaction will revert.
     */
    function removeLiquidity(
        IERC20 tokenA,
        IERC20 tokenB,
        address pool,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    /**
     * @param tokenA address of token in the pool
     * @param tokenB address of token in the pool
     * @param pool the address of the pool
     * @param liquidity the amount of lp token users want to burn
     * @param amountAMin the minimum token retuned after burning
     * @param amountBMin the minimum token retuned after burning
     * @param to Recipient of the returned tokens.
     * @param deadline Unix timestamp after which the transaction will revert.
     * @param approveMax whether users permit the router spending max lp token or not.
     * @param r s v Signature of user to permit the router spending lp token
     */
    function removeLiquidityWithPermit(
        IERC20 tokenA,
        IERC20 tokenB,
        address pool,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    /**
     * @param token address of token in the pool
     * @param pool the address of the pool
     * @param liquidity the amount of lp token users want to burn
     * @param amountTokenMin the minimum token retuned after burning
     * @param amountETHMin the minimum eth in wei retuned after burning
     * @param to Recipient of the returned tokens.
     * @param deadline Unix timestamp after which the transaction will revert
     */
    function removeLiquidityETH(
        IERC20 token,
        address pool,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    /**
     * @param token address of token in the pool
     * @param pool the address of the pool
     * @param liquidity the amount of lp token users want to burn
     * @param amountTokenMin the minimum token retuned after burning
     * @param amountETHMin the minimum eth in wei retuned after burning
     * @param to Recipient of the returned tokens.
     * @param deadline Unix timestamp after which the transaction will revert
     * @param approveMax whether users permit the router spending max lp token
     * @param r s v signatures of user to permit the router spending lp token.
     */
    function removeLiquidityETHWithPermit(
        IERC20 token,
        address pool,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    /**
     * @param amountA amount of 1 side token added to the pool
     * @param reserveA current reserve of the pool
     * @param reserveB current reserve of the pool
     * @return amountB amount of the other token added to the pool
     */
    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);
}


// File contracts/interfaces/IKSPool.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.6.12;

interface IKSPool {
    function mint(address to) external returns (uint256 liquidity);

    function burn(address to) external returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function sync() external;

    function getReserves() external view returns (uint112 reserve0, uint112 reserve1);

    function getTradeInfo()
        external
        view
        returns (
            uint112 _vReserve0,
            uint112 _vReserve1,
            uint112 reserve0,
            uint112 reserve1,
            uint256 feeInPrecision
        );

    function token0() external view returns (IERC20);

    function token1() external view returns (IERC20);

    function ampBps() external view returns (uint32);

    function factory() external view returns (IKSFactory);

    function kLast() external view returns (uint256);
}


// File contracts/interfaces/IKSRouter01.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.6.12;



/// @dev full interface for router
interface IKSRouter01 is IKSExchangeRouter, IKSLiquidityRouter {
    function factory() external pure returns (address);

    function weth() external pure returns (IWETH);
}


// File contracts/interfaces/IKSRouter02.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.6.12;

interface IKSRouter02 is IKSRouter01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        IERC20 token,
        address pool,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        IERC20 token,
        address pool,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external;
}


// File contracts/interfaces/IKSCallee.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.6.12;

interface IKSCallee {
    function ksSwapCall(
        address sender,
        uint256 amount0,
        uint256 amount1,
        bytes calldata data
    ) external;
}


// File contracts/KSPool.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.6.12;








contract KSPool is IKSPool, ERC20Permit, ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    uint256 internal constant MAX_UINT112 = 2**112 - 1;
    uint256 internal constant BPS = 10000;

    struct ReserveData {
        uint256 reserve0;
        uint256 reserve1;
        uint256 vReserve0;
        uint256 vReserve1; // only used when isAmpPool = true
    }

    uint256 public constant MINIMUM_LIQUIDITY = 10**3;
    uint256 internal constant PRECISION = 10**18;

    /// @dev To make etherscan auto-verify new pool, these variables are not immutable
    IKSFactory public override factory;
    IERC20 public override token0;
    IERC20 public override token1;

    /// @dev uses single storage slot, accessible via getReservesData
    uint112 internal reserve0;
    uint112 internal reserve1;
    uint32 public override ampBps;
    /// @dev addition param only when amplification factor > 1
    uint112 internal vReserve0;
    uint112 internal vReserve1;

    /// @dev vReserve0 * vReserve1, as of immediately after the most recent liquidity event
    uint256 public override kLast;

    /// @dev fixed fee for swap
    uint256 internal feeInPrecision;

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to,
        uint256 feeInPrecision
    );
    event Sync(uint256 vReserve0, uint256 vReserve1, uint256 reserve0, uint256 reserve1);

    constructor() public ERC20Permit("KyberSwap LP", "KS-LP", "1") {
        factory = IKSFactory(msg.sender);
    }

    // called once by the factory at time of deployment
    function initialize(
        IERC20 _token0,
        IERC20 _token1,
        uint32 _ampBps,
        uint16 _feeBps
    ) external {
        require(msg.sender == address(factory), "KS: FORBIDDEN");
        token0 = _token0;
        token1 = _token1;
        ampBps = _ampBps;
        feeInPrecision = (_feeBps * PRECISION) / BPS;
    }

    /// @dev this low-level function should be called from a contract
    ///                 which performs important safety checks
    function mint(address to) external override nonReentrant returns (uint256 liquidity) {
        (bool isAmpPool, ReserveData memory data) = getReservesData();
        ReserveData memory _data;
        _data.reserve0 = token0.balanceOf(address(this));
        _data.reserve1 = token1.balanceOf(address(this));
        uint256 amount0 = _data.reserve0.sub(data.reserve0);
        uint256 amount1 = _data.reserve1.sub(data.reserve1);

        bool feeOn = _mintFee(isAmpPool, data);
        uint256 _totalSupply = totalSupply(); // gas savings, must be defined here since totalSupply can update in _mintFee
        if (_totalSupply == 0) {
            if (isAmpPool) {
                uint32 _ampBps = ampBps;
                _data.vReserve0 = _data.reserve0.mul(_ampBps) / BPS;
                _data.vReserve1 = _data.reserve1.mul(_ampBps) / BPS;
            }
            liquidity = MathExt.sqrt(amount0.mul(amount1)).sub(MINIMUM_LIQUIDITY);
            _mint(address(-1), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens
        } else {
            liquidity = Math.min(
                amount0.mul(_totalSupply) / data.reserve0,
                amount1.mul(_totalSupply) / data.reserve1
            );
            if (isAmpPool) {
                uint256 b = liquidity.add(_totalSupply);
                _data.vReserve0 = Math.max(data.vReserve0.mul(b) / _totalSupply, _data.reserve0);
                _data.vReserve1 = Math.max(data.vReserve1.mul(b) / _totalSupply, _data.reserve1);
            }
        }
        require(liquidity > 0, "KS: INSUFFICIENT_LIQUIDITY_MINTED");
        _mint(to, liquidity);

        _update(isAmpPool, _data);
        if (feeOn) kLast = getK(isAmpPool, _data);
        emit Mint(msg.sender, amount0, amount1);
    }

    /// @dev this low-level function should be called from a contract
    /// @dev which performs important safety checks
    /// @dev user must transfer LP token to this contract before call burn
    function burn(address to)
        external
        override
        nonReentrant
        returns (uint256 amount0, uint256 amount1)
    {
        (bool isAmpPool, ReserveData memory data) = getReservesData(); // gas savings
        IERC20 _token0 = token0; // gas savings
        IERC20 _token1 = token1; // gas savings

        uint256 balance0 = _token0.balanceOf(address(this));
        uint256 balance1 = _token1.balanceOf(address(this));
        require(balance0 >= data.reserve0 && balance1 >= data.reserve1, "KS: UNSYNC_RESERVES");
        uint256 liquidity = balanceOf(address(this));

        bool feeOn = _mintFee(isAmpPool, data);
        uint256 _totalSupply = totalSupply(); // gas savings, must be defined here since totalSupply can update in _mintFee
        amount0 = liquidity.mul(balance0) / _totalSupply; // using balances ensures pro-rata distribution
        amount1 = liquidity.mul(balance1) / _totalSupply; // using balances ensures pro-rata distribution
        require(amount0 > 0 && amount1 > 0, "KS: INSUFFICIENT_LIQUIDITY_BURNED");
        _burn(address(this), liquidity);
        _token0.safeTransfer(to, amount0);
        _token1.safeTransfer(to, amount1);
        ReserveData memory _data;
        _data.reserve0 = _token0.balanceOf(address(this));
        _data.reserve1 = _token1.balanceOf(address(this));
        if (isAmpPool) {
            uint256 b = Math.min(
                _data.reserve0.mul(_totalSupply) / data.reserve0,
                _data.reserve1.mul(_totalSupply) / data.reserve1
            );
            _data.vReserve0 = Math.max(data.vReserve0.mul(b) / _totalSupply, _data.reserve0);
            _data.vReserve1 = Math.max(data.vReserve1.mul(b) / _totalSupply, _data.reserve1);
        }
        _update(isAmpPool, _data);
        if (feeOn) kLast = getK(isAmpPool, _data); // data are up-to-date
        emit Burn(msg.sender, amount0, amount1, to);
    }

    /// @dev this low-level function should be called from a contract
    /// @dev which performs important safety checks
    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata callbackData
    ) external override nonReentrant {
        require(amount0Out > 0 || amount1Out > 0, "KS: INSUFFICIENT_OUTPUT_AMOUNT");
        (bool isAmpPool, ReserveData memory data) = getReservesData(); // gas savings
        require(
            amount0Out < data.reserve0 && amount1Out < data.reserve1,
            "KS: INSUFFICIENT_LIQUIDITY"
        );

        ReserveData memory newData;
        {
            // scope for _token{0,1}, avoids stack too deep errors
            IERC20 _token0 = token0;
            IERC20 _token1 = token1;
            require(to != address(_token0) && to != address(_token1), "KS: INVALID_TO");
            if (amount0Out > 0) _token0.safeTransfer(to, amount0Out); // optimistically transfer tokens
            if (amount1Out > 0) _token1.safeTransfer(to, amount1Out); // optimistically transfer tokens
            if (callbackData.length > 0)
                IKSCallee(to).ksSwapCall(msg.sender, amount0Out, amount1Out, callbackData);
            newData.reserve0 = _token0.balanceOf(address(this));
            newData.reserve1 = _token1.balanceOf(address(this));
            if (isAmpPool) {
                newData.vReserve0 = data.vReserve0.add(newData.reserve0).sub(data.reserve0);
                newData.vReserve1 = data.vReserve1.add(newData.reserve1).sub(data.reserve1);
            }
        }
        uint256 amount0In = newData.reserve0 > data.reserve0 - amount0Out
            ? newData.reserve0 - (data.reserve0 - amount0Out)
            : 0;
        uint256 amount1In = newData.reserve1 > data.reserve1 - amount1Out
            ? newData.reserve1 - (data.reserve1 - amount1Out)
            : 0;
        require(amount0In > 0 || amount1In > 0, "KS: INSUFFICIENT_INPUT_AMOUNT");
        verifyBalance(
            amount0In,
            amount1In,
            isAmpPool ? data.vReserve0 : data.reserve0,
            isAmpPool ? data.vReserve1 : data.reserve1,
            isAmpPool ? newData.vReserve0 : newData.reserve0,
            isAmpPool ? newData.vReserve1 : newData.reserve1
        );

        _update(isAmpPool, newData);
        emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to, feeInPrecision);
    }

    /// @dev force balances to match reserves
    function skim(address to) external nonReentrant {
        token0.safeTransfer(to, token0.balanceOf(address(this)).sub(reserve0));
        token1.safeTransfer(to, token1.balanceOf(address(this)).sub(reserve1));
    }

    /// @dev force reserves to match balances
    function sync() external override nonReentrant {
        (bool isAmpPool, ReserveData memory data) = getReservesData();
        bool feeOn = _mintFee(isAmpPool, data);
        ReserveData memory newData;
        newData.reserve0 = IERC20(token0).balanceOf(address(this));
        newData.reserve1 = IERC20(token1).balanceOf(address(this));
        // update virtual reserves if this is amp pool
        if (isAmpPool) {
            uint256 _totalSupply = totalSupply();
            uint256 b = Math.min(
                newData.reserve0.mul(_totalSupply) / data.reserve0,
                newData.reserve1.mul(_totalSupply) / data.reserve1
            );
            newData.vReserve0 = Math.max(data.vReserve0.mul(b) / _totalSupply, newData.reserve0);
            newData.vReserve1 = Math.max(data.vReserve1.mul(b) / _totalSupply, newData.reserve1);
        }
        _update(isAmpPool, newData);
        if (feeOn) kLast = getK(isAmpPool, newData);
    }

    /// @dev returns data to calculate amountIn, amountOut
    function getTradeInfo()
        external
        virtual
        override
        view
        returns (
            uint112 _reserve0,
            uint112 _reserve1,
            uint112 _vReserve0,
            uint112 _vReserve1,
            uint256 _feeInPrecision
        )
    {
        // gas saving to read reserve data
        _reserve0 = reserve0;
        _reserve1 = reserve1;
        uint32 _ampBps = ampBps;
        _vReserve0 = vReserve0;
        _vReserve1 = vReserve1;
        if (_ampBps == BPS) {
            _vReserve0 = _reserve0;
            _vReserve1 = _reserve1;
        }
        _feeInPrecision = feeInPrecision;
    }

    /// @dev returns reserve data to calculate amount to add liquidity
    function getReserves() external override view returns (uint112 _reserve0, uint112 _reserve1) {
        _reserve0 = reserve0;
        _reserve1 = reserve1;
    }

    function name() public override view returns (string memory) {
        IERC20Metadata _token0 = IERC20Metadata(address(token0));
        IERC20Metadata _token1 = IERC20Metadata(address(token1));
        return string(abi.encodePacked("KyberSwap LP ", _token0.symbol(), "-", _token1.symbol()));
    }

    function symbol() public override view returns (string memory) {
        IERC20Metadata _token0 = IERC20Metadata(address(token0));
        IERC20Metadata _token1 = IERC20Metadata(address(token1));
        return string(abi.encodePacked("KS-LP ", _token0.symbol(), "-", _token1.symbol()));
    }

    function verifyBalance(
        uint256 amount0In,
        uint256 amount1In,
        uint256 beforeReserve0,
        uint256 beforeReserve1,
        uint256 afterReserve0,
        uint256 afterReserve1
    ) internal virtual view {
        // verify balance update matches with fomula
        uint256 balance0Adjusted = afterReserve0.mul(PRECISION);
        balance0Adjusted = balance0Adjusted.sub(amount0In.mul(feeInPrecision));
        balance0Adjusted = balance0Adjusted / PRECISION;
        uint256 balance1Adjusted = afterReserve1.mul(PRECISION);
        balance1Adjusted = balance1Adjusted.sub(amount1In.mul(feeInPrecision));
        balance1Adjusted = balance1Adjusted / PRECISION;
        require(
            balance0Adjusted.mul(balance1Adjusted) >= beforeReserve0.mul(beforeReserve1),
            "KS: K"
        );
    }

    /// @dev update reserves
    function _update(bool isAmpPool, ReserveData memory data) internal {
        reserve0 = safeUint112(data.reserve0);
        reserve1 = safeUint112(data.reserve1);
        if (isAmpPool) {
            assert(data.vReserve0 >= data.reserve0 && data.vReserve1 >= data.reserve1); // never happen
            vReserve0 = safeUint112(data.vReserve0);
            vReserve1 = safeUint112(data.vReserve1);
        }
        emit Sync(data.vReserve0, data.vReserve1, data.reserve0, data.reserve1);
    }

    /// @dev if fee is on, mint liquidity equivalent to configured fee of the growth in sqrt(k)
    function _mintFee(bool isAmpPool, ReserveData memory data) internal returns (bool feeOn) {
        (address feeTo, uint16 governmentFeeBps) = factory.getFeeConfiguration();
        feeOn = feeTo != address(0);
        uint256 _kLast = kLast; // gas savings
        if (feeOn) {
            if (_kLast != 0) {
                uint256 rootK = MathExt.sqrt(getK(isAmpPool, data));
                uint256 rootKLast = MathExt.sqrt(_kLast);
                if (rootK > rootKLast) {
                    uint256 numerator = totalSupply().mul(rootK.sub(rootKLast)).mul(
                        governmentFeeBps
                    );
                    uint256 denominator = rootK.add(rootKLast).mul(5000);
                    uint256 liquidity = numerator / denominator;
                    if (liquidity > 0) _mint(feeTo, liquidity);
                }
            }
        } else if (_kLast != 0) {
            kLast = 0;
        }
    }

    /// @dev gas saving to read reserve data
    function getReservesData() internal view returns (bool isAmpPool, ReserveData memory data) {
        data.reserve0 = reserve0;
        data.reserve1 = reserve1;
        isAmpPool = ampBps != BPS;
        if (isAmpPool) {
            data.vReserve0 = vReserve0;
            data.vReserve1 = vReserve1;
        }
    }

    function getK(bool isAmpPool, ReserveData memory data) internal pure returns (uint256) {
        return isAmpPool ? data.vReserve0 * data.vReserve1 : data.reserve0 * data.reserve1;
    }

    function safeUint112(uint256 x) internal pure returns (uint112) {
        require(x <= MAX_UINT112, "KS: OVERFLOW");
        return uint112(x);
    }
}


// File contracts/KSFactory.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.6.12;


contract KSFactory is IKSFactory {
    using EnumerableSet for EnumerableSet.AddressSet;

    uint256 internal constant BPS = 10000;

    address private feeTo;
    uint16 private governmentFeeBps;
    address public override feeToSetter;

    /// @dev fee to set for pools
    mapping(uint16 => bool) public feeOptions;

    mapping(IERC20 => mapping(IERC20 => EnumerableSet.AddressSet)) internal tokenPools;
    mapping(IERC20 => mapping(IERC20 => address)) public override getUnamplifiedPool;
    address[] public override allPools;

    event PoolCreated(
        IERC20 indexed token0,
        IERC20 indexed token1,
        address pool,
        uint32 ampBps,
        uint16 feeBps,
        uint256 totalPool
    );
    event SetFeeConfiguration(address feeTo, uint16 governmentFeeBps);
    event EnableFeeOption(uint16 feeBps);
    event DisableFeeOption(uint16 feeBps);
    event SetFeeToSetter(address feeToSetter);

    modifier onlyFeeSetter() {
        require(msg.sender == feeToSetter, "only fee setter");
        _;
    }

    constructor(address _feeToSetter) public {
        feeToSetter = _feeToSetter;

        feeOptions[1] = true;
        feeOptions[5] = true;
        feeOptions[30] = true;
        feeOptions[50] = true;
        feeOptions[100] = true;
    }

    function createPool(
        IERC20 tokenA,
        IERC20 tokenB,
        uint32 ampBps,
        uint16 feeBps
    ) external override returns (address pool) {
        require(tokenA != tokenB, "KS: IDENTICAL_ADDRESSES");
        (IERC20 token0, IERC20 token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(address(token0) != address(0), "KS: ZERO_ADDRESS");
        require(ampBps >= BPS, "KS: INVALID_BPS");
        // only exist 1 unamplified pool of a pool.
        require(
            ampBps != BPS || getUnamplifiedPool[token0][token1] == address(0),
            "KS: UNAMPLIFIED_POOL_EXISTS"
        );
        require(feeOptions[feeBps], "KS: FEE_OPTION_NOT_EXISTS");
        pool = address(new KSPool());
        KSPool(pool).initialize(token0, token1, ampBps, feeBps);
        // populate mapping in the reverse direction
        tokenPools[token0][token1].add(pool);
        tokenPools[token1][token0].add(pool);
        if (ampBps == BPS) {
            getUnamplifiedPool[token0][token1] = pool;
            getUnamplifiedPool[token1][token0] = pool;
        }
        allPools.push(pool);

        emit PoolCreated(token0, token1, pool, ampBps, feeBps, allPools.length);
    }

    function setFeeConfiguration(address _feeTo, uint16 _governmentFeeBps)
        external
        override
        onlyFeeSetter
    {
        require(_governmentFeeBps > 0 && _governmentFeeBps < 2000, "KS: INVALID FEE");
        feeTo = _feeTo;
        governmentFeeBps = _governmentFeeBps;

        emit SetFeeConfiguration(_feeTo, _governmentFeeBps);
    }

    function enableFeeOption(uint16 _feeBps) external override onlyFeeSetter {
        require(_feeBps > 0, "KS: INVALID FEE");
        feeOptions[_feeBps] = true;

        emit EnableFeeOption(_feeBps);
    }

    function disableFeeOption(uint16 _feeBps) external override onlyFeeSetter {
        require(_feeBps > 0, "KS: INVALID FEE");
        feeOptions[_feeBps] = false;

        emit DisableFeeOption(_feeBps);
    }

    function setFeeToSetter(address _feeToSetter) external override onlyFeeSetter {
        feeToSetter = _feeToSetter;

        emit SetFeeToSetter(_feeToSetter);
    }

    function getFeeConfiguration()
        external
        override
        view
        returns (address _feeTo, uint16 _governmentFeeBps)
    {
        _feeTo = feeTo;
        _governmentFeeBps = governmentFeeBps;
    }

    function allPoolsLength() external override view returns (uint256) {
        return allPools.length;
    }

    function getPools(IERC20 token0, IERC20 token1)
        external
        override
        view
        returns (address[] memory _tokenPools)
    {
        uint256 length = tokenPools[token0][token1].length();
        _tokenPools = new address[](length);
        for (uint256 i = 0; i < length; i++) {
            _tokenPools[i] = tokenPools[token0][token1].at(i);
        }
    }

    function getPoolsLength(IERC20 token0, IERC20 token1) external view returns (uint256) {
        return tokenPools[token0][token1].length();
    }

    function getPoolAtIndex(
        IERC20 token0,
        IERC20 token1,
        uint256 index
    ) external view returns (address pool) {
        return tokenPools[token0][token1].at(index);
    }

    function isPool(
        IERC20 token0,
        IERC20 token1,
        address pool
    ) external override view returns (bool) {
        return tokenPools[token0][token1].contains(pool);
    }
}


// File contracts/libraries/KSLibrary.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.6.12;


library KSLibrary {
  using SafeMath for uint256;

  uint256 public constant PRECISION = 1e18;

  // returns sorted token addresses, used to handle return values from pools sorted in this order
  function sortTokens(IERC20 tokenA, IERC20 tokenB)
    internal
    pure
    returns (IERC20 token0, IERC20 token1)
  {
    require(tokenA != tokenB, "KSLibrary: IDENTICAL_ADDRESSES");
    (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
    require(address(token0) != address(0), "KSLibrary: ZERO_ADDRESS");
  }

  /// @dev fetch the reserves and fee for a pool, used for trading purposes
  function getTradeInfo(
    address pool,
    IERC20 tokenA,
    IERC20 tokenB
  )
    internal
    view
    returns (
      uint256 reserveA,
      uint256 reserveB,
      uint256 vReserveA,
      uint256 vReserveB,
      uint256 feeInPrecision
    )
  {
    (IERC20 token0, ) = sortTokens(tokenA, tokenB);
    uint256 reserve0;
    uint256 reserve1;
    uint256 vReserve0;
    uint256 vReserve1;
    (reserve0, reserve1, vReserve0, vReserve1, feeInPrecision) = IKSPool(pool)
      .getTradeInfo();
    (reserveA, reserveB, vReserveA, vReserveB) = tokenA == token0
      ? (reserve0, reserve1, vReserve0, vReserve1)
      : (reserve1, reserve0, vReserve1, vReserve0);
  }

  /// @dev fetches the reserves for a pool, used for liquidity adding
  function getReserves(
    address pool,
    IERC20 tokenA,
    IERC20 tokenB
  ) internal view returns (uint256 reserveA, uint256 reserveB) {
    (IERC20 token0, ) = sortTokens(tokenA, tokenB);
    (uint256 reserve0, uint256 reserve1) = IKSPool(pool).getReserves();
    (reserveA, reserveB) = tokenA == token0
      ? (reserve0, reserve1)
      : (reserve1, reserve0);
  }

  // given some amount of an asset and pool reserves, returns an equivalent amount of the other asset
  function quote(
    uint256 amountA,
    uint256 reserveA,
    uint256 reserveB
  ) internal pure returns (uint256 amountB) {
    require(amountA > 0, "KSLibrary: INSUFFICIENT_AMOUNT");
    require(reserveA > 0 && reserveB > 0, "KSLibrary: INSUFFICIENT_LIQUIDITY");
    amountB = amountA.mul(reserveB) / reserveA;
  }

  // given an input amount of an asset and pool reserves, returns the maximum output amount of the other asset
  function getAmountOut(
    uint256 amountIn,
    uint256 reserveIn,
    uint256 reserveOut,
    uint256 vReserveIn,
    uint256 vReserveOut,
    uint256 feeInPrecision
  ) internal pure returns (uint256 amountOut) {
    require(amountIn > 0, "KSLibrary: INSUFFICIENT_INPUT_AMOUNT");
    require(
      reserveIn > 0 && reserveOut > 0,
      "KSLibrary: INSUFFICIENT_LIQUIDITY"
    );
    uint256 amountInWithFee = amountIn.mul(PRECISION.sub(feeInPrecision)).div( // 99989999722410112
      PRECISION
    );
    uint256 numerator = amountInWithFee.mul(vReserveOut);
    uint256 denominator = vReserveIn.add(amountInWithFee);
    amountOut = numerator.div(denominator);
    require(reserveOut > amountOut, "KSLibrary: INSUFFICIENT_LIQUIDITY");
  }

  function getAmountOutV2(
    uint256 amountIn,
    uint256 reserveIn,
    uint256 reserveOut,
    uint256 vReserveIn,
    uint256 vReserveOut,
    uint256 feeInPrecision
  ) internal pure returns (uint256 amountOut) {
    require(amountIn > 0, "KSLibrary: INSUFFICIENT_INPUT_AMOUNT");
    require(
      reserveIn > 0 && reserveOut > 0,
      "KSLibrary: INSUFFICIENT_LIQUIDITY"
    );
    uint256 amountInWithFee = amountIn.mul(PRECISION.sub(feeInPrecision)).div(
      PRECISION
    );
    uint256 numerator = amountInWithFee.mul(vReserveOut);
    uint256 denominator = vReserveIn.add(amountInWithFee);
    amountOut = numerator.div(denominator);
  }

  // given an output amount of an asset and pool reserves, returns a required input amount of the other asset
  function getAmountIn(
    uint256 amountOut,
    uint256 reserveIn,
    uint256 reserveOut,
    uint256 vReserveIn,
    uint256 vReserveOut,
    uint256 feeInPrecision
  ) internal pure returns (uint256 amountIn) {
    require(amountOut > 0, "KSLibrary: INSUFFICIENT_OUTPUT_AMOUNT");
    require(
      reserveIn > 0 && reserveOut > amountOut,
      "KSLibrary: INSUFFICIENT_LIQUIDITY"
    );
    uint256 numerator = vReserveIn.mul(amountOut);
    uint256 denominator = vReserveOut.sub(amountOut);
    amountIn = numerator.div(denominator).add(1);
    // amountIn = floor(amountIN *PRECISION / (PRECISION - feeInPrecision));
    numerator = amountIn.mul(PRECISION);
    denominator = PRECISION.sub(feeInPrecision);
    amountIn = numerator.add(denominator - 1).div(denominator);
  }

  // performs chained getAmountOut calculations on any number of pools
  function getAmountsOut(
    uint256 amountIn,
    address[] memory poolsPath,
    IERC20[] memory path
  ) internal view returns (uint256[] memory amounts) {
    amounts = new uint256[](path.length);
    amounts[0] = amountIn;
    for (uint256 i; i < path.length - 1; i++) {
      (
        uint256 reserveIn,
        uint256 reserveOut,
        uint256 vReserveIn,
        uint256 vReserveOut,
        uint256 feeInPrecision
      ) = getTradeInfo(poolsPath[i], path[i], path[i + 1]);
      amounts[i + 1] = getAmountOut(
        amounts[i],
        reserveIn,
        reserveOut,
        vReserveIn,
        vReserveOut,
        feeInPrecision
      );
    }
  }

  // performs chained getAmountIn calculations on any number of pools
  function getAmountsIn(
    uint256 amountOut,
    address[] memory poolsPath,
    IERC20[] memory path
  ) internal view returns (uint256[] memory amounts) {
    amounts = new uint256[](path.length);
    amounts[amounts.length - 1] = amountOut;
    for (uint256 i = path.length - 1; i > 0; i--) {
      (
        uint256 reserveIn,
        uint256 reserveOut,
        uint256 vReserveIn,
        uint256 vReserveOut,
        uint256 feeInPrecision
      ) = getTradeInfo(poolsPath[i - 1], path[i - 1], path[i]);
      amounts[i - 1] = getAmountIn(
        amounts[i],
        reserveIn,
        reserveOut,
        vReserveIn,
        vReserveOut,
        feeInPrecision
      );
    }
  }
}


// File contracts/mock/fee/IKyberDao.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.12;

interface IEpochUtils {
    function epochPeriodInSeconds() external view returns (uint256);

    function firstEpochStartTimestamp() external view returns (uint256);

    function getCurrentEpochNumber() external view returns (uint256);

    function getEpochNumber(uint256 timestamp) external view returns (uint256);
}

interface IKyberDao is IEpochUtils {
    event Voted(
        address indexed staker,
        uint256 indexed epoch,
        uint256 indexed campaignID,
        uint256 option
    );

    function getLatestNetworkFeeDataWithCache()
        external
        returns (uint256 feeInBps, uint256 expiryTimestamp);

    function getLatestBRRDataWithCache()
        external
        returns (
            uint256 burnInBps,
            uint256 rewardInBps,
            uint256 rebateInBps,
            uint256 epoch,
            uint256 expiryTimestamp
        );

    function handleWithdrawal(address staker, uint256 penaltyAmount) external;

    function vote(uint256 campaignID, uint256 option) external;

    function getLatestNetworkFeeData()
        external
        view
        returns (uint256 feeInBps, uint256 expiryTimestamp);

    function shouldBurnRewardForEpoch(uint256 epoch) external view returns (bool);

    /**
     * @dev  return staker's reward percentage in precision for a past epoch only
     *       fee handler should call this function when a staker wants to claim reward
     *       return 0 if staker has no votes or stakes
     */
    function getPastEpochRewardPercentageInPrecision(address staker, uint256 epoch)
        external
        view
        returns (uint256);

    /**
     * @dev  return staker's reward percentage in precision for the current epoch
     *       reward percentage is not finalized until the current epoch is ended
     */
    function getCurrentEpochRewardPercentageInPrecision(address staker)
        external
        view
        returns (uint256);
}


// File contracts/mock/fee/FeeTo.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.12;




contract DaoOperator {
    address public daoOperator;

    constructor(address _daoOperator) public {
        require(_daoOperator != address(0), "daoOperator is 0");
        daoOperator = _daoOperator;
    }

    modifier onlyDaoOperator() {
        require(msg.sender == daoOperator, "only daoOperator");
        _;
    }
}

contract FeeTo is DaoOperator, ReentrancyGuard {
    uint256 internal constant PRECISION = (10**18);

    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IKyberDao public immutable kyberDao;

    mapping(uint256 => mapping(IERC20 => uint256)) public rewardsPerEpoch;
    mapping(uint256 => mapping(IERC20 => uint256)) public rewardsPaidPerEpoch;
    // hasClaimedReward[staker][epoch]: true/false if the staker has/hasn't claimed the reward for an epoch
    mapping(address => mapping(uint256 => mapping(IERC20 => bool))) public hasClaimedReward;
    mapping(IERC20 => uint256) public reserves; // total balance in the contract that is for reward and platform fee

    mapping(IERC20 => bool) public allowedToken;
    mapping(IERC20 => uint256) public lastFinalizedEpoch;

    event FeeDistributed(IERC20 indexed token, uint256 indexed epoch, uint256 rewardWei);
    event RewardPaid(
        address indexed staker,
        uint256 indexed epoch,
        IERC20 indexed token,
        uint256 amount
    );
    event SetAllowedToken(IERC20 token, bool isAllowed);

    constructor(IKyberDao _kyberDao, address _daoOperator) public DaoOperator(_daoOperator) {
        require(_kyberDao != IKyberDao(0), "_kyberDao 0");

        kyberDao = _kyberDao;
    }

    function setAllowedToken(IERC20 token, bool isAllowed) external onlyDaoOperator {
        allowedToken[token] = isAllowed;

        emit SetAllowedToken(token, isAllowed);
    }

    function finalize(IERC20 token, uint256 epoch) public {
        if (!allowedToken[token]) {
            return;
        }
        uint256 lastEpoch = kyberDao.getCurrentEpochNumber() - 1;
        // epoch mut be last epoch
        if (epoch != lastEpoch) {
            return;
        }
        // epoch must be not finalized
        if (lastEpoch <= lastFinalizedEpoch[token]) {
            return;
        }
        lastFinalizedEpoch[token] = lastEpoch;
        IDMMPool(address(token)).sync();

        uint256 amount = token.balanceOf(address(this)).sub(reserves[token]);
        if (amount == 0) {
            return;
        }
        rewardsPerEpoch[lastEpoch][token] = rewardsPerEpoch[lastEpoch][token].add(amount);
        reserves[token] = reserves[token].add(amount);
        emit FeeDistributed(token, lastEpoch, amount);
    }

    function burn(IERC20 token) external onlyDaoOperator {
        require(allowedToken[token], "token should be distributed");
        uint256 amount = token.balanceOf(address(this));
        if (amount <= 1) {
            return;
        }
        token.safeTransfer(address(token), amount - 1); // gas saving.
        IDMMPool(address(token)).burn(address(token));
    }

    /// @notice  WARNING When staker address is a contract,
    ///          it should be able to receive claimed reward in ETH whenever anyone calls this function.
    /// @dev not revert if already claimed or reward percentage is 0
    ///      allow writing a wrapper to claim for multiple epochs
    /// @param staker address.
    /// @param epoch for which epoch the staker is claiming the reward
    function claimStakerReward(
        address staker,
        IERC20 token,
        uint256 epoch
    ) external nonReentrant returns (uint256 amountWei) {
        if (hasClaimedReward[staker][epoch][token]) {
            // staker has already claimed reward for the epoch
            return 0;
        }

        // the relative part of the reward the staker is entitled to for the epoch.
        // units Precision: 10 ** 18 = 100%
        // if the epoch is current or in the future, kyberDao will return 0 as result
        uint256 percentageInPrecision = kyberDao.getPastEpochRewardPercentageInPrecision(
            staker,
            epoch
        );
        if (percentageInPrecision == 0) {
            return 0; // not revert, in case a wrapper wants to claim reward for multiple epochs
        }

        finalize(token, epoch);
        require(percentageInPrecision <= PRECISION, "percentage too high");

        // Amount of reward to be sent to staker
        uint256 rewardAllStaker = rewardsPerEpoch[epoch][token];
        amountWei = rewardAllStaker.mul(percentageInPrecision).div(PRECISION);
        {
            uint256 newRewardPaid = rewardsPaidPerEpoch[epoch][token].add(amountWei);
            assert(newRewardPaid <= rewardAllStaker); // redundant check, can't happen
            rewardsPaidPerEpoch[epoch][token] = newRewardPaid;
        }

        reserves[token] = reserves[token].sub(amountWei);
        hasClaimedReward[staker][epoch][token] = true; // SSTORE

        // send reward to staker
        token.safeTransfer(staker, amountWei);

        emit RewardPaid(staker, epoch, token, amountWei);
    }

    function getCurrentEpochNumber() internal view returns (uint256 epoch) {
        IKyberDao _kyberDao = kyberDao;
        if (_kyberDao == IKyberDao(0)) {
            return 0;
        } else {
            return _kyberDao.getCurrentEpochNumber();
        }
    }
}


// File contracts/mock/fee/MockKyberDao.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.12;

contract MockKyberDao is IKyberDao {
    uint256 public constant BPS = 10000; // Basic Price Steps. 1 step = 0.01%

    uint256 public rewardInBPS;
    uint256 public rebateInBPS;
    uint256 public epoch;
    uint256 public expiryTimestamp;
    uint256 public feeBps;
    uint256 public epochPeriod = 160;
    uint256 public startTimestamp;
    uint256 public rewardPercentageInPrecision;
    uint256 data;
    mapping(uint256 => bool) public shouldBurnRewardEpoch;

    constructor(
        uint256 _rewardInBPS,
        uint256 _rebateInBPS,
        uint256 _epoch,
        uint256 _expiryTimestamp
    ) public {
        rewardInBPS = _rewardInBPS;
        rebateInBPS = _rebateInBPS;
        epoch = _epoch;
        expiryTimestamp = _expiryTimestamp;
        startTimestamp = now;
    }

    function getLatestNetworkFeeDataWithCache() external override returns (uint256, uint256) {
        data++;
        return (feeBps, expiryTimestamp);
    }

    function getLatestBRRDataWithCache()
        external
        virtual
        override
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        return (BPS - rewardInBPS - rebateInBPS, rewardInBPS, rebateInBPS, epoch, expiryTimestamp);
    }

    function setStakerPercentageInPrecision(uint256 percentage) external {
        rewardPercentageInPrecision = percentage;
    }

    function getPastEpochRewardPercentageInPrecision(address staker, uint256 forEpoch)
        external
        override
        view
        returns (uint256)
    {
        staker;
        // return 0 for current or future epochs
        if (forEpoch >= epoch) {
            return 0;
        }
        return rewardPercentageInPrecision;
    }

    function getCurrentEpochRewardPercentageInPrecision(address staker)
        external
        override
        view
        returns (uint256)
    {
        staker;
        return rewardPercentageInPrecision;
    }

    function handleWithdrawal(address staker, uint256 reduceAmount) external override {
        staker;
        reduceAmount;
    }

    function vote(uint256 campaignID, uint256 option) external override {
        // must implement so it can be deployed.
        campaignID;
        option;
    }

    function epochPeriodInSeconds() external override view returns (uint256) {
        return epochPeriod;
    }

    function firstEpochStartTimestamp() external override view returns (uint256) {
        return startTimestamp;
    }

    function getCurrentEpochNumber() external override view returns (uint256) {
        return epoch;
    }

    function getEpochNumber(uint256 timestamp) public override view returns (uint256) {
        if (timestamp < startTimestamp || epochPeriod == 0) {
            return 0;
        }
        // ((timestamp - startTimestamp) / epochPeriod) + 1;
        return ((timestamp - startTimestamp) / epochPeriod) + 1;
    }

    function getLatestNetworkFeeData() external override view returns (uint256, uint256) {
        return (feeBps, expiryTimestamp);
    }

    function shouldBurnRewardForEpoch(uint256 epochNum) external override view returns (bool) {
        if (shouldBurnRewardEpoch[epochNum]) return true;
        return false;
    }

    function advanceEpoch() public {
        epoch++;
        expiryTimestamp = now + epochPeriod;
    }

    function setShouldBurnRewardTrue(uint256 epochNum) public {
        shouldBurnRewardEpoch[epochNum] = true;
    }

    function setMockEpochAndExpiryTimestamp(uint256 _epoch, uint256 _expiryTimestamp) public {
        epoch = _epoch;
        expiryTimestamp = _expiryTimestamp;
    }

    function setMockBRR(uint256 _rewardInBPS, uint256 _rebateInBPS) public {
        rewardInBPS = _rewardInBPS;
        rebateInBPS = _rebateInBPS;
    }

    function setNetworkFeeBps(uint256 _feeBps) public {
        feeBps = _feeBps;
    }
}


// File contracts/mock/MockDMMLibrary.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.12;

contract MockDMMLibrary {
    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut,
        uint256 vReserveIn,
        uint256 vReserveOut,
        uint256 fee
    ) external pure returns (uint256 amountOut) {
        return
            DMMLibrary.getAmountOut(amountIn, reserveIn, reserveOut, vReserveIn, vReserveOut, fee);
    }

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut,
        uint256 vReserveIn,
        uint256 vReserveOut,
        uint256 fee
    ) external pure returns (uint256 amountIn) {
        return
            DMMLibrary.getAmountIn(amountOut, reserveIn, reserveOut, vReserveIn, vReserveOut, fee);
    }

    function sortTokens(IERC20 tokenA, IERC20 tokenB)
        external
        pure
        returns (IERC20 token0, IERC20 token1)
    {
        return DMMLibrary.sortTokens(tokenA, tokenB);
    }
}


// File contracts/mock/MockDMMPair.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.12;

/// @dev this is a mock contract, so tester can set fee to random value
contract MockDMMPool is DMMPool {
    uint256 public simulationFee;

    constructor(
        address _factory,
        IERC20 _token0,
        IERC20 _token1,
        bool isAmpPool
    ) public DMMPool() {
        factory = IDMMFactory(_factory);
        token0 = _token0;
        token1 = _token1;
        ampBps = isAmpPool ? uint32(BPS + 1) : uint32(BPS);
    }

    function setFee(uint256 _fee) external {
        simulationFee = _fee;
    }

    function setReserves(
        uint112 _reserve0,
        uint112 _reserve1,
        uint112 _vReserve0,
        uint112 _vReserve1
    ) external {
        reserve0 = _reserve0;
        reserve1 = _reserve1;
        vReserve0 = _vReserve0;
        vReserve1 = _vReserve1;
    }

    function verifyBalanceAndUpdateEma(
        uint256 amount0In,
        uint256 amount1In,
        uint256 beforeReserve0,
        uint256 beforeReserve1,
        uint256 afterReserve0,
        uint256 afterReserve1
    ) internal override returns (uint256 feeInPrecision) {
        feeInPrecision = simulationFee;
        //verify balance update is match with fomula
        uint256 balance0Adjusted = afterReserve0.mul(PRECISION);
        balance0Adjusted = balance0Adjusted.sub(amount0In.mul(feeInPrecision));
        balance0Adjusted = balance0Adjusted / PRECISION;
        uint256 balance1Adjusted = afterReserve1.mul(PRECISION);
        balance1Adjusted = balance1Adjusted.sub(amount1In.mul(feeInPrecision));
        balance1Adjusted = balance1Adjusted / PRECISION;
        require(
            balance0Adjusted.mul(balance1Adjusted) >= beforeReserve0.mul(beforeReserve1),
            "DMM: K"
        );
    }
}


// File contracts/mock/MockERC20Permit.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.12;

contract MockERC20Permit is ERC20Permit {
    constructor(
        string memory _name,
        string memory _symbol,
        string memory _version,
        uint256 _totalSupply
    ) public ERC20Permit(_name, _symbol, _version) {
        _mint(msg.sender, _totalSupply);
    }
}


// File contracts/mock/MockFeeFomula.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.12;

contract MockFeeFomula {
    function getFee(uint256 rFactor) external pure returns (uint256) {
        return FeeFomula.getFee(rFactor);
    }
}


// File contracts/mock/MockFeeOnTransferERC20.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.12;

contract MockFeeOnTransferERC20 is ERC20 {
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply
    ) public ERC20(_name, _symbol) {
        _mint(msg.sender, _totalSupply);
    }

    function _transfer(
        address from,
        address to,
        uint256 value
    ) internal override {
        uint256 burnAmount = (value * 13) / 10000;
        _burn(from, burnAmount);
        uint256 transferAmount = value.sub(burnAmount);

        super._transfer(from, to, transferAmount);
    }
}


// File contracts/mock/MockMathExt.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.12;

contract MockMathExt {
    using MathExt for uint256;

    function mulInPrecision(uint256 x, uint256 y) external pure returns (uint256) {
        return x.mulInPrecision(y);
    }

    function powInPrecision(uint256 x, uint256 k) external pure returns (uint256) {
        return x.unsafePowInPrecision(k);
    }

    function sqrt(uint256 x) external pure returns (uint256) {
        return x.sqrt();
    }
}


// File contracts/mock/MockVolumeTrendRecorder.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.12;

contract MockVolumeTrendRecorder is VolumeTrendRecorder {
    constructor(uint128 _emaInit) public VolumeTrendRecorder(_emaInit) {}

    function mockRecordNewUpdatedVolume(uint256 value, uint256 blockNumber) external {
        recordNewUpdatedVolume(blockNumber, value);
    }

    function mockGetRFactor(uint256 blockNumber) external view returns (uint256) {
        return getRFactor(blockNumber);
    }

    function testGasCostGetRFactor(uint256 blockNumber) external view returns (uint256) {
        uint256 gas1 = gasleft();
        getRFactor(blockNumber);
        return gas1 - gasleft();
    }

    function mockGetInfo()
        external
        view
        returns (
            uint128 _shortEMA,
            uint128 _longEMA,
            uint128 _currentBlockVolume,
            uint128 _lastTradeBlock
        )
    {
        _shortEMA = shortEMA;
        _longEMA = longEMA;
        _currentBlockVolume = currentBlockVolume;
        _lastTradeBlock = lastTradeBlock;
    }

    function mockSafeUint128(uint256 a) external pure returns (uint128) {
        return safeUint128(a);
    }
}


// File contracts/mock/TestToken.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.12;

contract TestToken is ERC20 {
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply
    ) public ERC20(_name, _symbol) {
        _mint(msg.sender, _totalSupply);
    }
}


// File @openzeppelin/contracts/access/Ownable.sol@v3.4.1

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


// File contracts/periphery/DaoRegistry.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.6.12;


contract DaoRegistry is Ownable {
    using EnumerableSet for EnumerableSet.AddressSet;

    address public immutable factory;
    mapping(IERC20 => mapping(IERC20 => EnumerableSet.AddressSet)) internal tokenPools;

    event AddPool(IERC20 token0, IERC20 token1, address pool, bool isAdd);

    constructor(address _factory) public Ownable() {
        factory = _factory;
    }

    function addPool(
        IERC20 token0,
        IERC20 token1,
        address pool,
        bool isAdd
    ) external onlyOwner {
        // populate mapping in the reverse direction
        if (isAdd) {
            require(IDMMFactory(factory).isPool(token0, token1, pool), "Registry: INVALID_POOL");

            tokenPools[token0][token1].add(pool);
            tokenPools[token1][token0].add(pool);
        } else {
            tokenPools[token0][token1].remove(pool);
            tokenPools[token1][token0].remove(pool);
        }

        emit AddPool(token0, token1, pool, isAdd);
    }

    function getPools(IERC20 token0, IERC20 token1)
        external
        view
        returns (address[] memory _tokenPools)
    {
        uint256 length = tokenPools[token0][token1].length();
        _tokenPools = new address[](length);
        for (uint256 i = 0; i < length; i++) {
            _tokenPools[i] = tokenPools[token0][token1].at(i);
        }
    }
}


// File @uniswap/lib/contracts/libraries/TransferHelper.sol@v1.1.1

pragma solidity >=0.6.0;

// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
library TransferHelper {
    function safeApprove(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(address token, address from, address to, uint value) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }

    function safeTransferETH(address to, uint value) internal {
        (bool success,) = to.call{value:value}(new bytes(0));
        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
    }
}


// File contracts/periphery/DMMRouter02.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.6.12;








contract DMMRouter02 is IDMMRouter02 {
    using SafeERC20 for IERC20;
    using SafeERC20 for IWETH;
    using SafeMath for uint256;

    uint256 internal constant BPS = 10000;
    uint256 internal constant MIN_VRESERVE_RATIO = 0;
    uint256 internal constant MAX_VRESERVE_RATIO = 2**256 - 1;
    uint256 internal constant Q112 = 2**112;

    address public immutable override factory;
    IWETH public immutable override weth;

    modifier ensure(uint256 deadline) {
        require(deadline >= block.timestamp, "DMMRouter: EXPIRED");
        _;
    }

    constructor(address _factory, IWETH _weth) public {
        factory = _factory;
        weth = _weth;
    }

    receive() external payable {
        assert(msg.sender == address(weth)); // only accept ETH via fallback from the WETH contract
    }

    // **** ADD LIQUIDITY ****
    function _addLiquidity(
        IERC20 tokenA,
        IERC20 tokenB,
        address pool,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        uint256[2] memory vReserveRatioBounds
    ) internal virtual view returns (uint256 amountA, uint256 amountB) {
        (uint256 reserveA, uint256 reserveB, uint256 vReserveA, uint256 vReserveB, ) = DMMLibrary
            .getTradeInfo(pool, tokenA, tokenB);
        if (reserveA == 0 && reserveB == 0) {
            (amountA, amountB) = (amountADesired, amountBDesired);
        } else {
            uint256 amountBOptimal = DMMLibrary.quote(amountADesired, reserveA, reserveB);
            if (amountBOptimal <= amountBDesired) {
                require(amountBOptimal >= amountBMin, "DMMRouter: INSUFFICIENT_B_AMOUNT");
                (amountA, amountB) = (amountADesired, amountBOptimal);
            } else {
                uint256 amountAOptimal = DMMLibrary.quote(amountBDesired, reserveB, reserveA);
                assert(amountAOptimal <= amountADesired);
                require(amountAOptimal >= amountAMin, "DMMRouter: INSUFFICIENT_A_AMOUNT");
                (amountA, amountB) = (amountAOptimal, amountBDesired);
            }
            uint256 currentRate = (vReserveB * Q112) / vReserveA;
            require(
                currentRate >= vReserveRatioBounds[0] && currentRate <= vReserveRatioBounds[1],
                "DMMRouter: OUT_OF_BOUNDS_VRESERVE"
            );
        }
    }

    function addLiquidity(
        IERC20 tokenA,
        IERC20 tokenB,
        address pool,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        uint256[2] memory vReserveRatioBounds,
        address to,
        uint256 deadline
    )
        public
        virtual
        override
        ensure(deadline)
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        )
    {
        verifyPoolAddress(tokenA, tokenB, pool);
        (amountA, amountB) = _addLiquidity(
            tokenA,
            tokenB,
            pool,
            amountADesired,
            amountBDesired,
            amountAMin,
            amountBMin,
            vReserveRatioBounds
        );
        // using tokenA.safeTransferFrom will get "Stack too deep"
        SafeERC20.safeTransferFrom(tokenA, msg.sender, pool, amountA);
        SafeERC20.safeTransferFrom(tokenB, msg.sender, pool, amountB);
        liquidity = IDMMPool(pool).mint(to);
    }

    function addLiquidityETH(
        IERC20 token,
        address pool,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        uint256[2] memory vReserveRatioBounds,
        address to,
        uint256 deadline
    )
        public
        override
        payable
        ensure(deadline)
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        )
    {
        verifyPoolAddress(token, weth, pool);
        (amountToken, amountETH) = _addLiquidity(
            token,
            weth,
            pool,
            amountTokenDesired,
            msg.value,
            amountTokenMin,
            amountETHMin,
            vReserveRatioBounds
        );
        token.safeTransferFrom(msg.sender, pool, amountToken);
        weth.deposit{value: amountETH}();
        weth.safeTransfer(pool, amountETH);
        liquidity = IDMMPool(pool).mint(to);
        // refund dust eth, if any
        if (msg.value > amountETH) {
            TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
        }
    }

    function addLiquidityNewPool(
        IERC20 tokenA,
        IERC20 tokenB,
        uint32 ampBps,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        override
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        )
    {
        address pool;
        if (ampBps == BPS) {
            pool = IDMMFactory(factory).getUnamplifiedPool(tokenA, tokenB);
        }
        if (pool == address(0)) {
            pool = IDMMFactory(factory).createPool(tokenA, tokenB, ampBps);
        }
        // if we add liquidity to an existing pool, this is an unamplifed pool
        // so there is no need for bounds of virtual reserve ratio
        uint256[2] memory vReserveRatioBounds = [MIN_VRESERVE_RATIO, MAX_VRESERVE_RATIO];
        (amountA, amountB, liquidity) = addLiquidity(
            tokenA,
            tokenB,
            pool,
            amountADesired,
            amountBDesired,
            amountAMin,
            amountBMin,
            vReserveRatioBounds,
            to,
            deadline
        );
    }

    function addLiquidityNewPoolETH(
        IERC20 token,
        uint32 ampBps,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        override
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        )
    {
        address pool;
        if (ampBps == BPS) {
            pool = IDMMFactory(factory).getUnamplifiedPool(token, weth);
        }
        if (pool == address(0)) {
            pool = IDMMFactory(factory).createPool(token, weth, ampBps);
        }
        // if we add liquidity to an existing pool, this is an unamplifed pool
        // so there is no need for bounds of virtual reserve ratio
        uint256[2] memory vReserveRatioBounds = [MIN_VRESERVE_RATIO, MAX_VRESERVE_RATIO];
        (amountToken, amountETH, liquidity) = addLiquidityETH(
            token,
            pool,
            amountTokenDesired,
            amountTokenMin,
            amountETHMin,
            vReserveRatioBounds,
            to,
            deadline
        );
    }

    // **** REMOVE LIQUIDITY ****
    function removeLiquidity(
        IERC20 tokenA,
        IERC20 tokenB,
        address pool,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) public override ensure(deadline) returns (uint256 amountA, uint256 amountB) {
        verifyPoolAddress(tokenA, tokenB, pool);
        IERC20(pool).safeTransferFrom(msg.sender, pool, liquidity); // send liquidity to pool
        (uint256 amount0, uint256 amount1) = IDMMPool(pool).burn(to);
        (IERC20 token0, ) = DMMLibrary.sortTokens(tokenA, tokenB);
        (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
        require(amountA >= amountAMin, "DMMRouter: INSUFFICIENT_A_AMOUNT");
        require(amountB >= amountBMin, "DMMRouter: INSUFFICIENT_B_AMOUNT");
    }

    function removeLiquidityETH(
        IERC20 token,
        address pool,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) public override ensure(deadline) returns (uint256 amountToken, uint256 amountETH) {
        (amountToken, amountETH) = removeLiquidity(
            token,
            weth,
            pool,
            liquidity,
            amountTokenMin,
            amountETHMin,
            address(this),
            deadline
        );
        token.safeTransfer(to, amountToken);
        IWETH(weth).withdraw(amountETH);
        TransferHelper.safeTransferETH(to, amountETH);
    }

    function removeLiquidityWithPermit(
        IERC20 tokenA,
        IERC20 tokenB,
        address pool,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external virtual override returns (uint256 amountA, uint256 amountB) {
        uint256 value = approveMax ? uint256(-1) : liquidity;
        IERC20Permit(pool).permit(msg.sender, address(this), value, deadline, v, r, s);
        (amountA, amountB) = removeLiquidity(
            tokenA,
            tokenB,
            pool,
            liquidity,
            amountAMin,
            amountBMin,
            to,
            deadline
        );
    }

    function removeLiquidityETHWithPermit(
        IERC20 token,
        address pool,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external override returns (uint256 amountToken, uint256 amountETH) {
        uint256 value = approveMax ? uint256(-1) : liquidity;
        IERC20Permit(pool).permit(msg.sender, address(this), value, deadline, v, r, s);
        (amountToken, amountETH) = removeLiquidityETH(
            token,
            pool,
            liquidity,
            amountTokenMin,
            amountETHMin,
            to,
            deadline
        );
    }

    // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****

    function removeLiquidityETHSupportingFeeOnTransferTokens(
        IERC20 token,
        address pool,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) public override ensure(deadline) returns (uint256 amountETH) {
        (, amountETH) = removeLiquidity(
            token,
            weth,
            pool,
            liquidity,
            amountTokenMin,
            amountETHMin,
            address(this),
            deadline
        );
        token.safeTransfer(to, IERC20(token).balanceOf(address(this)));
        IWETH(weth).withdraw(amountETH);
        TransferHelper.safeTransferETH(to, amountETH);
    }

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        IERC20 token,
        address pool,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external override returns (uint256 amountETH) {
        uint256 value = approveMax ? uint256(-1) : liquidity;
        IERC20Permit(pool).permit(msg.sender, address(this), value, deadline, v, r, s);
        amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
            token,
            pool,
            liquidity,
            amountTokenMin,
            amountETHMin,
            to,
            deadline
        );
    }

    // **** SWAP ****
    // requires the initial amount to have already been sent to the first pool
    function _swap(
        uint256[] memory amounts,
        address[] memory poolsPath,
        IERC20[] memory path,
        address _to
    ) private {
        for (uint256 i; i < path.length - 1; i++) {
            (IERC20 input, IERC20 output) = (path[i], path[i + 1]);
            (IERC20 token0, ) = DMMLibrary.sortTokens(input, output);
            uint256 amountOut = amounts[i + 1];
            (uint256 amount0Out, uint256 amount1Out) = input == token0
                ? (uint256(0), amountOut)
                : (amountOut, uint256(0));
            address to = i < path.length - 2 ? poolsPath[i + 1] : _to;
            IDMMPool(poolsPath[i]).swap(amount0Out, amount1Out, to, new bytes(0));
        }
    }

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] memory poolsPath,
        IERC20[] memory path,
        address to,
        uint256 deadline
    ) public virtual override ensure(deadline) returns (uint256[] memory amounts) {
        verifyPoolsPathSwap(poolsPath, path);
        amounts = DMMLibrary.getAmountsOut(amountIn, poolsPath, path);
        require(
            amounts[amounts.length - 1] >= amountOutMin,
            "DMMRouter: INSUFFICIENT_OUTPUT_AMOUNT"
        );
        IERC20(path[0]).safeTransferFrom(msg.sender, poolsPath[0], amounts[0]);
        _swap(amounts, poolsPath, path, to);
    }

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] memory poolsPath,
        IERC20[] memory path,
        address to,
        uint256 deadline
    ) public override ensure(deadline) returns (uint256[] memory amounts) {
        verifyPoolsPathSwap(poolsPath, path);
        amounts = DMMLibrary.getAmountsIn(amountOut, poolsPath, path);
        require(amounts[0] <= amountInMax, "DMMRouter: EXCESSIVE_INPUT_AMOUNT");
        path[0].safeTransferFrom(msg.sender, poolsPath[0], amounts[0]);
        _swap(amounts, poolsPath, path, to);
    }

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external override payable ensure(deadline) returns (uint256[] memory amounts) {
        require(path[0] == weth, "DMMRouter: INVALID_PATH");
        verifyPoolsPathSwap(poolsPath, path);
        amounts = DMMLibrary.getAmountsOut(msg.value, poolsPath, path);
        require(
            amounts[amounts.length - 1] >= amountOutMin,
            "DMMRouter: INSUFFICIENT_OUTPUT_AMOUNT"
        );
        IWETH(weth).deposit{value: amounts[0]}();
        weth.safeTransfer(poolsPath[0], amounts[0]);
        _swap(amounts, poolsPath, path, to);
    }

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external override ensure(deadline) returns (uint256[] memory amounts) {
        require(path[path.length - 1] == weth, "DMMRouter: INVALID_PATH");
        verifyPoolsPathSwap(poolsPath, path);
        amounts = DMMLibrary.getAmountsIn(amountOut, poolsPath, path);
        require(amounts[0] <= amountInMax, "DMMRouter: EXCESSIVE_INPUT_AMOUNT");
        path[0].safeTransferFrom(msg.sender, poolsPath[0], amounts[0]);
        _swap(amounts, poolsPath, path, address(this));
        IWETH(weth).withdraw(amounts[amounts.length - 1]);
        TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
    }

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external override ensure(deadline) returns (uint256[] memory amounts) {
        require(path[path.length - 1] == weth, "DMMRouter: INVALID_PATH");
        verifyPoolsPathSwap(poolsPath, path);
        amounts = DMMLibrary.getAmountsOut(amountIn, poolsPath, path);
        require(
            amounts[amounts.length - 1] >= amountOutMin,
            "DMMRouter: INSUFFICIENT_OUTPUT_AMOUNT"
        );
        path[0].safeTransferFrom(msg.sender, poolsPath[0], amounts[0]);
        _swap(amounts, poolsPath, path, address(this));
        IWETH(weth).withdraw(amounts[amounts.length - 1]);
        TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
    }

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external override payable ensure(deadline) returns (uint256[] memory amounts) {
        require(path[0] == weth, "DMMRouter: INVALID_PATH");
        verifyPoolsPathSwap(poolsPath, path);
        amounts = DMMLibrary.getAmountsIn(amountOut, poolsPath, path);
        require(amounts[0] <= msg.value, "DMMRouter: EXCESSIVE_INPUT_AMOUNT");
        IWETH(weth).deposit{value: amounts[0]}();
        weth.safeTransfer(poolsPath[0], amounts[0]);
        _swap(amounts, poolsPath, path, to);
        // refund dust eth, if any
        if (msg.value > amounts[0]) {
            TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
        }
    }

    // **** SWAP (supporting fee-on-transfer tokens) ****
    // requires the initial amount to have already been sent to the first pool
    function _swapSupportingFeeOnTransferTokens(
        address[] memory poolsPath,
        IERC20[] memory path,
        address _to
    ) internal {
        verifyPoolsPathSwap(poolsPath, path);
        for (uint256 i; i < path.length - 1; i++) {
            (IERC20 input, IERC20 output) = (path[i], path[i + 1]);
            (IERC20 token0, ) = DMMLibrary.sortTokens(input, output);
            IDMMPool pool = IDMMPool(poolsPath[i]);
            uint256 amountOutput;
            {
                // scope to avoid stack too deep errors
                (
                    uint256 reserveIn,
                    uint256 reserveOut,
                    uint256 vReserveIn,
                    uint256 vReserveOut,
                    uint256 feeInPrecision
                ) = DMMLibrary.getTradeInfo(poolsPath[i], input, output);
                uint256 amountInput = IERC20(input).balanceOf(address(pool)).sub(reserveIn);
                amountOutput = DMMLibrary.getAmountOut(
                    amountInput,
                    reserveIn,
                    reserveOut,
                    vReserveIn,
                    vReserveOut,
                    feeInPrecision
                );
            }
            (uint256 amount0Out, uint256 amount1Out) = input == token0
                ? (uint256(0), amountOutput)
                : (amountOutput, uint256(0));
            address to = i < path.length - 2 ? poolsPath[i + 1] : _to;
            pool.swap(amount0Out, amount1Out, to, new bytes(0));
        }
    }

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] memory poolsPath,
        IERC20[] memory path,
        address to,
        uint256 deadline
    ) public override ensure(deadline) {
        path[0].safeTransferFrom(msg.sender, poolsPath[0], amountIn);
        uint256 balanceBefore = path[path.length - 1].balanceOf(to);
        _swapSupportingFeeOnTransferTokens(poolsPath, path, to);
        uint256 balanceAfter = path[path.length - 1].balanceOf(to);
        require(
            balanceAfter >= balanceBefore.add(amountOutMin),
            "DMMRouter: INSUFFICIENT_OUTPUT_AMOUNT"
        );
    }

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external override payable ensure(deadline) {
        require(path[0] == weth, "DMMRouter: INVALID_PATH");
        uint256 amountIn = msg.value;
        IWETH(weth).deposit{value: amountIn}();
        weth.safeTransfer(poolsPath[0], amountIn);
        uint256 balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
        _swapSupportingFeeOnTransferTokens(poolsPath, path, to);
        require(
            path[path.length - 1].balanceOf(to).sub(balanceBefore) >= amountOutMin,
            "DMMRouter: INSUFFICIENT_OUTPUT_AMOUNT"
        );
    }

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external override ensure(deadline) {
        require(path[path.length - 1] == weth, "DMMRouter: INVALID_PATH");
        path[0].safeTransferFrom(msg.sender, poolsPath[0], amountIn);
        _swapSupportingFeeOnTransferTokens(poolsPath, path, address(this));
        uint256 amountOut = IWETH(weth).balanceOf(address(this));
        require(amountOut >= amountOutMin, "DMMRouter: INSUFFICIENT_OUTPUT_AMOUNT");
        IWETH(weth).withdraw(amountOut);
        TransferHelper.safeTransferETH(to, amountOut);
    }

    // **** LIBRARY FUNCTIONS ****

    /// @dev get the amount of tokenB for adding liquidity with given amount of token A and the amount of tokens in the pool
    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external override pure returns (uint256 amountB) {
        return DMMLibrary.quote(amountA, reserveA, reserveB);
    }

    function getAmountsOut(
        uint256 amountIn,
        address[] calldata poolsPath,
        IERC20[] calldata path
    ) external override view returns (uint256[] memory amounts) {
        verifyPoolsPathSwap(poolsPath, path);
        return DMMLibrary.getAmountsOut(amountIn, poolsPath, path);
    }

    function getAmountsIn(
        uint256 amountOut,
        address[] calldata poolsPath,
        IERC20[] calldata path
    ) external override view returns (uint256[] memory amounts) {
        verifyPoolsPathSwap(poolsPath, path);
        return DMMLibrary.getAmountsIn(amountOut, poolsPath, path);
    }

    function verifyPoolsPathSwap(address[] memory poolsPath, IERC20[] memory path) internal view {
        require(path.length >= 2, "DMMRouter: INVALID_PATH");
        require(poolsPath.length == path.length - 1, "DMMRouter: INVALID_POOLS_PATH");
        for (uint256 i = 0; i < poolsPath.length; i++) {
            verifyPoolAddress(path[i], path[i + 1], poolsPath[i]);
        }
    }

    function verifyPoolAddress(
        IERC20 tokenA,
        IERC20 tokenB,
        address pool
    ) internal view {
        require(IDMMFactory(factory).isPool(tokenA, tokenB, pool), "DMMRouter: INVALID_POOL");
    }
}


// File contracts/periphery/KSRouter02.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.6.12;








contract KSRouter02 is IKSRouter02 {
    using SafeERC20 for IERC20;
    using SafeERC20 for IWETH;
    using SafeMath for uint256;

    uint256 internal constant BPS = 10000;
    uint256 internal constant MIN_VRESERVE_RATIO = 0;
    uint256 internal constant MAX_VRESERVE_RATIO = 2**256 - 1;
    uint256 internal constant Q112 = 2**112;

    address public immutable override factory;
    IWETH public immutable override weth;

    modifier ensure(uint256 deadline) {
        require(deadline >= block.timestamp, "KSRouter: EXPIRED");
        _;
    }

    constructor(address _factory, IWETH _weth) public {
        factory = _factory;
        weth = _weth;
    }

    receive() external payable {
        assert(msg.sender == address(weth)); // only accept ETH via fallback from the WETH contract
    }

    // **** ADD LIQUIDITY ****
    function _addLiquidity(
        IERC20 tokenA,
        IERC20 tokenB,
        address pool,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        uint256[2] memory vReserveRatioBounds
    ) internal virtual view returns (uint256 amountA, uint256 amountB) {
        (uint256 reserveA, uint256 reserveB, uint256 vReserveA, uint256 vReserveB, ) = KSLibrary
            .getTradeInfo(pool, tokenA, tokenB);
        if (reserveA == 0 && reserveB == 0) {
            (amountA, amountB) = (amountADesired, amountBDesired);
        } else {
            uint256 amountBOptimal = KSLibrary.quote(amountADesired, reserveA, reserveB);
            if (amountBOptimal <= amountBDesired) {
                require(amountBOptimal >= amountBMin, "KSRouter: INSUFFICIENT_B_AMOUNT");
                (amountA, amountB) = (amountADesired, amountBOptimal);
            } else {
                uint256 amountAOptimal = KSLibrary.quote(amountBDesired, reserveB, reserveA);
                assert(amountAOptimal <= amountADesired);
                require(amountAOptimal >= amountAMin, "KSRouter: INSUFFICIENT_A_AMOUNT");
                (amountA, amountB) = (amountAOptimal, amountBDesired);
            }
            uint256 currentRate = (vReserveB * Q112) / vReserveA;
            require(
                currentRate >= vReserveRatioBounds[0] && currentRate <= vReserveRatioBounds[1],
                "KSRouter: OUT_OF_BOUNDS_VRESERVE"
            );
        }
    }

    function addLiquidity(
        IERC20 tokenA,
        IERC20 tokenB,
        address pool,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        uint256[2] memory vReserveRatioBounds,
        address to,
        uint256 deadline
    )
        public
        virtual
        override
        ensure(deadline)
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        )
    {
        verifyPoolAddress(tokenA, tokenB, pool);
        (amountA, amountB) = _addLiquidity(
            tokenA,
            tokenB,
            pool,
            amountADesired,
            amountBDesired,
            amountAMin,
            amountBMin,
            vReserveRatioBounds
        );
        // using tokenA.safeTransferFrom will get "Stack too deep"
        SafeERC20.safeTransferFrom(tokenA, msg.sender, pool, amountA);
        SafeERC20.safeTransferFrom(tokenB, msg.sender, pool, amountB);
        liquidity = IKSPool(pool).mint(to);
    }

    function addLiquidityETH(
        IERC20 token,
        address pool,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        uint256[2] memory vReserveRatioBounds,
        address to,
        uint256 deadline
    )
        public
        override
        payable
        ensure(deadline)
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        )
    {
        verifyPoolAddress(token, weth, pool);
        (amountToken, amountETH) = _addLiquidity(
            token,
            weth,
            pool,
            amountTokenDesired,
            msg.value,
            amountTokenMin,
            amountETHMin,
            vReserveRatioBounds
        );
        token.safeTransferFrom(msg.sender, pool, amountToken);
        weth.deposit{value: amountETH}();
        weth.safeTransfer(pool, amountETH);
        liquidity = IKSPool(pool).mint(to);
        // refund dust eth, if any
        if (msg.value > amountETH) {
            TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
        }
    }

    function addLiquidityNewPool(
        IERC20 tokenA,
        IERC20 tokenB,
        uint32[2] memory ampBpsAndFeeBps,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        override
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        )
    {
        address pool;
        if (ampBpsAndFeeBps[0] == BPS) {
            pool = IKSFactory(factory).getUnamplifiedPool(tokenA, tokenB);
        }
        if (pool == address(0)) {
            pool = IKSFactory(factory).createPool(
                tokenA,
                tokenB,
                ampBpsAndFeeBps[0],
                uint16(ampBpsAndFeeBps[1])
            );
        }
        // if we add liquidity to an existing pool, this is an unamplifed pool
        // so there is no need for bounds of virtual reserve ratio
        uint256[2] memory vReserveRatioBounds = [MIN_VRESERVE_RATIO, MAX_VRESERVE_RATIO];
        (amountA, amountB, liquidity) = addLiquidity(
            tokenA,
            tokenB,
            pool,
            amountADesired,
            amountBDesired,
            amountAMin,
            amountBMin,
            vReserveRatioBounds,
            to,
            deadline
        );
    }

    function addLiquidityNewPoolETH(
        IERC20 token,
        uint32[2] memory ampBpsAndFeeBps,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        override
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        )
    {
        address pool;
        if (ampBpsAndFeeBps[0] == BPS) {
            pool = IKSFactory(factory).getUnamplifiedPool(token, weth);
        }
        if (pool == address(0)) {
            pool = IKSFactory(factory).createPool(
                token,
                weth,
                ampBpsAndFeeBps[0],
                uint16(ampBpsAndFeeBps[1])
            );
        }
        // if we add liquidity to an existing pool, this is an unamplifed pool
        // so there is no need for bounds of virtual reserve ratio
        uint256[2] memory vReserveRatioBounds = [MIN_VRESERVE_RATIO, MAX_VRESERVE_RATIO];
        (amountToken, amountETH, liquidity) = addLiquidityETH(
            token,
            pool,
            amountTokenDesired,
            amountTokenMin,
            amountETHMin,
            vReserveRatioBounds,
            to,
            deadline
        );
    }

    // **** REMOVE LIQUIDITY ****
    function removeLiquidity(
        IERC20 tokenA,
        IERC20 tokenB,
        address pool,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) public override ensure(deadline) returns (uint256 amountA, uint256 amountB) {
        verifyPoolAddress(tokenA, tokenB, pool);
        IERC20(pool).safeTransferFrom(msg.sender, pool, liquidity); // send liquidity to pool
        (uint256 amount0, uint256 amount1) = IKSPool(pool).burn(to);
        (IERC20 token0, ) = KSLibrary.sortTokens(tokenA, tokenB);
        (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
        require(amountA >= amountAMin, "KSRouter: INSUFFICIENT_A_AMOUNT");
        require(amountB >= amountBMin, "KSRouter: INSUFFICIENT_B_AMOUNT");
    }

    function removeLiquidityETH(
        IERC20 token,
        address pool,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) public override ensure(deadline) returns (uint256 amountToken, uint256 amountETH) {
        (amountToken, amountETH) = removeLiquidity(
            token,
            weth,
            pool,
            liquidity,
            amountTokenMin,
            amountETHMin,
            address(this),
            deadline
        );
        token.safeTransfer(to, amountToken);
        IWETH(weth).withdraw(amountETH);
        TransferHelper.safeTransferETH(to, amountETH);
    }

    function removeLiquidityWithPermit(
        IERC20 tokenA,
        IERC20 tokenB,
        address pool,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external virtual override returns (uint256 amountA, uint256 amountB) {
        uint256 value = approveMax ? uint256(-1) : liquidity;
        IERC20Permit(pool).permit(msg.sender, address(this), value, deadline, v, r, s);
        (amountA, amountB) = removeLiquidity(
            tokenA,
            tokenB,
            pool,
            liquidity,
            amountAMin,
            amountBMin,
            to,
            deadline
        );
    }

    function removeLiquidityETHWithPermit(
        IERC20 token,
        address pool,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external override returns (uint256 amountToken, uint256 amountETH) {
        uint256 value = approveMax ? uint256(-1) : liquidity;
        IERC20Permit(pool).permit(msg.sender, address(this), value, deadline, v, r, s);
        (amountToken, amountETH) = removeLiquidityETH(
            token,
            pool,
            liquidity,
            amountTokenMin,
            amountETHMin,
            to,
            deadline
        );
    }

    // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****

    function removeLiquidityETHSupportingFeeOnTransferTokens(
        IERC20 token,
        address pool,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) public override ensure(deadline) returns (uint256 amountETH) {
        (, amountETH) = removeLiquidity(
            token,
            weth,
            pool,
            liquidity,
            amountTokenMin,
            amountETHMin,
            address(this),
            deadline
        );
        token.safeTransfer(to, IERC20(token).balanceOf(address(this)));
        IWETH(weth).withdraw(amountETH);
        TransferHelper.safeTransferETH(to, amountETH);
    }

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        IERC20 token,
        address pool,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external override returns (uint256 amountETH) {
        uint256 value = approveMax ? uint256(-1) : liquidity;
        IERC20Permit(pool).permit(msg.sender, address(this), value, deadline, v, r, s);
        amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
            token,
            pool,
            liquidity,
            amountTokenMin,
            amountETHMin,
            to,
            deadline
        );
    }

    // **** SWAP ****
    // requires the initial amount to have already been sent to the first pool
    function _swap(
        uint256[] memory amounts,
        address[] memory poolsPath,
        IERC20[] memory path,
        address _to
    ) private {
        for (uint256 i; i < path.length - 1; i++) {
            (IERC20 input, IERC20 output) = (path[i], path[i + 1]);
            (IERC20 token0, ) = KSLibrary.sortTokens(input, output);
            uint256 amountOut = amounts[i + 1];
            (uint256 amount0Out, uint256 amount1Out) = input == token0
                ? (uint256(0), amountOut)
                : (amountOut, uint256(0));
            address to = i < path.length - 2 ? poolsPath[i + 1] : _to;
            IKSPool(poolsPath[i]).swap(amount0Out, amount1Out, to, new bytes(0));
        }
    }

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] memory poolsPath,
        IERC20[] memory path,
        address to,
        uint256 deadline
    ) public virtual override ensure(deadline) returns (uint256[] memory amounts) {
        verifyPoolsPathSwap(poolsPath, path);
        amounts = KSLibrary.getAmountsOut(amountIn, poolsPath, path);
        require(
            amounts[amounts.length - 1] >= amountOutMin,
            "KSRouter: INSUFFICIENT_OUTPUT_AMOUNT"
        );
        IERC20(path[0]).safeTransferFrom(msg.sender, poolsPath[0], amounts[0]);
        _swap(amounts, poolsPath, path, to);
    }

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] memory poolsPath,
        IERC20[] memory path,
        address to,
        uint256 deadline
    ) public override ensure(deadline) returns (uint256[] memory amounts) {
        verifyPoolsPathSwap(poolsPath, path);
        amounts = KSLibrary.getAmountsIn(amountOut, poolsPath, path);
        require(amounts[0] <= amountInMax, "KSRouter: EXCESSIVE_INPUT_AMOUNT");
        path[0].safeTransferFrom(msg.sender, poolsPath[0], amounts[0]);
        _swap(amounts, poolsPath, path, to);
    }

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external override payable ensure(deadline) returns (uint256[] memory amounts) {
        require(path[0] == weth, "KSRouter: INVALID_PATH");
        verifyPoolsPathSwap(poolsPath, path);
        amounts = KSLibrary.getAmountsOut(msg.value, poolsPath, path);
        require(
            amounts[amounts.length - 1] >= amountOutMin,
            "KSRouter: INSUFFICIENT_OUTPUT_AMOUNT"
        );
        IWETH(weth).deposit{value: amounts[0]}();
        weth.safeTransfer(poolsPath[0], amounts[0]);
        _swap(amounts, poolsPath, path, to);
    }

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external override ensure(deadline) returns (uint256[] memory amounts) {
        require(path[path.length - 1] == weth, "KSRouter: INVALID_PATH");
        verifyPoolsPathSwap(poolsPath, path);
        amounts = KSLibrary.getAmountsIn(amountOut, poolsPath, path);
        require(amounts[0] <= amountInMax, "KSRouter: EXCESSIVE_INPUT_AMOUNT");
        path[0].safeTransferFrom(msg.sender, poolsPath[0], amounts[0]);
        _swap(amounts, poolsPath, path, address(this));
        IWETH(weth).withdraw(amounts[amounts.length - 1]);
        TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
    }

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external override ensure(deadline) returns (uint256[] memory amounts) {
        require(path[path.length - 1] == weth, "KSRouter: INVALID_PATH");
        verifyPoolsPathSwap(poolsPath, path);
        amounts = KSLibrary.getAmountsOut(amountIn, poolsPath, path);
        require(
            amounts[amounts.length - 1] >= amountOutMin,
            "KSRouter: INSUFFICIENT_OUTPUT_AMOUNT"
        );
        path[0].safeTransferFrom(msg.sender, poolsPath[0], amounts[0]);
        _swap(amounts, poolsPath, path, address(this));
        IWETH(weth).withdraw(amounts[amounts.length - 1]);
        TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
    }

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external override payable ensure(deadline) returns (uint256[] memory amounts) {
        require(path[0] == weth, "KSRouter: INVALID_PATH");
        verifyPoolsPathSwap(poolsPath, path);
        amounts = KSLibrary.getAmountsIn(amountOut, poolsPath, path);
        require(amounts[0] <= msg.value, "KSRouter: EXCESSIVE_INPUT_AMOUNT");
        IWETH(weth).deposit{value: amounts[0]}();
        weth.safeTransfer(poolsPath[0], amounts[0]);
        _swap(amounts, poolsPath, path, to);
        // refund dust eth, if any
        if (msg.value > amounts[0]) {
            TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
        }
    }

    // **** SWAP (supporting fee-on-transfer tokens) ****
    // requires the initial amount to have already been sent to the first pool
    function _swapSupportingFeeOnTransferTokens(
        address[] memory poolsPath,
        IERC20[] memory path,
        address _to
    ) internal {
        verifyPoolsPathSwap(poolsPath, path);
        for (uint256 i; i < path.length - 1; i++) {
            (IERC20 input, IERC20 output) = (path[i], path[i + 1]);
            (IERC20 token0, ) = KSLibrary.sortTokens(input, output);
            IKSPool pool = IKSPool(poolsPath[i]);
            uint256 amountOutput;
            {
                // scope to avoid stack too deep errors
                (
                    uint256 reserveIn,
                    uint256 reserveOut,
                    uint256 vReserveIn,
                    uint256 vReserveOut,
                    uint256 feeInPrecision
                ) = KSLibrary.getTradeInfo(poolsPath[i], input, output);
                uint256 amountInput = IERC20(input).balanceOf(address(pool)).sub(reserveIn);
                amountOutput = KSLibrary.getAmountOut(
                    amountInput,
                    reserveIn,
                    reserveOut,
                    vReserveIn,
                    vReserveOut,
                    feeInPrecision
                );
            }
            (uint256 amount0Out, uint256 amount1Out) = input == token0
                ? (uint256(0), amountOutput)
                : (amountOutput, uint256(0));
            address to = i < path.length - 2 ? poolsPath[i + 1] : _to;
            pool.swap(amount0Out, amount1Out, to, new bytes(0));
        }
    }

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] memory poolsPath,
        IERC20[] memory path,
        address to,
        uint256 deadline
    ) public override ensure(deadline) {
        path[0].safeTransferFrom(msg.sender, poolsPath[0], amountIn);
        uint256 balanceBefore = path[path.length - 1].balanceOf(to);
        _swapSupportingFeeOnTransferTokens(poolsPath, path, to);
        uint256 balanceAfter = path[path.length - 1].balanceOf(to);
        require(
            balanceAfter >= balanceBefore.add(amountOutMin),
            "KSRouter: INSUFFICIENT_OUTPUT_AMOUNT"
        );
    }

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external override payable ensure(deadline) {
        require(path[0] == weth, "KSRouter: INVALID_PATH");
        uint256 amountIn = msg.value;
        IWETH(weth).deposit{value: amountIn}();
        weth.safeTransfer(poolsPath[0], amountIn);
        uint256 balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
        _swapSupportingFeeOnTransferTokens(poolsPath, path, to);
        require(
            path[path.length - 1].balanceOf(to).sub(balanceBefore) >= amountOutMin,
            "KSRouter: INSUFFICIENT_OUTPUT_AMOUNT"
        );
    }

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata poolsPath,
        IERC20[] calldata path,
        address to,
        uint256 deadline
    ) external override ensure(deadline) {
        require(path[path.length - 1] == weth, "KSRouter: INVALID_PATH");
        path[0].safeTransferFrom(msg.sender, poolsPath[0], amountIn);
        _swapSupportingFeeOnTransferTokens(poolsPath, path, address(this));
        uint256 amountOut = IWETH(weth).balanceOf(address(this));
        require(amountOut >= amountOutMin, "KSRouter: INSUFFICIENT_OUTPUT_AMOUNT");
        IWETH(weth).withdraw(amountOut);
        TransferHelper.safeTransferETH(to, amountOut);
    }

    // **** LIBRARY FUNCTIONS ****

    /// @dev get the amount of tokenB for adding liquidity with given amount of token A and the amount of tokens in the pool
    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external override pure returns (uint256 amountB) {
        return KSLibrary.quote(amountA, reserveA, reserveB);
    }

    function getAmountsOut(
        uint256 amountIn,
        address[] calldata poolsPath,
        IERC20[] calldata path
    ) external override view returns (uint256[] memory amounts) {
        verifyPoolsPathSwap(poolsPath, path);
        return KSLibrary.getAmountsOut(amountIn, poolsPath, path);
    }

    function getAmountsIn(
        uint256 amountOut,
        address[] calldata poolsPath,
        IERC20[] calldata path
    ) external override view returns (uint256[] memory amounts) {
        verifyPoolsPathSwap(poolsPath, path);
        return KSLibrary.getAmountsIn(amountOut, poolsPath, path);
    }

    function verifyPoolsPathSwap(address[] memory poolsPath, IERC20[] memory path) internal view {
        require(path.length >= 2, "KSRouter: INVALID_PATH");
        require(poolsPath.length == path.length - 1, "KSRouter: INVALID_POOLS_PATH");
        for (uint256 i = 0; i < poolsPath.length; i++) {
            verifyPoolAddress(path[i], path[i + 1], poolsPath[i]);
        }
    }

    function verifyPoolAddress(
        IERC20 tokenA,
        IERC20 tokenB,
        address pool
    ) internal view {
        require(IKSFactory(factory).isPool(tokenA, tokenB, pool), "KSRouter: INVALID_POOL");
    }
}


// File contracts/periphery/ZapIn.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.12;









/// @dev detail here: https://hackmd.io/vdqxJx8STNqPm0LG8vGWaw
contract ZapIn {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    struct ReserveData {
        uint256 rIn;
        uint256 rOut;
        uint256 vIn;
        uint256 vOut;
        uint256 feeInPrecision;
    }

    uint256 private constant PRECISION = 1e18;
    uint256 internal constant Q112 = 2**112;

    IDMMFactory public immutable factory;
    address public immutable weth;

    modifier ensure(uint256 deadline) {
        require(deadline >= block.timestamp, "DMMRouter: EXPIRED");
        _;
    }

    constructor(IDMMFactory _factory, address _weth) public {
        factory = _factory;
        weth = _weth;
    }

    receive() external payable {
        assert(msg.sender == weth); // only accept ETH via fallback from the WETH contract
    }

    /// @dev swap eth to token and then add liquidity to a pool with token-weth
    /// @param tokenOut another token of the pool - not weth
    /// @param pool address of the pool
    /// @param minLpQty min of lp token after swap
    /// @param deadline the last time the transaction can be executed
    function zapInEth(
        IERC20 tokenOut,
        address pool,
        address to,
        uint256 minLpQty,
        uint256 deadline
    ) external payable ensure(deadline) returns (uint256 lpQty) {
        IWETH(weth).deposit{value: msg.value}();
        (uint256 amountSwap, uint256 amountOutput) = calculateSwapAmounts(
            IERC20(weth),
            tokenOut,
            pool,
            msg.value
        );
        IERC20(weth).safeTransfer(pool, amountSwap);
        _swap(amountOutput, IERC20(weth), tokenOut, pool, address(this));

        IERC20(weth).safeTransfer(pool, msg.value.sub(amountSwap));
        tokenOut.safeTransfer(pool, amountOutput);

        lpQty = IDMMPool(pool).mint(to);
        require(lpQty >= minLpQty, "DMMRouter: INSUFFICIENT_MINT_QTY");
    }

    /// @dev swap and add liquidity to a pool with token-weth
    /// @param tokenIn the input token
    /// @param tokenOut another token of the pool
    /// @param pool address of the pool
    /// @param userIn amount of input token
    /// @param minLpQty min of lp token after swap
    /// @param deadline the last time the transaction can be executed
    function zapIn(
        IERC20 tokenIn,
        IERC20 tokenOut,
        uint256 userIn,
        address pool,
        address to,
        uint256 minLpQty,
        uint256 deadline
    ) external ensure(deadline) returns (uint256 lpQty) {
        (uint256 amountSwap, uint256 amountOutput) = calculateSwapAmounts(
            tokenIn,
            tokenOut,
            pool,
            userIn
        );

        tokenIn.safeTransferFrom(msg.sender, pool, amountSwap);
        _swap(amountOutput, tokenIn, tokenOut, pool, address(this));
        tokenIn.safeTransferFrom(msg.sender, pool, userIn.sub(amountSwap));
        tokenOut.safeTransfer(pool, amountOutput);

        lpQty = IDMMPool(pool).mint(to);
        require(lpQty >= minLpQty, "INSUFFICIENT_MINT_QTY");
    }

    function zapOut(
        IERC20 tokenIn,
        IERC20 tokenOut,
        uint256 liquidity,
        address pool,
        address to,
        uint256 minTokenOut,
        uint256 deadline
    ) external ensure(deadline) returns (uint256 amountOut) {
        amountOut = _zapOut(tokenIn, tokenOut, liquidity, pool, minTokenOut);
        tokenOut.safeTransfer(to, amountOut);
    }

    function zapOutPermit(
        IERC20 tokenIn,
        IERC20 tokenOut,
        uint256 liquidity,
        address pool,
        address to,
        uint256 minTokenOut,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external ensure(deadline) returns (uint256 amountOut) {
        uint256 value = approveMax ? uint256(-1) : liquidity;
        IERC20Permit(pool).permit(msg.sender, address(this), value, deadline, v, r, s);
        amountOut = _zapOut(tokenIn, tokenOut, liquidity, pool, minTokenOut);
        tokenOut.safeTransfer(to, amountOut);
    }

    function zapOutEth(
        IERC20 tokenIn,
        uint256 liquidity,
        address pool,
        address to,
        uint256 minTokenOut,
        uint256 deadline
    ) external ensure(deadline) returns (uint256 amountOut) {
        amountOut = _zapOut(tokenIn, IERC20(weth), liquidity, pool, minTokenOut);
        IWETH(weth).withdraw(amountOut);
        TransferHelper.safeTransferETH(to, amountOut);
    }

    function zapOutEthPermit(
        IERC20 tokenIn,
        uint256 liquidity,
        address pool,
        address to,
        uint256 minTokenOut,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountOut) {
        uint256 value = approveMax ? uint256(-1) : liquidity;
        IERC20Permit(pool).permit(msg.sender, address(this), value, deadline, v, r, s);
        amountOut = _zapOut(tokenIn, IERC20(weth), liquidity, pool, minTokenOut);
        IWETH(weth).withdraw(amountOut);
        TransferHelper.safeTransferETH(to, amountOut);
    }

    function calculateZapInAmounts(
        IERC20 tokenIn,
        IERC20 tokenOut,
        address pool,
        uint256 userIn
    ) external view returns (uint256 tokenInAmount, uint256 tokenOutAmount) {
        uint256 amountSwap;
        (amountSwap, tokenOutAmount) = calculateSwapAmounts(tokenIn, tokenOut, pool, userIn);
        tokenInAmount = userIn.sub(amountSwap);
    }

    function calculateZapOutAmount(
        IERC20 tokenIn,
        IERC20 tokenOut,
        address pool,
        uint256 lpQty
    ) external view returns (uint256) {
        require(factory.isPool(tokenIn, tokenOut, pool), "INVALID_POOL");
        (uint256 amountIn, uint256 amountOut, ReserveData memory data) = _calculateBurnAmount(
            pool,
            tokenIn,
            tokenOut,
            lpQty
        );
        amountOut += DMMLibrary.getAmountOut(
            amountIn,
            data.rIn,
            data.rOut,
            data.vIn,
            data.vOut,
            data.feeInPrecision
        );
        return amountOut;
    }

    function calculateSwapAmounts(
        IERC20 tokenIn,
        IERC20 tokenOut,
        address pool,
        uint256 userIn
    ) public view returns (uint256 amountSwap, uint256 amountOutput) {
        require(factory.isPool(tokenIn, tokenOut, pool), "INVALID_POOL");
        (uint256 rIn, uint256 rOut, uint256 vIn, uint256 vOut, uint256 feeInPrecision) = DMMLibrary
            .getTradeInfo(pool, tokenIn, tokenOut);
        amountSwap = _calculateSwapInAmount(rIn, rOut, vIn, vOut, feeInPrecision, userIn);
        amountOutput = DMMLibrary.getAmountOut(amountSwap, rIn, rOut, vIn, vOut, feeInPrecision);
    }

    function _swap(
        uint256 amountOut,
        IERC20 tokenIn,
        IERC20 tokenOut,
        address pool,
        address to
    ) internal {
        (IERC20 token0, ) = DMMLibrary.sortTokens(tokenIn, tokenOut);
        (uint256 amount0Out, uint256 amount1Out) = tokenIn == token0
            ? (uint256(0), amountOut)
            : (amountOut, uint256(0));
        IDMMPool(pool).swap(amount0Out, amount1Out, to, new bytes(0));
    }

    function _zapOut(
        IERC20 tokenIn,
        IERC20 tokenOut,
        uint256 liquidity,
        address pool,
        uint256 minTokenOut
    ) internal returns (uint256 amountOut) {
        uint256 amountIn;
        {
            require(factory.isPool(tokenIn, tokenOut, pool), "INVALID_POOL");
            IERC20(pool).safeTransferFrom(msg.sender, pool, liquidity); // send liquidity to pool
            (uint256 amount0, uint256 amount1) = IDMMPool(pool).burn(address(this));
            (IERC20 token0, ) = DMMLibrary.sortTokens(tokenIn, tokenOut);
            (amountIn, amountOut) = tokenIn == token0 ? (amount0, amount1) : (amount1, amount0);
        }
        uint256 swapAmount;
        {
            (
                uint256 rIn,
                uint256 rOut,
                uint256 vIn,
                uint256 vOut,
                uint256 feeInPrecision
            ) = DMMLibrary.getTradeInfo(pool, tokenIn, tokenOut);
            swapAmount = DMMLibrary.getAmountOut(amountIn, rIn, rOut, vIn, vOut, feeInPrecision);
        }
        tokenIn.safeTransfer(pool, amountIn);
        _swap(swapAmount, tokenIn, tokenOut, pool, address(this));
        amountOut += swapAmount;
        require(amountOut >= minTokenOut, "INSUFFICIENT_OUTPUT_AMOUNT");
    }

    function _calculateBurnAmount(
        address pool,
        IERC20 tokenIn,
        IERC20 tokenOut,
        uint256 lpQty
    )
        internal
        view
        returns (
            uint256 amountIn,
            uint256 amountOut,
            ReserveData memory newData
        )
    {
        ReserveData memory data;
        (data.rIn, data.rOut, data.vIn, data.vOut, data.feeInPrecision) = DMMLibrary.getTradeInfo(
            pool,
            tokenIn,
            tokenOut
        );
        uint256 totalSupply = _calculateSyncTotalSupply(IDMMPool(pool), data);
        bool isAmpPool = (IDMMPool(pool).ampBps() != 10000);
        // calculate amountOut
        amountIn = lpQty.mul(data.rIn) / totalSupply;
        amountOut = lpQty.mul(data.rOut) / totalSupply;
        // calculate ReserveData
        newData.rIn = data.rIn - amountIn;
        newData.rOut = data.rOut - amountOut;
        if (isAmpPool) {
            uint256 b = Math.min(
                newData.rIn.mul(totalSupply) / data.rIn,
                newData.rOut.mul(totalSupply) / data.rOut
            );
            newData.vIn = Math.max(data.vIn.mul(b) / totalSupply, newData.rIn);
            newData.vOut = Math.max(data.vOut.mul(b) / totalSupply, newData.rOut);
        } else {
            newData.vIn = newData.rIn;
            newData.vOut = newData.rOut;
        }
        newData.feeInPrecision = data.feeInPrecision;
    }

    function _calculateSyncTotalSupply(IDMMPool pool, ReserveData memory data)
        internal
        view
        returns (uint256 totalSupply)
    {
        totalSupply = IERC20(address(pool)).totalSupply();

        (address feeTo, uint16 governmentFeeBps) = factory.getFeeConfiguration();
        if (feeTo == address(0)) return totalSupply;

        uint256 _kLast = pool.kLast();
        if (_kLast == 0) return totalSupply;

        uint256 rootKLast = MathExt.sqrt(_kLast);
        uint256 rootK = MathExt.sqrt(data.vIn * data.vOut);

        uint256 numerator = totalSupply.mul(rootK.sub(rootKLast)).mul(governmentFeeBps);
        uint256 denominator = rootK.add(rootKLast).mul(5000);
        uint256 liquidity = numerator / denominator;

        totalSupply += liquidity;
    }

    function _calculateSwapInAmount(
        uint256 rIn,
        uint256 rOut,
        uint256 vIn,
        uint256 vOut,
        uint256 feeInPrecision,
        uint256 userIn
    ) internal pure returns (uint256) {
        uint256 r = PRECISION - feeInPrecision;
        // b = (vOut * rIn + userIn * (vOut - rOut)) * r / PRECISION / rOut+ vIN
        uint256 b;
        {
            uint256 tmp = userIn.mul(vOut.sub(rOut));
            tmp = tmp.add(vOut.mul(rIn));
            b = tmp.div(rOut).mul(r) / PRECISION;
            b = b.add(vIn);
        }
        uint256 inverseC = vIn.mul(userIn);
        // numerator = sqrt(b^2 -4ac) - b
        uint256 numerator = MathExt.sqrt(b.mul(b).add(inverseC.mul(4 * r) / PRECISION)).sub(b);
        return numerator.mul(PRECISION) / (2 * r);
    }
}


// File contracts/periphery/ZapInV2.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;









/// @dev detail here: https://hackmd.io/vdqxJx8STNqPm0LG8vGWaw
contract ZapInV2 {
  using SafeERC20 for IERC20;
  using SafeMath for uint256;

  struct ReserveData {
    uint256 rIn;
    uint256 rOut;
    uint256 vIn;
    uint256 vOut;
    uint256 feeInPrecision;
  }

  uint256 private constant PRECISION = 1e18;
  uint256 internal constant Q112 = 2**112;

  IKSFactory public immutable factory;
  address public immutable weth;

  modifier ensure(uint256 deadline) {
    require(deadline >= block.timestamp, "KSRouter: EXPIRED");
    _;
  }

  constructor(IKSFactory _factory, address _weth) public {
    factory = _factory;
    weth = _weth;
  }

  receive() external payable {
    assert(msg.sender == weth); // only accept ETH via fallback from the WETH contract
  }

  /// @dev swap eth to token and then add liquidity to a pool with token-weth
  /// @param tokenOut another token of the pool - not weth
  /// @param pool address of the pool
  /// @param minLpQty min of lp token after swap
  /// @param deadline the last time the transaction can be executed
  function zapInEth(
    IERC20 tokenOut,
    address pool,
    address to,
    uint256 minLpQty,
    uint256 deadline
  ) external payable ensure(deadline) returns (uint256 lpQty) {
    IWETH(weth).deposit{ value: msg.value }();
    (uint256 amountSwap, uint256 amountOutput) = calculateSwapAmounts(
      IERC20(weth),
      tokenOut,
      pool,
      msg.value
    );
    IERC20(weth).safeTransfer(pool, amountSwap);
    _swap(amountOutput, IERC20(weth), tokenOut, pool, address(this));

    IERC20(weth).safeTransfer(pool, msg.value.sub(amountSwap));
    tokenOut.safeTransfer(pool, amountOutput);

    lpQty = IKSPool(pool).mint(to);
    require(lpQty >= minLpQty, "IKSRouter: INSUFFICIENT_MINT_QTY");
  }

  /// @dev swap and add liquidity to a pool with token-weth
  /// @param tokenIn the input token
  /// @param tokenOut another token of the pool
  /// @param pool address of the pool
  /// @param userIn amount of input token
  /// @param minLpQty min of lp token after swap
  /// @param deadline the last time the transaction can be executed
  function zapIn(
    IERC20 tokenIn,
    IERC20 tokenOut,
    uint256 userIn,
    address pool,
    address to,
    uint256 minLpQty,
    uint256 deadline
  ) external ensure(deadline) returns (uint256 lpQty) {
    (uint256 amountSwap, uint256 amountOutput) = calculateSwapAmounts(
      tokenIn,
      tokenOut,
      pool,
      userIn
    );

    tokenIn.safeTransferFrom(msg.sender, pool, amountSwap);
    _swap(amountOutput, tokenIn, tokenOut, pool, address(this));
    tokenIn.safeTransferFrom(msg.sender, pool, userIn.sub(amountSwap));
    tokenOut.safeTransfer(pool, amountOutput);

    lpQty = IKSPool(pool).mint(to);
    require(lpQty >= minLpQty, "INSUFFICIENT_MINT_QTY");
  }

  function zapOut(
    IERC20 tokenIn,
    IERC20 tokenOut,
    uint256 liquidity,
    address pool,
    address to,
    uint256 minTokenOut,
    uint256 deadline
  ) external ensure(deadline) returns (uint256 amountOut) {
    amountOut = _zapOut(tokenIn, tokenOut, liquidity, pool, minTokenOut);
    tokenOut.safeTransfer(to, amountOut);
  }

  function zapOutPermit(
    IERC20 tokenIn,
    IERC20 tokenOut,
    uint256 liquidity,
    address pool,
    address to,
    uint256 minTokenOut,
    uint256 deadline,
    bool approveMax,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external ensure(deadline) returns (uint256 amountOut) {
    uint256 value = approveMax ? uint256(-1) : liquidity;
    IERC20Permit(pool).permit(
      msg.sender,
      address(this),
      value,
      deadline,
      v,
      r,
      s
    );
    amountOut = _zapOut(tokenIn, tokenOut, liquidity, pool, minTokenOut);
    tokenOut.safeTransfer(to, amountOut);
  }

  function zapOutEth(
    IERC20 tokenIn,
    uint256 liquidity,
    address pool,
    address to,
    uint256 minTokenOut,
    uint256 deadline
  ) external ensure(deadline) returns (uint256 amountOut) {
    amountOut = _zapOut(tokenIn, IERC20(weth), liquidity, pool, minTokenOut);
    IWETH(weth).withdraw(amountOut);
    TransferHelper.safeTransferETH(to, amountOut);
  }

  function zapOutEthPermit(
    IERC20 tokenIn,
    uint256 liquidity,
    address pool,
    address to,
    uint256 minTokenOut,
    uint256 deadline,
    bool approveMax,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external returns (uint256 amountOut) {
    uint256 value = approveMax ? uint256(-1) : liquidity;
    IERC20Permit(pool).permit(
      msg.sender,
      address(this),
      value,
      deadline,
      v,
      r,
      s
    );
    amountOut = _zapOut(tokenIn, IERC20(weth), liquidity, pool, minTokenOut);
    IWETH(weth).withdraw(amountOut);
    TransferHelper.safeTransferETH(to, amountOut);
  }

  function calculateZapInAmounts(
    IERC20 tokenIn,
    IERC20 tokenOut,
    address pool,
    uint256 userIn
  ) external view returns (uint256 tokenInAmount, uint256 tokenOutAmount) {
    uint256 amountSwap;
    (amountSwap, tokenOutAmount) = calculateSwapAmounts(
      tokenIn,
      tokenOut,
      pool,
      userIn
    );
    tokenInAmount = userIn.sub(amountSwap);
  }

  function calculateBurnAmount(
    IERC20 tokenIn,
    IERC20 tokenOut,
    address pool,
    uint256 lpQty
  )
    external
    view
    returns (
      uint256 amountIn,
      uint256 amountOut,
      ReserveData memory data
    )
  {
    require(factory.isPool(tokenIn, tokenOut, pool), "INVALID_POOL");
    (amountIn, amountOut, data) = _calculateBurnAmount(
      pool,
      tokenIn,
      tokenOut,
      lpQty
    );
  }

  function calculateZapOutAmount(
    uint256 amountIn,
    uint256 amountOut,
    ReserveData memory data
  ) external view returns (uint256) {
    amountOut += KSLibrary.getAmountOut(
      amountIn,
      data.rIn,
      data.rOut,
      data.vIn,
      data.vOut,
      data.feeInPrecision
    );
    return amountOut;
  }

  function calculateSwapAmounts(
    IERC20 tokenIn,
    IERC20 tokenOut,
    address pool,
    uint256 userIn
  ) public view returns (uint256 amountSwap, uint256 amountOutput) {
    require(factory.isPool(tokenIn, tokenOut, pool), "INVALID_POOL");
    (
      uint256 rIn,
      uint256 rOut,
      uint256 vIn,
      uint256 vOut,
      uint256 feeInPrecision
    ) = KSLibrary.getTradeInfo(pool, tokenIn, tokenOut);
    amountSwap = _calculateSwapInAmount(
      rIn,
      rOut,
      vIn,
      vOut,
      feeInPrecision,
      userIn
    );
    amountOutput = KSLibrary.getAmountOut(
      amountSwap,
      rIn,
      rOut,
      vIn,
      vOut,
      feeInPrecision
    );
  }

  function _swap(
    uint256 amountOut,
    IERC20 tokenIn,
    IERC20 tokenOut,
    address pool,
    address to
  ) internal {
    (IERC20 token0, ) = KSLibrary.sortTokens(tokenIn, tokenOut);
    (uint256 amount0Out, uint256 amount1Out) = tokenIn == token0
      ? (uint256(0), amountOut)
      : (amountOut, uint256(0));
    IKSPool(pool).swap(amount0Out, amount1Out, to, new bytes(0));
  }

  function _zapOut(
    IERC20 tokenIn,
    IERC20 tokenOut,
    uint256 liquidity,
    address pool,
    uint256 minTokenOut
  ) internal returns (uint256 amountOut) {
    uint256 amountIn;
    {
      require(factory.isPool(tokenIn, tokenOut, pool), "INVALID_POOL");
      IERC20(pool).safeTransferFrom(msg.sender, pool, liquidity); // send liquidity to pool
      (uint256 amount0, uint256 amount1) = IKSPool(pool).burn(address(this));
      (IERC20 token0, ) = KSLibrary.sortTokens(tokenIn, tokenOut);
      (amountIn, amountOut) = tokenIn == token0
        ? (amount0, amount1)
        : (amount1, amount0);
    }
    uint256 swapAmount;
    {
      (
        uint256 rIn,
        uint256 rOut,
        uint256 vIn,
        uint256 vOut,
        uint256 feeInPrecision
      ) = KSLibrary.getTradeInfo(pool, tokenIn, tokenOut);
      swapAmount = KSLibrary.getAmountOut(
        amountIn,
        rIn,
        rOut,
        vIn,
        vOut,
        feeInPrecision
      );
    }
    tokenIn.safeTransfer(pool, amountIn);
    _swap(swapAmount, tokenIn, tokenOut, pool, address(this));
    amountOut += swapAmount;
    require(amountOut >= minTokenOut, "INSUFFICIENT_OUTPUT_AMOUNT");
  }

  function _calculateBurnAmount(
    address pool,
    IERC20 tokenIn,
    IERC20 tokenOut,
    uint256 lpQty
  )
    internal
    view
    returns (
      uint256 amountIn,
      uint256 amountOut,
      ReserveData memory newData
    )
  {
    ReserveData memory data;
    (data.rIn, data.rOut, data.vIn, data.vOut, data.feeInPrecision) = KSLibrary
      .getTradeInfo(pool, tokenIn, tokenOut);
    uint256 totalSupply = _calculateSyncTotalSupply(IKSPool(pool), data);
    bool isAmpPool = (IKSPool(pool).ampBps() != 10000);
    // calculate amountOut
    amountIn = lpQty.mul(data.rIn) / totalSupply; // = data.rIn = 99999999722382351
    amountOut = lpQty.mul(data.rOut) / totalSupply; // = data.rOut = 208289075
    // calculate ReserveData
    newData.rIn = data.rIn - amountIn; // 21908994
    newData.rOut = data.rOut - amountOut; // 1
    if (isAmpPool) {
      uint256 b = Math.min( // 1000
        newData.rIn.mul(totalSupply) / data.rIn, // 1000
        newData.rOut.mul(totalSupply) / data.rOut // 21913
      );
      newData.vIn = Math.max(data.vIn.mul(b) / totalSupply, newData.rIn); // 0
      newData.vOut = Math.max(data.vOut.mul(b) / totalSupply, newData.rOut); // 21913
    } else {
      newData.vIn = newData.rIn;
      newData.vOut = newData.rOut;
    }
    newData.feeInPrecision = data.feeInPrecision;
  }

  function _calculateSyncTotalSupply(IKSPool pool, ReserveData memory data)
    internal
    view
    returns (uint256 totalSupply)
  {
    totalSupply = IERC20(address(pool)).totalSupply();

    (address feeTo, uint16 governmentFeeBps) = factory.getFeeConfiguration();
    if (feeTo == address(0)) return totalSupply;

    uint256 _kLast = pool.kLast();
    if (_kLast == 0) return totalSupply;

    uint256 rootKLast = MathExt.sqrt(_kLast);
    uint256 rootK = MathExt.sqrt(data.vIn * data.vOut);

    uint256 numerator = totalSupply.mul(rootK.sub(rootKLast)).mul(
      governmentFeeBps
    );
    uint256 denominator = rootK.add(rootKLast).mul(5000);
    uint256 liquidity = numerator / denominator;

    totalSupply += liquidity;
  }

  function _calculateSwapInAmount(
    uint256 rIn,
    uint256 rOut,
    uint256 vIn,
    uint256 vOut,
    uint256 feeInPrecision,
    uint256 userIn
  ) internal pure returns (uint256) {
    uint256 r = PRECISION - feeInPrecision;
    // b = (vOut * rIn + userIn * (vOut - rOut)) * r / PRECISION / rOut+ vIN
    uint256 b;
    {
      uint256 tmp = userIn.mul(vOut.sub(rOut));
      tmp = tmp.add(vOut.mul(rIn));
      b = tmp.div(rOut).mul(r) / PRECISION;
      b = b.add(vIn);
    }
    uint256 inverseC = vIn.mul(userIn);
    // numerator = sqrt(b^2 -4ac) - b
    uint256 numerator = MathExt
      .sqrt(b.mul(b).add(inverseC.mul(4 * r) / PRECISION))
      .sub(b);
    return numerator.mul(PRECISION) / (2 * r);
  }
}


// File @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol@v1.0.1

pragma solidity >=0.5.0;

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}


// File contracts/wrapper/LiquidityMigrator.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;








interface ILiquidityMigrator {
    struct PermitData {
        bool approveMax;
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    struct PoolInfo {
        address poolAddress;
        uint32 poolAmp;
        uint256[2] dmmVReserveRatioBounds;
    }

    event RemoveLiquidity(
        address indexed tokenA,
        address indexed tokenB,
        address indexed uniPair,
        uint256 liquidity,
        uint256 amountA,
        uint256 amountB
    );

    event Migrated(
        address indexed tokenA,
        address indexed tokenB,
        uint256 dmmAmountA,
        uint256 dmmAmountB,
        uint256 dmmLiquidity,
        PoolInfo info
    );

    /**
     * @dev Migrate tokens from a pair to a Kyber Dmm Pool
     *   Supporting both normal tokens and tokens with fee on transfer
     *   Support create new pool with received tokens from removing, or
     *       add tokens to a given pool address
     * @param uniPair pair for token that user wants to migrate from
     *   it should be compatible with UniswapPair's interface
     * @param tokenA first token of the pool
     * @param tokenB second token of the pool
     * @param liquidity amount of LP tokens to migrate
     * @param amountAMin min amount for tokenA when removing
     * @param amountBMin min amount for tokenB when removing
     * @param dmmAmountAMin min amount for tokenA when adding
     * @param dmmAmountBMin min amount for tokenB when adding
     * @param poolInfo info the the Kyber DMM Pool - (poolAddress, poolAmp)
     *   if poolAddress is 0x0 -> create new pool with amp factor of poolAmp
     *   otherwise add liquidity to poolAddress
     * @param deadline only allow transaction to be executed before the deadline
     */
    function migrateLpToDmmPool(
        address uniPair,
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        uint256 dmmAmountAMin,
        uint256 dmmAmountBMin,
        PoolInfo calldata poolInfo,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 addedLiquidity
        );

    /**
     * @dev Migrate tokens from a pair to a Kyber Dmm Pool with permit
     *   User doesn't have to make an approve allowance transaction, just need to sign the data
     *   Supporting both normal tokens and tokens with fee on transfer
     *   Support create new pool with received tokens from removing, or
     *       add tokens to a given pool address
     * @param uniPair pair for token that user wants to migrate from
     *   it should be compatible with UniswapPair's interface
     * @param tokenA first token of the pool
     * @param tokenB second token of the pool
     * @param liquidity amount of LP tokens to migrate
     * @param amountAMin min amount for tokenA when removing
     * @param amountBMin min amount for tokenB when removing
     * @param dmmAmountAMin min amount for tokenA when adding
     * @param dmmAmountBMin min amount for tokenB when adding
     * @param poolInfo info the the Kyber DMM Pool - (poolAddress, poolAmp)
     *   if poolAddress is 0x0 -> create new pool with amp factor of poolAmp
     *   otherwise add liquidity to poolAddress
     * @param deadline only allow transaction to be executed before the deadline
     * @param permitData data of approve allowance
     */
    function migrateLpToDmmPoolWithPermit(
        address uniPair,
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        uint256 dmmAmountAMin,
        uint256 dmmAmountBMin,
        PoolInfo calldata poolInfo,
        uint256 deadline,
        PermitData calldata permitData
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 addedLiquidity
        );
}

/**
 * @dev Liquidity Migrator contract to help migrating liquidity
 *       from other sources to Kyber DMM Pool
 */
contract LiquidityMigrator is ILiquidityMigrator, Ownable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    address public immutable dmmRouter;

    constructor(address _dmmRouter) public {
        require(_dmmRouter != address(0), "Migrator: INVALID_ROUTER");
        dmmRouter = _dmmRouter;
    }

    /**
     * @dev Use only for some special tokens
     */
    function manualApproveAllowance(
        IERC20[] calldata tokens,
        address[] calldata spenders,
        uint256 allowance
    ) external onlyOwner {
        for (uint256 i = 0; i < tokens.length; i++) {
            for (uint256 j = 0; j < spenders.length; j++) {
                tokens[i].safeApprove(spenders[j], allowance);
            }
        }
    }

    /**
     * @dev Migrate tokens from a pair to a Kyber Dmm Pool
     *   Supporting both normal tokens and tokens with fee on transfer
     *   Support create new pool with received tokens from removing, or
     *       add tokens to a given pool address
     * @param uniPair pair for token that user wants to migrate from
     *   it should be compatible with UniswapPair's interface
     * @param tokenA first token of the pool
     * @param tokenB second token of the pool
     * @param liquidity amount of LP tokens to migrate
     * @param amountAMin min amount for tokenA when removing/adding
     * @param amountBMin min amount for tokenB when removing/adding
     * @param poolInfo info the the Kyber DMM Pool - (poolAddress, poolAmp)
     *   if poolAddress is 0x0 -> create new pool with amp factor of poolAmp
     *   otherwise add liquidity to poolAddress
     * @param deadline only allow transaction to be executed before the deadline
     * @param permitData data of approve allowance
     */
    function migrateLpToDmmPoolWithPermit(
        address uniPair,
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        uint256 dmmAmountAMin,
        uint256 dmmAmountBMin,
        PoolInfo calldata poolInfo,
        uint256 deadline,
        PermitData calldata permitData
    )
        external
        override
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 addedLiquidity
        )
    {
        IERC20Permit(uniPair).permit(
            msg.sender,
            address(this),
            permitData.approveMax ? uint256(-1) : liquidity,
            deadline,
            permitData.v,
            permitData.r,
            permitData.s
        );

        (amountA, amountB, addedLiquidity) = migrateLpToDmmPool(
            uniPair,
            tokenA,
            tokenB,
            liquidity,
            amountAMin,
            amountBMin,
            dmmAmountAMin,
            dmmAmountBMin,
            poolInfo,
            deadline
        );
    }

    /**
     * @dev Migrate tokens from a pair to a Kyber Dmm Pool with permit
     *   User doesn't have to make an approve allowance transaction, just need to sign the data
     *   Supporting both normal tokens and tokens with fee on transfer
     *   Support create new pool with received tokens from removing, or
     *       add tokens to a given pool address
     * @param uniPair pair for token that user wants to migrate from
     *   it should be compatible with UniswapPair's interface
     * @param tokenA first token of the pool
     * @param tokenB second token of the pool
     * @param liquidity amount of LP tokens to migrate
     * @param amountAMin min amount for tokenA when removing/adding
     * @param amountBMin min amount for tokenB when removing/adding
     * @param poolInfo info the the Kyber DMM Pool - (poolAddress, poolAmp)
     *   if poolAddress is 0x0 -> create new pool with amp factor of poolAmp
     *   otherwise add liquidity to poolAddress
     * @param deadline only allow transaction to be executed before the deadline
     */
    function migrateLpToDmmPool(
        address uniPair,
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        uint256 dmmAmountAMin,
        uint256 dmmAmountBMin,
        PoolInfo memory poolInfo,
        uint256 deadline
    )
        public
        override
        returns (
            uint256 dmmAmountA,
            uint256 dmmAmountB,
            uint256 dmmLiquidity
        )
    {
        // support for both normal token and token with fee on transfer
        {
            uint256 balanceTokenA = IERC20(tokenA).balanceOf(address(this));
            uint256 balanceTokenB = IERC20(tokenB).balanceOf(address(this));
            _removeUniLiquidity(
                uniPair,
                tokenA,
                tokenB,
                liquidity,
                amountAMin,
                amountBMin,
                deadline
            );
            dmmAmountA = IERC20(tokenA).balanceOf(address(this)).sub(balanceTokenA);
            dmmAmountB = IERC20(tokenB).balanceOf(address(this)).sub(balanceTokenB);
            require(dmmAmountA > 0 && dmmAmountB > 0, "Migrator: INVALID_AMOUNT");

            emit RemoveLiquidity(tokenA, tokenB, uniPair, liquidity, dmmAmountA, dmmAmountB);
        }

        (dmmAmountA, dmmAmountB, dmmLiquidity) = _addLiquidityToDmmPool(
            tokenA,
            tokenB,
            dmmAmountA,
            dmmAmountB,
            dmmAmountAMin,
            dmmAmountBMin,
            poolInfo,
            deadline
        );

        emit Migrated(tokenA, tokenB, dmmAmountA, dmmAmountB, dmmLiquidity, poolInfo);
    }

    /** @dev Allow the Owner to withdraw any funds that have been 'wrongly'
     *       transferred to the migrator contract
     */
    function withdrawFund(IERC20 token, uint256 amount) external onlyOwner {
        if (token == IERC20(0)) {
            (bool success, ) = owner().call{value: amount}("");
            require(success, "Migrator: TRANSFER_ETH_FAILED");
        } else {
            token.safeTransfer(owner(), amount);
        }
    }

    /**
     * @dev Add liquidity to Kyber dmm pool, support adding to new pool or an existing pool
     */
    function _addLiquidityToDmmPool(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        PoolInfo memory poolInfo,
        uint256 deadline
    )
        internal
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        )
    {
        // safe approve only if needed
        _safeApproveAllowance(IERC20(tokenA), address(dmmRouter));
        _safeApproveAllowance(IERC20(tokenB), address(dmmRouter));
        if (poolInfo.poolAddress == address(0)) {
            // add to new pool
            (amountA, amountB, liquidity) = _addLiquidityNewPool(
                tokenA,
                tokenB,
                amountADesired,
                amountBDesired,
                amountAMin,
                amountBMin,
                poolInfo.poolAmp,
                deadline
            );
        } else {
            (amountA, amountB, liquidity) = _addLiquidityExistingPool(
                tokenA,
                tokenB,
                amountADesired,
                amountBDesired,
                amountAMin,
                amountBMin,
                poolInfo.poolAddress,
                poolInfo.dmmVReserveRatioBounds,
                deadline
            );
        }
    }

    /**
     * @dev Add liquidity to an existing pool, and return back tokens to users if any
     */
    function _addLiquidityExistingPool(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address dmmPool,
        uint256[2] memory vReserveRatioBounds,
        uint256 deadline
    )
        internal
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        )
    {
        (amountA, amountB, liquidity) = IDMMLiquidityRouter(dmmRouter).addLiquidity(
            IERC20(tokenA),
            IERC20(tokenB),
            dmmPool,
            amountADesired,
            amountBDesired,
            amountAMin,
            amountBMin,
            vReserveRatioBounds,
            msg.sender,
            deadline
        );
        // return back token if needed
        if (amountA < amountADesired) {
            IERC20(tokenA).safeTransfer(msg.sender, amountADesired - amountA);
        }
        if (amountB < amountBDesired) {
            IERC20(tokenB).safeTransfer(msg.sender, amountBDesired - amountB);
        }
    }

    /**
     * @dev Add liquidity to a new pool, and return back tokens to users if any
     */
    function _addLiquidityNewPool(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        uint32 amps,
        uint256 deadline
    )
        internal
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        )
    {
        (amountA, amountB, liquidity) = IDMMLiquidityRouter(dmmRouter).addLiquidityNewPool(
            IERC20(tokenA),
            IERC20(tokenB),
            amps,
            amountADesired,
            amountBDesired,
            amountAMin,
            amountBMin,
            msg.sender,
            deadline
        );
        // return back token if needed
        if (amountA < amountADesired) {
            IERC20(tokenA).safeTransfer(msg.sender, amountADesired - amountA);
        }
        if (amountB < amountBDesired) {
            IERC20(tokenB).safeTransfer(msg.sender, amountBDesired - amountB);
        }
    }

    /**
     * @dev Re-write remove liquidity function from Uniswap
     */
    function _removeUniLiquidity(
        address pair,
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        uint256 deadline
    ) internal {
        require(deadline >= block.timestamp, "Migratior: EXPIRED");
        IERC20(pair).safeTransferFrom(msg.sender, pair, liquidity); // send liquidity to pair
        (uint256 amount0, uint256 amount1) = IUniswapV2Pair(pair).burn(address(this));
        (address token0, ) = _sortTokens(tokenA, tokenB);
        (uint256 amountA, uint256 amountB) = tokenA == token0
            ? (amount0, amount1)
            : (amount1, amount0);
        require(amountA >= amountAMin, "Migratior: UNI_INSUFFICIENT_A_AMOUNT");
        require(amountB >= amountBMin, "Migratior: UNI_INSUFFICIENT_B_AMOUNT");
    }

    /**
     * @dev only approve if the current allowance is 0
     */
    function _safeApproveAllowance(IERC20 token, address spender) internal {
        if (token.allowance(address(this), spender) == 0) {
            token.safeApprove(spender, uint256(-1));
        }
    }

    /**
     * @dev Copy logic of sort token from Uniswap lib
     */
    function _sortTokens(address tokenA, address tokenB)
        internal
        pure
        returns (address token0, address token1)
    {
        require(tokenA != tokenB, "Migrator: IDENTICAL_ADDRESSES");
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), "Migrator: ZERO_ADDRESS");
    }
}


// File contracts/InterviewTest.sol

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

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

contract BasicERC20 is IERC20 {
  mapping(address => uint256) balances;

  mapping(address => mapping(address => uint256)) allowed;

  string public name = "Test";
  string public symbol = "TST";
  uint256 public decimals = 18;
  uint256 public INITIAL_SUPPLY = 30 * 10**18;
  uint256 public override totalSupply;

  constructor(
    string memory _name,
    string memory _symbol,
    uint256 _decimals
  ) public {
    totalSupply = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
    name = _name;
    symbol = _symbol;
    decimals = _decimals;
  }

  event Approval(address sender, address spender, uint256 amount);

  function approve(address _spender, uint256 _value)
    public
    override
    returns (bool)
  {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  function allowance(address _owner, address _spender)
    public
    view
    override
    returns (uint256 remaining)
  {
    return allowed[_owner][_spender];
  }

  event Transfer(address sender, address receiver, uint256 amount);

  function transfer(address _to, uint256 _value)
    public
    override
    returns (bool)
  {
    require(balances[msg.sender] - _value >= 0);
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  ) public override returns (bool) {
    uint256 _allowance = allowed[_from][msg.sender];

    if (_value > _allowance) revert();

    balances[_to] += _value;
    balances[_from] -= _value;
    allowed[_from][msg.sender] -= _value;
    emit Transfer(_from, _to, _value);
  }

  function balanceOf(address _owner)
    public
    view
    override
    returns (uint256 balance)
  {
    return balances[_owner];
  }

  event Burn(address indexed _burner, uint256 _value);

  function burn(uint256 _value) public returns (bool) {
    require(balances[msg.sender] >= _value);
    balances[msg.sender] -= _value;
    totalSupply -= _value;
    emit Burn(msg.sender, _value);
    emit Transfer(msg.sender, address(0x0), _value);
    return true;
  }

  // save some gas by making only one contract call
  function burnFrom(address _from, uint256 _value) public returns (bool) {
    transferFrom(_from, msg.sender, _value);
    return burn(_value);
  }
}

// Inherited by Lottery contract to allow users to make multiple guesses in a single tx
contract Multicall {
  function multicall(bytes[] calldata calls, bool revertOnFail)
    external
    payable
    returns (bool[] memory successes, bytes[] memory results)
  {
    successes = new bool[](calls.length);
    results = new bytes[](calls.length);
    for (uint256 i = 0; i < calls.length; i++) {
      (bool success, bytes memory result) = address(this).delegatecall(
        calls[i]
      );
      require(success || !revertOnFail, _getRevertMsg(result));
      successes[i] = success;
      results[i] = result;
    }
  }

  function _getRevertMsg(bytes memory _returnData)
    internal
    pure
    returns (string memory)
  {
    // If the _res length is less than 68, then the transaction failed silently (without a revert message)
    if (_returnData.length < 68) return "Transaction reverted silently";

    assembly {
      // Slice the sighash.
      _returnData := add(_returnData, 0x04)
    }
    return abi.decode(_returnData, (string)); // All that remains is the revert string
  }
}

interface IWeth is IERC20 {
  function deposit() external payable;

  function withdraw(uint256) external;
}

/// Lottery contract that requires users to guess the block hash of a specified block number
/// A user can make multiple guesses, with each guess costing 0.1 eth
/// A user can also withdraw their guess and be refunded
contract Lottery is Multicall {
  IWeth weth;
  // each guess costs 0.1 eth
  uint256 constant GUESS_COST = 1e17;
  // list of particpiants for this game
  address[] public guessers;
  // end block number for guessing period
  uint32 public endBlockNum;
  // guesses each participiant made
  mapping(address => bytes32[]) public guesses;
  // total deposited funds per guesser
  mapping(address => uint256) public stakes;

  constructor(IWeth _weth, uint32 _endBlockNum) public {
    weth = _weth;
    endBlockNum = _endBlockNum;
  }

  modifier beforeEnd() {
    require(uint32(block.number) < endBlockNum, "guessing period ended");
    _;
  }

  // a guesser made a guess with ETH
  function guessWithEth(bytes32 hash) public payable beforeEnd {
    require(msg.value >= GUESS_COST, "lack of funds");
    weth.deposit{ value: msg.value }();
    _guess(hash);
  }

  // a guesser made a guess with WETH
  function guessWithWeth(bytes32 hash, uint256 amount)
    public
    payable
    beforeEnd
  {
    weth.transferFrom(msg.sender, address(this), amount);
    _guess(hash);
  }

  event WithdrawGuess(address guesser, uint256 index);

  // withdraw guess, unwrap and withdraw eth
  // index = guess index in array
  function withdrawGuess(uint256 index) public payable beforeEnd {
    require(stakes[msg.sender] - GUESS_COST >= 0);
    // remove guess
    delete guesses[msg.sender][index];
    weth.withdraw(GUESS_COST);
    msg.sender.transfer(GUESS_COST);
    stakes[msg.sender] -= GUESS_COST;
    // if no more guesses, remove from list
    for (uint256 i = guessers.length - 1; i >= 0; i--) {
      if (guessers[i] == msg.sender) {
        guessers[i] = guessers[guessers.length - 1];
        guessers.pop();
      }
    }
    emit WithdrawGuess(msg.sender, index);
  }

  // after voting period, anyone will be able to withdraw entire contract balance
  // but only if they are lucky enough in guessing the end block hash
  function winContractFunds(uint256 index) external {
    require(
      uint32(block.number) >= endBlockNum,
      "guessing period has not ended"
    );
    require(
      guesses[msg.sender][index] ==
        keccak256(abi.encodePacked(blockhash(endBlockNum)))
    );
    weth.withdraw(weth.balanceOf(address(this)));
    msg.sender.transfer(address(this).balance);
  }

  function getGuesses(address guesser) public view returns (bytes32[] memory) {
    return guesses[guesser];
  }

  event Guessed(address guesser, bytes32 guess);

  function _guess(bytes32 hash) internal {
    // new guesser, add to list
    if (guesses[msg.sender].length == 0) {
      guessers.push(msg.sender);
    }
    stakes[msg.sender] += GUESS_COST;
    guesses[msg.sender].push(hash);
    emit Guessed(msg.sender, hash);
  }
}


// File contracts/mock/WETH9.sol

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.6.12;

contract WETH9 {
    string public name = "Wrapped Ether";
    string public symbol = "WETH";
    uint8 public decimals = 18;

    event Approval(address indexed src, address indexed guy, uint256 wad);
    event Transfer(address indexed src, address indexed dst, uint256 wad);
    event Deposit(address indexed dst, uint256 wad);
    event Withdrawal(address indexed src, uint256 wad);

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // function() public payable {
    //     deposit();
    // }
    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 wad) public {
        require(balanceOf[msg.sender] >= wad, "");
        balanceOf[msg.sender] -= wad;
        msg.sender.transfer(wad);
        emit Withdrawal(msg.sender, wad);
    }

    function totalSupply() public view returns (uint256) {
        return address(this).balance;
    }

    function approve(address guy, uint256 wad) public returns (bool) {
        allowance[msg.sender][guy] = wad;
        emit Approval(msg.sender, guy, wad);
        return true;
    }

    function transfer(address dst, uint256 wad) public returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }

    function transferFrom(
        address src,
        address dst,
        uint256 wad
    ) public returns (bool) {
        require(balanceOf[src] >= wad, "");

        if (src != msg.sender && allowance[src][msg.sender] != uint256(-1)) {
            require(allowance[src][msg.sender] >= wad, "");
            allowance[src][msg.sender] -= wad;
        }

        balanceOf[src] -= wad;
        balanceOf[dst] += wad;

        emit Transfer(src, dst, wad);

        return true;
    }
}

/*
                    GNU GENERAL PUBLIC LICENSE
                       Version 3, 29 June 2007

 Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
 Everyone is permitted to copy and distribute verbatim copies
 of this license document, but changing it is not allowed.

                            Preamble

  The GNU General Public License is a free, copyleft license for
software and other kinds of works.

  The licenses for most software and other practical works are designed
to take away your freedom to share and change the works.  By contrast,
the GNU General Public License is intended to guarantee your freedom to
share and change all versions of a program--to make sure it remains free
software for all its users.  We, the Free Software Foundation, use the
GNU General Public License for most of our software; it applies also to
any other work released this way by its authors.  You can apply it to
your programs, too.

  When we speak of free software, we are referring to freedom, not
price.  Our General Public Licenses are designed to make sure that you
have the freedom to distribute copies of free software (and charge for
them if you wish), that you receive source code or can get it if you
want it, that you can change the software or use pieces of it in new
free programs, and that you know you can do these things.

  To protect your rights, we need to prevent others from denying you
these rights or asking you to surrender the rights.  Therefore, you have
certain responsibilities if you distribute copies of the software, or if
you modify it: responsibilities to respect the freedom of others.

  For example, if you distribute copies of such a program, whether
gratis or for a fee, you must pass on to the recipients the same
freedoms that you received.  You must make sure that they, too, receive
or can get the source code.  And you must show them these terms so they
know their rights.

  Developers that use the GNU GPL protect your rights with two steps:
(1) assert copyright on the software, and (2) offer you this License
giving you legal permission to copy, distribute and/or modify it.

  For the developers' and authors' protection, the GPL clearly explains
that there is no warranty for this free software.  For both users' and
authors' sake, the GPL requires that modified versions be marked as
changed, so that their problems will not be attributed erroneously to
authors of previous versions.

  Some devices are designed to deny users access to install or run
modified versions of the software inside them, although the manufacturer
can do so.  This is fundamentally incompatible with the aim of
protecting users' freedom to change the software.  The systematic
pattern of such abuse occurs in the area of products for individuals to
use, which is precisely where it is most unacceptable.  Therefore, we
have designed this version of the GPL to prohibit the practice for those
products.  If such problems arise substantially in other domains, we
stand ready to extend this provision to those domains in future versions
of the GPL, as needed to protect the freedom of users.

  Finally, every program is threatened constantly by software patents.
States should not allow patents to restrict development and use of
software on general-purpose computers, but in those that do, we wish to
avoid the special danger that patents applied to a free program could
make it effectively proprietary.  To prevent this, the GPL assures that
patents cannot be used to render the program non-free.

  The precise terms and conditions for copying, distribution and
modification follow.

                       TERMS AND CONDITIONS

  0. Definitions.

  "This License" refers to version 3 of the GNU General Public License.

  "Copyright" also means copyright-like laws that apply to other kinds of
works, such as semiconductor masks.

  "The Program" refers to any copyrightable work licensed under this
License.  Each licensee is addressed as "you".  "Licensees" and
"recipients" may be individuals or organizations.

  To "modify" a work means to copy from or adapt all or part of the work
in a fashion requiring copyright permission, other than the making of an
exact copy.  The resulting work is called a "modified version" of the
earlier work or a work "based on" the earlier work.

  A "covered work" means either the unmodified Program or a work based
on the Program.

  To "propagate" a work means to do anything with it that, without
permission, would make you directly or secondarily liable for
infringement under applicable copyright law, except executing it on a
computer or modifying a private copy.  Propagation includes copying,
distribution (with or without modification), making available to the
public, and in some countries other activities as well.

  To "convey" a work means any kind of propagation that enables other
parties to make or receive copies.  Mere interaction with a user through
a computer network, with no transfer of a copy, is not conveying.

  An interactive user interface displays "Appropriate Legal Notices"
to the extent that it includes a convenient and prominently visible
feature that (1) displays an appropriate copyright notice, and (2)
tells the user that there is no warranty for the work (except to the
extent that warranties are provided), that licensees may convey the
work under this License, and how to view a copy of this License.  If
the interface presents a list of user commands or options, such as a
menu, a prominent item in the list meets this criterion.

  1. Source Code.

  The "source code" for a work means the preferred form of the work
for making modifications to it.  "Object code" means any non-source
form of a work.

  A "Standard Interface" means an interface that either is an official
standard defined by a recognized standards body, or, in the case of
interfaces specified for a particular programming language, one that
is widely used among developers working in that language.

  The "System Libraries" of an executable work include anything, other
than the work as a whole, that (a) is included in the normal form of
packaging a Major Component, but which is not part of that Major
Component, and (b) serves only to enable use of the work with that
Major Component, or to implement a Standard Interface for which an
implementation is available to the public in source code form.  A
"Major Component", in this context, means a major essential component
(kernel, window system, and so on) of the specific operating system
(if any) on which the executable work runs, or a compiler used to
produce the work, or an object code interpreter used to run it.

  The "Corresponding Source" for a work in object code form means all
the source code needed to generate, install, and (for an executable
work) run the object code and to modify the work, including scripts to
control those activities.  However, it does not include the work's
System Libraries, or general-purpose tools or generally available free
programs which are used unmodified in performing those activities but
which are not part of the work.  For example, Corresponding Source
includes interface definition files associated with source files for
the work, and the source code for shared libraries and dynamically
linked subprograms that the work is specifically designed to require,
such as by intimate data communication or control flow between those
subprograms and other parts of the work.

  The Corresponding Source need not include anything that users
can regenerate automatically from other parts of the Corresponding
Source.

  The Corresponding Source for a work in source code form is that
same work.

  2. Basic Permissions.

  All rights granted under this License are granted for the term of
copyright on the Program, and are irrevocable provided the stated
conditions are met.  This License explicitly affirms your unlimited
permission to run the unmodified Program.  The output from running a
covered work is covered by this License only if the output, given its
content, constitutes a covered work.  This License acknowledges your
rights of fair use or other equivalent, as provided by copyright law.

  You may make, run and propagate covered works that you do not
convey, without conditions so long as your license otherwise remains
in force.  You may convey covered works to others for the sole purpose
of having them make modifications exclusively for you, or provide you
with facilities for running those works, provided that you comply with
the terms of this License in conveying all material for which you do
not control copyright.  Those thus making or running the covered works
for you must do so exclusively on your behalf, under your direction
and control, on terms that prohibit them from making any copies of
your copyrighted material outside their relationship with you.

  Conveying under any other circumstances is permitted solely under
the conditions stated below.  Sublicensing is not allowed; section 10
makes it unnecessary.

  3. Protecting Users' Legal Rights From Anti-Circumvention Law.

  No covered work shall be deemed part of an effective technological
measure under any applicable law fulfilling obligations under article
11 of the WIPO copyright treaty adopted on 20 December 1996, or
similar laws prohibiting or restricting circumvention of such
measures.

  When you convey a covered work, you waive any legal power to forbid
circumvention of technological measures to the extent such circumvention
is effected by exercising rights under this License with respect to
the covered work, and you disclaim any intention to limit operation or
modification of the work as a means of enforcing, against the work's
users, your or third parties' legal rights to forbid circumvention of
technological measures.

  4. Conveying Verbatim Copies.

  You may convey verbatim copies of the Program's source code as you
receive it, in any medium, provided that you conspicuously and
appropriately publish on each copy an appropriate copyright notice;
keep intact all notices stating that this License and any
non-permissive terms added in accord with section 7 apply to the code;
keep intact all notices of the absence of any warranty; and give all
recipients a copy of this License along with the Program.

  You may charge any price or no price for each copy that you convey,
and you may offer support or warranty protection for a fee.

  5. Conveying Modified Source Versions.

  You may convey a work based on the Program, or the modifications to
produce it from the Program, in the form of source code under the
terms of section 4, provided that you also meet all of these conditions:

    a) The work must carry prominent notices stating that you modified
    it, and giving a relevant date.

    b) The work must carry prominent notices stating that it is
    released under this License and any conditions added under section
    7.  This requirement modifies the requirement in section 4 to
    "keep intact all notices".

    c) You must license the entire work, as a whole, under this
    License to anyone who comes into possession of a copy.  This
    License will therefore apply, along with any applicable section 7
    additional terms, to the whole of the work, and all its parts,
    regardless of how they are packaged.  This License gives no
    permission to license the work in any other way, but it does not
    invalidate such permission if you have separately received it.

    d) If the work has interactive user interfaces, each must display
    Appropriate Legal Notices; however, if the Program has interactive
    interfaces that do not display Appropriate Legal Notices, your
    work need not make them do so.

  A compilation of a covered work with other separate and independent
works, which are not by their nature extensions of the covered work,
and which are not combined with it such as to form a larger program,
in or on a volume of a storage or distribution medium, is called an
"aggregate" if the compilation and its resulting copyright are not
used to limit the access or legal rights of the compilation's users
beyond what the individual works permit.  Inclusion of a covered work
in an aggregate does not cause this License to apply to the other
parts of the aggregate.

  6. Conveying Non-Source Forms.

  You may convey a covered work in object code form under the terms
of sections 4 and 5, provided that you also convey the
machine-readable Corresponding Source under the terms of this License,
in one of these ways:

    a) Convey the object code in, or embodied in, a physical product
    (including a physical distribution medium), accompanied by the
    Corresponding Source fixed on a durable physical medium
    customarily used for software interchange.

    b) Convey the object code in, or embodied in, a physical product
    (including a physical distribution medium), accompanied by a
    written offer, valid for at least three years and valid for as
    long as you offer spare parts or customer support for that product
    model, to give anyone who possesses the object code either (1) a
    copy of the Corresponding Source for all the software in the
    product that is covered by this License, on a durable physical
    medium customarily used for software interchange, for a price no
    more than your reasonable cost of physically performing this
    conveying of source, or (2) access to copy the
    Corresponding Source from a network server at no charge.

    c) Convey individual copies of the object code with a copy of the
    written offer to provide the Corresponding Source.  This
    alternative is allowed only occasionally and noncommercially, and
    only if you received the object code with such an offer, in accord
    with subsection 6b.

    d) Convey the object code by offering access from a designated
    place (gratis or for a charge), and offer equivalent access to the
    Corresponding Source in the same way through the same place at no
    further charge.  You need not require recipients to copy the
    Corresponding Source along with the object code.  If the place to
    copy the object code is a network server, the Corresponding Source
    may be on a different server (operated by you or a third party)
    that supports equivalent copying facilities, provided you maintain
    clear directions next to the object code saying where to find the
    Corresponding Source.  Regardless of what server hosts the
    Corresponding Source, you remain obligated to ensure that it is
    available for as long as needed to satisfy these requirements.

    e) Convey the object code using peer-to-peer transmission, provided
    you inform other peers where the object code and Corresponding
    Source of the work are being offered to the general public at no
    charge under subsection 6d.

  A separable portion of the object code, whose source code is excluded
from the Corresponding Source as a System Library, need not be
included in conveying the object code work.

  A "User Product" is either (1) a "consumer product", which means any
tangible personal property which is normally used for personal, family,
or household purposes, or (2) anything designed or sold for incorporation
into a dwelling.  In determining whether a product is a consumer product,
doubtful cases shall be resolved in favor of coverage.  For a particular
product received by a particular user, "normally used" refers to a
typical or common use of that class of product, regardless of the status
of the particular user or of the way in which the particular user
actually uses, or expects or is expected to use, the product.  A product
is a consumer product regardless of whether the product has substantial
commercial, industrial or non-consumer uses, unless such uses represent
the only significant mode of use of the product.

  "Installation Information" for a User Product means any methods,
procedures, authorization keys, or other information required to install
and execute modified versions of a covered work in that User Product from
a modified version of its Corresponding Source.  The information must
suffice to ensure that the continued functioning of the modified object
code is in no case prevented or interfered with solely because
modification has been made.

  If you convey an object code work under this section in, or with, or
specifically for use in, a User Product, and the conveying occurs as
part of a transaction in which the right of possession and use of the
User Product is transferred to the recipient in perpetuity or for a
fixed term (regardless of how the transaction is characterized), the
Corresponding Source conveyed under this section must be accompanied
by the Installation Information.  But this requirement does not apply
if neither you nor any third party retains the ability to install
modified object code on the User Product (for example, the work has
been installed in ROM).

  The requirement to provide Installation Information does not include a
requirement to continue to provide support service, warranty, or updates
for a work that has been modified or installed by the recipient, or for
the User Product in which it has been modified or installed.  Access to a
network may be denied when the modification itself materially and
adversely affects the operation of the network or violates the rules and
protocols for communication across the network.

  Corresponding Source conveyed, and Installation Information provided,
in accord with this section must be in a format that is publicly
documented (and with an implementation available to the public in
source code form), and must require no special password or key for
unpacking, reading or copying.

  7. Additional Terms.

  "Additional permissions" are terms that supplement the terms of this
License by making exceptions from one or more of its conditions.
Additional permissions that are applicable to the entire Program shall
be treated as though they were included in this License, to the extent
that they are valid under applicable law.  If additional permissions
apply only to part of the Program, that part may be used separately
under those permissions, but the entire Program remains governed by
this License without regard to the additional permissions.

  When you convey a copy of a covered work, you may at your option
remove any additional permissions from that copy, or from any part of
it.  (Additional permissions may be written to require their own
removal in certain cases when you modify the work.)  You may place
additional permissions on material, added by you to a covered work,
for which you have or can give appropriate copyright permission.

  Notwithstanding any other provision of this License, for material you
add to a covered work, you may (if authorized by the copyright holders of
that material) supplement the terms of this License with terms:

    a) Disclaiming warranty or limiting liability differently from the
    terms of sections 15 and 16 of this License; or

    b) Requiring preservation of specified reasonable legal notices or
    author attributions in that material or in the Appropriate Legal
    Notices displayed by works containing it; or

    c) Prohibiting misrepresentation of the origin of that material, or
    requiring that modified versions of such material be marked in
    reasonable ways as different from the original version; or

    d) Limiting the use for publicity purposes of names of licensors or
    authors of the material; or

    e) Declining to grant rights under trademark law for use of some
    trade names, trademarks, or service marks; or

    f) Requiring indemnification of licensors and authors of that
    material by anyone who conveys the material (or modified versions of
    it) with contractual assumptions of liability to the recipient, for
    any liability that these contractual assumptions directly impose on
    those licensors and authors.

  All other non-permissive additional terms are considered "further
restrictions" within the meaning of section 10.  If the Program as you
received it, or any part of it, contains a notice stating that it is
governed by this License along with a term that is a further
restriction, you may remove that term.  If a license document contains
a further restriction but permits relicensing or conveying under this
License, you may add to a covered work material governed by the terms
of that license document, provided that the further restriction does
not survive such relicensing or conveying.

  If you add terms to a covered work in accord with this section, you
must place, in the relevant source files, a statement of the
additional terms that apply to those files, or a notice indicating
where to find the applicable terms.

  Additional terms, permissive or non-permissive, may be stated in the
form of a separately written license, or stated as exceptions;
the above requirements apply either way.

  8. Termination.

  You may not propagate or modify a covered work except as expressly
provided under this License.  Any attempt otherwise to propagate or
modify it is void, and will automatically terminate your rights under
this License (including any patent licenses granted under the third
paragraph of section 11).

  However, if you cease all violation of this License, then your
license from a particular copyright holder is reinstated (a)
provisionally, unless and until the copyright holder explicitly and
finally terminates your license, and (b) permanently, if the copyright
holder fails to notify you of the violation by some reasonable means
prior to 60 days after the cessation.

  Moreover, your license from a particular copyright holder is
reinstated permanently if the copyright holder notifies you of the
violation by some reasonable means, this is the first time you have
received notice of violation of this License (for any work) from that
copyright holder, and you cure the violation prior to 30 days after
your receipt of the notice.

  Termination of your rights under this section does not terminate the
licenses of parties who have received copies or rights from you under
this License.  If your rights have been terminated and not permanently
reinstated, you do not qualify to receive new licenses for the same
material under section 10.

  9. Acceptance Not Required for Having Copies.

  You are not required to accept this License in order to receive or
run a copy of the Program.  Ancillary propagation of a covered work
occurring solely as a consequence of using peer-to-peer transmission
to receive a copy likewise does not require acceptance.  However,
nothing other than this License grants you permission to propagate or
modify any covered work.  These actions infringe copyright if you do
not accept this License.  Therefore, by modifying or propagating a
covered work, you indicate your acceptance of this License to do so.

  10. Automatic Licensing of Downstream Recipients.

  Each time you convey a covered work, the recipient automatically
receives a license from the original licensors, to run, modify and
propagate that work, subject to this License.  You are not responsible
for enforcing compliance by third parties with this License.

  An "entity transaction" is a transaction transferring control of an
organization, or substantially all assets of one, or subdividing an
organization, or merging organizations.  If propagation of a covered
work results from an entity transaction, each party to that
transaction who receives a copy of the work also receives whatever
licenses to the work the party's predecessor in interest had or could
give under the previous paragraph, plus a right to possession of the
Corresponding Source of the work from the predecessor in interest, if
the predecessor has it or can get it with reasonable efforts.

  You may not impose any further restrictions on the exercise of the
rights granted or affirmed under this License.  For example, you may
not impose a license fee, royalty, or other charge for exercise of
rights granted under this License, and you may not initiate litigation
(including a cross-claim or counterclaim in a lawsuit) alleging that
any patent claim is infringed by making, using, selling, offering for
sale, or importing the Program or any portion of it.

  11. Patents.

  A "contributor" is a copyright holder who authorizes use under this
License of the Program or a work on which the Program is based.  The
work thus licensed is called the contributor's "contributor version".

  A contributor's "essential patent claims" are all patent claims
owned or controlled by the contributor, whether already acquired or
hereafter acquired, that would be infringed by some manner, permitted
by this License, of making, using, or selling its contributor version,
but do not include claims that would be infringed only as a
consequence of further modification of the contributor version.  For
purposes of this definition, "control" includes the right to grant
patent sublicenses in a manner consistent with the requirements of
this License.

  Each contributor grants you a non-exclusive, worldwide, royalty-free
patent license under the contributor's essential patent claims, to
make, use, sell, offer for sale, import and otherwise run, modify and
propagate the contents of its contributor version.

  In the following three paragraphs, a "patent license" is any express
agreement or commitment, however denominated, not to enforce a patent
(such as an express permission to practice a patent or covenant not to
sue for patent infringement).  To "grant" such a patent license to a
party means to make such an agreement or commitment not to enforce a
patent against the party.

  If you convey a covered work, knowingly relying on a patent license,
and the Corresponding Source of the work is not available for anyone
to copy, free of charge and under the terms of this License, through a
publicly available network server or other readily accessible means,
then you must either (1) cause the Corresponding Source to be so
available, or (2) arrange to deprive yourself of the benefit of the
patent license for this particular work, or (3) arrange, in a manner
consistent with the requirements of this License, to extend the patent
license to downstream recipients.  "Knowingly relying" means you have
actual knowledge that, but for the patent license, your conveying the
covered work in a country, or your recipient's use of the covered work
in a country, would infringe one or more identifiable patents in that
country that you have reason to believe are valid.

  If, pursuant to or in connection with a single transaction or
arrangement, you convey, or propagate by procuring conveyance of, a
covered work, and grant a patent license to some of the parties
receiving the covered work authorizing them to use, propagate, modify
or convey a specific copy of the covered work, then the patent license
you grant is automatically extended to all recipients of the covered
work and works based on it.

  A patent license is "discriminatory" if it does not include within
the scope of its coverage, prohibits the exercise of, or is
conditioned on the non-exercise of one or more of the rights that are
specifically granted under this License.  You may not convey a covered
work if you are a party to an arrangement with a third party that is
in the business of distributing software, under which you make payment
to the third party based on the extent of your activity of conveying
the work, and under which the third party grants, to any of the
parties who would receive the covered work from you, a discriminatory
patent license (a) in connection with copies of the covered work
conveyed by you (or copies made from those copies), or (b) primarily
for and in connection with specific products or compilations that
contain the covered work, unless you entered into that arrangement,
or that patent license was granted, prior to 28 March 2007.

  Nothing in this License shall be construed as excluding or limiting
any implied license or other defenses to infringement that may
otherwise be available to you under applicable patent law.

  12. No Surrender of Others' Freedom.

  If conditions are imposed on you (whether by court order, agreement or
otherwise) that contradict the conditions of this License, they do not
excuse you from the conditions of this License.  If you cannot convey a
covered work so as to satisfy simultaneously your obligations under this
License and any other pertinent obligations, then as a consequence you may
not convey it at all.  For example, if you agree to terms that obligate you
to collect a royalty for further conveying from those to whom you convey
the Program, the only way you could satisfy both those terms and this
License would be to refrain entirely from conveying the Program.

  13. Use with the GNU Affero General Public License.

  Notwithstanding any other provision of this License, you have
permission to link or combine any covered work with a work licensed
under version 3 of the GNU Affero General Public License into a single
combined work, and to convey the resulting work.  The terms of this
License will continue to apply to the part which is the covered work,
but the special requirements of the GNU Affero General Public License,
section 13, concerning interaction through a network will apply to the
combination as such.

  14. Revised Versions of this License.

  The Free Software Foundation may publish revised and/or new versions of
the GNU General Public License from time to time.  Such new versions will
be similar in spirit to the present version, but may differ in detail to
address new problems or concerns.

  Each version is given a distinguishing version number.  If the
Program specifies that a certain numbered version of the GNU General
Public License "or any later version" applies to it, you have the
option of following the terms and conditions either of that numbered
version or of any later version published by the Free Software
Foundation.  If the Program does not specify a version number of the
GNU General Public License, you may choose any version ever published
by the Free Software Foundation.

  If the Program specifies that a proxy can decide which future
versions of the GNU General Public License can be used, that proxy's
public statement of acceptance of a version permanently authorizes you
to choose that version for the Program.

  Later license versions may give you additional or different
permissions.  However, no additional obligations are imposed on any
author or copyright holder as a result of your choosing to follow a
later version.

  15. Disclaimer of Warranty.

  THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY
APPLICABLE LAW.  EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT
HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY
OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
IS WITH YOU.  SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF
ALL NECESSARY SERVICING, REPAIR OR CORRECTION.

  16. Limitation of Liability.

  IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MODIFIES AND/OR CONVEYS
THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY
GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE
USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF
DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD
PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS),
EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

  17. Interpretation of Sections 15 and 16.

  If the disclaimer of warranty and limitation of liability provided
above cannot be given local legal effect according to their terms,
reviewing courts shall apply local law that most closely approximates
an absolute waiver of all civil liability in connection with the
Program, unless a warranty or assumption of liability accompanies a
copy of the Program in return for a fee.

                     END OF TERMS AND CONDITIONS

            How to Apply These Terms to Your New Programs

  If you develop a new program, and you want it to be of the greatest
possible use to the public, the best way to achieve this is to make it
free software which everyone can redistribute and change under these terms.

  To do so, attach the following notices to the program.  It is safest
to attach them to the start of each source file to most effectively
state the exclusion of warranty; and each file should have at least
the "copyright" line and a pointer to where the full notice is found.

    <one line to give the program's name and a brief idea of what it does.>
    Copyright (C) <year>  <name of author>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

Also add information on how to contact you by electronic and paper mail.

  If the program does terminal interaction, make it output a short
notice like this when it starts in an interactive mode:

    <program>  Copyright (C) <year>  <name of author>
    This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
    This is free software, and you are welcome to redistribute it
    under certain conditions; type `show c' for details.

The hypothetical commands `show w' and `show c' should show the appropriate
parts of the General Public License.  Of course, your program's commands
might be different; for a GUI interface, you would use an "about box".

  You should also get your employer (if you work as a programmer) or school,
if any, to sign a "copyright disclaimer" for the program, if necessary.
For more information on this, and how to apply and follow the GNU GPL, see
<http://www.gnu.org/licenses/>.

  The GNU General Public License does not permit incorporating your program
into proprietary programs.  If your program is a subroutine library, you
may consider it more useful to permit linking proprietary applications with
the library.  If this is what you want to do, use the GNU Lesser General
Public License instead of this License.  But first, please read
<http://www.gnu.org/philosophy/why-not-lgpl.html>.

*/
