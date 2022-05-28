// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract VotationContract is IERC20, Ownable {
    using SafeMath for uint256;
    uint256 public proposalTime = 0;
    uint256 public votationStartTime = 0;

    // Creamos un mapping con titulo de propuestas y la descricion de la propuesta
    mapping(string => string) public approvedProposals;

    // Estructura de datos a retornar cuando finalice la votacion
    struct VotationResult {
        uint256 approvedVotes;
        uint256 refusedVotes;
        uint256 abstentionVotes;
    }
    VotationResult votation_result = VotationResult(0, 0, 0);

    // Creamos un mapping para el proposalTitle y sus resultados
    mapping(string => VotationResult) public proposalResults;

    // Nos ayudara a poner condiciones para comienzo, final y momento en que se propone algo
    enum Voting_state {
        Open,
        Closed,
        About_To_Start
    }
    Voting_state public state_voting;

    // Un whitelist para cada persona que podra hacer propuestas
    address[] public whiteList;

    // Creamos este event para poder acceder a los resutados de las votaciones dentro de otra funcion
    // event proposalVotationResult(VotationResult indexed votationInit);

    // Creamos el governanceToken
    // Crear el token cuando se lanza el contrato o antes?

    // constructor(uint256 totalSupplyPerAccount)
    //     public
    //     ERC20("Governance", "GOV")
    // {}

    // // Agregar cuentas a la whitelist
    // function addAccountToWhiteList(address accountToAdd) public onlyOwner {
    //     whiteList.push(accountToAdd);
    // }

    // Creacion de la propuesta con cada una de sus partes

    function proposalCreation(
        address proposerAddress,
        string memory proposalTitle,
        string memory proposalDescription
    ) public {
        // Crear un mecanismo para que haya una sola proposal a la vez

        // Verificar antes de hacer una propuesta que no haya ninguna votacion en curso
        require(state_voting == Voting_state.Closed);

        // Verificar que la cuenta que propone este en el whiteList
        bool whiteList_ok = false;
        for (uint256 i = 0; i == whiteList.length; i++) {
            if (proposerAddress == whiteList[i]) {
                whiteList_ok = true;
            }
        }
        require(whiteList_ok == true);

        // Publicar proposal
        approvedProposals[proposalTitle] = proposalDescription;
        state_voting = Voting_state.About_To_Start;

        //Configurar el tiempo de delay entre la publicacion de la propuesta y el comienzo de la votacion

        // Capaz se puede programar el tiempo a traves del script en python
        proposalTime = block.timestamp;

        // Queria crear un votationResult struct object con el nombre de la proposalTitle, pero no me dejaba

        // VotationResult storage proposalTitle;
        // proposalTitle.approvedVotes = 0;
        // proposalTitle.refusedVotes = 0;
        // proposalTitle.abstentionVotes = 0;
    }

    function voting_start() public onlyOwner {
        // La votacion podra ser comenzada cuando se hace este call luego de un tiempo predefinido luego que la propuesta fue aceptada o de que se hace efectivamente una propuesta =
        require(
            proposalTime + 600 seconds < block.timestamp,
            "Is not yet time to vote"
        );

        votation_result = VotationResult(0, 0, 0);
        state_voting = Voting_state.Open;
        votationStartTime = block.timestamp;

        // Averiguar como implementar un delay para que esta funcion se active sola. Hay servicios de terceros pero hay que investigarlo.
    }

    function approveProposal() public {
        require(state_voting == Voting_state.Open);
        votation_result.approvedVotes += 1;
    }

    function refuseProposal() public {
        require(state_voting == Voting_state.Open);
        votation_result.refusedVotes += 1;
    }

    function abstainProposal() public {
        require(state_voting == Voting_state.Open);
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
