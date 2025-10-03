"""
GAUSSEL1 - Basic Gaussian Elimination
Solves linear equation system Ax = b using Gaussian elimination without pivoting.
"""

import numpy as np
from typing import Union, Optional, Tuple
import warnings


def gaussel1(
    A: np.ndarray, b: np.ndarray, display_matrices: bool = False
) -> np.ndarray:
    """
    Solves linear equation system Ax = b using Gaussian elimination.

    Parameters:
    -----------
    A : np.ndarray
        Coefficient matrix (n x n or n x m)
    b : np.ndarray
        Right-hand side vector(s) (n x 1 or n x k for multiple RHS)
    display_matrices : bool, optional
        Whether to display intermediate matrices (default: False)

    Returns:
    --------
    np.ndarray
        Solution vector(s) x

    Raises:
    -------
    ValueError
        If matrix dimensions are incompatible or system cannot be solved
    """

    # Ensure inputs are numpy arrays
    A = np.array(A, dtype=float)
    b = np.array(b, dtype=float)

    # Handle vector b - ensure it's 2D
    if b.ndim == 1:
        b = b.reshape(-1, 1)

    n, m = A.shape
    nb, kb = b.shape

    # Input validation
    if n != nb:
        raise ValueError("Matrix A and vector b dimensions are incompatible")

    if m > n:
        raise ValueError("Matrix A has more columns than rows - underdetermined system")

    # Create augmented matrix
    augmented = np.hstack([A, b])
    eps = np.finfo(float).eps

    if display_matrices:
        print("Initial matrix A(0):")
        print(A)
        print()

    # Forward elimination
    for i in range(min(n, m)):
        # Simple row swapping if diagonal element is too small
        if abs(augmented[i, i]) < eps:
            for k in range(i + 1, n):
                if abs(augmented[k, i]) > eps:
                    # Swap rows
                    augmented[[i, k]] = augmented[[k, i]]
                    break

            if abs(augmented[i, i]) < eps:
                raise ValueError("Gaussian elimination cannot proceed without pivoting")

        # Eliminate below diagonal
        for j in range(i + 1, n):
            if abs(augmented[j, i]) > eps:
                factor = augmented[j, i] / augmented[i, i]
                augmented[j, :] = augmented[j, :] - factor * augmented[i, :]

        if display_matrices:
            print(f"Matrix A({i + 1}):")
            print(augmented[:, :m])
            print()

    # Check for underdetermined system
    if m < n:
        warnings.warn("System is underdetermined. Providing base solution.")

    # Check for singularity
    for i in range(n - 1, -1, -1):
        if i < m and abs(augmented[i, i]) < eps:
            raise ValueError("Matrix is singular")

    # Back substitution
    x = np.zeros((m, kb))

    for col in range(kb):
        rhs = augmented[:, m + col]

        for i in range(min(n, m) - 1, -1, -1):
            if i >= m or abs(augmented[i, i]) < eps:
                continue

            x[i, col] = rhs[i]
            for j in range(i + 1, min(m, n)):
                x[i, col] -= augmented[i, j] * x[j, col]
            x[i, col] /= augmented[i, i]

    # Return 1D array if input b was 1D
    if kb == 1:
        return x.flatten()

    return x


if __name__ == "__main__":
    # Simple test
    print("Testing gaussel1 with a simple 3x3 system:")
    print("System: 2x + y - z = 8")
    print("       -3x - y + 2z = -11")
    print("       -2x + y + 2z = -3")

    A = np.array([[2, 1, -1], [-3, -1, 2], [-2, 1, 2]], dtype=float)

    b = np.array([8, -11, -3], dtype=float)

    try:
        x = gaussel1(A, b, display_matrices=True)
        print("Solution:")
        print(f"x = {x}")

        # Verify solution
        residual = A @ x - b
        print(f"Residual (should be ~0): {np.linalg.norm(residual)}")

    except Exception as e:
        print(f"Error: {e}")
