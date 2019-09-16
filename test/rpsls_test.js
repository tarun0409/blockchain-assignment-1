var Rpsls = artifacts.require("Rpsls");
contract('Rpsls',function(accounts){
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
                console.log(e.message);
                assert(e.message.startsWith("Returned error: VM Exception"),'Expected revert!');
            }
            assert(exceptionOccurred,'Exception should have been thrown');
            
        });
    });
}); 