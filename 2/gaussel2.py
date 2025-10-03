"""
GAUSSEL2 - Gaussian Elimination with Pivoting
Solves linear equation system Ax = b using Gaussian elimination with partial or full pivoting.
"""

import numpy as np
from typing import Union, Optional, Tuple
import warnings


def gaussel2(
    A: np.ndarray,
    b: np.ndarray,
    use_partial_pivoting: bool = True,
    display_matrices: bool = False,
) -> np.ndarray:
    """
    Solves linear equation system Ax = b using Gaussian elimination with pivoting.

    Parameters:
    -----------
    A : np.ndarray
        Coefficient matrix (n x n or n x m)
    b : np.ndarray
        Right-hand side vector(s) (n x 1 or n x k for multiple RHS)
    use_partial_pivoting : bool, optional
        True for partial pivoting, False for full pivoting (default: True)
        Will automatically switch to full pivoting if partial pivoting fails
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

    # Initialize permutation vectors
    row_permutation = np.arange(n)
    col_permutation = np.arange(m)
    pivoting_switched = False

    if display_matrices:
        print("Initial matrix A(0):")
        print(A)
        print()

    # Forward elimination with pivoting
    for i in range(min(n, m)):
        max_val = 0.0
        max_row = i
        max_col = i

        # Partial pivoting (search only in current column)
        if use_partial_pivoting and not pivoting_switched:
            for k in range(i, n):
                if abs(augmented[k, i]) > max_val:
                    max_val = abs(augmented[k, i])
                    max_row = k

            # If partial pivoting fails, switch to full pivoting
            if max_val < eps:
                if i < m:
                    print("Warning: Partial pivoting stuck, switching to full pivoting")
                    use_partial_pivoting = False
                    pivoting_switched = True

        # Full pivoting (search in remaining submatrix)
        if not use_partial_pivoting or pivoting_switched:
            for k in range(i, n):
                for j in range(i, m):
                    if abs(augmented[k, j]) > max_val:
                        max_val = abs(augmented[k, j])
                        max_row = k
                        max_col = j

        # Check for singularity
        if max_val < eps:
            if i == n - 1:
                warnings.warn("System is underdetermined. Providing base solution.")
                break
            else:
                raise ValueError("Matrix is singular - cannot proceed")

        # Perform row swap if needed
        if max_row != i:
            augmented[[i, max_row]] = augmented[[max_row, i]]
            row_permutation[[i, max_row]] = row_permutation[[max_row, i]]
            if display_matrices:
                print(f"Row swap: {i + 1} <-> {max_row + 1}")

        # Perform column swap if needed (only for full pivoting)
        if max_col != i and (not use_partial_pivoting or pivoting_switched):
            augmented[:, [i, max_col]] = augmented[:, [max_col, i]]
            col_permutation[[i, max_col]] = col_permutation[[max_col, i]]
            if display_matrices:
                print(f"Column swap: {i + 1} <-> {max_col + 1}")

        # Eliminate below diagonal
        for j in range(i + 1, n):
            if abs(augmented[j, i]) > eps:
                factor = augmented[j, i] / augmented[i, i]
                augmented[j, :] = augmented[j, :] - factor * augmented[i, :]

        if display_matrices:
            print(f"Matrix A({i + 1}) after pivoting and elimination:")
            print(augmented[:, :m])
            print()

    # Inform about pivoting switch
    if pivoting_switched:
        print("Note: Full pivoting was used instead of partial pivoting")

    # Check for underdetermined system
    if m < n:
        warnings.warn("System is underdetermined. Providing base solution.")

    # Back substitution
    x_temp = np.zeros((m, kb))

    for col in range(kb):
        rhs = augmented[:, m + col]

        for i in range(min(n, m) - 1, -1, -1):
            if abs(augmented[i, i]) < eps:
                continue

            x_temp[i, col] = rhs[i]
            for j in range(i + 1, m):
                x_temp[i, col] -= augmented[i, j] * x_temp[j, col]
            x_temp[i, col] /= augmented[i, i]

    # Undo column permutations
    x = np.zeros((m, kb))
    for i in range(m):
        x[col_permutation[i], :] = x_temp[i, :]

    # Return 1D array if input b was 1D
    if kb == 1:
        return x.flatten()

    return x


if __name__ == "__main__":
    # Test with a problematic matrix that requires pivoting
    print("Testing gaussel2 with a matrix requiring pivoting:")
    print("System: 0x + 2y + 3z = 13")
    print("        4x + 5y + 6z = 32")
    print("        7x + 8y + 0z = 23")

    A = np.array([[0, 2, 3], [4, 5, 6], [7, 8, 0]], dtype=float)

    b = np.array([13, 32, 23], dtype=float)

    print("\n--- Testing with partial pivoting ---")
    try:
        x1 = gaussel2(A, b, use_partial_pivoting=True, display_matrices=True)
        print("Solution with partial pivoting:")
        print(f"x = {x1}")

        # Verify solution
        residual1 = A @ x1 - b
        print(f"Residual: {np.linalg.norm(residual1)}")

    except Exception as e:
        print(f"Error with partial pivoting: {e}")

    print("\n--- Testing with full pivoting ---")
    try:
        x2 = gaussel2(A, b, use_partial_pivoting=False, display_matrices=True)
        print("Solution with full pivoting:")
        print(f"x = {x2}")

        # Verify solution
        residual2 = A @ x2 - b
        print(f"Residual: {np.linalg.norm(residual2)}")

    except Exception as e:
        print(f"Error with full pivoting: {e}")
