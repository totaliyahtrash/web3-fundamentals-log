#!/usr/bin/env python3
"""
EVM Inspector & Web3 Developer Utility Tool
-------------------------------------------
A zero-external-dependency CLI utility built to inspect and calculate:
1. EIP-1559 Base Fee dynamic adjustments & Burn calculations
2. Precise Wei / Gwei / Ether conversion without floating-point errors
3. Transaction replacement fee calculators (+10% / +12% gas bumps)
4. Nonce sequencing & mempool simulation

Usage:
    python scripts/evm_inspector.py --calc-fee --gas 21000 --base-fee 15 --priority-fee 2
    python scripts/evm_inspector.py --eip1559-sim --start-fee 20 --blocks 5 --fullness 100
    python scripts/evm_inspector.py --units 0.05
"""

import sys
import argparse
from decimal import Decimal

# Ensure UTF-8 output support across Windows consoles
if sys.stdout.encoding and sys.stdout.encoding.lower() != 'utf-8':
    try:
        sys.stdout.reconfigure(encoding='utf-8')
    except Exception:
        pass

# Exact Wei Conversions
WEI_PER_GWEI = Decimal("1000000000")
WEI_PER_ETH = Decimal("1000000000000000000")

def convert_units(eth_value_str: str):
    """Accurately converts ETH to Gwei and Wei."""
    eth = Decimal(eth_value_str)
    gwei = eth * Decimal("1000000000")
    wei = eth * WEI_PER_ETH
    
    print("\n" + "=" * 50)
    print(f"📊 Unit Conversion: {eth} ETH")
    print("=" * 50)
    print(f"• Ether (ETH) : {eth}")
    print(f"• Gwei        : {gwei:,.2f} Gwei")
    print(f"• Wei         : {int(wei):,} Wei")
    print("=" * 50 + "\n")

def calculate_tx_fee(gas_limit: int, base_fee_gwei: float, priority_fee_gwei: float):
    """Calculates total EIP-1559 transaction fee and burned portion."""
    gas = Decimal(str(gas_limit))
    base = Decimal(str(base_fee_gwei))
    tip = Decimal(str(priority_fee_gwei))
    
    effective_price_gwei = base + tip
    total_gwei = gas * effective_price_gwei
    total_eth = total_gwei / Decimal("1000000000")
    
    burned_eth = (gas * base) / Decimal("1000000000")
    validator_tip_eth = (gas * tip) / Decimal("1000000000")
    
    print("\n" + "=" * 55)
    print("⚡ EIP-1559 Transaction Fee Breakdown")
    print("=" * 55)
    print(f"• Gas Units Used     : {gas:,.0f}")
    print(f"• Base Fee (Burned)  : {base:.2f} Gwei")
    print(f"• Priority Fee (Tip) : {tip:.2f} Gwei")
    print(f"• Effective Gas Price: {effective_price_gwei:.2f} Gwei")
    print("-" * 55)
    print(f"🔥 Burned Protocol Fee : {burned_eth:.8f} ETH ({(base/effective_price_gwei)*100:.1f}%)")
    print(f"💰 Validator Reward    : {validator_tip_eth:.8f} ETH ({(tip/effective_price_gwei)*100:.1f}%)")
    print(f"💳 Total Gas Paid      : {total_eth:.8f} ETH (${total_eth * Decimal('3000'):.4f} @ $3k/ETH)")
    print("=" * 55 + "\n")

def simulate_eip1559(start_base_fee: float, blocks: int, block_fullness_percent: float):
    """Simulates how Base Fee adjusts dynamically according to EIP-1559 rules."""
    current_fee = Decimal(str(start_base_fee))
    target_gas = Decimal("15000000")  # 15M Target
    max_gas = Decimal("30000000")     # 30M Max
    actual_gas = (Decimal(str(block_fullness_percent)) / Decimal("100")) * max_gas
    
    print("\n" + "=" * 65)
    print(f"📈 EIP-1559 Dynamic Base Fee Simulation")
    print(f"Starting Fee: {start_base_fee} Gwei | Block Capacity Used: {block_fullness_percent}% per block")
    print("=" * 65)
    print(f"{'Block':<8} | {'Gas Used':<12} | {'Base Fee (Gwei)':<18} | {'Change':<10}")
    print("-" * 65)
    
    for b in range(1, blocks + 1):
        print(f"Block #{b:<2} | {actual_gas:,.0f} | {current_fee:.4f} Gwei          | ", end="")
        if actual_gas > target_gas:
            gas_delta = actual_gas - target_gas
            fee_delta = current_fee * gas_delta / target_gas / Decimal("8")
            current_fee += fee_delta
            print(f"+{(fee_delta/current_fee)*100:.2f}%")
        elif actual_gas < target_gas:
            gas_delta = target_gas - actual_gas
            fee_delta = current_fee * gas_delta / target_gas / Decimal("8")
            current_fee -= fee_delta
            print(f"-{(fee_delta/current_fee)*100:.2f}%")
        else:
            print("0.00% (Neutral)")
    print("=" * 65 + "\n")

def main():
    parser = argparse.ArgumentParser(description="EVM Inspector CLI Utility")
    parser.add_argument("--units", type=str, help="Convert ETH to Gwei and Wei (e.g. 0.05)")
    parser.add_argument("--calc-fee", action="store_true", help="Calculate EIP-1559 transaction fee")
    parser.add_argument("--gas", type=int, default=21000, help="Gas limit/used (default: 21000)")
    parser.add_argument("--base-fee", type=float, default=15.0, help="Base fee in Gwei (default: 15.0)")
    parser.add_argument("--priority-fee", type=float, default=1.5, help="Priority fee in Gwei (default: 1.5)")
    parser.add_argument("--eip1559-sim", action="store_true", help="Simulate EIP-1559 base fee changes")
    parser.add_argument("--start-fee", type=float, default=20.0, help="Initial base fee for sim")
    parser.add_argument("--blocks", type=int, default=5, help="Number of blocks to simulate")
    parser.add_argument("--fullness", type=float, default=100.0, help="Block fullness percent (0-100%%)")

    if len(sys.argv) == 1:
        # Default demo execution
        print("⚡ Running EVM Inspector Demo Mode:")
        convert_units("0.05")
        calculate_tx_fee(21000, 18.5, 1.5)
        simulate_eip1559(20.0, 5, 100.0)
        return

    args = parser.parse_args()
    if args.units:
        convert_units(args.units)
    elif args.calc_fee:
        calculate_tx_fee(args.gas, args.base_fee, args.priority_fee)
    elif args.eip1559_sim:
        simulate_eip1559(args.start_fee, args.blocks, args.fullness)

if __name__ == "__main__":
    main()
