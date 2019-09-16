var Rpsls = artifacts.require("Rpsls");
contract('RPSLS ::: Test Set 1',function(accounts){
    it("should revert if function bet amount is 0",function(){
        return Rpsls.deployed().then(async function(instance)
        {
            var exceptionOccurred = false;
            try
            {
                await instance.bet(1,{value:0});
            }
            catch(e)
            {
                exceptionOccurred = true;
                assert(e.message.startsWith("Returned error: VM Exception"),'Expected revert!');
            }
            assert(exceptionOccurred,'Exception should have been thrown');
            
        });
    });

    it("should revert if choice is less than 1",function(){
        return Rpsls.deployed().then(async function(instance)
        {
            var exceptionOccurred = false;
            try
            {
                await instance.bet(0,{value:2});
            }
            catch(e)
            {
                exceptionOccurred = true;
                assert(e.message.startsWith("Returned error: VM Exception"),'Expected revert!');
            }
            assert(exceptionOccurred,'Exception should have been thrown');
            
        });
    });

    it("should revert if choice is greater than 5",function(){
        return Rpsls.deployed().then(async function(instance)
        {
            var exceptionOccurred = false;
            try
            {
                await instance.bet(6,{value:2});
            }
            catch(e)
            {
                exceptionOccurred = true;
                assert(e.message.startsWith("Returned error: VM Exception"),'Expected revert!');
            }
            assert(exceptionOccurred,'Exception should have been thrown');
            
        });
    });

    it("player should be able to place a bet",function(){
        return Rpsls.deployed().then(async function(instance)
        {
            var exceptionOccurred = false;
            try
            {
                await instance.bet(2,{from:accounts[0],value:2});
            }
            catch(e)
            {
                exceptionOccurred = true;
                assert(e.message.startsWith("Returned error: VM Exception"),'Transaction should not be reverted!');
            }
            assert(!exceptionOccurred,'Exception should not have been thrown');
            
        });
    });

    it("after a player the other player should be able to play",function(){
        return Rpsls.deployed().then(async function(instance)
        {
            var exceptionOccurred = false;
            try
            {
                await instance.bet(2,{from:accounts[1],value:2});
                await instance.bet(3,{from:accounts[0],value:2});
                await instance.bet(1,{from:accounts[1],value:2});
                await instance.bet(4,{from:accounts[0],value:2});
            }
            catch(e)
            {
                exceptionOccurred = true;
                assert(e.message.startsWith("Returned error: VM Exception"),'Transaction should not be reverted!');
            }
            assert(!exceptionOccurred,'Exception should not have been thrown');
            
        });
    });

    it("one player should not make two consecutive moves",function(){
        return Rpsls.deployed().then(async function(instance)
        {
            var exceptionOccurred = false;
            try
            {
                await instance.bet(2,{from:accounts[1],value:2});
                await instance.bet(3,{from:accounts[1],value:2});
            }
            catch(e)
            {
                exceptionOccurred = true;
                assert(e.message.startsWith("Returned error: VM Exception"),'Expected revert!');
            }
            assert(exceptionOccurred,'Exception should have been thrown');
            
        });
    });
}); 
contract('RPSLS ::: Test Set 2',function(accounts){
    it("should be able to play 10 games in a row",function(){
        return Rpsls.deployed().then(async function(instance)
        {
            var exceptionOccurred = false;
            try
            {
                await instance.bet(2,{from:accounts[0],value:2});
                await instance.bet(3,{from:accounts[1],value:2});

                await instance.bet(1,{from:accounts[0],value:2});
                await instance.bet(4,{from:accounts[1],value:2});

                await instance.bet(3,{from:accounts[0],value:2});
                await instance.bet(1,{from:accounts[1],value:2});

                await instance.bet(5,{from:accounts[0],value:2});
                await instance.bet(2,{from:accounts[1],value:2});

                await instance.bet(3,{from:accounts[0],value:2});
                await instance.bet(2,{from:accounts[1],value:2});

                await instance.bet(1,{from:accounts[0],value:2});
                await instance.bet(5,{from:accounts[1],value:2});

                await instance.bet(3,{from:accounts[0],value:2});
                await instance.bet(3,{from:accounts[1],value:2});

                await instance.bet(5,{from:accounts[0],value:2});
                await instance.bet(2,{from:accounts[1],value:2});

                await instance.bet(2,{from:accounts[0],value:2});
                await instance.bet(5,{from:accounts[1],value:2});

                await instance.bet(2,{from:accounts[0],value:2});
                await instance.bet(1,{from:accounts[1],value:2});

            }
            catch(e)
            {
                exceptionOccurred = true;
                assert(e.message.startsWith("Returned error: VM Exception"),'Expected revert!');
            }
            assert(!exceptionOccurred,'Exception should have been thrown');
            
        });
    });
});

