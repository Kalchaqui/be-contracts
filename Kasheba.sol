// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract Kasheba is ERC20, ERC20Pausable, Ownable, ERC20Permit {
    address public cityToken;

    constructor(address initialOwner, address _cityToken)
        ERC20("Kasheba", "KSB")
        Ownable(initialOwner)
        ERC20Permit("Kasheba")
    {
        cityToken = _cityToken;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function buy(uint256 amount) public payable {
        require(msg.value > 0, "Insufficient funds");
        ERC20 token = ERC20(cityToken);
        uint256 tokenAmount = amount * 10 ** decimals();
        require(tokenAmount <= token.balanceOf(owner()), "Not enough city tokens available");
        _transfer(owner(), msg.sender, tokenAmount);
    }

    function sell(uint256 amount) public payable {
        uint256 tokenAmount = amount * 10 ** decimals();
        require(tokenAmount <= balanceOf(msg.sender), "Not enough tokens");
        require(address(this).balance >= msg.value, "Not enough Ether in contract");
        _transfer(msg.sender, owner(), tokenAmount);
        payable(msg.sender).transfer(msg.value);
    }

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Pausable)
    {
        super._update(from, to, value);
    }
}