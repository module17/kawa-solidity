pragma solidity ^0.4.11;

contract Kawa {
    string public constant symbol = "KAWA";
    string public constant name = "Kawa Coin";
    uint8 public constant decimals = 3;
    string public greet = "Kawa is great.";
    uint public totalKawa = 17000.000;
    address creator;
    mapping (address => uint) private balances;
    mapping (address => mapping(address => uint)) allowances;
    
    function Kawa() public {
        creator = msg.sender;
        balances[msg.sender] = totalKawa;
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
        totalKawa += amount;
    }
    
    function sendKawa(address receiver, uint amount) public {
        require(receiver != address(0) && amount > 0 && balances[msg.sender] > amount);
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        LogTrx('Kawa sent.', msg.sender, receiver, amount);
    }

    function checkKawaBalance(address wallet) public constant returns(uint) {
        require(wallet != address(0));
        return balances[wallet];
    }

    function sendKawaFrom(address from, address receiver, uint amount) public {
        require(
            from != address(0) &&
            receiver != address(0) &&
            amount > 0 &&
            balances[from] >= amount &&
            allowances[from][msg.sender] >= amount
            );
        balances[from] -= amount;
        balances[receiver] += amount;
        allowances[from][msg.sender] -= amount;
        LogTrx('Kawa transferred.', from, receiver, amount);
    }

    function allowKawaTransfer(address spender, uint amount) public {
        require(spender != address(0) && amount > 0);
        allowances[msg.sender][spender] = amount;
        LogTrx('Allowed Kawa transfer.', msg.sender, spender, amount);
    }

    function checkKawaAllowance(address owner, address spender) public constant returns (uint allowance) {
        return allowances[owner][spender];
    }
}
