"""
QR Decomposition using Householder Reflections Algorithm

Implements QR decomposition using Householder transformations to zero out below-diagonal
elements. More numerically stable than Gram-Schmidt for ill-conditioned matrices.

"""

import numpy as np
from typing import Tuple


def hhalg(
    A: np.ndarray, cleanup_threshold: float = 1e-10
) -> Tuple[np.ndarray, np.ndarray]:
    """
    QR-decomposition using Householder reflections algorithm.

    Parameters
    ----------
    A : np.ndarray
        Square matrix (n x n)
    cleanup_threshold : float, optional
        Threshold for zeroing near-zero below-diagonal elements (default: 1e-10)

    Returns
    -------
    Q : np.ndarray
        Orthogonal matrix (n x n) where Q.T @ Q = I
    R : np.ndarray
        Upper triangular matrix (n x n)

    Raises
    ------
    ValueError
        If A is not square

    Notes
    -----
    - Uses Householder reflections to zero below-diagonal elements column by column
    - More numerically stable than Gram-Schmidt
    - Sign convention: sigma = -sign(x[0]) * norm(x) for numerical stability
    - Accumulates Q as product of Householder matrices: Q = H1 @ H2 @ ... @ H(n-1)
    - For each column k, creates reflection that maps x = R[k:n, k] to e1 = [||x||, 0, ..., 0]

    Algorithm
    ---------
    For each column k = 0, 1, ..., n-2:
        1. Extract subvector x = R[k:n, k]
        2. Compute target: e1 with ||e1|| = ||x||, pointing along first basis vector
        3. Use sign convention to avoid cancellation: sigma = -sign(x[0]) * ||x||
        4. Householder vector: v = x - sigma*e1
        5. Reflection: H_k = I - 2*v*v'/(v'*v)
        6. Apply: R = H_k @ R (zeros out R[k+1:n, k])
        7. Accumulate: Q = Q @ H_k

    Examples
    --------
    >>> A = np.array([[12, -51, 4], [6, 167, -68], [-4, 24, -41]], dtype=float)
    >>> Q, R = hhalg(A)
    >>> np.allclose(A, Q @ R)
    True
    >>> np.allclose(Q.T @ Q, np.eye(3))
    True
    """
    # Input validation
    if A.shape[0] != A.shape[1]:
        raise ValueError(f"Matrix A must be square, got shape {A.shape}")

    n = A.shape[0]

    # Initialize
    R = A.astype(float).copy()
    Q = np.eye(n)

    # Householder reflections for each column
    for k in range(n - 1):
        # Extract subvector from column k, starting at row k
        x = R[k:, k].copy()
        x_norm = np.linalg.norm(x)

        if x_norm < np.finfo(float).eps:
            # Column is already zero below diagonal
            continue

        # Sign convention for numerical stability: avoid cancellation
        # sigma = -sign(x[0]) * ||x||
        if x[0] >= 0:
            sigma = -x_norm
        else:
            sigma = x_norm

        # First basis vector scaled by sigma
        e1 = np.zeros_like(x)
        e1[0] = sigma

        # Householder vector: v = x - sigma*e1
        v = x - e1
        v_norm_sq = v @ v

        if v_norm_sq < np.finfo(float).eps:
            # No reflection needed
            continue

        # Create Householder matrix for this subspace
        # H = I - 2*v*v'/(v'*v)
        H_sub = np.eye(len(x)) - 2 * np.outer(v, v) / v_norm_sq

        # Build full-size Householder matrix
        H = np.eye(n)
        H[k:, k:] = H_sub

        # Apply Householder transformation
        R = H @ R
        Q = Q @ H

    # Clean up numerical errors below diagonal
    for i in range(n):
        for j in range(i):
            if abs(R[i, j]) < cleanup_threshold:
                R[i, j] = 0.0

    return Q, R


