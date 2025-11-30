"""
Secant Method for Finding Roots of Nonlinear Equations

The secant method uses linear interpolation between successive points to
approximate the root. It's faster than bisection but doesn't require derivatives.
"""

from typing import Callable, Optional, List
import numpy as np
import matplotlib.pyplot as plt


def secant(
    f: Callable[[float], float],
    a: float,
    b: float,
    n: int,
    f_desc: Optional[str] = None,
    create_plot: bool = True,
) -> float:
    """
    Secant method for finding roots of nonlinear equations.

    Parameters
    ----------
    f : Callable[[float], float]
        Function for which we want to find a root
    a : float
        First starting point
    b : float
        Second starting point
    n : int
        Number of iterations
    f_desc : str, optional
        Description of function for plot title (e.g., "x^3 - 2x - 5")
    create_plot : bool, default=True
        Whether to create visualization plot

    Returns
    -------
    x_star : float
        Approximation of the root

    Raises
    ------
    ValueError
        If f(a) == f(b) (division by zero)

    Warnings
    --------
    If there's no sign change between a and b, a warning is printed.

    Notes
    -----
    The secant formula is: x_new = x1 - f(x1) * (x1 - x0) / (f(x1) - f(x0))

    Examples
    --------
    >>> f = lambda x: x**3 - 2*x - 5
    >>> x_star = secant(f, 2, 3, 10, create_plot=False)
    >>> abs(x_star - 2.0946) < 0.001
    True
    """
    # Evaluate function at starting points
    fa = f(a)
    fb = f(b)

    # Check if starting points are valid
    if fa == fb:
        raise ValueError(
            "f(a) = f(b), cannot proceed with secant method (division by zero)"
        )

    # Check if there's likely a root (sign change)
    if fa * fb > 0:
        print(
            "Warning: No sign change between a and b. Root may not exist in interval."
        )

    # Store iteration history for plotting
    x_history: List[float] = [a, b]
    f_history: List[float] = [fa, fb]

    # Initialize
    x0 = a
    x1 = b
    f0 = fa
    f1 = fb

    # Secant iterations
    for i in range(1, n + 1):
        # Check for division by zero
        if f1 == f0:
            print(f"Warning: Division by zero at iteration {i}. Stopping.")
            break

        # Secant formula: x_new = x1 - f(x1) * (x1 - x0) / (f(x1) - f(x0))
        x_new = x1 - f1 * (x1 - x0) / (f1 - f0)
        f_new = f(x_new)

        # Store for plotting
        x_history.append(x_new)
        f_history.append(f_new)

        # Update for next iteration
        x0 = x1
        f0 = f1
        x1 = x_new
        f1 = f_new

        # Check convergence
        if abs(f_new) < 1e-10:
            print(f"Converged to root at iteration {i}")
            break

    x_star = x1

    print(f"Secant method completed after {len(x_history) - 2} iterations")
    print(f"Root approximation: x* = {x_star:.10f}")
    print(f"Function value: f(x*) = {f(x_star):.2e}")

    # Create visualization
    if create_plot:
        _plot_secant_iterations(f, x_history, f_history, f_desc)

    return x_star


def _plot_secant_iterations(
    f: Callable[[float], float],
    x_history: List[float],
    f_history: List[float],
    f_desc: Optional[str] = None,
) -> None:
    """
    Helper function to plot the secant method iterations.

    Parameters
    ----------
    f : Callable[[float], float]
        The function being analyzed
    x_history : List[float]
        History of x values during iteration
    f_history : List[float]
        History of f(x) values during iteration
    f_desc : str, optional
        Description of function for plot title
    """
    fig, ax = plt.subplots(figsize=(9, 6))

    # Determine plotting range
    x_range = max(x_history) - min(x_history)
    x_min = min(x_history) - 0.4 * x_range
    x_max = max(x_history) + 0.4 * x_range
    x_plot = np.linspace(x_min, x_max, 1000)

    # Plot the function
    y_plot = np.array([f(x) for x in x_plot])
    ax.plot(x_plot, y_plot, "b-", linewidth=2, label="f(x)")

    # Plot zero line
    ax.axhline(y=0, color="k", linewidth=0.5)

    # Plot secant lines (only between the two points, not extended)
    for i in range(len(x_history) - 1):
        x1 = x_history[i]
        x2 = x_history[i + 1]
        y1 = f_history[i]
        y2 = f_history[i + 1]

        # Draw simple secant line between the two points only
        if i == 0:
            ax.plot([x1, x2], [y1, y2], "g-", linewidth=1.5, label="Secant lines")
        else:
            ax.plot([x1, x2], [y1, y2], "g-", linewidth=1.5)

    # Plot iteration points
    ax.plot(
        x_history,
        f_history,
        "ro",
        markersize=7,
        markerfacecolor="r",
        markeredgewidth=1,
        label="Iterations",
    )

    # Add iteration number labels
    y_range = max(y_plot) - min(y_plot)
    for i, (x, y) in enumerate(zip(x_history, f_history)):
        # Offset label slightly above or below point
        y_offset = 0.015 * y_range
        if y > 0:
            valign = "bottom"
            y_pos = y + y_offset
        else:
            valign = "top"
            y_pos = y - y_offset

        ax.text(
            x,
            y_pos,
            str(i),
            fontsize=9,
            color="red",
            ha="center",
            va=valign,
        )

    ax.grid(True, alpha=0.3)
    ax.set_xlabel("x", fontsize=12)
    ax.set_ylabel("f(x)", fontsize=12)

    # Set title based on function description
    if f_desc:
        title = f"Secant Method: f(x) = {f_desc}"
    else:
        title = "Secant Method Iterations"

    ax.set_title(title, fontsize=13, fontweight="bold")
    ax.legend(loc="best")

    plt.tight_layout()
    plt.show()

    print(f"\nPlot created showing {len(x_history) - 1} iterations")


if __name__ == "__main__":
    print("=" * 70)
    print("SECANT METHOD - TEST")
    print("=" * 70)
    print()

    # Test 1: Cubic polynomial
    print("Test 1: f(x) = x^3 - 2*x - 5")
    print("Expected root: x ≈ 2.0946")
    print("-" * 70)

    f1 = lambda x: x**3 - 2 * x - 5
    x_root1 = secant(f1, 2, 3, 5, f_desc="x^3 - 2x - 5")

    print()
    input("Press Enter to continue to Test 2...")
    plt.close("all")

    # Test 2: Exponential function
    print("\n" + "=" * 70)
    print("Test 2: f(x) = exp(-x) - 0.5*x")
    print("Expected root: x ≈ 1.2")
    print("-" * 70)

    f2 = lambda x: np.exp(-x) - 0.5 * x
    x_root2 = secant(f2, 0, 2, 5, f_desc="e^(-x) - 0.5x")

    print()
    input("Press Enter to continue to Test 3...")
    plt.close("all")

    # Test 3: Transcendental equation
    print("\n" + "=" * 70)
    print("Test 3: f(x) = cos(x) - x")
    print("Expected root: x ≈ 0.739085")
    print("-" * 70)

    f3 = lambda x: np.cos(x) - x
    x_root3 = secant(f3, 0, 1, 5, f_desc="cos(x) - x")

    print()
    print("=" * 70)
    print("ALL TESTS COMPLETED")
    print("=" * 70)
