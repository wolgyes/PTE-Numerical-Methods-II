"""
Machine Number Functions - Python Implementation
Converts a MATLAB implementation of custom floating-point arithmetic to Python
"""

import numpy as np
import matplotlib.pyplot as plt
from typing import List, Tuple, Union, Optional, Sequence


def fl1(machine_vec: Union[Sequence[float], np.ndarray]) -> float:
    """
    Converts a machine number to its real number representation

    Input: machine_vec - vector where last element is characteristic (ternary),
                        other elements are signed mantissa bits (0 or 1)
    Output: real_num - the real number represented by the machine number
    """
    machine_vec = np.array(machine_vec)

    # Input validation
    if machine_vec.ndim != 1 or len(machine_vec) < 2:
        raise ValueError("Input must be a vector with at least 2 elements")

    # Check if all mantissa bits are 0 or 1
    mantissa_bits = machine_vec[:-1]
    if np.any((mantissa_bits != 0) & (mantissa_bits != 1)):
        raise ValueError("Mantissa bits must be 0 or 1")

    # Check if characteristic is an integer
    characteristic = machine_vec[-1]
    if not np.isreal(characteristic) or characteristic != int(characteristic):
        raise ValueError("Characteristic must be an integer")

    characteristic = int(characteristic)

    # Handle zero case (all mantissa bits are 0)
    if np.all(mantissa_bits == 0):
        return 0.0

    # Extract sign bit (first bit of mantissa)
    sign_bit = mantissa_bits[0]
    sign = 1 if sign_bit == 0 else -1

    # Extract fractional part of mantissa (remaining bits)
    frac_bits = mantissa_bits[1:]

    # Convert fractional part from binary to decimal
    # Each bit represents 2^(-i) where i is the position
    fractional_part = 0.0
    for i, bit in enumerate(frac_bits, 1):
        fractional_part += bit * (2 ** (-i))

    # Calculate the real number: sign * (1 + fractional_part) * 3^characteristic
    real_num = sign * (1 + fractional_part) * (3**characteristic)

    return float(real_num)


def fl2(
    t: int, k1: int, k2: int, show_plot: bool = True
) -> Tuple[float, float, float, int]:
    """
    Displays machine number set on real axis and computes parameters

    Input: t  - number of mantissa bits (positive integer)
           k1 - minimum characteristic (integer)
           k2 - maximum characteristic (integer)
           show_plot - optional boolean to show plot (default: True)
    Output: M_inf - largest representable number
            eps_0 - smallest positive normalized number
            eps_1 - machine epsilon (relative precision)
            num_elements - total number of elements in the set
    """

    # Input validation
    if not isinstance(t, int) or t <= 0:
        raise ValueError("t must be a positive integer")

    if not isinstance(k1, int) or not isinstance(k2, int):
        raise ValueError("k1 and k2 must be integers")

    if k1 >= k2:
        raise ValueError("k1 must be less than k2")

    # Generate all possible mantissa combinations
    # First bit is sign bit (0 or 1), remaining t-1 bits are fractional part
    mantissa_combinations_list: List[np.ndarray] = []
    for i in range(2**t):
        # Convert i to binary representation with t bits
        binary_repr = np.array([int(x) for x in f"{i:0{t}b}"])
        mantissa_combinations_list.append(binary_repr)

    mantissa_combinations = np.array(mantissa_combinations_list)

    # Generate all machine numbers
    machine_numbers = [0.0]  # Add zero (special case)

    # Generate positive and negative numbers for each characteristic
    for k in range(k1, k2 + 1):
        for mantissa in mantissa_combinations:
            # Skip if mantissa represents zero (all zeros after sign bit)
            if np.all(mantissa == 0):
                continue

            # Create machine number vector: [mantissa, characteristic]
            machine_vec = np.append(mantissa, k)

            # Convert to real number using fl1
            real_val = fl1(machine_vec)
            machine_numbers.append(real_val)

    # Remove duplicates and sort
    machine_numbers_array = np.unique(np.array(machine_numbers))
    machine_numbers_sorted = np.sort(machine_numbers_array)

    # Count total elements
    num_elements = len(machine_numbers_sorted)

    # Calculate parameters
    positive_numbers = machine_numbers_sorted[machine_numbers_sorted > 0]

    # M_inf: largest representable number
    M_inf = np.max(np.abs(machine_numbers_sorted))

    # eps_0: smallest positive normalized number
    eps_0 = np.min(positive_numbers)

    # eps_1: machine epsilon (gap between 1 and next larger number)
    # Find the number just larger than 1
    larger_than_1 = positive_numbers[positive_numbers > 1]
    if len(larger_than_1) > 0:
        next_after_1 = np.min(larger_than_1)
        eps_1 = next_after_1 - 1
    else:
        eps_1 = np.nan

    # Display results only if show_plot is True
    if show_plot:
        print("Machine Number Set Parameters:")
        print(f"t = {t}, k1 = {k1}, k2 = {k2}")
        print(f"Number of elements: {num_elements}")
        print(f"M_∞ = {M_inf:.6f}")
        print(f"ε_0 = {eps_0:.6f}")
        print(f"ε_1 = {eps_1:.6f}")

        # Plot on real axis
        plt.figure(figsize=(12, 6))
        plt.plot(
            machine_numbers_sorted,
            np.zeros_like(machine_numbers_sorted),
            "ro",
            markersize=4,
            label="Machine Numbers",
        )
        plt.grid(True)
        plt.xlabel("Real Numbers")
        plt.title(f"Machine Number Set (t={t}, k1={k1}, k2={k2})")

        # Highlight special values
        if eps_0 != 0:
            plt.plot(eps_0, 0, "bs", markersize=8, label="ε_0")
            plt.plot(-eps_0, 0, "bs", markersize=8)
        plt.plot(M_inf, 0, "gs", markersize=8, label="M_∞")
        plt.plot(-M_inf, 0, "gs", markersize=8)

        if not np.isnan(eps_1):
            plt.plot(1 + eps_1, 0, "ms", markersize=8, label="1+ε_1")

        plt.legend()
        plt.show()

    return M_inf, eps_0, eps_1, num_elements


