"""
Householder Transformation Matrix

Computes the Householder reflection matrix that transforms one point to another.
The Householder matrix H reflects points across a hyperplane.

"""

import numpy as np
from typing import Optional


def householder(
    P: np.ndarray, P_prime: np.ndarray, tol: Optional[float] = None
) -> np.ndarray:
    """
    Compute Householder reflection matrix transforming P to P_prime.

    Parameters
    ----------
    P : np.ndarray
        Original point (column vector in R^n), shape (n,) or (n, 1)
    P_prime : np.ndarray
        Target point (column vector in R^n), shape (n,) or (n, 1)
    tol : float, optional
        Tolerance for detecting identical points (default: machine epsilon scaled)

    Returns
    -------
    H : np.ndarray
        Householder transformation matrix (n x n)
        H = I - 2*v*v'/(v'*v) where v = P - P_prime

    Raises
    ------
    ValueError
        If P and P_prime have different dimensions

    Notes
    -----
    - H is symmetric: H.T = H
    - H is orthogonal: H.T @ H = I
    - H @ P = P_prime and H @ P_prime = P (reflection property)
    - If P ≈ P_prime (within tolerance), returns identity matrix

    Examples
    --------
    >>> P = np.array([3, 4])
    >>> P_prime = np.array([5, 0])
    >>> H = householder(P, P_prime)
    >>> np.allclose(H @ P, P_prime)
    True
    >>> np.allclose(H @ P_prime, P)
    True
    """
    # Flatten inputs to handle both (n,) and (n, 1) shapes
    P = np.asarray(P).flatten()
    P_prime = np.asarray(P_prime).flatten()

    # Dimension check
    if len(P) != len(P_prime):
        raise ValueError(
            f"Dimension mismatch: P has length {len(P)}, P_prime has length {len(P_prime)}"
        )

    n = len(P)

    # Compute reflection vector v = P - P_prime
    v = P - P_prime

    # Set tolerance for detecting identical points
    if tol is None:
        tol = np.finfo(float).eps * max(
            float(np.linalg.norm(P)), float(np.linalg.norm(P_prime)), 1.0
        )

    v_norm = np.linalg.norm(v)

    # If P ≈ P_prime, return identity (no reflection needed)
    if v_norm < tol:
        return np.eye(n)

    # Compute Householder matrix: H = I - 2*v*v'/(v'*v)
    # Using outer product for v*v'
    v_outer = np.outer(v, v)
    v_dot = v @ v  # Same as v'*v

    H: np.ndarray = np.eye(n) - 2 * v_outer / v_dot

    return H


if __name__ == "__main__":
    print("Test: Householder Transformation Matrix")
    print("=" * 60)

    # Test 1: 2D reflection
    print("\nTest 1: 2D point reflection")
    P1 = np.array([3.0, 4.0])
    P1_prime = np.array([5.0, 0.0])

    H1 = householder(P1, P1_prime)
    print(f"P = {P1}")
    print(f"P' = {P1_prime}")
    print("\nHouseholder matrix H:")
    print(H1)

    # Verify reflection
    reflected = H1 @ P1
    print(f"\nH @ P = {reflected}")
    print(f"Expected: {P1_prime}")
    print(f"Match: {np.allclose(reflected, P1_prime)}")

    # Verify symmetry (H @ P' = P)
    reflected_back = H1 @ P1_prime
    print(f"\nH @ P' = {reflected_back}")
    print(f"Expected: {P1}")
    print(f"Match: {np.allclose(reflected_back, P1)}")

    # Test 2: Verify H is orthogonal
    print("\n" + "=" * 60)
    print("Test 2: Verify H is orthogonal (H.T @ H = I)")
    orthogonality = H1.T @ H1
    print("H.T @ H:")
    print(orthogonality)
    print(f"Is identity: {np.allclose(orthogonality, np.eye(2))}")
    print(f"Error: {np.linalg.norm(orthogonality - np.eye(2)):.2e}")

    # Test 3: Verify H is symmetric
    print("\n" + "=" * 60)
    print("Test 3: Verify H is symmetric (H.T = H)")
    print(f"H.T = H: {np.allclose(H1.T, H1)}")
    print(f"Error: {np.linalg.norm(H1.T - H1):.2e}")

    # Test 4: Higher dimensional case (R^4)
    print("\n" + "=" * 60)
    print("Test 4: 4D reflection")
    P4 = np.array([1.0, 2.0, 3.0, 4.0])
    P4_prime = np.array([5.0, 1.0, 0.0, 0.0])

    H4 = householder(P4, P4_prime)
    reflected4 = H4 @ P4
    print(f"P (4D) = {P4}")
    print(f"P' (4D) = {P4_prime}")
    print(f"H @ P = {reflected4}")
    print(f"Match: {np.allclose(reflected4, P4_prime)}")

    # Test 5: Edge case - identical points
    print("\n" + "=" * 60)
    print("Test 5: Edge case - P = P' (should return identity)")
    P5 = np.array([1.0, 2.0, 3.0])
    H5 = householder(P5, P5)
    print("H (should be identity):")
    print(H5)
    print(f"Is identity: {np.allclose(H5, np.eye(3))}")

    # Test 6: Reflection line visualization info (for 2D)
    print("\n" + "=" * 60)
    print("Test 6: Reflection line (2D case)")
    P6 = np.array([4.0, 2.0])
    P6_prime = np.array([2.0, 4.0])
    H6 = householder(P6, P6_prime)

    # The reflection line is perpendicular to v = P - P' and passes through midpoint
    v = P6 - P6_prime
    midpoint = (P6 + P6_prime) / 2
    print(f"P = {P6}")
    print(f"P' = {P6_prime}")
    print(f"Reflection vector v = P - P' = {v}")
    print(f"Midpoint = {midpoint}")
    print(f"Reflection line is perpendicular to v and passes through midpoint")
    print(f"Reflection line direction (perpendicular to v): {np.array([-v[1], v[0]])}")
