pragma solidity ^0.4.15;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./DreamTeamToken.sol";

// interface
contract DTTMigrationTokenInterface {
  function createToken(address _target, uint256 _amount)public;
  function finalizeMigration() public;
  function totalSupply() public returns (uint256);
}

contract MigrationAgent is Ownable {
  using SafeMath for uint256;

  address public dttSourceToken;
  address public dttTargetToken;
  uint256 public tokenSupply;

  event SupplyUpdated(uint256 _value);

  function MigrationAgent(address _dttSourceToken) public {
    require(DreamTeamToken(_dttSourceToken).migrationAgent() == address(0));
    tokenSupply = DreamTeamToken(_dttSourceToken).totalSupply();
    dttSourceToken = _dttSourceToken;
  }

  function safetyInvariantCheck(uint256 _value) internal {
    require(DreamTeamToken(dttSourceToken).totalSupply() + DTTMigrationTokenInterface(dttTargetToken).totalSupply() == tokenSupply - _value);
  }

  function setTargetToken(address _dttTargetToken) public onlyOwner {
    require(dttTargetToken == address(0)); //Allow this change once only
    dttTargetToken = _dttTargetToken;
  }

  function migrateFrom(address _from, uint256 _value) public {
    require(msg.sender == dttSourceToken);
    require(dttTargetToken != address(0));
    updateSupply();
    safetyInvariantCheck(_value); // dttSourceToken has already been updated, but corresponding DTT have not been created in the dttTargetToken contract yet
    DTTMigrationTokenInterface(dttTargetToken).createToken(_from, _value);
    safetyInvariantCheck(0); // totalSupply invariant must hold
  }

  function finalizeMigration() public onlyOwner {
    require(dttTargetToken != address(0));
    require(DreamTeamToken(dttSourceToken).totalSupply() == 0); //only finlize if all tokens have been migrated
    safetyInvariantCheck(0);
    DTTMigrationTokenInterface(dttTargetToken).finalizeMigration();

    dttSourceToken = address(0);
    dttTargetToken = address(0);
    tokenSupply = 0;
  }

  function updateSupply() public {
    DreamTeamToken sourceToken = DreamTeamToken(dttSourceToken);
    tokenSupply = tokenSupply.add(sourceToken.newTokens()).sub(sourceToken.burntTokens());
    sourceToken.resetNewTokens();
    sourceToken.resetBurntTokens();
    SupplyUpdated(tokenSupply);
  }
}
