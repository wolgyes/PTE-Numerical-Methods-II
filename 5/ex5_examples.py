"""
Example script demonstrating root-finding methods.

Tests bisect, secant, and newt (Newton-Raphson) methods on curved functions
where iterative lines are clearly visible.
"""

import numpy as np
import matplotlib.pyplot as plt
from ex5_bisect import bisect
from ex5_secant import secant
from ex5_newt import newt


def main() -> None:
    """Run demonstration of all three root-finding methods."""
    print("=" * 70)
    print("ROOT FINDING METHODS - DEMONSTRATION")
    print("=" * 70)
    print()

    # Example 1: Cubic polynomial f(x) = x^3 - 2*x - 5
    print("-" * 70)
    print("Example 1: f(x) = x^3 - 2*x - 5 (Cubic polynomial)")
    print("Expected root: x ≈ 2.0946")
    print("-" * 70)
    print()

    f1 = lambda x: x**3 - 2 * x - 5

    # Bisection method: root in [2, 3]
    print("=== BISECTION METHOD ===")
    x_bisect1, eps_bisect1 = bisect(f1, 2, 3, 15)

    print()

    # Secant method: highly curved function shows iterative lines clearly
    print("=== SECANT METHOD ===")
    x_secant1 = secant(f1, 2, 3, 5, f_desc="x^3 - 2x - 5")

    print()

    # Newton-Raphson method: start from x0 = 2
    print("=== NEWTON-RAPHSON METHOD ===")
    x_newt1 = newt(f1, 2, 8)

    print()
    print("COMPARISON:")
    print(f"Bisection:       x* = {x_bisect1:.10f}, error est = {eps_bisect1:.2e}")
    print(f"Secant:          x* = {x_secant1:.10f}")
    print(f"Newton-Raphson:  x* = {x_newt1:.10f}")
    print("Exact:           x  ≈ 2.094551482")
    print()

    input("Press Enter to continue to Example 2...")
    plt.close("all")

    # Example 2: Exponential function f(x) = exp(-x) - 0.5*x
    print("\n" + "=" * 70)
    print("Example 2: f(x) = exp(-x) - 0.5*x (Exponential decay)")
    print("Expected root: x ≈ 1.2")
    print("=" * 70)
    print()

    f2 = lambda x: np.exp(-x) - 0.5 * x

    # Bisection method: root in [0, 2]
    print("=== BISECTION METHOD ===")
    x_bisect2, eps_bisect2 = bisect(f2, 0, 2, 15)

    print()

    # Secant method: exponential curve makes secant lines very visible
    print("=== SECANT METHOD ===")
    x_secant2 = secant(f2, 0, 2, 5, f_desc="e^(-x) - 0.5x")

    print()

    # Newton-Raphson method: start from x0 = 1
    print("=== NEWTON-RAPHSON METHOD ===")
    x_newt2 = newt(f2, 1, 8)

    print()
    print("COMPARISON:")
    print(f"Bisection:       x* = {x_bisect2:.10f}, error est = {eps_bisect2:.2e}")
    print(f"Secant:          x* = {x_secant2:.10f}")
    print(f"Newton-Raphson:  x* = {x_newt2:.10f}")
    print()

    input("Press Enter to continue to Example 3...")
    plt.close("all")

    # Example 3: Transcendental equation f(x) = cos(x) - x
    print("\n" + "=" * 70)
    print("Example 3: f(x) = cos(x) - x (Transcendental)")
    print("Expected root: x ≈ 0.739085")
    print("=" * 70)
    print()

    f3 = lambda x: np.cos(x) - x

    # Bisection method: root in [0, 1]
    print("=== BISECTION METHOD ===")
    x_bisect3, eps_bisect3 = bisect(f3, 0, 1, 15)

    print()

    # Secant method
    print("=== SECANT METHOD ===")
    x_secant3 = secant(f3, 0, 1, 5, f_desc="cos(x) - x")

    print()

    # Newton-Raphson method: start from x0 = 0.5
    print("=== NEWTON-RAPHSON METHOD ===")
    x_newt3 = newt(f3, 0.5, 8)

    print()
    print("COMPARISON:")
    print(f"Bisection:       x* = {x_bisect3:.10f}, error est = {eps_bisect3:.2e}")
    print(f"Secant:          x* = {x_secant3:.10f}")
    print(f"Newton-Raphson:  x* = {x_newt3:.10f}")
    print("Exact:           x  ≈ 0.739085133")
    print()

    print("\n" + "=" * 70)
    print("ALL EXAMPLES COMPLETED")
    print("=" * 70)

    # Summary
    print("\nSUMMARY OF METHODS:\n")
    print("BISECTION METHOD:")
    print("  - Guaranteed convergence if root exists in interval")
    print("  - Linear convergence (slow but reliable)")
    print("  - Requires sign change: f(a)*f(b) < 0\n")

    print("SECANT METHOD:")
    print("  - Faster than bisection (superlinear convergence)")
    print("  - Doesn't require derivative")
    print("  - May fail if f(x1) ≈ f(x0)")
    print("  - Visual inspection shows iterative approximation clearly\n")

    print("NEWTON-RAPHSON METHOD:")
    print("  - Fastest convergence (quadratic)")
    print("  - Requires derivative computation")
    print("  - May fail if f'(x) ≈ 0")
    print("  - Sensitive to starting point\n")

    print("NOTE: The secant method plots show how the method approximates")
    print("      the curve with straight lines. With highly curved functions")
    print("      (like x^3 or e^(-x)), the iterative secant lines are very")
    print("      visible and clearly different from the actual curve.\n")


if __name__ == "__main__":
    main()
