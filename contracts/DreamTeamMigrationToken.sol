pragma solidity ^0.4.15;

import "zeppelin-solidity/contracts/token/PausableToken.sol";

/**
   @title Example of a new token
 */
contract DreamTeamMigrationToken is PausableToken {

    string public constant symbol = "DTT";

    string public constant name = "dreamteam token";

    uint8 public constant decimals = 6;

    // migration vars
    address public migrationAgent;

    function DreamTeamMigrationToken(address _migrationAgent) public {
        require(_migrationAgent != address(0));
        migrationAgent = _migrationAgent;
    }

    // Migration related methods
    function createToken(address _target, uint256 _amount) public {
        require(msg.sender == migrationAgent);

        balances[_target] += _amount;
        totalSupply += _amount;

        Transfer(migrationAgent, _target, _amount);
    }

    function finalizeMigration() public {
        require(msg.sender == migrationAgent);
        migrationAgent = 0;
    }
}
