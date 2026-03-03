// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title StakingPool
 * @dev A simple staking contract where users earn rewards for locking tokens.
 */
contract StakingPool is Ownable {
    IERC20 public stakingToken;
    uint256 public rewardRate = 100; // Simplified reward rate (e.g., tokens per block/time)

    struct Stake {
        uint256 amount;
        uint256 startTime;
    }

    mapping(address => Stake) public stakes;
    mapping(address => uint256) public rewards;

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);

    constructor(address _stakingToken) Ownable(msg.sender) {
        stakingToken = IERC20(_stakingToken);
    }

    /**
     * @dev Deposit tokens into the staking pool.
     */
    function stake(uint256 _amount) external {
        require(_amount > 0, "Cannot stake 0");
        
        // Update rewards before changing the stake amount
        _updateReward(msg.sender);

        stakingToken.transferFrom(msg.sender, address(this), _amount);
        stakes[msg.sender].amount += _amount;
        stakes[msg.sender].startTime = block.timestamp;

        emit Staked(msg.sender, _amount);
    }

    /**
     * @dev Withdraw staked tokens and claim rewards.
     */
    function withdraw() external {
        _updateReward(msg.sender);
        
        uint256 amount = stakes[msg.sender].amount;
        require(amount > 0, "No tokens staked");

        uint256 reward = rewards[msg.sender];
        rewards[msg.sender] = 0;
        stakes[msg.sender].amount = 0;

        stakingToken.transfer(msg.sender, amount + reward);
        
        emit Withdrawn(msg.sender, amount);
        emit RewardPaid(msg.sender, reward);
    }

    /**
     * @dev Internal function to calculate and update rewards.
     */
    function _updateReward(address _user) internal {
        if (stakes[_user].amount > 0) {
            uint256 timeStaked = block.timestamp - stakes[_user].startTime;
            uint256 reward = (stakes[_user].amount * rewardRate * timeStaked) / 10**18;
            rewards[_user] += reward;
        }
    }
}
