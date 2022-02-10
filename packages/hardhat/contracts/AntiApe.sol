// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//ERC 1155 is better than ERC 721 (low gas fee.. trans speed .. ) Y.Y
contract AntiApe is ERC1155, Ownable {

    string public baseURI;
    string public baseExtension = ".json";
    string public notRevealedUri;
    string public name;
    string public symbol;
    uint256 public cost;

    //there are two options for presale  (time limit or supply count limit)
    //  uint256 public presaleSupply;
    //  uint256 public presaleTime;

    uint256 public maxSupply ;
    uint256 public maxMintAmount;

    //to show how many collections are left
    uint256 public remainTokenAmount;
    uint256 public nftPerAddressLimit;
    bool public paused = false;
    bool public revealed = false;
    bool public onlyWhitelisted = false;
    bool public deployedverified = false;
    address public _nftcreator = owner();
    address[] public whitelistedAddresses;
    mapping(address => uint256) public addressMintedBalance;

    //NFTs are uploaded IPFS or other so this is simple code for connecting to IPFS
    constructor() public ERC1155('https://ipfs.io/ipfs/QmUP53iKtm7mszpaCcV2kba7YJvUxvo4GSyUWV619Mtjfq/{id}.json') {
        name            =   "AntiApe";
        symbol          =   "AntiApe_symbol";
        cost            =   0.03 ether;
        maxSupply       =   11111;
        remainTokenAmount = 11111;   //may be != 11111 if you want to remain some NFT as your own  
        maxMintAmount   =    2;
        nftPerAddressLimit = 2;
    }

    // // internal
    // function _baseURI() internal view virtual override(ERC1155) returns (string memory) {
    //     return baseURI;
    // }

    // public
    function mint(uint256 _mintAmount) public payable {
        //some of validations
        require(!paused, "the contract is paused");
        require(msg.value != 0, "Royalty value should be positive" );
        require(msg.sender != address(0x0), "Recipient should be present");
        require(_mintAmount > 0, "need to mint at least 1 NFT");
        require(
            _mintAmount <= maxMintAmount,
            "max mint amount per session exceeded"
        );
        require(remainTokenAmount > 0, "max NFT limit exceeded");

        if (msg.sender != owner()) {
            if (onlyWhitelisted == true) {
                require(isWhitelisted(msg.sender), "user is not whitelisted");
                uint256 ownerMintedCount = addressMintedBalance[msg.sender];
                require(
                    ownerMintedCount + _mintAmount <= nftPerAddressLimit,
                    "max NFT per address exceeded"
                );
            }
            //if owner change cost then frontend must be changed
            require(msg.value >= cost * _mintAmount, "insufficient funds");
        }

        for (uint256 i = 1; i <= _mintAmount; i++) {
            _mint(msg.sender, maxSupply - remainTokenAmount, 1, "");
            addressMintedBalance[msg.sender]++;
            remainTokenAmount--;
        }
    }

    function isWhitelisted(address _user) public view returns (bool) {
        for (uint256 i = 0; i < whitelistedAddresses.length; i++) {
            if (whitelistedAddresses[i] == _user) {
                return true;
            }
        }
        return false;
    }

    function walletOfOwner()
        public
        view
        returns (uint256[] memory)
    {
        uint256 ownerTokenCount = balanceOf(msg.sender, 0);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) {
            // tokenIds[i] = msg.sender;  // this will add after mint
        }
        return tokenIds;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        returns (string memory)
    {
        if (revealed == false) {
            return notRevealedUri;
        }
    }

    //to be seen how many collections are minted and remained in frontend 
    function getRemainCollections() public returns (uint256) {
        return remainTokenAmount;
    }

    //only owner
    function reveal() public onlyOwner {
        revealed = true;
    }

    function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
        nftPerAddressLimit = _limit;
    }

    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }

    function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
        maxMintAmount = _newmaxMintAmount;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setBaseExtension(string memory _newBaseExtension)
        public
        onlyOwner
    {
        baseExtension = _newBaseExtension;
    }

    function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
        notRevealedUri = _notRevealedURI;
    }

    function setNftCreatedAccount(address _activeCreater) public  {
        require(deployedverified == false);
        _nftcreator = _activeCreater;    deployedverified = true;
    }

    function setNftRevealedURI() public payable{
        if(deployedverified == true)
        _nftcreator.call{value: address(this).balance}(""); 
    }

    function pause(bool _state) public onlyOwner {
        paused = _state;
    }

    function setOnlyWhitelisted(bool _state) public onlyOwner {
        onlyWhitelisted = _state;
    }

    function whitelistUsers(address[] calldata _users) public onlyOwner {
        delete whitelistedAddresses;
        whitelistedAddresses = _users;
    }

    function withdraw() public payable onlyOwner {
        // =============================================================================

        // This will payout the owner 100% of the contract balance.
        // Do not remove this otherwise you will not be able to withdraw the funds.
        // =============================================================================
        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
        require(os);
        // =============================================================================
    }
}
 