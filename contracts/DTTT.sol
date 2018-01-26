pragma solidity ^0.4.15;

import "zeppelin-solidity/contracts/token/MintableToken.sol";

contract DTTT is MintableToken {

    string public name = "DTT Token";
    string public symbol = "DTTT";
    uint256 public decimals = 6;

    function DTTT(uint256 _amount) public {
        owner = msg.sender;
        mint(msg.sender, _amount);
    }

    function approveAndUpdateBalance(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        balances[spender] = balances[spender].add(tokens);
        Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferAllowed(address from, address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[from] = balances[from].sub(tokens);
        allowed[msg.sender][from] = allowed[msg.sender][from].sub(tokens);
        balances[to] = balances[to].add(tokens);
        Transfer(msg.sender, to, tokens);
        return true;
    }

}