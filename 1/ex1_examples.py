"""
Machine Number Functions Examples
This script demonstrates the usage of all four machine number functions
"""

import numpy as np
from ex1_machine_numbers import fl1, fl2, fl3, fl4


def main() -> None:
    print("=== Testing Machine Number Functions ===\n")

    # Test parameters
    t = 4  # 4-bit mantissa
    k1 = -2  # minimum characteristic
    k2 = 2  # maximum characteristic

    print(f"Using parameters: t={t}, k1={k1}, k2={k2}\n")

    # Test fl1 - Machine number to real number conversion
    print("1. Testing fl1 (machine number to real number):")

    # Test case 1: Positive number
    # Mantissa: [0, 1, 1, 0] (sign=0, fractional=110 in binary = 0.75)
    # Characteristic: 1
    # Should be: (1 + 0.75) * 3^1 = 1.75 * 3 = 5.25
    machine_num1 = [0, 1, 1, 0, 1]
    real_val1 = fl1(machine_num1)
    print(f"   Machine: {machine_num1} -> Real: {real_val1:.6f}")

    # Test case 2: Negative number
    # Mantissa: [1, 0, 1, 0] (sign=1, fractional=010 in binary = 0.25)
    # Characteristic: 0
    # Should be: -(1 + 0.25) * 3^0 = -1.25
    machine_num2 = [1, 0, 1, 0, 0]
    real_val2 = fl1(machine_num2)
    print(f"   Machine: {machine_num2} -> Real: {real_val2:.6f}")

    # Test case 3: Zero
    machine_num3 = [0, 0, 0, 0, 0]
    real_val3 = fl1(machine_num3)
    print(f"   Machine: {machine_num3} -> Real: {real_val3:.6f}")

    # Test fl2 - Display machine number set
    print("\n2. Testing fl2 (machine number set analysis):")
    M_inf, eps_0, eps_1, num_elements = fl2(t, k1, k2)

    # Test fl3 - Real number to machine number conversion
    print("\n3. Testing fl3 (real number to machine number):")

    try:
        # Test with the real values we got from fl1
        machine_reconstructed1 = fl3(real_val1, t, k1, k2)
        machine_list = [int(x) for x in machine_reconstructed1]
        print(f"   Real: {real_val1:.6f} -> Machine: {machine_list}")

        # Verify by converting back
        verification1 = fl1(machine_reconstructed1)
        error1 = abs(verification1 - real_val1)
        print(f"   Verification: {verification1:.6f} (error: {error1:.2e})")

        # Test with a simple number
        test_real = 2.0
        machine_test = fl3(test_real, t, k1, k2)
        machine_test_list = [int(x) for x in machine_test]
        print(f"   Real: {test_real:.6f} -> Machine: {machine_test_list}")
        verification_test = fl1(machine_test)
        error_test = abs(verification_test - test_real)
        print(f"   Verification: {verification_test:.6f} (error: {error_test:.2e})")

    except Exception as e:
        print(f"   Error in fl3: {e}")

    # Test fl4 - Machine number addition
    print("\n4. Testing fl4 (machine number addition):")

    try:
        # Add two positive numbers
        sum_result = fl4(machine_num1, [0, 1, 0, 0, 0])  # Add [0,1,0,0,0]
        real_sum = fl1(sum_result)
        second_num_real = fl1([0, 1, 0, 0, 0])

        print(f"   Adding: {real_val1:.6f} + {second_num_real:.6f}")
        sum_result_list = [int(x) for x in sum_result]
        print(f"   Result machine: {sum_result_list}")
        print(f"   Result real: {real_sum:.6f}")
        expected_sum = real_val1 + second_num_real
        error_sum = abs(real_sum - expected_sum)
        print(f"   Expected: {expected_sum:.6f} (error: {error_sum:.2e})")

        # Test subtraction (positive + negative)
        sub_result = fl4(machine_num1, machine_num2)
        real_sub = fl1(sub_result)

        print(f"\n   Subtracting: {real_val1:.6f} + ({real_val2:.6f})")
        sub_result_list = [int(x) for x in sub_result]
        print(f"   Result machine: {sub_result_list}")
        print(f"   Result real: {real_sub:.6f}")
        expected_sub = real_val1 + real_val2
        error_sub = abs(real_sub - expected_sub)
        print(f"   Expected: {expected_sub:.6f} (error: {error_sub:.2e})")

    except Exception as e:
        print(f"   Error in fl4: {e}")

    # Summary
    print("\n=== Test Summary ===")
    print("All functions have been tested with basic examples.")
    print("Check the results above for accuracy and consistency.")

    # Display some machine number set statistics
    print("\nMachine number set statistics:")
    print(f"- Total elements: {num_elements}")
    print(f"- Largest number (M∞): {M_inf:.6f}")
    print(f"- Smallest positive (ε₀): {eps_0:.6f}")
    if not np.isnan(eps_1):
        print(f"- Machine epsilon (ε₁): {eps_1:.6f}")
    else:
        print("- Machine epsilon (ε₁): undefined")


if __name__ == "__main__":
    main()
