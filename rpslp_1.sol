pragma solidity >=0.4.22 <0.6.0;

contract rock_papers_scissors_lizard_spock
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
    
    constructor (uint256 betAmount, bool randomAgent) public {
        _betAmount = betAmount * myEtherValue;
        owner = msg.sender;
        playerOne = address(0);
        playerTwo = address(0);
        cashPrice = 0;
        cntrl = 0;
    }
    function bet(uint current_choice) payable public {
        require(msg.value == _betAmount &&  current_choice < 6 && (playerOne == address(0) || playerTwo == address(0) || playerOne == msg.sender || playerTwo == msg.sender) && (games_won[playerOne] + games_won[playerTwo] < 10));
        if(playerOne == address(0))
        {
            playerOne = msg.sender;
            games_won[playerOne] = 0;
        }
        else if(msg.sender != playerOne && playerTwo == address(0))
        {
            playerTwo = msg.sender;
            games_won[playerTwo] = 0;
        }
        if(cntrl % 2 == 0 && msg.sender != playerOne)
        {
            revert();
        }
        if(cntrl % 2 == 1 && msg.sender != playerTwo)
        {
            revert();
        }
        choice[msg.sender] = current_choice;    
        cashPrice += _betAmount;
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
    
    
    function cashIn() public {
        require(games_won[playerOne] + games_won[playerTwo] == 10);
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
    }
    
}
