from brownie import GOVToken, VotationContract, accounts, config, network
from scripts.helpful_scripts import set_account


def main():
    close_votation()
    add_proposal_with_whitelist()


def deploy_gov_token():
    account = set_account()
    votation_contract = GOVToken.deploy(
        {"from": account},
        publish_source=config["networks"][network.show_active()].get("verify"),
    )
    print(votation_contract.address)


def deploy():
    account = set_account()
    gov_contract = VotationContract.deploy(
        {"from": account},
        publish_source=config["networks"][network.show_active()].get("verify"),
    )
    print(f"Governance Contract deployed! at {gov_contract.address}")


def add_whiteList():
    account = set_account()
    votation_contract = VotationContract[-1]
    print(votation_contract.address)
    tx = votation_contract.add_white_list(
        "0x16A1BE9BBB52D750752A67EC7DF50E9D61204ADC", {"from": account}
    )


def add_proposal_with_whitelist():
    account = set_account()
    token_contract = GOVToken[-1]
    print("contrato del governanceToken obtenido")
    votation_contract = VotationContract[-1]
    print("contrato de votacion obtenido")
    tx = votation_contract.add_white_list(
        account,
        {"from": account},
    )
    print(f"Agregada la cuenta {account} a la white list")

    tx_proposal = votation_contract.proposalCreation(
        "title", "description", {"from": account}
    )
    print("Propuesta Creada")
    tx_proposal.wait(1)
    print(votation_contract.publishedProposals("title"))


def add_proposal_with_tokens():
    account = set_account()
    token_contract = GOVToken[-1]
    print("contrato del governanceToken deployeado/obtenido")
    votation_contract = VotationContract.deploy({"from": account})
    print("contrato de votacion deployeado/obtenido")
    tx_mint = token_contract.mint(100, {"from": account, "value": 10000000000050000})
    tx_mint.wait(1)
    print(f"Tokens minteados a la cuenta {account}")

    tx_proposal = votation_contract.proposalCreation(
        "title", "description", {"from": account}
    )
    print("Propuesta Creada")
    tx_proposal.wait(1)
    print(votation_contract.publishedProposals("title"))


def close_votation():
    account = set_account()
    votation_contract = VotationContract[-1]
    print("contrato de votacion obtenido")
    tx = votation_contract.closeVotation({"from": account})
    tx.wait(1)
