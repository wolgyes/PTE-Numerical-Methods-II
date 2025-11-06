"""
Example demonstrations for iterative methods

Showcases usage of jacobi, gaussseid, and jomega functions with various systems.

"""

import numpy as np
from ex4_jacobi import jacobi, IterationResult
from ex4_gaussseid import gaussseid
from ex4_jomega import jomega, compare_omega_systems


def example_basic_comparison() -> None:
    """Compare Jacobi and Gauss-Seidel on simple systems"""
    print("=" * 70)
    print("Example 1: Basic Comparison - Jacobi vs Gauss-Seidel")
    print("=" * 70)

    # Define a diagonally dominant system
    A = np.array([[4, -1, 0], [-1, 4, -1], [0, -1, 4]], dtype=float)
    b = np.array([1, 5, 0], dtype=float)

    print("\nSystem: Ax = b")
    print("Matrix A:")
    print(A)
    print("\nVector b:")
    print(b)

    # Exact solution
    x_exact = np.linalg.solve(A, b)
    print(f"\nExact solution: {x_exact}")

    # Solve with Jacobi
    print("\n" + "-" * 70)
    print("Jacobi Method:")
    result_jacobi = jacobi(A, b, return_history=True)
    assert isinstance(result_jacobi, IterationResult)  # Type narrowing
    print(f"Solution: {result_jacobi.x}")
    print(f"Converged in {result_jacobi.iterations} iterations")
    print(f"Final residual: {result_jacobi.residual_norm:.2e}")
    print(f"Error: {np.linalg.norm(result_jacobi.x - x_exact):.2e}")

    # Solve with Gauss-Seidel
    print("\n" + "-" * 70)
    print("Gauss-Seidel Method:")
    result_gs = gaussseid(A, b, return_history=True)
    assert isinstance(result_gs, IterationResult)  # Type narrowing
    print(f"Solution: {result_gs.x}")
    print(f"Converged in {result_gs.iterations} iterations")
    print(f"Final residual: {result_gs.residual_norm:.2e}")
    print(f"Error: {np.linalg.norm(result_gs.x - x_exact):.2e}")

    # Summary
    print("\n" + "-" * 70)
    print("Summary:")
    print(
        f"Gauss-Seidel was {result_jacobi.iterations / result_gs.iterations:.2f}x faster"
    )
    print()


def example_convergence_analysis() -> None:
    """Analyze and visualize convergence behavior"""
    print("=" * 70)
    print("Example 2: Convergence Analysis")
    print("=" * 70)

    # Larger system
    A = np.array(
        [
            [10, -1, 2, 0],
            [-1, 11, -1, 3],
            [2, -1, 10, -1],
            [0, 3, -1, 8],
        ],
        dtype=float,
    )
    b = np.array([6, 25, -11, 15], dtype=float)

    print("\n4x4 System")
    print("Matrix A:")
    print(A)
    print("\nVector b:")
    print(b)

    # Solve with both methods and get history
    result_jacobi = jacobi(A, b, return_history=True)
    result_gs = gaussseid(A, b, return_history=True)
    assert isinstance(result_jacobi, IterationResult)  # Type narrowing
    assert isinstance(result_gs, IterationResult)  # Type narrowing

    print(f"\nJacobi iterations: {result_jacobi.iterations}")
    print(f"Gauss-Seidel iterations: {result_gs.iterations}")

    # Show convergence history
    print("\nConvergence History (first 5 iterations):")
    print("Iter |   Jacobi Residual   | Gauss-Seidel Residual")
    print("-" * 55)
    max_iter = min(5, min(result_jacobi.iterations, result_gs.iterations))
    for i in range(max_iter):
        jac_res = (
            result_jacobi.residual_history[i]
            if i < len(result_jacobi.residual_history)
            else 0
        )
        gs_res = (
            result_gs.residual_history[i] if i < len(result_gs.residual_history) else 0
        )
        print(f"{i+1:4d} | {jac_res:18.6e} | {gs_res:18.6e}")
    print()


def example_omega_analysis() -> None:
    """Demonstrate omega parameter optimization"""
    print("=" * 70)
    print("Example 3: Omega Parameter Analysis")
    print("=" * 70)

    # Define test matrix
    A = np.array([[4, -1, 0], [-1, 4, -1], [0, -1, 4]], dtype=float)

    print("\nMatrix A:")
    print(A)

    print("\nAnalyzing optimal omega parameter...")
    result = jomega(A, plot=False)  # Suppress plot for text output

    print(f"\nResults:")
    print(f"  Optimal omega: {result.omega_opt:.4f}")
    print(f"  Minimum spectral radius: {result.rho_opt:.4f}")
    if result.omega_conv:
        print(
            f"  Convergence interval: [{result.omega_conv[0]:.4f}, {result.omega_conv[1]:.4f}]"
        )

    # Compare with standard Jacobi (omega = 1)
    idx_omega_1 = np.argmin(np.abs(result.omega_values - 1.0))
    rho_omega_1 = result.rho_values[idx_omega_1]
    print(f"\nStandard Jacobi (ω=1): ρ = {rho_omega_1:.4f}")
    print(
        f"Improvement with optimal ω: {((rho_omega_1 - result.rho_opt) / rho_omega_1 * 100):.1f}%"
    )
    print()


