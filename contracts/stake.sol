// SPDX-License-Identifier:MIT
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./INft.sol";

contract Nftstake{

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
    address public owner;

    
    string private name;

    
    string private symbol;

    
    uint256 private decimal;

    
    uint private totalSupply;
     mapping (address => uint256) private balanceOf;
    // owner => spender =>  amount
    mapping (address =>mapping(address => uint)) public allowance;

    event transfer_(address indexed from, address to, uint amount);
    event _mint(address indexed from, address to, uint amount);
    IERC20 rewardToken;

    constructor() {
        stakeNft = IERC721(0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D);
        stakeToken = IERC20(0x0D8775F648430679A709E98d2b0Cb6250d2887EF);
        name = "ATOKEN";
        symbol = "AT";
        decimal = 1e18;
        rewardToken = IERC20(address(this));
        owner = msg.sender;

        mint(address(this), 100000000000000000000000000);
    }

    modifier onlyowner {
        require(msg.sender == owner, "unauthorised access");

        _;
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

      function WithdrawReward(uint256 amount) public {
        Staker storage _user = user[msg.sender];
        Reward();
        uint256 _claimableReward = _user.rewardAccrued;
        require(_claimableReward >= amount, "insufficient funds");
        _user.rewardAccrued -= amount;
        
        rewardToken.transfer(msg.sender, amount);
    }

    function transfer(address _to, uint amount)public {
        _transfer(msg.sender, _to, amount);
        emit transfer_(msg.sender, _to, amount);

    }
      function _transfer(address from, address to, uint amount) internal {
        require(balanceOf[from] >= amount, "insufficient fund");
        require(to != address(0), "transferr to address(0)");
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
    }

    function mint(address to, uint256 amount) onlyowner public {
        require(msg.sender == owner, "Access Denied");
        require(to != address(0), "transfer to zero not possible");
        totalSupply += amount;
        balanceOf[to] += amount * decimal;
        emit _mint(address(0), to, amount);


    }
     receive() external payable{}


    fallback() external payable{}
}