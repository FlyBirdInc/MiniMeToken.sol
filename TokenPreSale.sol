pragma solidity ^0.4.17;

import "./MiniMeToken.sol";
import "./SafeMath.sol";

contract TokenPreSale {
    using SafeMath for uint256;
    
    MiniMeToken public token;
    address public beneficiary;
    uint256 public amountRaised;
    uint256 public bonus;

    uint256 constant public exchange = 1;
    uint256 constant public minSaleAmount = 1000000000000000000;

    function TokenPreSale(
        address _token,
        address _beneficiary,
        uint256 _bonus
    ) public {
        token = MiniMeToken(_token);
        beneficiary = _beneficiary;
        bonus = _bonus;
    }

    function () public payable {
        uint256 amount = msg.value;
        uint256 tokenAmount = amount.mul(exchange);
        assert(tokenAmount > minSaleAmount);
        tokenAmount = tokenAmount.add(tokenAmount.percent(bonus));
        amountRaised = amountRaised.add(amount);
        token.transfer(msg.sender, tokenAmount);
    }

    function WithdrawETH(uint256 _amount) public {
        require(msg.sender == beneficiary);
        msg.sender.transfer(_amount);
    }

    function WithdrawTokens(uint256 _amount) public {
        require(msg.sender == beneficiary);
        token.transfer(beneficiary, _amount);
    }

    function TransferTokens(address _to, uint _amount) public {
        require(msg.sender == beneficiary);
        token.transfer(_to, _amount);
    }

    function ChangeBonus(uint256 _bonus) public {
        require(msg.sender == beneficiary);
        bonus = _bonus;
    }
}
