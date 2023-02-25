// SPDX-License-Identifier:MIT
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./INft.sol";

contract Nftstake {

     struct Staker{
        uint256 stakedId;
        uint256 startTime;
        uint256 rewardAccrued;
        uint256 stakeAmount;
    }
    mapping(address => Staker) user;

    IERC721 stakeNft;
    uint256 constant Years = 31536000;
    IERC20 stakeToken;

    constructor() {
        stakeNft = IERC721(0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D);
        stakeToken = IERC20(0x0D8775F648430679A709E98d2b0Cb6250d2887EF);
    }



      function stake(uint256 amount) external {
        uint bal = stakeNft.balanceOf(msg.sender);
        address isowner = stakeNft.ownerOf(bal);
        require(msg.sender == isowner, "you need the boreApe nft to stake");
        Staker storage _user = user[msg.sender];
        uint256 _amount = _user.stakeAmount;

        stakeToken.transfer(msg.sender, amount);

        if (_amount == 0) {
            _user.stakeAmount = amount;
            _user.startTime = block.timestamp;
        } else {
            Reward();
            _user.stakeAmount += amount;
        }
    }

     function Reward() public returns(uint currentreward) {
        Staker storage _user = user[msg.sender];
        uint256 _reward;

        uint256 _amount = _user.stakeAmount;
        uint256 _startTime = _user.startTime;
        uint256 duration = block.timestamp - _startTime;
        _reward = (duration * 20 * _amount) / (Years * 100);
        _user.rewardAccrued += _reward;
        _user.startTime = block.timestamp;

        return currentreward = _reward;

    }

     function withdrawStaked(uint256 amount) public {
        Staker storage _user = user[msg.sender];
        uint256 staked = _user.stakeAmount;
        require(staked >= amount, "insufficient fund");
        Reward();
        _user.stakeAmount -= amount;
        stakeToken.transfer(msg.sender, amount);
    }
}