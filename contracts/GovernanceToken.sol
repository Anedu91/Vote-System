// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract GOVToken is ERC20 {
    uint256 price;

    // Para calcular el price que le queremos dar a nuestro token le daremos el valor de otro token del mercado a traves de un AggregatorV3Interface de openzeppelin

    constructor() public ERC20("GOV Token", "GOV") {
        // _mint(msg.sender, initialSupply);
        // No vamos a mandar ningun token a ninguna direccion con el deployment del contrato
        // Como manejar el initial supply? Lo dejamos fijo o libre?
    }

    function mint(uint256 requestedTokensQuantity) public payable {
        // Pedimos como fee el 0,01% en ethers de la cantidad minteada
        // La relacion que estableci es: 1 GOVToken = 0.0001 eth
        // 1 eth = 1000000000000000000
        require(msg.value >= (requestedTokensQuantity * 100000000000000));

        // Tenemos que crear un sistema que obtenga el precio de nuestro token (inicialmente nos podemos basar en el price_feed de otro token) y asi pedir que el monto en ether mandado sea preciotoken*requestedTokensQuantity
        _mint(msg.sender, requestedTokensQuantity);
    }
}
