from brownie import VotationContract, GOVToken
from scripts.helpful_scripts import set_account


def test_creation_proposal_with_tokens():

    # Arrange
    account = set_account()
    token_contract = GOVToken.deploy({"from": account})
    tx_mint = token_contract.mint(100, {"from": account, "value": 10000000000050000})
    tx_mint.wait(1)
    print("Contrato Minteado")
    votation_contract = VotationContract.deploy({"from": account})
    print("contrato de votacion deployed")
    # Acting
    tx_proposal = votation_contract.proposalCreation(
        "title", "description", {"from": account}
    )
    tx_proposal.wait(1)
    print(votation_contract.publishedProposals("title"))

    assert votation_contract.state_voting() == 2


def test_creation_proposal_with_whiteList():
    # Arrange
    account = set_account()
    votation_contract = VotationContract.deploy({"from": account})
    print("contrato de votacion deployed")
    tx = votation_contract.add_white_list(
        account,
        {"from": account},
    )
    print(votation_contract.whiteList(0))

    # Acting
    tx_proposal = votation_contract.proposalCreation(
        "title", "description", {"from": account}
    )
    tx_proposal.wait(1)
    print(votation_contract.publishedProposals("title"))

    assert votation_contract.state_voting() == 2
