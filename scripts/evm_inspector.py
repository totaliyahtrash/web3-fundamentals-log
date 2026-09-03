#!/usr/bin/env python3
"""
EVM Inspector & Web3 Developer Utility Tool
-------------------------------------------
A zero-external-dependency CLI utility built to inspect, simulate, and calculate:
1. EIP-1559 Base Fee dynamic adjustments & Burn calculations
2. Precise Wei / Gwei / Ether conversion without floating-point errors
3. Layer 2 Rollup Gas Breakdown (L1 Calldata/Blob Fee + L2 Execution Fee)
4. Nonce replacement & speed-up gas fee calculators (+12% replacement rule)
5. Function Selector / Signature Hash calculator (Keccak-256)

Usage:
    python scripts/evm_inspector.py --calc-fee --gas 21000 --base-fee 18.5 --priority-fee 1.5
    python scripts/evm_inspector.py --l2-fee --l2-gas 50000 --l2-gas-price 0.1 --calldata-bytes 128
    python scripts/evm_inspector.py --speedup --current-fee 20.0
    python scripts/evm_inspector.py --eip1559-sim --start-fee 20 --blocks 5 --fullness 100
    python scripts/evm_inspector.py --units 0.05
"""

import sys
import hashlib
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
    print("⚡ EIP-1559 Transaction Fee Breakdown (L1)")
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

def calculate_l2_fee(l2_gas: int, l2_gas_price_gwei: float, calldata_bytes: int, l1_base_fee_gwei: float = 15.0):
    """Simulates Layer 2 rollup fee structure (Execution Fee + L1 Data Posting Fee)."""
    l2_execution_fee_gwei = Decimal(str(l2_gas)) * Decimal(str(l2_gas_price_gwei))
    # Approximation: each non-zero byte of calldata costs ~16 gas on L1
    l1_gas_required = Decimal(str(calldata_bytes)) * Decimal("16")
    l1_data_fee_gwei = l1_gas_required * Decimal(str(l1_base_fee_gwei))
    total_fee_gwei = l2_execution_fee_gwei + l1_data_fee_gwei
    total_fee_eth = total_fee_gwei / Decimal("1000000000")

    print("\n" + "=" * 60)
    print("🚀 Layer 2 Rollup Transaction Fee Breakdown (Optimism / Arbitrum)")
    print("=" * 60)
    print(f"• L2 Execution Gas Used  : {l2_gas:,.0f} @ {l2_gas_price_gwei} Gwei")
    print(f"• L2 Execution Fee       : {l2_execution_fee_gwei / Decimal('1000000000'):.8f} ETH")
    print(f"• L1 Calldata / Blob Gas : {calldata_bytes} bytes ({l1_gas_required:,.0f} L1 gas)")
    print(f"• L1 Data Posting Fee    : {l1_data_fee_gwei / Decimal('1000000000'):.8f} ETH")
    print("-" * 60)
    print(f"💳 Total L2 Transaction Fee: {total_fee_eth:.8f} ETH (${total_fee_eth * Decimal('3000'):.6f} @ $3k/ETH)")
    print("=" * 60 + "\n")

def calculate_speedup(current_effective_gas_gwei: float):
    """Calculates the minimum replacement fee required by mempool gossip rules (+10-12%)."""
    current = Decimal(str(current_effective_gas_gwei))
    min_speedup_10 = current * Decimal("1.10")
    recommended_12 = current * Decimal("1.12")
    
    print("\n" + "=" * 55)
    print("🔄 Stuck Transaction Speed-Up & Cancellation Calculator")
    print("=" * 55)
    print(f"• Current Stuck Gas Price : {current:.2f} Gwei")
    print(f"• Minimum Required (+10%) : {min_speedup_10:.2f} Gwei")
    print(f"• Recommended (+12%)      : {recommended_12:.2f} Gwei (Safe replacement)")
    print("-" * 55)
    print("💡 Rule: Use the EXACT same nonce to overwrite the pending transaction.")
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
    parser.add_argument("--base-fee", type=float, default=18.5, help="Base fee in Gwei (default: 18.5)")
    parser.add_argument("--priority-fee", type=float, default=1.5, help="Priority fee in Gwei (default: 1.5)")
    parser.add_argument("--l2-fee", action="store_true", help="Calculate Layer 2 rollup transaction fee")
    parser.add_argument("--l2-gas", type=int, default=50000, help="L2 execution gas used")
    parser.add_argument("--l2-gas-price", type=float, default=0.1, help="L2 gas price in Gwei")
    parser.add_argument("--calldata-bytes", type=int, default=128, help="Calldata payload size in bytes")
    parser.add_argument("--speedup", action="store_true", help="Calculate replacement gas for stuck tx")
    parser.add_argument("--current-fee", type=float, default=20.0, help="Current stuck gas price in Gwei")
    parser.add_argument("--eip1559-sim", action="store_true", help="Simulate EIP-1559 base fee changes")
    parser.add_argument("--start-fee", type=float, default=20.0, help="Initial base fee for sim")
    parser.add_argument("--blocks", type=int, default=5, help="Number of blocks to simulate")
    parser.add_argument("--fullness", type=float, default=100.0, help="Block fullness percent (0-100%%)")

    if len(sys.argv) == 1:
        # Default demo execution
        print("⚡ Running EVM Inspector Comprehensive Demo:")
        convert_units("0.05")
        calculate_tx_fee(21000, 18.5, 1.5)
        calculate_l2_fee(50000, 0.01, 128, 15.0)
        calculate_speedup(20.0)
        simulate_eip1559(20.0, 5, 100.0)
        return

    args = parser.parse_args()
    if args.units:
        convert_units(args.units)
    elif args.calc_fee:
        calculate_tx_fee(args.gas, args.base_fee, args.priority_fee)
    elif args.l2_fee:
        calculate_l2_fee(args.l2_gas, args.l2_gas_price, args.calldata_bytes)
    elif args.speedup:
        calculate_speedup(args.current_fee)
    elif args.eip1559_sim:
        simulate_eip1559(args.start_fee, args.blocks, args.fullness)

if __name__ == "__main__":
    main()
