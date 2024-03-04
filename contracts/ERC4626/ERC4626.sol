// // SPDX-License-Identifier: MIT

// pragma solidity ^0.8.0;

// import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
// import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
// import {IERC4626} from "./IERC4626.sol";

// abstract contract ERC4626 is ERC20, IERC4626 {
//     using Math for uint256;

//     ERC20 private immutable _asset;
//     uint8 private immutable _underlyingDecimals;

//     constructor(ERC20 asset_) {
//         (bool success, uint8 assetDecimals) = _tryGetAssetDecimals(asset_);
//         _underlyingDecimals = success ? assetDecimals : 18;
//         _asset = asset_;
//     }

//     function _tryGetAssetDecimals(
//         IERC20 asset_
//     ) private view returns (bool, uint8) {
//         (bool success, bytes memory encodedDecimals) = address(asset_)
//         // почитать про ЭТО
//             .staticcall(abi.encodeCall(IERC20Metadata.decimals, ()));
//         if (success && encodedDecimals.length >= 32) {
//             uint256 returnedDecimals = abi.decode(encodedDecimals, (uint256));
//             if (returnedDecimals <= type(uint8).max) {
//                 return (true, uint8(returnedDecimals));
//             }
//         }
//         return (false, 0);
//     }

//     function asset() public view virtual returns (address) {
//         return address(_asset);
//     }

//     function totalAssets() public view virtual returns (uint256) {
//         return _asset.balanceOf(address(this));
//     }

//     function convertToShares(uint assets) public view returns (uint shares) {
//         return _convertToShares(assets, Math.Rounding.Floor);
//     }

//     function convertToAssets(uint shares) public view returns (uint assets) {
//         return _convertToShares(shares, Math.Rounding.Floor);
//     }

//     function maxDeposit(address receiver) public view returns (uint maxAssets) {
//         return type(uint256).max;
//     }

//     function maxMint(address receiver) public view returns (uint maxShares) {
//         return type(uint256).max;
//     }

//     function maxWithdraw(address owner) public view returns (uint maxAssets) {
//         return _convertToAssets(balanceOf(owner), Math.Rounding.Floor);
//     }

//     function maxRedeem(address owner) public view returns (uint maxShares) {
//         return balanceOf(owner);
//     }

//     function previewDeposit(uint assets) public view returns (uint shares) {
//         return _convertToShares(assets, Math.Rounding.Floor);
//     }

//     function previewMint(uint shares) public view returns (uint assets) {
//         return _convertToAssets(shares, Math.Rounding.Ceil);
//     }

//     function previewWithdraw(uint assets) public view returns (uint shares) {
//         return _convertToShares(assets, Math.Rounding.Floor);
//     }

//     function previewRedeem(uint shares) public view returns (uint assets) {
//         return _convertToAssets(shares, Math.Rounding.Floor);
//     }

//     function deposit(
//         uint assets,
//         address receiver
//     ) external returns (uint shares) {
//         require(assets <= maxDeposit(receiver));

//         shares = previewDeposit(assets);

//         _deposit(msg.sender, receiver, assets, shares);
//         return shares;
//     }

//     function mint(
//         uint shares,
//         address receiver
//     ) external returns (uint assets) {
//         require(assets <= maxMint(receiver));

//         assets = previewMint(shares);

//         _deposit(msg.sender, receiver, assets, shares);

//         return assets;
//     }

//     function withdraw(
//         uint assets,
//         address receiver,
//         address owner
//     ) external returns (uint shares) {
//         require(assets <= maxWithdraw(owner));

//         shares = previewWithdraw(assets);

//         _withdraw(msg.sender, receiver, owner, assets, shares);
//     }

//     function redeem(
//         uint shares,
//         address receiver,
//         address owner
//     ) external returns (uint assets) {
//         require(shares <= maxRedeem(owner));

//         assets = previewRedeem(assets);

//         _withdraw(msg.sender, receiver, owner, assets, shares);
//     }

//     function _deposit(
//         address caller,
//         address receiver,
//         uint256 assets,
//         uint256 shares
//     ) internal virtual {
//         _asset.transferFrom(caller, address(this), assets);

//         _mint(receiver, shares);

//         emit Deposit(caller, receiver, assets, shares);
//     }

//     function _withdraw(
//         address caller,
//         address receiver,
//         address owner,
//         uint256 assets,
//         uint256 shares
//     ) internal virtual {
//         if (caller != owner) {
//             _spendAllowance(owner, caller, shares);
//         }

//         _burn(owner, shares);

//         _asset.transfer(receiver, assets);

//         emit Withdraw(caller, receiver, owner, assets, shares);
//     }

//     function _convertToShares(
//         uint assets,
//         Math.Rounding rounding
//     ) public virtual returns (uint) {
//         assets.mulDiv(
//             totalSupply() + 10 ** _decimalOffset(),
//             totalAssets() + 1,
//             rounding
//         );
//     }

//     function _convertToAssets(
//         uint shares,
//         Math.Rounding rounding
//     ) public virtual returns (uint) {
//         shares.mulDiv(
//             totalAssets() + 1,
//             totalSupply() + 10 ** _decimalOffset(),
//             rounding
//         );
//     }

//     function _decimalOffset() internal view virtual returns (uint8) {
//         return 0;
//     }
// }