if __name__ == "__main__":
    print("Test: Householder QR Decomposition Algorithm")
    print("=" * 60)

    # Test 1: Standard 3x3 matrix
    print("\nTest 1: Standard 3x3 matrix")
    A1 = np.array([[12, -51, 4], [6, 167, -68], [-4, 24, -41]], dtype=float)
    print("Matrix A:")
    print(A1)

    Q1, R1 = hhalg(A1)
    print("\nOrthogonal matrix Q:")
    print(Q1)
    print("\nUpper triangular matrix R:")
    print(R1)

    # Verify QR decomposition
    reconstruction_error = np.linalg.norm(A1 - Q1 @ R1, "fro")
    print(f"\nReconstruction error ||A - QR||_F: {reconstruction_error:.2e}")

    orthogonality_error = np.linalg.norm(Q1.T @ Q1 - np.eye(3), "fro")
    print(f"Orthogonality error ||Q'Q - I||_F: {orthogonality_error:.2e}")

    # Check if R is upper triangular
    print(f"R is upper triangular: {np.allclose(R1, np.triu(R1))}")

    # Test 2: Identity matrix (edge case)
    print("\n" + "=" * 60)
    print("Test 2: Identity matrix (edge case)")
    I = np.eye(4)
    Q2, R2 = hhalg(I)
    print("Q (should be I):")
    print(Q2)
    print("\nR (should be I):")
    print(R2)
    print(f"Q is identity: {np.allclose(Q2, np.eye(4))}")
    print(f"R is identity: {np.allclose(R2, np.eye(4))}")

    # Test 3: Random matrix
    print("\n" + "=" * 60)
    print("Test 3: Random 5x5 matrix")
    np.random.seed(42)
    A3 = np.random.randn(5, 5)
    Q3, R3 = hhalg(A3)

    reconstruction_error3 = np.linalg.norm(A3 - Q3 @ R3, "fro")
    orthogonality_error3 = np.linalg.norm(Q3.T @ Q3 - np.eye(5), "fro")

    print(f"Reconstruction error ||A - QR||_F: {reconstruction_error3:.2e}")
    print(f"Orthogonality error ||Q'Q - I||_F: {orthogonality_error3:.2e}")
    print(f"R is upper triangular: {np.allclose(R3, np.triu(R3))}")

    # Test 4: Comparison with NumPy's QR
    print("\n" + "=" * 60)
    print("Test 4: Comparison with NumPy's QR decomposition")
    A4 = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 10]], dtype=float)
    print("Matrix A:")
    print(A4)

    Q_ours, R_ours = hhalg(A4)
    Q_numpy, R_numpy = np.linalg.qr(A4)

    print("\nOur Q:")
    print(Q_ours)
    print("\nNumPy Q:")
    print(Q_numpy)

    print("\nOur R:")
    print(R_ours)
    print("\nNumPy R:")
    print(R_numpy)

    # Note: Q and R are not unique (can differ by signs of columns/rows)
    # Check reconstruction instead
    print("\nReconstruction comparison:")
    print(f"Our reconstruction error: {np.linalg.norm(A4 - Q_ours @ R_ours):.2e}")
    print(f"NumPy reconstruction error: {np.linalg.norm(A4 - Q_numpy @ R_numpy):.2e}")

    # Test 5: Large matrix
    print("\n" + "=" * 60)
    print("Test 5: Larger 10x10 random matrix")
    np.random.seed(123)
    A5 = np.random.randn(10, 10)
    Q5, R5 = hhalg(A5)

    reconstruction_error5 = np.linalg.norm(A5 - Q5 @ R5, "fro")
    orthogonality_error5 = np.linalg.norm(Q5.T @ Q5 - np.eye(10), "fro")

    print(f"Reconstruction error ||A - QR||_F: {reconstruction_error5:.2e}")
    print(f"Orthogonality error ||Q'Q - I||_F: {orthogonality_error5:.2e}")
    print(f"R is upper triangular: {np.allclose(R5, np.triu(R5))}")
    print(
        f"All tests passed: {reconstruction_error5 < 1e-10 and orthogonality_error5 < 1e-10}"
    )
