"""
Examples for Gaussian Elimination Functions
Comprehensive examples demonstrating gaussel1, gaussel2, and gaussel3 functionality.
"""

import numpy as np
from typing import Optional
from ex2_gaussel1 import gaussel1
from ex2_gaussel2 import gaussel2
from ex2_gaussel3 import gaussel3


def main() -> None:
    """Main function with interactive menu."""
    print("=" * 50)
    print("GAUSSIAN ELIMINATION EXAMPLES")
    print("=" * 50)
    print()
    print("Select which examples to run:")
    print("1. gaussel1 examples (Basic Gaussian Elimination)")
    print("2. gaussel2 examples (Gaussian Elimination with Pivoting)")
    print("3. gaussel3 examples (Matrix Inverse and LU Decomposition)")
    print("4. Run all examples")
    print("0. Exit")

    while True:
        try:
            choice_str = input("\nEnter your choice (0-4): ")
            choice = int(choice_str)
            break
        except ValueError:
            print("Invalid input. Please enter a number between 0-4.")

    if choice == 1:
        examples_gaussel1()
    elif choice == 2:
        examples_gaussel2()
    elif choice == 3:
        examples_gaussel3()
    elif choice == 4:
        examples_gaussel1()
        input("\nPress Enter to continue to gaussel2 examples...")
        examples_gaussel2()
        input("\nPress Enter to continue to gaussel3 examples...")
        examples_gaussel3()
    elif choice == 0:
        print("Exiting...")
        return
    else:
        print("Invalid choice. Please run the function again.")


def examples_gaussel1() -> None:
    """Examples for gaussel1 (Basic Gaussian Elimination)."""
    print("\n" + "=" * 50)
    print("GAUSSEL1 EXAMPLES")
    print("Basic Gaussian Elimination")
    print("=" * 50)
    print()

    print("Example 1: Solving a simple 3x3 system")
    print("-" * 40)
    print("System of equations:")
    print("  2x + y - z = 8")
    print(" -3x - y + 2z = -11")
    print(" -2x + y + 2z = -3")
    print()

    A1 = np.array([[2, 1, -1], [-3, -1, 2], [-2, 1, 2]], dtype=float)
    b1 = np.array([8, -11, -3], dtype=float)

    print("Matrix A:")
    print(A1)
    print("Vector b:")
    print(b1)

    x1 = gaussel1(A1, b1)
    print("Solution x:")
    print(x1)

    print("Verification (Ax = b):")
    verification = A1 @ x1
    print(verification)
    print("Original b = [8, -11, -3]")
    print(f"Error: {np.linalg.norm(verification - b1):.2e}")

    input("\nPress Enter to continue...")

    print("\nExample 2: System with multiple right-hand sides")
    print("-" * 48)
    print("Solving Ax = b1 and Ax = b2 simultaneously")
    print()

    A2 = np.array([[4, -2, 1], [2, 1, -3], [-1, 3, 2]], dtype=float)
    b2 = np.array([[5, 2], [1, -1], [8, 4]], dtype=float)

    print("Matrix A:")
    print(A2)
    print("Multiple RHS matrix B (each column is a different b vector):")
    print(b2)

    x2 = gaussel1(A2, b2)
    print("Solutions X (each column corresponds to each b):")
    print(x2)

    print("Verification AX = B:")
    verification = A2 @ x2
    print(verification)
    print("Should equal B")
    print(f"Error: {np.linalg.norm(verification - b2):.2e}")

    input("\nPress Enter to continue...")

    print("\nExample 3: Displaying intermediate matrices")
    print("-" * 44)
    print("Solving system with display_matrices = True")
    print()

    A3 = np.array([[1, 2, -1], [3, 1, 2], [2, -1, 1]], dtype=float)
    b3 = np.array([2, 12, 5], dtype=float)

    print("Matrix A:")
    print(A3)
    print("Vector b:")
    print(b3)

    print("\nSolving with intermediate steps shown:")
    print("-" * 39)
    x3 = gaussel1(A3, b3, display_matrices=True)

    print("\nFinal solution:")
    print(x3)

    print("Verification Ax = b:")
    verification = A3 @ x3
    print(verification)
    print(f"Error: {np.linalg.norm(verification - b3):.2e}")

    input("\nPress Enter to continue...")

    print("\nExample 4: System requiring row swapping")
    print("-" * 41)
    print("System where first pivot is zero")
    print()

    A4 = np.array([[0, 2, 1], [1, -1, 3], [2, 1, -1]], dtype=float)
    b4 = np.array([1, 8, 1], dtype=float)

    print("Matrix A (note zero in position (1,1)):")
    print(A4)
    print("Vector b:")
    print(b4)

    x4 = gaussel1(A4, b4)
    print("Solution x:")
    print(x4)

    print("Verification Ax = b:")
    verification = A4 @ x4
    print(verification)
    print("Original b = [1, 8, 1]")
    print(f"Error: {np.linalg.norm(verification - b4):.2e}")

    input("\nPress Enter to continue...")


