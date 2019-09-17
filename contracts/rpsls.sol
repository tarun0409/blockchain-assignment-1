pragma solidity >=0.4.22 <0.6.0;

contract Rpsls
{
    mapping (address => uint) private choice;
    mapping (address => uint) private games_won;
    address payable private playerOne;
    address payable private playerTwo;
    uint256 private _betAmount;
    uint256 private cashPrice;
    address payable private owner;
    address payable nextPlayer;
    uint256 private myEtherValue = 1 ether;
    uint private cntrl;
    bool allPlayersRegistered;
    bool private _randomAgent;
    uint256 private contract_amt;
    
    constructor (bool randomAgent) payable public {
        // _betAmount = betAmount * myEtherValue;
        require(msg.value > 0);
        owner = msg.sender;
        contract_amt = msg.value;
        playerOne = address(0);
        playerTwo = address(0);
        cashPrice = 0;
        cntrl = 0;
        allPlayersRegistered = false;
        _randomAgent = randomAgent;
        if(randomAgent) {
            playerTwo = owner;
        }
    }
    function registerUser() public {
        require(playerOne == address(0) || playerTwo == address(0));
        if(playerOne != address(0) && playerOne == msg.sender)
        {
            revert('reg1');
        }
        if(playerTwo != address(0) && playerTwo == msg.sender)
        {
            revert('reg2');
        }
        if(playerOne != address(0) && playerTwo != address(0))
        {
            revert('reg3');
        }
        bool justRegisteredPlayerOne = false;
        if(playerOne == address(0))
        {
            playerOne = msg.sender;
            games_won[playerOne] = 0;
            justRegisteredPlayerOne = true;
            
            if(_randomAgent)
            {
                playerTwo = owner;
                games_won[playerTwo] = 0;
                allPlayersRegistered = true;
            }
        }
        if(!justRegisteredPlayerOne && playerTwo == address(0))
        {
            playerTwo = msg.sender;
            games_won[playerTwo] = 0;
            allPlayersRegistered = true;
        }
    }
    
    function random() private view returns(uint){
        return uint8(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)))%6) + 1;
    }
    
    function bet(uint current_choice) payable public {
        require(msg.value > 0 && current_choice > 0 && current_choice < 6 && (playerOne == address(0) || playerTwo == address(0) || playerOne == msg.sender || playerTwo == msg.sender) && (games_won[playerOne] + games_won[playerTwo] < 10), 'Exception in bet');
        // if(playerOne == address(0) && allPlayersRegistered)
        // {
        //     playerOne = msg.sender;
        //     games_won[playerOne] = 0;
        // }
        // else if(msg.sender != playerOne && playerTwo == address(0) && allPlayersRegistered)
        // {
        //     playerTwo = msg.sender;
        //     games_won[playerTwo] = 0;
        // }
        if(cntrl % 2 == 0 && msg.sender != playerOne)
        {
            revert('Player one is not caller');
        }
        if(cntrl % 2 == 1 && msg.sender != playerTwo)
        {
            revert('Player two is not caller');
        }
        choice[msg.sender] = current_choice;    
        cashPrice += msg.value;
        
        if(_randomAgent) {
            choice[playerTwo] = random();
            if(contract_amt >= msg.value) {
                cashPrice += msg.value;
            }
            else {
                cashPrice += contract_amt;
            }
            // cashPrice += msg.value;
            // games_won[playerTwo] = 0;
            cntrl++;
        }
        
        if(cntrl % 2 == 1)
        {
            if(choice[playerOne] == choice[playerTwo])
            {
                games_won[owner] = games_won[owner] + 1;
            }
            else if(choice[playerOne] == 1)
            {
                if(choice[playerTwo] == 3 || choice[playerTwo] == 4)
                {
                    games_won[playerOne] = games_won[playerOne] + 1;
                }
                else
                {
                    games_won[playerTwo] = games_won[playerTwo] + 1;
                }
            }
            else if(choice[playerOne] == 2)
            {
                if(choice[playerTwo] == 1 || choice[playerTwo] == 5)
                {
                    games_won[playerOne] = games_won[playerOne] + 1;
                }
                else
                {
                    games_won[playerTwo] = games_won[playerTwo] + 1;
                }
            }
            else if(choice[playerOne] == 3)
            {
                if(choice[playerTwo] == 2 || choice[playerTwo] == 4)
                {
                    games_won[playerOne] = games_won[playerOne] + 1;
                }
                else
                {
                    games_won[playerTwo] = games_won[playerTwo] + 1;
                }
            }
            else if(choice[playerOne] == 4)
            {
                if(choice[playerTwo] == 2 || choice[playerTwo] == 5)
                {
                    games_won[playerOne] = games_won[playerOne] + 1;
                }
                else
                {
                    games_won[playerTwo] = games_won[playerTwo] + 1;
                }
            }
            else if(choice[playerOne] == 5)
            {
                if(choice[playerTwo] == 1 || choice[playerTwo] == 3)
                {
                    games_won[playerOne] = games_won[playerOne] + 1;
                }
                else
                {
                    games_won[playerTwo] = games_won[playerTwo] + 1;
                }
            }
        }
        cntrl++;
    }
    
    function reset(bool randomAgent) public {
        playerOne = address(0);
        playerTwo = address(0);
        cashPrice = 0;
        cntrl = 0;
        _randomAgent = randomAgent;
        allPlayersRegistered = false;
    }
    
    
    function cashIn() public {
        require(cntrl == 20, 'Revert from cashin');
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
    
    
    function recharge() payable public {
        require(msg.value > 0);
        contract_amt += msg.value;
    }
    
}