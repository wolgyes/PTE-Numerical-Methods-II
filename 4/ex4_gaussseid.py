"""
Gauss-Seidel Iteration Method for Linear Systems

Solves Ax = b using the Gauss-Seidel iterative method with vectorial form.
Uses the splitting A = (D + L) - U where D is diagonal, L is strictly
lower triangular, and U is strictly upper triangular.

"""

import numpy as np
import warnings
from typing import Optional, Union
from ex4_jacobi import IterationResult


def gaussseid(
    A: np.ndarray,
    b: np.ndarray,
    x0: Optional[np.ndarray] = None,
    tol: float = 1e-6,
    maxiter: int = 1000,
    return_history: bool = False,
) -> Union[np.ndarray, IterationResult]:
    """
    Solves linear system Ax = b using Gauss-Seidel iteration (vectorial form).

    The Gauss-Seidel method uses the splitting A = (D + L) - U where:
    - D is the diagonal matrix
    - L is the strictly lower triangular part
    - U is the strictly upper triangular part

    The iteration formula is: x^(k+1) = (D+L)^(-1)(b - U * x^(k))

    Parameters
    ----------
    A : np.ndarray
        Coefficient matrix (n x n), must be square
    b : np.ndarray
        Right-hand side vector (n,) or (n, 1)
    x0 : Optional[np.ndarray]
        Initial guess. If None, uses zero vector (default: None)
    tol : float
        Convergence tolerance for infinity norm of difference (default: 1e-6)
    maxiter : int
        Maximum number of iterations (default: 1000)
    return_history : bool
        If True, returns full IterationResult with history (default: False)

    Returns
    -------
    np.ndarray or IterationResult
        If return_history=False: solution vector x
        If return_history=True: IterationResult with full information

    Raises
    ------
    ValueError
        If A is not square, dimensions incompatible, or A has zero diagonal

    Notes
    -----
    - Generally converges faster than Jacobi for same system
    - Uses updated values immediately (unlike Jacobi)
    - Converges if A is symmetric positive definite or strictly diagonally dominant
    - Vectorial form using matrix solve is more efficient than element-wise
    - Spectral radius of iteration matrix (D+L)^(-1)*U must be < 1 for convergence

    Examples
    --------
    >>> A = np.array([[4, -1, 0], [-1, 4, -1], [0, -1, 4]])
    >>> b = np.array([1, 5, 0])
    >>> x = gaussseid(A, b)
    >>> print(f"Solution: {x}")
    """
    # Input validation
    if A.shape[0] != A.shape[1]:
        raise ValueError(f"Matrix A must be square, got shape {A.shape}")

    n = A.shape[0]
    b = np.asarray(b).flatten()

    if len(b) != n:
        raise ValueError(f"Dimension mismatch: A is {n}x{n} but b has length {len(b)}")

    # Check for zero diagonal elements
    diag_A = np.diag(A)
    if np.any(np.abs(diag_A) < np.finfo(float).eps):
        raise ValueError("Matrix A has zero diagonal element(s)")

    # Set initial guess
    if x0 is None:
        x = np.zeros(n)
    else:
        x = np.asarray(x0).flatten()
        if len(x) != n:
            raise ValueError(f"Initial guess x0 must have length {n}, got {len(x)}")

    # Extract D (diagonal), L (strictly lower), U (strictly upper)
    D = np.diag(diag_A)
    L = np.tril(A, -1)  # Strictly lower triangular
    U = np.triu(A, 1)  # Strictly upper triangular

    # Track residual history if requested
    residual_history: list[float] = []

    # Gauss-Seidel iteration
    for iter_count in range(1, maxiter + 1):
        # Vectorial form: x_new = (D+L)^(-1) * (b - U * x)
        x_new = np.linalg.solve(D + L, b - U @ x)

        # Check convergence using infinity norm
        diff_norm = np.linalg.norm(x_new - x, ord=np.inf)

        if return_history:
            residual = float(np.linalg.norm(A @ x_new - b))
            residual_history.append(residual)

        if diff_norm < tol:
            # Converged
            final_residual = float(np.linalg.norm(A @ x_new - b))

            if return_history:
                return IterationResult(
                    x=x_new,
                    converged=True,
                    iterations=iter_count,
                    residual_norm=final_residual,
                    residual_history=residual_history,
                )
            else:
                print(f"Gauss-Seidel converged in {iter_count} iterations")
                return x_new

        x = x_new

    # Did not converge
    final_residual = float(np.linalg.norm(A @ x - b))
    warnings.warn(
        f"Gauss-Seidel did not converge within {maxiter} iterations", RuntimeWarning
    )

    if return_history:
        return IterationResult(
            x=x,
            converged=False,
            iterations=maxiter,
            residual_norm=final_residual,
            residual_history=residual_history,
        )
    else:
        return x


if __name__ == "__main__":
    # Simple test
    A = np.array([[4, -1, 0], [-1, 4, -1], [0, -1, 4]], dtype=float)
    b = np.array([1, 5, 0], dtype=float)

    print("Test: Gauss-Seidel iteration")
    print("=" * 50)
    print("Matrix A:")
    print(A)
    print("\nVector b:")
    print(b)

    # Simple return
    x = gaussseid(A, b)
    print(f"\nSolution: {x}")
    print(f"Verification: ||Ax - b|| = {np.linalg.norm(A @ x - b):.2e}")

    # Full return with history
    print("\n" + "=" * 50)
    print("With history:")
    result_full = gaussseid(A, b, return_history=True)
    assert isinstance(result_full, IterationResult)  # Type narrowing for mypy
    print(result_full)
    print(f"\nConvergence history ({len(result_full.residual_history)} iterations):")
    for i, res in enumerate(result_full.residual_history[:5], 1):
        print(f"  Iteration {i}: residual = {res:.2e}")
    if len(result_full.residual_history) > 5:
        print("  ...")
