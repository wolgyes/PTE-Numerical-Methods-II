"""
Newton-Raphson Method for Finding Roots of Nonlinear Equations

The Newton-Raphson method uses the tangent line at a point to approximate
the root. It has quadratic convergence but requires derivative computation.
"""

from typing import Callable, Optional
import numpy as np


def newt(f: Callable[[float], float], x0: float, n: int) -> float:
    """
    Newton-Raphson method for finding roots of nonlinear equations.

    Parameters
    ----------
    f : Callable[[float], float]
        Function for which we want to find a root
    x0 : float
        Starting point
    n : int
        Number of iterations

    Returns
    -------
    x_star : float
        Approximation of the root

    Notes
    -----
    The function attempts to compute the derivative symbolically using sympy.
    If sympy is not available or fails, it falls back to numerical differentiation
    using central finite differences.

    Newton-Raphson formula: x_new = x - f(x) / f'(x)

    Warnings
    --------
    The method may fail if the derivative is near zero at any iteration point.

    Examples
    --------
    >>> f = lambda x: x**2 - 4
    >>> x_star = newt(f, 3, 10)
    >>> abs(x_star - 2.0) < 1e-6
    True
    """
    # Try symbolic differentiation
    f_prime: Optional[Callable[[float], float]] = None

    try:
        import sympy as sp

        x_sym = sp.Symbol("x")

        # Try to extract expression from lambda
        # This is tricky in Python - we'll use a workaround
        # For common cases, we create symbolic versions

        # Attempt symbolic differentiation
        # Note: This won't work for arbitrary lambdas, so we'll catch and fallback
        try:
            # Try to evaluate symbolically (this will only work for simple cases)
            f_sym = f(x_sym)
            f_prime_sym = sp.diff(f_sym, x_sym)

            # Convert back to numeric function
            f_prime = sp.lambdify(x_sym, f_prime_sym, "numpy")

            print(f"Symbolic derivative computed: f'(x) = {f_prime_sym}")

        except (TypeError, AttributeError):
            # Symbolic evaluation failed, fall back to numerical
            raise RuntimeError("Symbolic differentiation not applicable")

    except (ImportError, RuntimeError) as e:
        print(f"Symbolic differentiation failed or not available: {e}")
        print("Falling back to numerical differentiation (finite difference)")

        # Numerical differentiation using central difference
        h = 1e-8
        f_prime = lambda x: (f(x + h) - f(x - h)) / (2 * h)

    # Ensure f_prime is not None before iteration
    assert f_prime is not None, "Derivative function must be defined"

    # Newton-Raphson iterations
    x = x0
    print("\nNewton-Raphson Method:")
    print(f"{'Iter':<5} | {'x':<16} | {'f(x)':<14} | {'f''(x)':<14}")
    print("-" * 55)

    for i in range(n):
        fx = f(x)
        fpx = f_prime(x)

        print(f"{i:<5} | {x:14.8f} | {fx:14.6e} | {fpx:14.6e}")

        # Check for zero derivative
        if abs(fpx) < np.finfo(float).eps:
            print(
                f"\nWarning: Derivative near zero at iteration {i}. Newton method may fail."
            )
            break

        # Newton-Raphson update: x_new = x - f(x) / f'(x)
        x_new = x - fx / fpx

        # Check convergence
        if abs(x_new - x) < 1e-10:
            print(f"\nConverged after {i + 1} iterations")
            x = x_new
            break

        x = x_new

    x_star = x

    print("\nNewton-Raphson completed")
    print(f"Root approximation: x* = {x_star:.10f}")
    print(f"Function value: f(x*) = {f(x_star):.2e}")

    return x_star


if __name__ == "__main__":
    print("=" * 70)
    print("NEWTON-RAPHSON METHOD - TEST")
    print("=" * 70)
    print()

    # Test 1: Simple quadratic f(x) = x^2 - 4
    print("Test 1: f(x) = x^2 - 4")
    print("Expected root: x = 2.0")
    print("-" * 70)

    f1 = lambda x: x**2 - 4
    x_root1 = newt(f1, 3, 10)

    print(f"\nError from exact root: {abs(x_root1 - 2.0):.2e}")
    print()

    # Test 2: Cubic polynomial f(x) = x^3 - 2*x - 5
    print("=" * 70)
    print("Test 2: f(x) = x^3 - 2*x - 5")
    print("Expected root: x ≈ 2.0946")
    print("-" * 70)

    f2 = lambda x: x**3 - 2 * x - 5
    x_root2 = newt(f2, 2, 10)

    print()

    # Test 3: Transcendental equation f(x) = cos(x) - x
    print("=" * 70)
    print("Test 3: f(x) = cos(x) - x")
    print("Expected root: x ≈ 0.739085")
    print("-" * 70)

    f3 = lambda x: np.cos(x) - x
    x_root3 = newt(f3, 0.5, 10)

    print()

    # Test 4: Exponential function f(x) = exp(-x) - 0.5*x
    print("=" * 70)
    print("Test 4: f(x) = exp(-x) - 0.5*x")
    print("Expected root: x ≈ 1.2")
    print("-" * 70)

    f4 = lambda x: np.exp(-x) - 0.5 * x
    x_root4 = newt(f4, 1, 10)

    print()
    print("=" * 70)
    print("ALL TESTS COMPLETED")
    print("=" * 70)
    print()
    print("Note: The Newton-Raphson method uses numerical differentiation")
    print("      (central finite difference) since symbolic differentiation")
    print("      of lambda functions is not straightforward in Python.")
