"""
Unified Omega Parameter Analysis for Multiple Systems

Demonstrates the compare_omega_systems() function by analyzing three different
matrix types on a single plot for direct visual comparison.

This is the Python equivalent of example_jomega_subplots.m

"""

import numpy as np
from ex4_jomega import compare_omega_systems


def main() -> None:
    """Main function to run the unified omega analysis"""

    print("=" * 60)
    print("Jomega Analysis: Unified Single Plot Visualization")
    print("=" * 60)
    print()

    # System 1: Highly Asymmetric Matrix (Very Curved)
    print("Analyzing System 1: Highly Asymmetric Matrix...")
    A1 = np.array(
        [[10, -3, 2, -1], [1, 8, -2, 1], [-2, 1, 9, -3], [1, -1, 2, 12]], dtype=float
    )

    # System 2: Symmetric Positive Definite Matrix
    print("Analyzing System 2: Symmetric Positive Definite Matrix...")
    A2 = np.array(
        [[4, -1, 0, 0], [-1, 4, -1, 0], [0, -1, 4, -1], [0, 0, -1, 4]], dtype=float
    )

    # System 3: Laplace-like Matrix (Very Structured)
    print("Analyzing System 3: Laplace-like Matrix...")
    n = 6
    A3 = 4 * np.eye(n) - np.diag(np.ones(n - 1), 1) - np.diag(np.ones(n - 1), -1)

    # Define systems with labels
    systems = [
        (A1, "Highly Asymmetric (4x4)"),
        (A2, "Symmetric Pos Def (4x4)"),
        (A3, "Laplace-like (6x6)"),
    ]

    print()
    print("Creating unified plot with all three systems...")
    print()

    # Use finer omega range for System 3 (like MATLAB version)
    omega_range = np.arange(0, 2.005, 0.005)

    # Analyze all systems and display on single plot
    results = compare_omega_systems(systems, omega_range=omega_range)

    # Print comparison table
    print("\n" + "=" * 60)
    print("Comparison of Results")
    print("=" * 60)
    print("System                    | Optimal ω | Optimal ρ | Conv. Interval")
    print("-" * 60)

    for i, (result, (_, label)) in enumerate(zip(results, systems), 1):
        if result.omega_conv is not None:
            conv_str = f"[{result.omega_conv[0]:.3f}, {result.omega_conv[1]:.3f}]"
        else:
            conv_str = "None"

        print(
            f"{i}. {label:22s} | {result.omega_opt:9.4f} | {result.rho_opt:9.4f} | {conv_str}"
        )

    print("=" * 60)
    print()
    print("Note: The optimal omega value minimizes the spectral radius,")
    print("      leading to fastest convergence of the Soothed Jacobi method.")
    print("      Convergence occurs when the spectral radius is less than 1.")
    print("      All three systems are now visible on a single plot for comparison.")
    print()


if __name__ == "__main__":
    main()
