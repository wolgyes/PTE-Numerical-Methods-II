"""
QR Decomposition using Modified Gram-Schmidt Orthogonalization

Implements QR decomposition where A = QR with Q orthogonal and R upper triangular.
Uses Modified Gram-Schmidt for better numerical stability.

"""

import numpy as np
from typing import Tuple


def gramschmidt(A: np.ndarray, verify: bool = False) -> Tuple[np.ndarray, np.ndarray]:
    """
    QR-decomposition using Modified Gram-Schmidt orthogonalization.

    Parameters
    ----------
    A : np.ndarray
        Square matrix (n x n) with linearly independent columns
    verify : bool, optional
        If True, verifies reconstruction and orthogonality (default: False)

    Returns
    -------
    Q : np.ndarray
        Orthogonal matrix (n x n) where Q.T @ Q = I
    R : np.ndarray
        Upper triangular matrix (n x n)

    Raises
    ------
    ValueError
        If A is not square or columns are linearly dependent

    Notes
    -----
    - Uses Modified Gram-Schmidt for better numerical stability than classical GS
    - Modified GS performs in-place orthogonalization at each step
    - Satisfies A = Q @ R
    - Linear independence is checked via matrix rank

    Examples
    --------
    >>> A = np.array([[12, -51, 4], [6, 167, -68], [-4, 24, -41]], dtype=float)
    >>> Q, R = gramschmidt(A)
    >>> np.allclose(A, Q @ R)
    True
    >>> np.allclose(Q.T @ Q, np.eye(3))
    True
    """
    # Input validation
    if A.shape[0] != A.shape[1]:
        raise ValueError(f"Matrix A must be square, got shape {A.shape}")

    n = A.shape[0]

    # Check for linear independence using rank
    if np.linalg.matrix_rank(A) < n:
        raise ValueError(
            f"Matrix columns are linearly dependent (rank {np.linalg.matrix_rank(A)} < {n})"
        )

    # Initialize Q and R
    Q = A.astype(float).copy()  # Will be orthogonalized in-place
    R = np.zeros((n, n))

    # Modified Gram-Schmidt orthogonalization
    for j in range(n):
        # Compute R[j, j] as the norm of current column
        R[j, j] = np.linalg.norm(Q[:, j])

        if R[j, j] < np.finfo(float).eps:
            raise ValueError(
                f"Column {j} becomes zero during orthogonalization (linear dependence)"
            )

        # Normalize the column
        Q[:, j] = Q[:, j] / R[j, j]

        # Orthogonalize remaining columns against this one
        for k in range(j + 1, n):
            R[j, k] = Q[:, j] @ Q[:, k]  # Project Q[:, k] onto Q[:, j]
            Q[:, k] = Q[:, k] - R[j, k] * Q[:, j]  # Remove component

    # Optional verification
    if verify:
        # Check reconstruction: A = Q @ R
        reconstruction_error = np.linalg.norm(A - Q @ R, "fro")
        print(f"Reconstruction error ||A - QR||_F: {reconstruction_error:.2e}")

        # Check orthogonality: Q.T @ Q = I
        orthogonality_error = np.linalg.norm(Q.T @ Q - np.eye(n), "fro")
        print(f"Orthogonality error ||Q'Q - I||_F: {orthogonality_error:.2e}")

        # Check if R is upper triangular
        triu_check = np.allclose(R, np.triu(R))
        print(f"R is upper triangular: {triu_check}")

    return Q, R


if __name__ == "__main__":
    print("Test: Gram-Schmidt QR Decomposition")
    print("=" * 60)

    # Test 1: Standard 3x3 matrix
    print("\nTest 1: Standard 3x3 matrix")
    A = np.array([[12, -51, 4], [6, 167, -68], [-4, 24, -41]], dtype=float)
    print("Matrix A:")
    print(A)

    Q, R = gramschmidt(A, verify=True)
    print("\nOrthogonal matrix Q:")
    print(Q)
    print("\nUpper triangular matrix R:")
    print(R)

    # Test 2: Identity matrix (edge case)
    print("\n" + "=" * 60)
    print("Test 2: Identity matrix (edge case)")
    I = np.eye(3)
    Q2, R2 = gramschmidt(I)
    print("Q (should be I):")
    print(Q2)
    print("\nR (should be I):")
    print(R2)

    # Test 3: Random matrix
    print("\n" + "=" * 60)
    print("Test 3: Random 4x4 matrix")
    np.random.seed(42)
    A3 = np.random.randn(4, 4)
    Q3, R3 = gramschmidt(A3, verify=True)
    print(f"\nVerification: ||A - QR|| = {np.linalg.norm(A3 - Q3 @ R3):.2e}")

    # Comparison with NumPy's QR
    print("\n" + "=" * 60)
    print("Comparison with NumPy's QR decomposition:")
    Q_np, R_np = np.linalg.qr(A3)
    print(
        f"Difference in Q (up to sign): {np.linalg.norm(np.abs(Q3) - np.abs(Q_np)):.2e}"
    )
    print(
        f"Difference in R (up to sign): {np.linalg.norm(np.abs(R3) - np.abs(R_np)):.2e}"
    )