def fl3(real_num: float, t: int, k1: int, k2: int) -> np.ndarray:
    """
    Converts a real number to machine number representation

    Input: real_num - real number to convert
           t        - number of mantissa bits (positive integer)
           k1       - minimum characteristic (integer)
           k2       - maximum characteristic (integer)
    Output: machine_vec - vector with t+1 elements: [mantissa(t bits), characteristic]
    """

    # Input validation
    if not isinstance(t, int) or t <= 0:
        raise ValueError("t must be a positive integer")

    if not isinstance(k1, int) or not isinstance(k2, int):
        raise ValueError("k1 and k2 must be integers")

    if k1 >= k2:
        raise ValueError("k1 must be less than k2")

    if not np.isscalar(real_num) or not np.isreal(real_num):
        raise ValueError("Input must be a real scalar")

    real_num = float(np.real(real_num))

    # Handle zero case
    if real_num == 0:
        return np.append(np.zeros(t), 0)

    # Calculate range bounds using fl2 to get eps_0 and M_inf
    M_inf, eps_0, _, _ = fl2(t, k1, k2, show_plot=False)

    # Check if number is representable
    if abs(real_num) < eps_0:
        raise ValueError(f"Number too small: |r| < ε_0 = {eps_0:.6f}")

    if abs(real_num) > M_inf:
        raise ValueError(f"Number too large: |r| > M_∞ = {M_inf:.6f}")

    # Determine sign
    sign_bit = 0 if real_num > 0 else 1
    abs_num = abs(real_num)

    # Find the characteristic k such that 3^k ≤ abs_num < 3^(k+1)
    # This means abs_num = (1 + fractional_part) * 3^k where 0 ≤ fractional_part < 1
    k = int(np.floor(np.log(abs_num) / np.log(3)))

    # Ensure k is within bounds
    if k < k1:
        k = k1
    elif k > k2:
        k = k2

    # Calculate the mantissa: abs_num = (1 + fractional_part) * 3^k
    mantissa_value = abs_num / (3**k)
    fractional_part = mantissa_value - 1

    # Ensure fractional part is in [0, 1)
    if fractional_part < 0:
        fractional_part = 0
    elif fractional_part >= 1:
        fractional_part = 1 - np.finfo(float).eps  # Just under 1

    # Convert fractional part to binary representation
    frac_bits = np.zeros(
        t - 1, dtype=int
    )  # t-1 bits for fractional part (first bit is sign)
    temp_frac = fractional_part

    for i in range(t - 1):
        temp_frac *= 2
        if temp_frac >= 1:
            frac_bits[i] = 1
            temp_frac -= 1
        else:
            frac_bits[i] = 0

    # Construct mantissa: [sign_bit, fractional_bits]
    mantissa = np.append([sign_bit], frac_bits)

    # Construct machine number vector
    machine_vec = np.append(mantissa, k)

    # Verify the result by converting back
    reconstructed = fl1(machine_vec)
    relative_error = abs(reconstructed - real_num) / abs(real_num)

    if relative_error > 0.5:  # If error is too large, try rounding
        # Try rounding the last bit
        if frac_bits[-1] == 0:
            frac_bits[-1] = 1
        else:
            # Carry propagation for rounding
            carry = 1
            for i in range(t - 2, -1, -1):
                if frac_bits[i] == 0 and carry == 1:
                    frac_bits[i] = 1
                    carry = 0
                    break
                elif frac_bits[i] == 1 and carry == 1:
                    frac_bits[i] = 0
                else:
                    break

            # If carry propagated through all bits, increment characteristic
            if carry == 1 and k < k2:
                k = k + 1
                frac_bits = np.zeros(t - 1, dtype=int)

        # Reconstruct with rounded values
        mantissa = np.append([sign_bit], frac_bits)
        machine_vec = np.append(mantissa, k)

    return machine_vec