contract('RPSLS ::: Test Set 3',function(accounts){
    it("should be able to cash in after 10 games",function(){
        return Rpsls.deployed().then(async function(instance)
        {
            var exceptionOccurred = false;
            try
            {
                await instance.bet(2,{from:accounts[0],value:2});
                await instance.bet(3,{from:accounts[1],value:2});

                await instance.bet(1,{from:accounts[0],value:2});
                await instance.bet(4,{from:accounts[1],value:2});

                await instance.bet(3,{from:accounts[0],value:2});
                await instance.bet(1,{from:accounts[1],value:2});

                await instance.bet(5,{from:accounts[0],value:2});
                await instance.bet(2,{from:accounts[1],value:2});

                await instance.bet(3,{from:accounts[0],value:2});
                await instance.bet(2,{from:accounts[1],value:2});

                await instance.bet(1,{from:accounts[0],value:2});
                await instance.bet(5,{from:accounts[1],value:2});

                await instance.bet(3,{from:accounts[0],value:2});
                await instance.bet(3,{from:accounts[1],value:2});

                await instance.bet(5,{from:accounts[0],value:2});
                await instance.bet(2,{from:accounts[1],value:2});

                await instance.bet(2,{from:accounts[0],value:2});
                await instance.bet(5,{from:accounts[1],value:2});

                await instance.bet(2,{from:accounts[0],value:2});
                await instance.bet(1,{from:accounts[1],value:2});

                await instance.cashIn();

            }
            catch(e)
            {
                exceptionOccurred = true;
                assert(e.message.startsWith("Returned error: VM Exception"),'Expected revert!');
            }
            assert(!exceptionOccurred,'Exception should have been thrown');
            
        });
    });
});

contract('RPSLS ::: Test Set 4',function(accounts){
    it("winner of best of 10 games should get the cash",function(){
        return Rpsls.deployed().then(async function(instance)
        {
            const playerTwoBalanceBefore = await web3.eth.getBalance(accounts[1]);
            const two_ethers = await web3.utils.toWei("2");

            await instance.bet(2,{from:accounts[0],value:two_ethers});
            await instance.bet(3,{from:accounts[1],value:two_ethers});

            await instance.bet(1,{from:accounts[0],value:two_ethers}); 
            await instance.bet(4,{from:accounts[1],value:two_ethers}); 

            await instance.bet(3,{from:accounts[0],value:two_ethers}); 
            await instance.bet(1,{from:accounts[1],value:two_ethers});

            await instance.bet(5,{from:accounts[0],value:two_ethers});
            await instance.bet(2,{from:accounts[1],value:two_ethers});

            await instance.bet(3,{from:accounts[0],value:two_ethers});
            await instance.bet(2,{from:accounts[1],value:two_ethers});

            await instance.bet(1,{from:accounts[0],value:two_ethers});
            await instance.bet(5,{from:accounts[1],value:two_ethers});

            await instance.bet(3,{from:accounts[0],value:two_ethers});
            await instance.bet(3,{from:accounts[1],value:two_ethers});

            await instance.bet(5,{from:accounts[0],value:two_ethers});
            await instance.bet(2,{from:accounts[1],value:two_ethers});

            await instance.bet(2,{from:accounts[0],value:two_ethers});
            await instance.bet(5,{from:accounts[1],value:two_ethers});

            await instance.bet(2,{from:accounts[0],value:two_ethers});
            await instance.bet(3,{from:accounts[1],value:two_ethers});

            await instance.cashIn();

            const playerTwoBalanceAfter = await web3.eth.getBalance(accounts[1]);
            assert(parseInt(playerTwoBalanceAfter) > parseInt(playerTwoBalanceBefore), 'Winner did not get all or some of the full amount');

            
        });
    });
});

contract('RPSLS ::: Test Set 5',function(accounts){
    it("should revert if total games played is not 10",function(){
        return Rpsls.deployed().then(async function(instance)
        {
            var exceptionOccurred = false;
            try
            {
                await instance.bet(2,{from:accounts[0],value:2});
                await instance.bet(3,{from:accounts[1],value:2});
                await instance.bet(1,{from:accounts[0],value:2});
                await instance.bet(4,{from:accounts[1],value:2});
                await instance.cashIn();
            }
            catch(e)
            {
                exceptionOccurred = true;
                assert(e.message.startsWith("Returned error: VM Exception"),'Expected revert!');
            }
            assert(exceptionOccurred,'Exception should have been thrown');
            
        });
    });
});