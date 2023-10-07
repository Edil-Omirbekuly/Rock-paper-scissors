// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract RockPaperScissors {
    address payable private player;
    uint256 public stake;
    bool private hasPlayerMadeChoice;
    string private choiceOfPlayer;
    
    // Result of the game
    enum GameOutcome {
        DRAW,
        WIN,
        LOSE
    }
    
    // Добавляем модификатор payable к конструктору
    constructor() payable {
        stake = 0.0001 ether;
    }

    modifier hasStaked() {
        require(msg.value == stake, "You must pay the stake to play the game.");
        _;
    }

    modifier isPlayer() {
        require(msg.sender == player, "You are not playing this game.");
        _;
    }

    modifier isValidChoice(string memory _playerChoice) {
        require(
            keccak256(bytes(_playerChoice)) == keccak256(bytes('R')) ||
            keccak256(bytes(_playerChoice)) == keccak256(bytes('P')) ||
            keccak256(bytes(_playerChoice)) == keccak256(bytes('S')),
            "Your choice is not valid, it should be one of R, P, or S."
        );
        _;
    }
    
    function play(string calldata _playerChoice) external payable 
        hasStaked()
        isValidChoice(_playerChoice)
    {
        player = payable(msg.sender);
        choiceOfPlayer = _playerChoice;
        hasPlayerMadeChoice = true;

        // Simulate the game
        GameOutcome outcome = getOutcome();
        if(outcome == GameOutcome.WIN) {
            player.transfer(stake * 2);
        }
        if(outcome == GameOutcome.DRAW) {
            player.transfer(stake);
        }
        // In case LOSE, the contract keeps the funds.

        resetGame();
    }
    
    function getOutcome() internal view returns (GameOutcome) {
        uint8 randomResult = uint8(block.timestamp % 3);
        if(randomResult == 0) {
            return GameOutcome.DRAW;
        }
        if(randomResult == 1) {
            return GameOutcome.WIN;
        }
        return GameOutcome.LOSE;
    }

    function resetGame() internal {
        hasPlayerMadeChoice = false;
        choiceOfPlayer = "";
    }

}