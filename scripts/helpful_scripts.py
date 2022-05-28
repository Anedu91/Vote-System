from brownie import (
    accounts,
    network,
    config,
)

LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["development", "ganache-local", "mainnet-fork"]
FORKED_LOCAL_ENVIRONMENTS = ["mainnet-fork-dev"]

# OPENSEA_URL = "https://testnets.opensea.io/assets/{}/{}"
# DECIMALS = 8
# STARTING_PRICE = 200000000000
# BREED_MAPPING = {0: "PUG", 1: "SHIBA_INU", 2: "ST_BERNARD"}

# contract_to_mock = {
#     "vrf_coordinator": VRFCoordinatorMock,
#     "link_token": LinkToken,
# }


# def get_breed(breed_number):
#     return BREED_MAPPING[breed_number]


def set_account(id=None, index=None):
    if id:
        return accounts.load(id)
    if index:
        return accounts[index]
    if (
        network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS
        or network.show_active() in FORKED_LOCAL_ENVIRONMENTS
    ):
        return accounts[0]
    return accounts.add(config["wallets"]["from_key"])


# def get_contract(contract_name):
#     """This function will grab the contract addresses from the brownie config if defined, otherwise, it will deploy a mock version of that contract, and return that mock contract.

#     Args:
#         contract_name (string)

#     Returns:
#         brownie.network.contract.ProjectContract: The most recently deployed version of this contract.
#     """

#     contract_type = contract_to_mock[contract_name]

#     if network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS:

#         if len(contract_type) <= 0:
#             deploy_mocks()
#         contract = contract_type[-1]
#     else:
#         contract_address = config["networks"][network.show_active()][contract_name]

#         contract = Contract.from_abi(
#             contract_type._name,
#             # ._name es una propiedad de los contratos
#             contract_address,
#             contract_type.abi
#             # Contract es una class de brownie que te permite crear un Contract con diferentes methods que te ponen a disposicion
#         )
#         # MockV3Aggregator.abi

#     return contract


# def deploy_mocks(decimals=DECIMALS, initial_value=STARTING_PRICE):
#     account = set_account()
#     print("Deploying Mock LinkToken...")
#     link_token = LinkToken.deploy({"from": account})
#     print(f"Link token deployed to {link_token.address}")
#     print("Deploying mock VRF Coordinator...")
#     vrf_coordinator = VRFCoordinatorMock.deploy(link_token.address, {"from": account})
#     print("Mocks deployed!")


# def link_fund(
#     contract_address, account=None, link_token=None, amount=100000000000000000
# ):
#     # El amount es igual a 0.1 Link
#     account = account if account else set_account()
#     link_token = link_token if link_token else get_contract("link_token")
#     tx = link_token.transfer(contract_address, amount, {"from": account})
#     # link_token_contract= interface.LinkTokenInterface(link_token.address)
#     # Crear el link_token contract a traves de la funcion interface.
#     # tx= link_token_contract.transfer(contract_address, amount, {"from":account})
#     tx.wait(1)
#     print("Fund contract!")
#     return tx
