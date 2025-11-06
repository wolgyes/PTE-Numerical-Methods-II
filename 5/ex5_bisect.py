"""
Bisection Method for Finding Roots of Nonlinear Equations

The bisection method is a simple and robust root-finding algorithm that
repeatedly bisects an interval and selects a subinterval in which a root exists.
"""

from typing import Callable, Tuple
import numpy as np


def bisect(
    f: Callable[[float], float], a: float, b: float, n: int
) -> Tuple[float, float]:
    """
    Bisection method for finding roots of nonlinear equations.

    Parameters
    ----------
    f : Callable[[float], float]
        Function for which we want to find a root
    a : float
        Left endpoint of starting interval
    b : float
        Right endpoint of starting interval
    n : int
        Number of iterations

    Returns
    -------
    x_star : float
        Approximation of the root
    epsilon : float
        Error estimation (half-width of final interval)

    Raises
    ------
    ValueError
        If there is no sign change in the interval [a, b]

    Notes
    -----
    The method requires that f(a) and f(b) have opposite signs,
    guaranteeing a root exists in [a, b] by the Intermediate Value Theorem.

    Examples
    --------
    >>> f = lambda x: x**2 - 4
    >>> x_star, eps = bisect(f, 0, 3, 20)
    >>> abs(x_star - 2.0) < 0.001
    True
    """
    # Evaluate function at endpoints
    fa = f(a)
    fb = f(b)

    # Check if there is a root in the interval
    if fa * fb > 0:
        raise ValueError(
            f"No sign change in interval [{a:.4f}, {b:.4f}]. "
            f"Cannot guarantee root exists."
        )

    # Special cases: root is exactly at an endpoint
    if fa == 0:
        print(f"Root found exactly at a = {a:.10f}")
        return a, 0.0

    if fb == 0:
        print(f"Root found exactly at b = {b:.10f}")
        return b, 0.0

    # Bisection iterations
    for i in range(1, n + 1):
        # Compute midpoint
        c = (a + b) / 2
        fc = f(c)

        # Check if we found the exact root
        if fc == 0:
            print(f"Exact root found at iteration {i}: x = {c:.10f}")
            return c, 0.0

        # Determine which half contains the root
        if fa * fc < 0:
            # Root is in [a, c]
            b = c
            fb = fc
        else:
            # Root is in [c, b]
            a = c
            fa = fc

    # Final approximation is the midpoint of the last interval
    x_star = (a + b) / 2

    # Error estimation is half the width of the final interval
    epsilon = (b - a) / 2

    print(f"Bisection completed after {n} iterations")
    print(f"Root approximation: x* = {x_star:.10f}")
    print(f"Error estimate: ε = {epsilon:.2e}")
    print(f"Function value: f(x*) = {f(x_star):.2e}")

    return x_star, epsilon


if __name__ == "__main__":
    print("=" * 70)
    print("BISECTION METHOD - TEST")
    print("=" * 70)
    print()

    # Test 1: Simple quadratic f(x) = x^2 - 4
    print("Test 1: f(x) = x^2 - 4")
    print("Expected root: x = 2.0")
    print("-" * 70)

    f1 = lambda x: x**2 - 4
    x_root1, eps1 = bisect(f1, 0, 3, 20)

    print(f"\nError from exact root: {abs(x_root1 - 2.0):.2e}")
    print()

    # Test 2: Cubic polynomial f(x) = x^3 - 2*x - 5
    print("=" * 70)
    print("Test 2: f(x) = x^3 - 2*x - 5")
    print("Expected root: x ≈ 2.0946")
    print("-" * 70)

    f2 = lambda x: x**3 - 2 * x - 5
    x_root2, eps2 = bisect(f2, 2, 3, 20)

    print()

    # Test 3: Transcendental equation f(x) = cos(x) - x
    print("=" * 70)
    print("Test 3: f(x) = cos(x) - x")
    print("Expected root: x ≈ 0.739085")
    print("-" * 70)

    f3 = lambda x: np.cos(x) - x
    x_root3, eps3 = bisect(f3, 0, 1, 20)

    print()

    # Test 4: Error case - no sign change
    print("=" * 70)
    print("Test 4: Error handling - no sign change")
    print("-" * 70)

    f4 = lambda x: x**2 + 1
    try:
        bisect(f4, 0, 1, 10)
    except ValueError as e:
        print(f"Caught expected error: {e}")

    print()
    print("=" * 70)
    print("ALL TESTS COMPLETED")
    print("=" * 70)
