//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract dao{
    
    struct Proposal{
        uint256 prop_id;
        string prop_desc;
        address prop_owner;
        bool result; 
        mapping(address => bool) voters;
        uint256 vote_count;
    }
    uint256 proposal_count;
    //mapping(uint256 => proposal) proposals;
    Proposal[] public proposals;
    mapping(address => uint) balances;
    address public owner;
    uint256 minimum_req_votes;

    constructor(uint256 _minimum_votes){
        owner = msg.sender;
        minimum_req_votes=_minimum_votes;
    } 

    modifier onlyOwner(){
        require(msg.sender == owner, "Owner only functionality :)");
        _;
    }

    modifier onlyTokenHolder(){
        require(balances[msg.sender]>0, "Not enough balance to vote");
        _;
    }

    function deposit() public payable{
        balances[msg.sender]+=msg.value;
    }

    function create_proposal(string memory _desc) public onlyOwner onlyTokenHolder returns(uint256){
        proposal_count++;
        Proposal storage newProposal = proposals.push();
        newProposal.prop_id=proposal_count;
        newProposal.prop_owner=msg.sender;
        newProposal.prop_desc=_desc;
        newProposal.vote_count=0;
        newProposal.result=false;

        return proposal_count-1;
    } 

    function vote(uint256 proposal_id) public onlyTokenHolder{
        Proposal storage proposal = proposals[proposal_id];
        require(!proposal.voters[msg.sender], "Already voted");
        proposal.voters[msg.sender] = true;
        proposal.vote_count += balances[msg.sender];
    }

    function executeProposal(uint256 proposal_id) public onlyTokenHolder{
        Proposal storage proposal = proposals[proposal_id];
        require(proposal.vote_count>=minimum_req_votes, "Not enough votes");
        require(!proposal.result, "Proposal already executed");

        proposal.result = true;
    }




}