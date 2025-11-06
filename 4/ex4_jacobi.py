"""
Jacobi Iteration Method for Linear Systems

Solves Ax = b using the Jacobi iterative method with vectorial form.
The Jacobi method uses the splitting A = D - R where D is the diagonal
and R = D - A.

"""

import numpy as np
import warnings
from typing import Optional, Union
from dataclasses import dataclass, field


@dataclass
class IterationResult:
    """Container for iteration method results

    Attributes
    ----------
    x : np.ndarray
        Solution vector
    converged : bool
        Whether the method converged within maxiter
    iterations : int
        Number of iterations performed
    residual_norm : float
        Final residual norm ||Ax - b||
    residual_history : list[float]
        History of residuals per iteration (if tracked)
    """

    x: np.ndarray
    converged: bool
    iterations: int
    residual_norm: float
    residual_history: list[float] = field(default_factory=list)

    def __str__(self) -> str:
        """String representation for easy printing"""
        status = "Converged" if self.converged else "Did not converge"
        return (
            f"{status} in {self.iterations} iterations\n"
            f"Final residual norm: {self.residual_norm:.6e}"
        )


def jacobi(
    A: np.ndarray,
    b: np.ndarray,
    x0: Optional[np.ndarray] = None,
    tol: float = 1e-6,
    maxiter: int = 1000,
    return_history: bool = False,
) -> Union[np.ndarray, IterationResult]:
    """
    Solves linear system Ax = b using Jacobi iteration (vectorial form).

    The Jacobi method uses the splitting A = D - R where D is the diagonal
    and R = D - A. The iteration formula is:
        x^(k+1) = D^(-1)(b - R * x^(k))

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
    - Jacobi method converges if A is strictly diagonally dominant
    - Spectral radius of iteration matrix D^(-1)*R must be < 1 for convergence
    - Vectorial form is more efficient than element-wise computation

    Examples
    --------
    >>> A = np.array([[4, -1, 0], [-1, 4, -1], [0, -1, 4]])
    >>> b = np.array([1, 5, 0])
    >>> x = jacobi(A, b)
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

    # Extract diagonal matrix D and off-diagonal R
    D = np.diag(diag_A)
    R = A - D

    # Track residual history if requested
    residual_history: list[float] = []

    # Jacobi iteration
    for iter_count in range(1, maxiter + 1):
        # Vectorial form: x_new = D^(-1) * (b - R * x)
        x_new = np.linalg.solve(D, b - R @ x)

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
                print(f"Jacobi converged in {iter_count} iterations")
                return x_new

        x = x_new

    # Did not converge
    final_residual = float(np.linalg.norm(A @ x - b))
    warnings.warn(
        f"Jacobi did not converge within {maxiter} iterations", RuntimeWarning
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

    print("Test: Jacobi iteration")
    print("=" * 50)
    print("Matrix A:")
    print(A)
    print("\nVector b:")
    print(b)

    # Simple return
    x = jacobi(A, b)
    print(f"\nSolution: {x}")
    print(f"Verification: ||Ax - b|| = {np.linalg.norm(A @ x - b):.2e}")

    # Full return with history
    print("\n" + "=" * 50)
    print("With history:")
    result = jacobi(A, b, return_history=True)
    print(result)
