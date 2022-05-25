//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ICO {

    IERC20 TASToken = IERC20(0x24f915F25Ad6888c70adf3e567d0c9dc812FAacB); //initializing ERC20 token variable by using token's contract deployed address
    address public admin; //address of token owner
    address payable public deposit; //address of token owner where the investment from will be withdrawn
    uint public saleStart = block.timestamp; //starting time of ICO = contract's deployment time
    uint public saleEnd = block.timestamp+604800; //ending time of ICO = 1 week after contract's deployment time
    uint public hardCap = 0.02 ether; //investment goal for ICO
    uint public maxInvestment = 0.01 ether; //maximum investment value for an adddress to buy tokens
    uint public minInvestment = 0.001 ether;//minimum investment value for an address to buy tokens
    uint public totalInvestment; //total ethers received by the contract
    uint public tokenPrice = 0.001 ether; //price of one ERC20 token

    constructor(){
        admin = msg.sender; 
        deposit = payable(msg.sender);
        totalInvestment = 0;
    }

    //function to check if the investment goal is reached or not
    function goalReached() public view returns (bool) {
        if(totalInvestment >= hardCap){
            return true;
        }
        else{
            return false;
        }
  }
    //modifier to check if the ICO is still running
    modifier saleActive{
        require(block.timestamp >= saleStart && block.timestamp <= saleEnd && goalReached() == false );
        _;
    }

    

     modifier onlyAdmin{
        require(msg.sender == admin);
        _;
    }

    //function to change address address of token owner where the investment from will be withdrawn
    function setDeposit(address _deposit) public onlyAdmin {
        
        deposit = payable(_deposit);
    }
    
    //receive function to recieve ether in the contract
   receive() payable external{
        require(msg.value >= minInvestment && msg.value <= maxInvestment);
        buyToken();
    } 

    //function to buy token by sending ethers that are between minimum and maximum investment value
    function buyToken() public payable saleActive{
        require(msg.value >= minInvestment && msg.value <= maxInvestment); //check if the buyer has sent ether between minimum and maximum investment value
        require(msg.value+totalInvestment <= hardCap);
        uint numOfTokens = msg.value / tokenPrice; //calculate number of tokens to be sent to buyer according to the ether sent by buyer and price of one token
        TASToken.transfer(msg.sender, numOfTokens); //Send ERC20 token to buyer 
        totalInvestment = totalInvestment + msg.value;
    } 


    function getBalance() public onlyAdmin view returns (uint){
        
        return address(this).balance;
    }

    //function to withdraw investment by token's owner 
    function withdraw() public payable onlyAdmin{

        deposit.transfer(getBalance());

    }

    //function to end ICO by owner when the investment goal reached
    function burn() public payable onlyAdmin{
        require(goalReached() == true);
        selfdestruct(deposit);
    }


}