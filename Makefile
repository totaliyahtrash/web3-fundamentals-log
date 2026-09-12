-include .env

.PHONY: all test clean build deploy-sepolia snapshot format lint help

help:
	@echo "Available Makefile Commands:"
	@echo "  make build          - Compile all smart contracts"
	@echo "  make test           - Run full Foundry test suite"
	@echo "  make test-fuzz      - Run stateful invariant fuzz tests"
	@echo "  make snapshot       - Generate gas usage snapshot report"
	@echo "  make format         - Format all Solidity code with forge fmt"
	@echo "  make clean          - Remove build artifacts and cache"
	@echo "  make anvil          - Start local Anvil development node"
	@echo "  make inspect        - Run EVM Inspector Python CLI utility"

all: clean build

build:
	forge build

test:
	forge test -vvv

test-fuzz:
	forge test --match-contract InvariantsTest -vvvv

snapshot:
	forge snapshot

format:
	forge fmt

clean:
	forge clean

anvil:
	anvil -m 'test test test test test test test test test test test junk'

inspect:
	python3 scripts/evm_inspector.py

# Deployment Helpers (Requires .env configuration)
deploy-fundme-sepolia:
	forge script script/DeployFundMe.s.sol:DeployFundMe \
		--rpc-url $(SEPOLIA_RPC_URL) \
		--account devAccount \
		--broadcast \
		--verify \
		--etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
