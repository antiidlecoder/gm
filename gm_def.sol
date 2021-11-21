// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * 
 * 69 ways to say gm
 * 
 * stored on chain
 *  
 **/

contract gm is ERC721Enumerable, ReentrancyGuard, Ownable {
    string[] private gms = [
        "gm", 
        "gm.",
        "GM!",
        "gm :sun_with_face:",
        "gm :positivity:",
        "gm :smile:",
        "gm :memes:",
        "gm :wink:",
        "gm :lfg:",
        "gm :OGs:",
        "gm : ) :",
        "gm :sunrise:",
        "gm :sunrise_over_mountains:",
        "gm :city_sunrise:",
        "gm :fireworks:",
        "gm :raised_hands:",
        "gm :sunglasses:",
        "gm :thumbsup:",
        "gm :fist:",
        "gm :v:",
        "gm :ok_hand:",
        "gm :moon:",
        "gm :jpeg:",
        "gm :pray:",
        "gm :fire:",
        "gm :joy:",
        "gm :100:",
        "gm :heart:",
        "gm :punks:",
        "gm :apes:",
        "gm :pepe:",
        "gm :doge:",
        "gm :diamond_hands:",
        "gm :ser:",
        "gm :frens:",
        "gm :eyes:",
        "gm :sunny:",
        "gm :rainbow:",
        "gm :world:",
        "gm :elon:",
        "gm :brrrr:",
        "gm :coffee:",
        "gm :sparkles:",
        "gm :wagmi:",
        "gm :ngmi:",
        "gm :hodl:",
        "gm :fomo:",
        "gm :420:",
        "gm :69:",
        "gm :twitter:",
        "gm :satoshi:",
        "gm :vitalik:",
        "gm :uponly:",
        "gm :web3:",
        "gm :internet:",
        "gm :inspired:",
        "gm :creators:",
        "gm :community:",
        "gm :aliens:",
        "gm :devs:",
        "gm :artists:",
        "gm :rocket:",
        "gm :bears:",
        "gm :bulls:",
        "gm :bitcoin:",
        "gm :ethereum:",
        "gm :writers:",
        "gm :adventurers:",
        "gm :metaverse:"
    ];
        
    // tokenid / gm array index
    mapping(uint => string) private tokenIdToGm;

    function getRandom() private view returns (uint256) {
        uint gmsLen = gms.length;
        return uint256(keccak256(abi.encodePacked(block.timestamp)))%gmsLen;
    }
    
    function getGm(uint256 tokenId) public view returns (string memory) {
        return tokenIdToGm[tokenId];
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string[3] memory parts;
        parts[
            0
        ] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 22px; }</style><rect width="100%" height="100%" fill="black" /><text xmlns="http://www.w3.org/2000/svg" x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" class="base">';

        parts[1] = tokenIdToGm[tokenId];

        parts[2] = "</text></svg>";

        string memory output = string(
            abi.encodePacked(parts[0], parts[1], parts[2])
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "gm #',
                        toString(tokenId),
                        '", "description": "69 ways to say gm.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(output)),
                        '"}'
                    )
                )
            )
        );
        output = string(abi.encodePacked("data:application/json;base64,", json));

        return output;
    }

 
    function claim() public nonReentrant {
        require(totalSupply() < 70, "all gm's have been minted.");
        require(balanceOf(_msgSender()) < 3, "only 3 gm's per address");
        
        uint gmIndex = getRandom();
        _safeMint(_msgSender(), totalSupply()+1);
        tokenIdToGm[totalSupply()] = gms[gmIndex];
        gms[gmIndex] = gms[gms.length - 1];
        gms.pop();
    }
    
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT license
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    constructor() ERC721("gm", "GM") Ownable() {}
}

/// [MIT License]
/// @title Base64
/// @notice Provides a function for encoding some bytes in base64
/// @author Brecht Devos <brecht@loopring.org>
library Base64 {
    bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    /// @notice Encodes some bytes to the base64 representation
    function encode(bytes memory data) internal pure returns (string memory) {
        uint256 len = data.length;
        if (len == 0) return "";

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((len + 2) / 3);

        // Add some extra buffer at the end
        bytes memory result = new bytes(encodedLen + 32);

        bytes memory table = TABLE;

        assembly {
            let tablePtr := add(table, 1)
            let resultPtr := add(result, 32)

            for {
                let i := 0
            } lt(i, len) {

            } {
                i := add(i, 3)
                let input := and(mload(add(data, i)), 0xffffff)

                let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
                out := shl(224, out)

                mstore(resultPtr, out)

                resultPtr := add(resultPtr, 4)
            }

            switch mod(len, 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }

            mstore(result, encodedLen)
        }

        return string(result);
    }
}