def example_multiple_systems() -> None:
    """Compare omega analysis for different matrix structures"""
    print("=" * 70)
    print("Example 4: Comparing Multiple Systems")
    print("=" * 70)

    # Define different systems
    # System 1: Symmetric tridiagonal
    A1 = np.array([[4, -1, 0], [-1, 4, -1], [0, -1, 4]], dtype=float)

    # System 2: General diagonally dominant
    A2 = np.array(
        [
            [10, -1, 2, 0],
            [-1, 11, -1, 3],
            [2, -1, 10, -1],
            [0, 3, -1, 8],
        ],
        dtype=float,
    )

    # System 3: Asymmetric
    A3 = np.array(
        [[10, -3, 2, -1], [1, 8, -2, 1], [-2, 1, 9, -3], [1, -1, 2, 12]], dtype=float
    )

    systems = [
        (A1, "3x3 Tridiagonal"),
        (A2, "4x4 Diag Dominant"),
        (A3, "4x4 Asymmetric"),
    ]

    print("\nAnalyzing three different matrix structures...")
    print("(Suppressing plot for text output)\n")

    # Analyze without plotting (compare_omega_systems doesn't support plot parameter)
    results = []
    for A, label in systems:
        result = jomega(A, plot=False)
        results.append(result)

    # Print summary table
    print("Summary Table:")
    print("-" * 70)
    print("System              | Optimal ω | Optimal ρ | Convergence Interval")
    print("-" * 70)
    for (_, label), result in zip(systems, results):
        conv_str = (
            f"[{result.omega_conv[0]:.3f}, {result.omega_conv[1]:.3f}]"
            if result.omega_conv
            else "None"
        )
        print(
            f"{label:19s} | {result.omega_opt:9.4f} | {result.rho_opt:9.4f} | {conv_str}"
        )
    print("-" * 70)
    print()


def example_large_sparse_system() -> None:
    """Example with larger sparse-like system"""
    print("=" * 70)
    print("Example 5: Larger System (5x5 Tridiagonal)")
    print("=" * 70)

    # Create a tridiagonal system (common in finite difference methods)
    n = 5
    A = 4 * np.eye(n) - np.diag(np.ones(n - 1), 1) - np.diag(np.ones(n - 1), -1)
    b = np.ones(n)

    print(f"\nTridiagonal {n}x{n} system")
    print("Matrix A:")
    print(A)
    print("\nVector b:")
    print(b)

    # Exact solution
    x_exact = np.linalg.solve(A, b)

    # Solve with both methods
    result_jacobi = jacobi(A, b, return_history=True)
    result_gs = gaussseid(A, b, return_history=True)
    assert isinstance(result_jacobi, IterationResult)  # Type narrowing
    assert isinstance(result_gs, IterationResult)  # Type narrowing

    print(f"\nExact solution: {x_exact}")
    print(f"\nJacobi solution: {result_jacobi.x}")
    print(f"Iterations: {result_jacobi.iterations}")
    print(f"Error: {np.linalg.norm(result_jacobi.x - x_exact):.2e}")

    print(f"\nGauss-Seidel solution: {result_gs.x}")
    print(f"Iterations: {result_gs.iterations}")
    print(f"Error: {np.linalg.norm(result_gs.x - x_exact):.2e}")

    # Omega analysis
    print("\nOmega parameter analysis...")
    omega_result = jomega(A, omega_range=np.arange(0, 2, 0.005), plot=False)
    print(f"Optimal omega: {omega_result.omega_opt:.4f}")
    print()


if __name__ == "__main__":
    """Run all examples"""
    print("\n" + "=" * 70)
    print(" ITERATIVE METHODS FOR LINEAR SYSTEMS - EXAMPLES")
    print("=" * 70)
    print()

    # Run examples
    example_basic_comparison()
    input("Press Enter to continue to next example...")

    example_convergence_analysis()
    input("Press Enter to continue to next example...")

    example_omega_analysis()
    input("Press Enter to continue to next example...")

    example_multiple_systems()
    input("Press Enter to continue to next example...")

    example_large_sparse_system()

    print("\n" + "=" * 70)
    print(" ALL EXAMPLES COMPLETED")
    print("=" * 70)
    print()
