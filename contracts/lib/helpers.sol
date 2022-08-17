// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract helpers{
    function deleteIndex(uint256[] memory array, uint256 index)
        internal
        pure
        returns (uint256[] memory)
    {
        require(index < array.length);

        for (uint256 i = index; i < array.length - 1; i++) {
            array[i] = array[i + 1];
        }
        delete array[array.length - 1];
        return array;
    }

    function check(uint256[] memory array, uint256 id)
        internal
        pure
        returns (bool)
    {
        for (uint256 i = 0; i < array.length - 1; i++) {
            if (array[i] == id) {
                return true;
            }
        }
        return false;
    }

    function getIndex(uint256[] memory array, uint256 id)
        internal
        pure
        returns (uint256)
    {
        for (uint256 i = 0; i < array.length; i++) {
            if (array[i] == id) {
                return i;
            }
        }
    }
}