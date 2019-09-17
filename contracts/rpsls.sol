pragma solidity >=0.4.22 <0.6.0;


contract Rpsls
{
    //mapping (address => uint) private choice;
    bytes32[] public playerOneChoices;
    bytes32[] public playerTwoChoices;
    mapping (address => uint) private games_won;
    address payable private playerOne;
    address payable private playerTwo;
    //uint256 private _betAmount;
    
    address payable private owner;
    uint256 private cashPrice;
    address payable nextPlayer;
    //uint256 private myEtherValue = 1 ether;
    uint public cntrl;
    //bool allPlayersRegistered;
    bool private _randomAgent;
    // uint256 private contract_amt;
    // playerOneReveal;
    //bool playerTwoReveal;
    bool playerOneRevealed;
    bool playerTwoRevealed;
    bool playerOneRegistered;
    bool playerTwoRegistered;
    string playerOneNonce;
    string playerTwoNonce;
    
    constructor (bool randomAgent) payable public {
        owner = msg.sender;
        playerOne = address(0);
        playerTwo = address(0);
        cashPrice = msg.value;
        cntrl = 0;
        _randomAgent = randomAgent;
        // if(randomAgent) {
        //     playerTwo = owner;
        // }
        // playerOneReveal = false;
        // playerTwoReveal = false;
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
        // if(playerOne != address(0) && playerOne == msg.sender)
        // {
        //     revert('reg1');
        // }
        // if(playerTwo != address(0) && playerTwo == msg.sender)
        // {
        //     revert('reg2');
        // }
        // if(playerOne != address(0) && playerTwo != address(0))
        // {
        //     revert('reg3');
        // }
        // bool justRegisteredPlayerOne = false;
        // if(playerOne == address(0))
        // {
        //     playerOne = msg.sender;
        //     games_won[playerOne] = 0;
        //     justRegisteredPlayerOne = true;
            
        //     if(_randomAgent)
        //     {
        //         playerTwo = owner;
        //         games_won[playerTwo] = 0;
        //         //allPlayersRegistered = true;
        //     }
        // }
        // if(!justRegisteredPlayerOne && playerTwo == address(0))
        // {
        //     playerTwo = msg.sender;
        //     games_won[playerTwo] = 0;
        //     //allPlayersRegistered = true;
        // }
    }
    

    function random() private view returns(uint){
        return uint8(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)))%6) + 1;
    }
    
    function bet(bytes32 choiceHash) payable public {
        require(msg.value > 0  && (playerOne == address(0) || playerTwo == address(0) || playerOne == msg.sender || playerTwo == msg.sender) && (games_won[playerOne] + games_won[playerTwo] < 10), 'Exception in bet');
        
        if(cntrl % 2 == 0 && msg.sender != playerOne)
        {
            revert('Player one is not caller');
        }
        if(cntrl % 2 == 1 && msg.sender != playerTwo)
        {
            revert('Player two is not caller');
        }
        //choice[msg.sender] = current_choice;
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
        //allPlayersRegistered = false;
    }
    
    function reveal(string memory nonce) public {
        require(playerOneChoices.length == 10 && playerTwoChoices.length == 10);
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
        //require(games_won[playerOne] + games_won[playerTwo] == 10);
        require(playerOneRevealed && playerTwoRevealed);
        
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
        
        for(uint i=0; i < playerOneChoices.length; i++)
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
                revert();
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
                revert();
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
        require(msg.value > 0 && msg.sender == owner, 'Exception in recharge');
        cashPrice += msg.value;
    }
    
}