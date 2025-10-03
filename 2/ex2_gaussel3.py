"""
GAUSSEL3 - Matrix Inverse and LU Decomposition
Computes matrix inverse using Gaussian elimination with LU decomposition.
"""

import numpy as np
from typing import Tuple, Optional
import warnings
from ex2_gaussel2 import gaussel2


def gaussel3(
    A: np.ndarray, verbose: bool = True
) -> Tuple[Optional[np.ndarray], float, Optional[np.ndarray], Optional[np.ndarray]]:
    """
    Computes matrix inverse using Gaussian elimination with LU decomposition.

    Parameters:
    -----------
    A : np.ndarray
        Square matrix to invert
    verbose : bool, optional
        Whether to display results (default: True)

    Returns:
    --------
    Tuple[Optional[np.ndarray], float, Optional[np.ndarray], Optional[np.ndarray]]
        A_inv : Inverse of matrix A (None if singular)
        det_A : Determinant of matrix A
        L : Lower triangular matrix from LU decomposition (None if singular)
        U : Upper triangular matrix from LU decomposition (None if singular)

    Raises:
    -------
    ValueError
        If input is not a square matrix or is empty
    """

    # Ensure input is numpy array
    A = np.array(A, dtype=float)

    n, m = A.shape

    # Input validation
    if n != m:
        raise ValueError("Input must be a square matrix")

    if n == 0:
        raise ValueError("Input matrix cannot be empty")

    original_A = A.copy()
    eps = np.finfo(float).eps

    try:
        # Compute inverse using gaussel2 with identity matrix as RHS
        I = np.eye(n)
        A_inv = gaussel2(original_A, I, use_partial_pivoting=False)

        if A_inv is None or A_inv.size == 0:
            warnings.warn("Matrix is singular - inverse does not exist")
            return None, 0.0, None, None

        # Perform LU decomposition
        L = np.eye(n)
        U = A.copy()
        det_A = 1.0

        # Forward elimination for LU decomposition
        for i in range(n - 1):
            # Simple pivoting if diagonal element is too small
            if abs(U[i, i]) < eps:
                for k in range(i + 1, n):
                    if abs(U[k, i]) > eps:
                        # Swap rows in U and corresponding rows in L
                        U[[i, k]] = U[[k, i]]
                        if i > 0:
                            L[[i, k], :i] = L[[k, i], :i]
                        det_A = -det_A
                        break

                if abs(U[i, i]) < eps:
                    warnings.warn("Matrix is singular - inverse does not exist")
                    return None, 0.0, None, None

            # Update determinant
            det_A *= U[i, i]

            # Eliminate below diagonal and record multipliers in L
            for j in range(i + 1, n):
                if abs(U[j, i]) > eps:
                    factor = U[j, i] / U[i, i]
                    L[j, i] = factor
                    U[j, :] = U[j, :] - factor * U[i, :]

        # Final diagonal element for determinant
        det_A *= U[n - 1, n - 1]

        # Check if matrix is singular
        if abs(det_A) < eps:
            warnings.warn("Matrix is singular - inverse does not exist")
            return None, 0.0, None, None

    except Exception:
        warnings.warn("Matrix is singular - inverse does not exist")
        return None, 0.0, None, None

    # Display results if verbose
    if verbose:
        print("Matrix A:")
        print(original_A)
        print(f"\nDeterminant of A: {det_A:.6f}")
        print("\nL matrix (lower triangular):")
        print(L)
        print("\nU matrix (upper triangular):")
        print(U)
        print("\nVerification L*U:")
        print(L @ U)
        print("\nInverse of A:")
        print(A_inv)
        print("\nVerification A * A_inv:")
        verification = original_A @ A_inv
        print(verification)
        print(
            f"\nVerification error (should be ~0): {np.linalg.norm(verification - np.eye(n))}"
        )

    return A_inv, det_A, L, U


if __name__ == "__main__":
    # Test with a well-conditioned matrix
    print("Testing gaussel3 with a 3x3 matrix:")

    A = np.array([[2, 1, -1], [-3, -1, 2], [-2, 1, 2]], dtype=float)

    try:
        A_inv, det_A, L, U = gaussel3(A, verbose=True)

        if A_inv is not None:
            print(f"\nSummary:")
            print(f"Determinant: {det_A}")
            print(f"Matrix is invertible: {A_inv is not None}")

            # Additional verification
            identity_check = A @ A_inv
            error = np.linalg.norm(identity_check - np.eye(A.shape[0]))
            print(f"Inversion accuracy: {error:.2e}")

            # LU decomposition verification
            if L is not None and U is not None:
                lu_check = L @ U
                lu_error = np.linalg.norm(lu_check - A)
                print(f"LU decomposition accuracy: {lu_error:.2e}")

    except Exception as e:
        print(f"Error: {e}")

    # Test with a singular matrix
    print("\n" + "=" * 50)
    print("Testing with a singular matrix:")

    A_singular = np.array(
        [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9],  # This row is 2*row2 - row1, making matrix singular
        ],
        dtype=float,
    )

    try:
        A_inv, det_A, L, U = gaussel3(A_singular, verbose=False)
        print(f"Determinant of singular matrix: {det_A}")
        print(f"Inverse exists: {A_inv is not None}")

    except Exception as e:
        print(f"Error with singular matrix: {e}")
