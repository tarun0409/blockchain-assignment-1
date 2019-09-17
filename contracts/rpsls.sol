pragma solidity >=0.4.22 <0.6.0;


contract Rpsls
{
    bytes32[] private playerOneChoices;
    bytes32[] private playerTwoChoices;
    mapping (address => uint) private games_won;
    address payable private playerOne;
    address payable private playerTwo;
    address payable private owner;
    uint256 private cashPrice;
    uint private cntrl;
    bool private _randomAgent;
    bool private playerOneRevealed;
    bool private playerTwoRevealed;
    bool private playerOneRegistered;
    bool private playerTwoRegistered;
    string private playerOneNonce;
    string private playerTwoNonce;
    constructor (bool randomAgent) payable public {
        owner = msg.sender;
        playerOne = address(0);
        playerTwo = address(0);
        cashPrice = msg.value;
        cntrl = 0;
        _randomAgent = randomAgent;
        playerOneRevealed = false;
        playerTwoRevealed = false;
        playerOneRegistered = false;
        playerTwoRegistered = false;
    }
    function registerUser() public {
        require(!playerOneRegistered || !playerTwoRegistered,'Both players have registered');
        if(playerOneRegistered && msg.sender == playerOne)
        {
            revert('Player has already registered');
        }
        if(playerTwoRegistered && msg.sender == playerTwo)
        {
            revert('Player has already registered');
        }
        bool justRegisteredPlayerOne = false;
        if(!playerOneRegistered)
        {
            playerOne = msg.sender;
            playerOneRegistered = true;
            justRegisteredPlayerOne = true;
            games_won[playerOne] = 0;
            if(_randomAgent)
            {
                playerTwo = owner;
                playerTwoRegistered = true;
                games_won[playerTwo] = 0;
            }
        }
        if(!justRegisteredPlayerOne && !playerTwoRegistered)
        {
            playerTwo = msg.sender;
            playerTwoRegistered = true;
            games_won[playerTwo] = 0;
        }
    }
    function random() private view returns(uint){
        return uint8(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)))%6) + 1;
    }
    function bet(bytes32 choiceHash) payable public {
        require(msg.value > 0,'Player should send money to contract');
        require(playerOneRegistered && playerTwoRegistered,'One or more players not registered');
        require(games_won[playerOne] + games_won[playerTwo] < 10, 'Cashin, reset and register before starting new set of games');
        if(cntrl % 2 == 0 && msg.sender != playerOne)
        {
            revert('Player one is not caller');
        }
        if(cntrl % 2 == 1 && msg.sender != playerTwo)
        {
            revert('Player two is not caller');
        }
        if(msg.sender == playerOne)
        {
            playerOneChoices.push(choiceHash);
        }
        else if(msg.sender == playerTwo)
        {
            playerTwoChoices.push(choiceHash);
        }
        cashPrice += msg.value;
        if(_randomAgent) {
            uint randomNum = random();
            string memory numString;
            if(randomNum == 1)
            {
                numString = "1";
            }
            else if(randomNum == 2)
            {
                numString = "2";
            }
            else if(randomNum == 3)
            {
                numString = "3";
            }
            else if(randomNum == 4)
            {
                numString = "4";
            }
            else
            {
                numString = "5";
            }
            bytes32 randomChoiceHash = keccak256(abi.encodePacked("random",numString));
            playerTwoChoices.push(randomChoiceHash);
            cntrl++;
        }
        cntrl++;
    }
    function reset(bool randomAgent) public {
        playerOne = address(0);
        playerTwo = address(0);
        cashPrice = 0;
        cntrl = 0;
        _randomAgent = randomAgent;
        playerOneRegistered = false;
        playerTwoRegistered = false;
        playerOneRevealed = false;
        playerTwoRevealed = false;
    }
    function reveal(string memory nonce) public {
        require(playerOneChoices.length == 10 && playerTwoChoices.length == 10,'10 games have to be played');
        if(playerOne == msg.sender)
        {
            playerOneNonce = nonce;
            playerOneRevealed = true;
            if(_randomAgent)
            {
                playerTwoNonce = "random";
                playerTwoRevealed = true;
            }
        }
        else if(playerTwo == msg.sender)
        {
            playerTwoNonce = nonce;
            playerTwoRevealed = true;
        }
    }
    function cashIn() public {
        require(playerOneRevealed && playerTwoRevealed,'One or all players have not revealed nonce');
        bytes32 playerOneChoiceOne = keccak256(abi.encodePacked(playerOneNonce,"1"));
        bytes32 playerOneChoiceTwo = keccak256(abi.encodePacked(playerOneNonce,"2"));
        bytes32 playerOneChoiceThree = keccak256(abi.encodePacked(playerOneNonce,"3"));
        bytes32 playerOneChoiceFour = keccak256(abi.encodePacked(playerOneNonce,"4"));
        bytes32 playerOneChoiceFive = keccak256(abi.encodePacked(playerOneNonce,"5"));
        bytes32 playerTwoChoiceOne = keccak256(abi.encodePacked(playerTwoNonce,"1"));
        bytes32 playerTwoChoiceTwo = keccak256(abi.encodePacked(playerTwoNonce,"2"));
        bytes32 playerTwoChoiceThree = keccak256(abi.encodePacked(playerTwoNonce,"3"));
        bytes32 playerTwoChoiceFour = keccak256(abi.encodePacked(playerTwoNonce,"4"));
        bytes32 playerTwoChoiceFive = keccak256(abi.encodePacked(playerTwoNonce,"5"));
        for(uint i = 0; i < playerOneChoices.length; i++)
        {
            uint playerOneChoice = 0;
            uint playerTwoChoice = 0;
            if(playerOneChoices[i] == playerOneChoiceOne)
            {
                playerOneChoice = 1;
            }
            else if(playerOneChoices[i] == playerOneChoiceTwo)
            {
                playerOneChoice = 2;
            }
            else if(playerOneChoices[i] == playerOneChoiceThree)
            {
                playerOneChoice = 3;
            }
            else if(playerOneChoices[i] == playerOneChoiceFour)
            {
                playerOneChoice = 4;
            }
            else if(playerOneChoices[i] == playerOneChoiceFive)
            {
                playerOneChoice = 5;
            }
            else
            {
                revert('Invalid choice by the user');
            }
            if(playerTwoChoices[i] == playerTwoChoiceOne)
            {
                playerTwoChoice = 1;
            }
            else if(playerTwoChoices[i] == playerTwoChoiceTwo)
            {
                playerTwoChoice = 2;
            }
            else if(playerTwoChoices[i] == playerTwoChoiceThree)
            {
                playerTwoChoice = 3;
            }
            else if(playerTwoChoices[i] == playerTwoChoiceFour)
            {
                playerTwoChoice = 4;
            }
            else if(playerTwoChoices[i] == playerTwoChoiceFive)
            {
                playerTwoChoice = 5;
            }
            else
            {
                revert('Invalid choice by the user');
            }
            if(playerOneChoice == playerTwoChoice)
            {
                games_won[owner] = games_won[owner] + 1;
            }
            else if(playerOneChoice == 1)
            {
                if(playerTwoChoice == 3 || playerTwoChoice == 4)
                {
                    games_won[playerOne] = games_won[playerOne] + 1;
                }
                else
                {
                    games_won[playerTwo] = games_won[playerTwo] + 1;
                }
            }
            else if(playerOneChoice == 2)
            {
                if(playerTwoChoice == 1 || playerTwoChoice == 5)
                {
                    games_won[playerOne] = games_won[playerOne] + 1;
                }
                else
                {
                    games_won[playerTwo] = games_won[playerTwo] + 1;
                }
            }
            else if(playerOneChoice == 3)
            {
                if(playerTwoChoice == 2 || playerTwoChoice == 4)
                {
                    games_won[playerOne] = games_won[playerOne] + 1;
                }
                else
                {
                    games_won[playerTwo] = games_won[playerTwo] + 1;
                }
            }
            else if(playerOneChoice == 4)
            {
                if(playerTwoChoice == 2 || playerTwoChoice == 5)
                {
                    games_won[playerOne] = games_won[playerOne] + 1;
                }
                else
                {
                    games_won[playerTwo] = games_won[playerTwo] + 1;
                }
            }
            else if(playerOneChoice == 5)
            {
                if(playerTwoChoice == 1 || playerTwoChoice == 3)
                {
                    games_won[playerOne] = games_won[playerOne] + 1;
                }
                else
                {
                    games_won[playerTwo] = games_won[playerTwo] + 1;
                }
            }
        }
        address payable winner = address(0);
        if(games_won[playerOne] == games_won[playerTwo])
        {
            winner = owner;
        }
        else if(games_won[playerOne] > games_won[playerTwo])
        {
            winner = playerOne;
        }
        else
        {
            winner = playerTwo;
        }
        winner.transfer(cashPrice);
        reset(false);
    }
    function recharge() public payable {
        require(msg.value > 0,'Enter money to be recharged');
        require(msg.sender == owner, 'Only owner of contract can call recharge');
        cashPrice += msg.value;
    }
}