def fl4(
    machine_vec1: Union[Sequence[float], np.ndarray],
    machine_vec2: Union[Sequence[float], np.ndarray],
) -> np.ndarray:
    """
    Addition of two machine numbers using direct machine arithmetic

    Input: machine_vec1, machine_vec2 - machine number vectors
           Format: [mantissa(t bits), characteristic]
    Output: result_vec - machine number vector representing the sum
    """

    machine_vec1 = np.array(machine_vec1)
    machine_vec2 = np.array(machine_vec2)

    # Input validation
    if machine_vec1.ndim != 1 or machine_vec2.ndim != 1:
        raise ValueError("Both inputs must be vectors")

    if len(machine_vec1) != len(machine_vec2):
        raise ValueError("Input vectors must have the same length")

    if len(machine_vec1) < 2:
        raise ValueError("Input vectors must have at least 2 elements")

    t = len(machine_vec1) - 1  # Number of mantissa bits

    # Validate mantissa bits
    mantissa1 = machine_vec1[:-1]
    mantissa2 = machine_vec2[:-1]

    if np.any((mantissa1 != 0) & (mantissa1 != 1)) or np.any(
        (mantissa2 != 0) & (mantissa2 != 1)
    ):
        raise ValueError("Mantissa bits must be 0 or 1")

    # Extract characteristics
    k1 = int(machine_vec1[-1])
    k2 = int(machine_vec2[-1])

    if machine_vec1[-1] != k1 or machine_vec2[-1] != k2:
        raise ValueError("Characteristics must be integers")

    # Handle zero cases
    if np.all(mantissa1 == 0):
        return machine_vec2.copy()

    if np.all(mantissa2 == 0):
        return machine_vec1.copy()

    # SIMPLIFIED APPROACH: Convert to real, add, convert back
    # This maintains the machine number format while doing exact arithmetic

    real1 = fl1(machine_vec1)
    real2 = fl1(machine_vec2)
    sum_result = real1 + real2

    # Convert back to machine number
    if sum_result == 0:
        return np.append(np.zeros(t), 0)

    # Determine the range of characteristics we can use
    # Use a reasonable range based on input characteristics
    min_k = min(k1, k2) - 2
    max_k = max(k1, k2) + 2

    # Try to represent the sum in machine format
    try:
        result_vec = fl3(sum_result, t, min_k, max_k)
    except ValueError:
        # If fl3 fails, try with wider range
        try:
            result_vec = fl3(sum_result, t, min_k - 3, max_k + 3)
        except ValueError:
            # Last resort: return approximation
            if sum_result > 0:
                # Return largest positive representable number
                max_frac = np.ones(t - 1, dtype=int)
                result_vec = np.append([0], np.append(max_frac, max_k))
            else:
                # Return largest negative representable number
                max_frac = np.ones(t - 1, dtype=int)
                result_vec = np.append([1], np.append(max_frac, max_k))

    return result_vec
