var Rpsls = artifacts.require("Rpsls");
contract('RPSLS ::: Tests 1-6',function(accounts){
    it("should revert if function bet amount is 0",function(){
        return Rpsls.deployed().then(async function(instance)
        {
            await instance.registerUser({from:accounts[0]});
            await instance.registerUser({from:accounts[1]});
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
    it("should revert if total games played is not 10",function(){
        return Rpsls.deployed().then(async function(instance)
        {
            var exceptionOccurred = false;
            try
            {
                await instance.bet(2,{from:accounts[1],value:2});
                await instance.bet(3,{from:accounts[0],value:2});
                await instance.bet(1,{from:accounts[1],value:2});
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

contract('RPSLS ::: Test 7',function(accounts){
    it("after a player the other player should be able to play",function(){
        return Rpsls.deployed().then(async function(instance)
        {
            var exceptionOccurred = false;
            await instance.registerUser({from:accounts[1]});
            await instance.registerUser({from:accounts[2]});
            try
            {
                await instance.bet(2,{from:accounts[1],value:2});
                await instance.bet(3,{from:accounts[2],value:2});
                await instance.bet(1,{from:accounts[1],value:2});
                await instance.bet(4,{from:accounts[2],value:2});
            }
            catch(e)
            {
                exceptionOccurred = true;
                assert(e.message.startsWith("Returned error: VM Exception"),'Transaction should not be reverted!');
            }
            assert(!exceptionOccurred,'Exception should not have been thrown');
            
        });
    });
});
contract('RPSLS ::: Test 8',function(accounts){
    
    it("should be able to play 10 games in a row",function(){
        return Rpsls.deployed().then(async function(instance)
        {
            await instance.registerUser({from:accounts[0]});
            await instance.registerUser({from:accounts[1]});
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

contract('RPSLS ::: Test 9',function(accounts){
    it("should be able to cash in after 10 games",function(){
        return Rpsls.deployed().then(async function(instance)
        {
            await instance.registerUser({from:accounts[0]});
            await instance.registerUser({from:accounts[1]});
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

contract('RPSLS ::: Test 10',function(accounts){
    it("winner of best of 10 games should get the cash",function(){
        return Rpsls.deployed().then(async function(instance)
        {
            await instance.registerUser({from:accounts[0]});
            await instance.registerUser({from:accounts[1]});
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

contract('RPSLS ::: Test 11',function(accounts){
    it("should not crash when resetting after 10 games",function(){
        return Rpsls.deployed().then(async function(instance)
        {
            await instance.registerUser({from:accounts[1]});
            await instance.registerUser({from:accounts[2]});
            var exceptionOccurred = false;
            try
            {
                await instance.bet(2,{from:accounts[1],value:2});
                await instance.bet(3,{from:accounts[2],value:2});

                await instance.bet(1,{from:accounts[1],value:2});
                await instance.bet(4,{from:accounts[2],value:2});

                await instance.bet(3,{from:accounts[1],value:2});
                await instance.bet(1,{from:accounts[2],value:2});

                await instance.bet(5,{from:accounts[1],value:2});
                await instance.bet(2,{from:accounts[2],value:2});

                await instance.bet(3,{from:accounts[1],value:2});
                await instance.bet(2,{from:accounts[2],value:2});

                await instance.bet(1,{from:accounts[1],value:2});
                await instance.bet(5,{from:accounts[2],value:2});

                await instance.bet(4,{from:accounts[1],value:2});
                await instance.bet(4,{from:accounts[2],value:2});

                await instance.bet(5,{from:accounts[1],value:2});
                await instance.bet(2,{from:accounts[2],value:2});

                await instance.bet(2,{from:accounts[1],value:2});
                await instance.bet(5,{from:accounts[2],value:2});

                await instance.bet(2,{from:accounts[1],value:2});
                await instance.bet(1,{from:accounts[2],value:2});

                await instance.cashIn();

                await instance.registerUser({from:accounts[1]});
                await instance.registerUser({from:accounts[2]});

                await instance.bet(5,{from:accounts[1],value:2});
                await instance.bet(2,{from:accounts[2],value:2});

            }
            catch(e)
            {
                console.log(e.message);
                exceptionOccurred = true;
                assert(e.message.startsWith("Returned error: VM Exception"),'Expected revert!');
            }
            assert(!exceptionOccurred,'Exception should not have been thrown');
            
        });
    });
});

contract('RPSLS ::: Test 12',function(accounts){
    it("If best of 10 draws, then money should go to owner of contract",function(){
        return Rpsls.deployed().then(async function(instance)
        {
            await instance.registerUser({from:accounts[0]});
            await instance.registerUser({from:accounts[1]});
            const ownerBalanceBefore = await web3.eth.getBalance(accounts[0]);
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

            await instance.bet(3,{from:accounts[0],value:two_ethers});
            await instance.bet(2,{from:accounts[1],value:two_ethers});

            await instance.cashIn();

            const ownerBalanceAfter = await web3.eth.getBalance(accounts[0]);
            assert(parseInt(ownerBalanceAfter) > parseInt(ownerBalanceBefore), 'Owner did not get all or some of the full amount');

            
        });
    });
});
contract('RPSLS ::: Test 13',function(accounts){
    it("user should be able to register",function(){
        return Rpsls.deployed().then(async function(instance)
        {
            var exceptionOccurred = false;
            try
            {
                await instance.registerUser({from:accounts[0]});
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
contract('RPSLS ::: Test 14',function(accounts){
    it("user should not be able to register if already registered",function(){
        return Rpsls.deployed().then(async function(instance)
        {
            await instance.registerUser({from:accounts[0]});
            await instance.registerUser({from:accounts[1]});
            var exceptionOccurred = false;
            try
            {
                await instance.registerUser({from:accounts[1]});
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
contract('RPSLS ::: Test 15',function(accounts){
    it("user should not be able to play without registration",function(){
        return Rpsls.deployed().then(async function(instance)
        {
            var exceptionOccurred = false;
            try
            {
                await instance.bet(2,{from:accounts[1],value:2});
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
contract('RPSLS ::: Test 16',function(accounts){
    it("more than two users should not be able to register",function(){
        return Rpsls.deployed().then(async function(instance)
        {
            await instance.registerUser({from:accounts[0]});
            await instance.registerUser({from:accounts[1]});
            var exceptionOccurred = false;
            try
            {
                await instance.registerUser({from:accounts[2]});
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



