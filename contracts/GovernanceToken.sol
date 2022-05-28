// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract GOVToken is ERC20 {
    uint256 price;

    // Para calcular el price que le queremos dar a nuestro token le daremos el valor de otro token del mercado a traves de un AggregatorV3Interface de openzeppelin

    constructor(uint256 initialSupply) public ERC20("GOV Token", "GOV") {
        // _mint(msg.sender, initialSupply);
        // No vamos a mandar ningun token a ninguna direccion con el deployment del contrato
        // Se tiene que retirar el initialSupply como input
    }

    function mint(uint256 requestedTokensQuantity) public payable {
        uint256 value = (msg.value / price);
        _mint(msg.sender, value);
    }
}
