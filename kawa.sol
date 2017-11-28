pragma solidity ^0.4.11;

contract Kawa {
    string greet = "Kawa is great.";
    address creator;
    mapping (address => uint) private balances;
    
    function Kawa() public {
        creator = msg.sender;
    }
    
    event Log(string msg);
    event LogTrx(string msg, address from, address to, uint amount);
    
    modifier isCreator() {
        require(creator == msg.sender);
        _;
    }
    function getGreet() public constant returns(string) {
        return greet;
    }
    
    function setGreet(string newGreet) public isCreator returns(string) {
        greet = newGreet;
        return greet;
    }
    
    function depositFunds() public payable {
        require(msg.value > 0);
        LogTrx('Funds deposited.', msg.sender, address(this), msg.value);
    }
    
    function withdrawFunds() public isCreator payable {
        require(msg.value > 0);
        msg.sender.transfer(msg.value);
        LogTrx('Funds withdrawn.', msg.sender, address(this), msg.value);
    }
    
    function getBalance() public isCreator constant returns(uint) {
        return this.balance;
    }
    
    function brewKawa(address receiver, uint amount) public isCreator {
        require(receiver != address(0) && amount > 0);
        balances[receiver] += amount;
    }
    
    function sendKawa(address receiver, uint amount) public {
        require(receiver != address(0) && amount > 0 && balances[msg.sender] > amount);
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        LogTrx('Coins sent.', msg.sender, receiver, amount);
    }
    
    function checkKawaBalance(address wallet) public constant returns(uint) {
        require(wallet != address(0));
        return balances[wallet];
    }
}
