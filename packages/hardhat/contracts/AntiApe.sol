// SPDX-License-Identifier: GPL-3.0
///@consensys SWC-103
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// Contract implements ERC721Enumerable which is the standard for NFTs. Also implements Ownable pattern which prevents unauthorized
contract AntiApe is ERC721Enumerable, Ownable {
    using Strings for uint256;

    string public baseURI;
    // used to build the metadata url websites like Opeansea.io use to find information about the NFT
    string public baseExtension = ".json";
    string public metaDataFolder = "metadata/";

    uint256 public cost = 0.03 ether;
    uint256 public maxSupply = 50;
    uint256 public remainTokenAmount = 50;
    uint256 public maxMintAmount = 2;
    uint256 public nftPerAddressLimit = 2;
    string public _name;
    string public _symbol;
    string public _initBaseURI;
    // allow contract to be paused
    bool public paused = false;
    // a mapping of addresses used for presales
    mapping(address => bool) public allowlist;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _initBaseURI
    ) ERC721(_name, _symbol) {
        setBaseURI(_initBaseURI);
    }

    // internal
    // convenience function to return the baseURI
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    // public
    // Use Modifiers Only for Validation
    // mint function
    function mint(address _to, uint256 _mintAmount) public payable {
        uint256 supply = totalSupply();
        require(!paused, "Contract is paused");
        require(_mintAmount > 0, "Must mint at least 1");
        require(
            _mintAmount <= maxMintAmount,
            "Cannot mint more than 5 at once"
        );
        require(
            supply + _mintAmount <= maxSupply,
            "Mint amount exceeds max supply"
        );

        //@consensys SWC-122
        if (msg.sender != owner()) {
            ///@consensys SWC-115
            if (allowlist[msg.sender] != true) {
                require(msg.value >= cost * _mintAmount, "Not enough ETH sent");
            }
        }

        for (uint256 i = 1; i <= _mintAmount; i++) {
            // ERC721 mint function
            _safeMint(_to, supply + i);
            remainTokenAmount--;
        }
    }

    //to be seen how many collections are minted and remained in frontend
    function getRemainCollections() public view returns (uint256) {
        return remainTokenAmount;
    }

    // return all NFTs for a particular owner
    function walletOfOwner(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
    }

    // return the uri where the metadata for the NFT can be found
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory currentBaseURI = _baseURI();
        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        metaDataFolder,
                        tokenId.toString(),
                        baseExtension
                    )
                )
                : "";
    }

    // only contract owner can access the following functions

    // set cost of contract in wei
    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }

    // change how many NFTs can be minted at a time
    function setMaxMintAmount(uint256 _newMaxMintAmount) public onlyOwner {
        maxMintAmount = _newMaxMintAmount;
    }

    // change baseURI
    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    // change base extension
    function setBaseExtension(string memory _newBaseExtension)
        public
        onlyOwner
    {
        baseExtension = _newBaseExtension;
    }

    function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
        nftPerAddressLimit = _limit;
    }

    // pause the contract
    function pause(bool _state) public onlyOwner {
        paused = _state;
    }

    // add user(s) to an allowlist that permits free minting
    function allowlistUser(address[] memory _arr) public onlyOwner {
        for (uint256 i; i < _arr.length; i++) {
            allowlist[_arr[i]] = true;
        }
    }

    // remove user(s) from an allowlist
    function removeAllowlistUser(address[] memory _arr) public onlyOwner {
        for (uint256 i; i < _arr.length; i++) {
            allowlist[_arr[i]] = false;
        }
    }

    // withdraw the value of the contract
    function withdraw() public payable onlyOwner {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }
}
