from brownie import VotationContract, GOVToken, exceptions
from scripts.helpful_scripts import set_account
import pytest

# Definimos primero que es lo que queremos testear.

# Primero es probar a mintear algunos tokens

# Podemos testear el que una cuenta tenga tokens o este en la white list y pueda hacer una propuesta.

# Podemos testear el tiempo de espera entre propuestas y votacion.

# Podemos probar a votar y ver los resultados.

# Podemos probar a hacer dos propuestas a la vez


def test_mint():
    # Arrange
    account = set_account()
    gov_token = GOVToken.deploy({"from": account})

    # Acting

    gov_token.mint(100, {"from": account, "value": 10000000000000100})

    # Assert

    assert gov_token.totalSupply() == 100
    assert gov_token.balanceOf(account) == 100

    # with pytest.raises(exceptions.VirtualMachineError):
    #     lottery.enter({"from": set_account(), "value": lottery.getEntranceFee()})


def test_white_list():
    # Arrange
    account = set_account()
    votation_contract = VotationContract.deploy({"from": account})

    # Acting
    tx = votation_contract.add_white_list(
        "0x6bEf019aE1f6B79b63CBba23647b46DDFdd8FD10", {"from": account}
    )
    tx.wait(1)
    # Assert
    assert (
        votation_contract.whiteList(0) == "0x6BEF019AE1F6B79B63CBBA23647B46DDFDD8FD10"
    )


def test_onlyOwner_white_list():
    # Arrange
    account = set_account()
    votation_contract = VotationContract.deploy({"from": account})

    # Acting/Assert

    tx = votation_contract.add_white_list(
        account,
        {"from": account},
    )
    print(votation_contract.whiteList(0))


def test_notOwner_white_list():
    # Arrange
    account = set_account()
    votation_contract = VotationContract.deploy({"from": account})

    # Acting/Assert

    with pytest.raises(exceptions.VirtualMachineError):
        tx = votation_contract.add_white_list(
            "0x6bEf019aE1f6B79b63CBba23647b46DDFdd8FD10",
            {"from": "0x16A1bE9Bbb52D750752A67eC7dF50e9d61204adC"},
        )
