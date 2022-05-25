//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import {IERC20} from "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
contract ERC20 is IERC20 {

    string public constant name = "Sameer Irfan";
    string public constant symbol = "SI";
    uint8 public constant decimals = 18;
    uint256 _totalSupply;

    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;

    constructor() {
    _totalSupply = 300000000000000;
    balances[address(this)] = _totalSupply;
}

    function totalSupply() public view override returns(uint){
        return _totalSupply;
    }

    function balanceOf(address _owner) public view override returns (uint) {
    return balances[_owner];
}
    function transfer(address _to, uint _value) public override returns (bool) {
    require(_value <= balances[address(this)]);
    balances[address(this)] -= _value;
    balances[_to] += _value;
    emit Transfer(msg.sender, _to, _value);
    return true;
}

    function transferFrom(address _from, address _to, uint _value) public override returns (bool) {
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);
    balances[_from] -= _value;
    allowed[_from][msg.sender] -= _value;
    balances[_to] += _value;
    emit Transfer(_from, _to, _value);
    return true;
}

    function approve(address _spender, uint _value) public override returns (bool) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
}

    function allowance(address _owner, address _spender) public view override returns (uint) {
    return allowed[_owner][_spender];
}


    



}