def examples_gaussel2() -> None:
    """Examples for gaussel2 (Gaussian Elimination with Pivoting)."""
    print("\n" + "=" * 50)
    print("GAUSSEL2 EXAMPLES")
    print("Gaussian Elimination with Pivoting")
    print("=" * 50)
    print()

    print("Example 1: Partial vs Full Pivoting")
    print("-" * 36)
    print("Matrix requiring pivoting:")
    print()

    A1 = np.array([[0, 2, 3], [4, 5, 6], [7, 8, 0]], dtype=float)
    b1 = np.array([13, 32, 23], dtype=float)

    print("Matrix A:")
    print(A1)
    print("Vector b:")
    print(b1)

    print("\n--- Testing with partial pivoting ---")
    x1_partial = gaussel2(A1, b1, use_partial_pivoting=True, display_matrices=True)
    print("Solution with partial pivoting:")
    print(x1_partial)

    verification1 = A1 @ x1_partial
    print("Verification Ax = b:")
    print(verification1)
    print(f"Error: {np.linalg.norm(verification1 - b1):.2e}")

    input("\nPress Enter to continue...")

    print("\n--- Testing with full pivoting ---")
    x1_full = gaussel2(A1, b1, use_partial_pivoting=False, display_matrices=True)
    print("Solution with full pivoting:")
    print(x1_full)

    verification2 = A1 @ x1_full
    print("Verification Ax = b:")
    print(verification2)
    print(f"Error: {np.linalg.norm(verification2 - b1):.2e}")

    input("\nPress Enter to continue...")

    print("\nExample 2: Ill-conditioned system")
    print("-" * 34)
    print("System that challenges numerical stability:")
    print()

    A2 = np.array([[1e-14, 1, 0], [1, 1, 1], [0, 1, 2]], dtype=float)
    b2 = np.array([1, 3, 3], dtype=float)

    print("Matrix A (note very small element A[0,0]):")
    print(A2)
    print("Vector b:")
    print(b2)

    print("\n--- With partial pivoting ---")
    x2_partial = gaussel2(A2, b2, use_partial_pivoting=True)
    print("Solution:")
    print(x2_partial)

    verification = A2 @ x2_partial
    print("Verification Ax = b:")
    print(verification)
    print(f"Error: {np.linalg.norm(verification - b2):.2e}")

    input("\nPress Enter to continue...")


def examples_gaussel3() -> None:
    """Examples for gaussel3 (Matrix Inverse and LU Decomposition)."""
    print("\n" + "=" * 50)
    print("GAUSSEL3 EXAMPLES")
    print("Matrix Inverse and LU Decomposition")
    print("=" * 50)
    print()

    print("Example 1: Computing inverse of a well-conditioned matrix")
    print("-" * 56)

    A1 = np.array([[2, 1, -1], [-3, -1, 2], [-2, 1, 2]], dtype=float)

    print("Matrix A:")
    print(A1)

    A_inv, det_A, L, U = gaussel3(A1, verbose=False)

    if A_inv is not None:
        print(f"\nDeterminant: {det_A:.6f}")
        print("\nInverse A^(-1):")
        print(A_inv)

        print("\nL matrix (Lower triangular):")
        print(L)

        print("\nU matrix (Upper triangular):")
        print(U)

        # Verifications
        print("\nVerifications:")
        print("-------------")

        identity_check = A1 @ A_inv
        print(f"A * A^(-1) should be identity:")
        print(identity_check)
        print(f"Error from identity: {np.linalg.norm(identity_check - np.eye(3)):.2e}")

        if L is not None and U is not None:
            lu_check = L @ U
            print(f"\nL * U should equal A:")
            print(lu_check)
            print(f"Error from A: {np.linalg.norm(lu_check - A1):.2e}")

    input("\nPress Enter to continue...")

    print("\nExample 2: Singular matrix (no inverse)")
    print("-" * 39)

    A2 = np.array(
        [[1, 2, 3], [4, 5, 6], [7, 8, 9]], dtype=float  # This matrix is singular
    )

    print("Matrix A (singular):")
    print(A2)

    A_inv, det_A, L, U = gaussel3(A2, verbose=False)

    print(f"\nDeterminant: {det_A:.6f}")
    print(f"Inverse exists: {A_inv is not None}")

    if A_inv is None:
        print("As expected, this matrix has no inverse.")

    input("\nPress Enter to continue...")

    print("\nExample 3: Identity matrix")
    print("-" * 26)

    A3 = np.eye(3)
    print("Matrix A (3x3 Identity):")
    print(A3)

    A_inv, det_A, L, U = gaussel3(A3, verbose=False)

    if A_inv is not None:
        print(f"\nDeterminant: {det_A:.6f}")
        print("\nInverse (should be identity):")
        print(A_inv)

        print("\nL matrix:")
        print(L)

        print("\nU matrix:")
        print(U)

    input("\nPress Enter to continue...")


if __name__ == "__main__":
    main()
