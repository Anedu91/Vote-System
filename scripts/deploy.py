from brownie import VotationContract
from scripts.helpful_scripts import set_account


def main():
    deploy()


def deploy():
    account = set_account()
    supply = 1000000000000000000 / 4
    votation_contract = VotationContract.deploy(supply, {"from": account})
