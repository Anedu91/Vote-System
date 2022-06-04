// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VotationContract is Ownable {
    uint256 public proposalTime = 0;
    uint256 public votationStartTime = 0;
    IERC20 public governanceToken;
    address public governanceTokenAddress =
        0x9Fc30f488478C1fc64A286d3A0380Cf82c7ce3d1;

    // Creamos un mapping con titulo de propuestas y la descricion de la propuesta
    mapping(string => string) public publishedProposals;

    // Estructura de datos a retornar cuando finalice la votacion
    struct VotationResult {
        string proposalTitle;
        uint256 approvedVotes;
        uint256 refusedVotes;
        uint256 abstentionVotes;
    }
    VotationResult public votation_result =
        VotationResult("No proposal yet", 0, 0, 0);

    // Creamos un mapping para el proposalTitle y sus resultados
    mapping(string => VotationResult) public proposalResults;

    // Nos ayudara a poner condiciones para comienzo, final y momento en que se propone algo
    enum Voting_state {
        Open,
        Closed,
        About_To_Start
    }
    Voting_state public state_voting = Voting_state.Closed;

    // Un whitelist de personas que no posean el token, las puede agregar solo el owner del contrato
    address[] public whiteList;

    // Creacion de la propuesta con cada una de sus partes, pueden votar los que esten en la whitelist o los que tengan tokens

    function proposalCreation(
        string memory proposalTitle,
        string memory proposalDescription
    ) public {
        // Creamos la interfaz para interactuar con el contrato del token

        // La interfaz sera fijada con el deployment del contrato, por lo cual el contrato del token tendra que ya haber sido deployeado.

        governanceToken = IERC20(governanceTokenAddress);

        // Solo puede haber una propuesta a la vez gracias al state_voting

        // Verificar antes de hacer una propuesta que no haya ninguna votacion en curso
        require(
            state_voting == Voting_state.Closed,
            "Hay una votacion en curso"
        );
        if (
            governanceToken.balanceOf(msg.sender) >=
            (governanceToken.totalSupply() / 10)
        ) {
            // Publicar proposal
            publishedProposals[proposalTitle] = proposalDescription;

            // Cambio estado votacion - solo 1 propuesta a la vez
            state_voting = Voting_state.About_To_Start;

            // Nos aseguramos que la votacion empieza en cero
            votation_result = VotationResult(proposalTitle, 0, 0, 0);

            // Configurar el tiempo de delay entre la publicacion de la propuesta y el comienzo de la votacion

            // Capaz se puede programar el tiempo a traves del script en python
            proposalTime = block.timestamp;
        }

        // Verificar que la cuenta que propone este en el whiteList
        bool whiteList_ok = false;
        for (uint256 i = 0; i < whiteList.length; i++) {
            if (msg.sender == whiteList[i]) {
                whiteList_ok = true;
            }
        }

        if (whiteList_ok == true) {
            // Publicar proposal
            publishedProposals[proposalTitle] = proposalDescription;

            // Cambio estado votacion - solo 1 propuesta a la vez
            state_voting = Voting_state.About_To_Start;

            // Nos aseguramos que la votacion empieza en cero
            votation_result = VotationResult(proposalTitle, 0, 0, 0);

            //Configurar el tiempo de delay entre la publicacion de la propuesta y el comienzo de la votacion

            // Capaz se puede programar el tiempo a traves del script en python
            proposalTime = block.timestamp;
        }
    }

    function add_white_list(address whiteListNewAddress) public onlyOwner {
        whiteList.push(whiteListNewAddress);
    }

    function voting_start() public onlyOwner {
        // La votacion podra ser comenzada cuando se hace este call luego de un tiempo predefinido luego que la propuesta fue aceptada o de que se hace efectivamente una propuesta =
        require(
            proposalTime + 600 seconds < block.timestamp,
            "Is not yet time to vote"
        );

        state_voting = Voting_state.Open;
        votationStartTime = block.timestamp;

        // Averiguar como implementar un delay para que esta funcion se active sola. Hay servicios de terceros pero hay que investigarlo.
    }

    function approveProposal() public {
        require(state_voting == Voting_state.Open);
        require(
            governanceToken.balanceOf(msg.sender) >=
                (governanceToken.totalSupply() / 10)
        );
        votation_result.approvedVotes += 1;
    }

    function refuseProposal() public {
        require(state_voting == Voting_state.Open);
        require(
            governanceToken.balanceOf(msg.sender) >=
                (governanceToken.totalSupply() / 10)
        );
        votation_result.refusedVotes += 1;
    }

    function abstainProposal() public {
        require(state_voting == Voting_state.Open);
        require(
            governanceToken.balanceOf(msg.sender) >=
                (governanceToken.totalSupply() / 10)
        );
        votation_result.abstentionVotes += 1;
    }

    function closeVotation() public onlyOwner {
        require(
            votationStartTime + 2 hours < block.timestamp,
            "Aun no ha transcurrido el tiempo necesario para concluir la votacion"
        );
        state_voting = Voting_state.Closed;
    }
}

// Mis dudas son: Por que me pidio que los strings de proposalCreation sean memory
// Por que me pidio inicializar el struct con el (0,0,0)
