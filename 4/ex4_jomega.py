"""
Soothed (Weighted) Jacobi Parameter Analysis

Analyzes the omega relaxation parameter for optimal convergence of the
Soothed Jacobi iteration method.

"""

import numpy as np
import matplotlib.pyplot as plt
import warnings
from typing import Optional, Tuple
from dataclasses import dataclass


@dataclass
class OmegaAnalysisResult:
    """Container for omega parameter analysis results

    Attributes
    ----------
    omega_opt : float
        Optimal omega (minimum spectral radius)
    rho_opt : float
        Optimal spectral radius value
    omega_conv : Optional[Tuple[float, float]]
        Convergence interval [omega_min, omega_max] where rho < 1
    rho_values : np.ndarray
        Spectral radius for each omega tested
    omega_values : np.ndarray
        Omega values tested
    """

    omega_opt: float
    rho_opt: float
    omega_conv: Optional[Tuple[float, float]]
    rho_values: np.ndarray
    omega_values: np.ndarray

    def __str__(self) -> str:
        """String representation for easy printing"""
        conv_str = (
            f"[{self.omega_conv[0]:.6f}, {self.omega_conv[1]:.6f}]"
            if self.omega_conv
            else "None"
        )
        return (
            f"{'=' * 50}\n"
            f"Soothed Jacobi Parameter Analysis\n"
            f"{'=' * 50}\n"
            f"Optimal omega:        {self.omega_opt:.6f}\n"
            f"Optimal rho:          {self.rho_opt:.6f}\n"
            f"Convergence interval: {conv_str}\n"
            f"{'=' * 50}"
        )


def jomega(
    A: np.ndarray,
    omega_range: Optional[np.ndarray] = None,
    plot: bool = True,
    figsize: Tuple[int, int] = (10, 6),
) -> OmegaAnalysisResult:
    """
    Analyze spectral radius of Soothed Jacobi iteration as function of omega.

    For Soothed Jacobi: x^(k+1) = (1-ω)x^(k) + ω*D^(-1)(b - R*x^(k))
    Equivalently: x^(k+1) = (I - ω*D^(-1)*A)*x^(k) + ω*D^(-1)*b

    The iteration matrix is T_ω = I - ω*D^(-1)*A
    Convergence occurs when spectral radius ρ(T_ω) < 1

    Parameters
    ----------
    A : np.ndarray
        Coefficient matrix of linear system (n x n)
    omega_range : Optional[np.ndarray]
        Range of omega values to test. If None, uses np.arange(0, 2.01, 0.01)
        (default: None)
    plot : bool
        Whether to create visualization (default: True)
    figsize : Tuple[int, int]
        Figure size for plot (default: (10, 6))

    Returns
    -------
    OmegaAnalysisResult
        Complete analysis results including optimal parameters and convergence interval

    Raises
    ------
    ValueError
        If A is not square or has zero diagonal elements

    Notes
    -----
    - Optimal omega minimizes the spectral radius, yielding fastest convergence
    - Classical Jacobi corresponds to omega = 1
    - Convergence interval shows valid omega values where ρ < 1
    - For symmetric positive definite A, typically 0 < ω_opt < 2

    Examples
    --------
    >>> A = np.array([[4, -1, 0], [-1, 4, -1], [0, -1, 4]])
    >>> result = jomega(A)
    >>> print(result)
    >>> print(f"Use omega = {result.omega_opt:.3f} for fastest convergence")
    """
    # Input validation
    if A.shape[0] != A.shape[1]:
        raise ValueError(f"Matrix A must be square, got shape {A.shape}")

    n = A.shape[0]

    # Check for zero diagonal elements
    diag_A = np.diag(A)
    if np.any(np.abs(diag_A) < np.finfo(float).eps):
        raise ValueError("Matrix A has zero diagonal element(s)")

    # Set default omega range if not provided
    if omega_range is None:
        omega_values = np.arange(0, 2.01, 0.01)
    else:
        omega_values = omega_range

    # Compute D^(-1)
    D_inv = np.diag(1.0 / diag_A)

    # Preallocate for spectral radius values
    rho_values = np.zeros(len(omega_values))

    # Compute spectral radius for each omega
    for i, omega in enumerate(omega_values):
        # Iteration matrix for Soothed Jacobi: T_omega = I - omega * D^(-1) * A
        T_omega = np.eye(n) - omega * D_inv @ A

        # Compute spectral radius (maximum absolute eigenvalue)
        eigenvalues = np.linalg.eigvals(T_omega)
        rho_values[i] = np.max(np.abs(eigenvalues))

    # Find optimal omega (minimum spectral radius)
    idx_opt = np.argmin(rho_values)
    omega_opt = float(omega_values[idx_opt])
    rho_opt = float(rho_values[idx_opt])

    # Find convergence interval (where rho < 1)
    conv_indices = np.where(rho_values < 1)[0]
    if len(conv_indices) > 0:
        omega_conv: Optional[Tuple[float, float]] = (
            float(omega_values[conv_indices[0]]),
            float(omega_values[conv_indices[-1]]),
        )
    else:
        omega_conv = None
        warnings.warn(
            "No convergence interval found in the given omega range", RuntimeWarning
        )

    # Create visualization if requested
    if plot:
        _plot_omega_analysis(
            omega_values, rho_values, omega_opt, rho_opt, omega_conv, figsize
        )

    # Create and return result
    result = OmegaAnalysisResult(
        omega_opt=omega_opt,
        rho_opt=rho_opt,
        omega_conv=omega_conv,
        rho_values=rho_values,
        omega_values=omega_values,
    )

    # Print summary
    print(result)

    return result


def _plot_omega_analysis(
    omega_values: np.ndarray,
    rho_values: np.ndarray,
    omega_opt: float,
    rho_opt: float,
    omega_conv: Optional[Tuple[float, float]],
    figsize: Tuple[int, int],
) -> None:
    """
    Internal helper to create visualization of omega analysis.

    Creates a plot with:
    - Spectral radius curve vs omega
    - Optimal point marker
    - Convergence boundary line at rho = 1
    - Shaded convergence region
    """
    plt.figure(figsize=figsize)

    # Plot spectral radius curve
    plt.plot(omega_values, rho_values, "b-", linewidth=1.5, label="Spectral radius")

    # Mark optimal point
    plt.plot(
        omega_opt,
        rho_opt,
        "ro",
        markersize=10,
        markerfacecolor="r",
        label=f"Optimal: ω = {omega_opt:.3f}, ρ = {rho_opt:.4f}",
    )

    # Mark convergence region if it exists
    if omega_conv is not None:
        # Horizontal line at rho = 1
        plt.axhline(
            y=1,
            color="k",
            linestyle="--",
            linewidth=1,
            label="ρ = 1 (convergence boundary)",
        )

        # Shade convergence region
        y_fill = [0, 0, 1, 1]
        x_fill = [omega_conv[0], omega_conv[1], omega_conv[1], omega_conv[0]]
        plt.fill(
            x_fill,
            y_fill,
            "g",
            alpha=0.1,
            edgecolor="none",
            label=f"Convergence region: [{omega_conv[0]:.3f}, {omega_conv[1]:.3f}]",
        )

    plt.grid(True, alpha=0.3)
    plt.xlabel("ω (relaxation parameter)", fontsize=12)
    plt.ylabel("ρ(T_ω) (spectral radius)", fontsize=12)
    plt.title("Spectral Radius vs Omega for Soothed Jacobi Iteration", fontsize=14)
    plt.legend(loc="best")
    plt.tight_layout()
    plt.show()


def compare_omega_systems(
    systems: list[Tuple[np.ndarray, str]],
    omega_range: Optional[np.ndarray] = None,
    figsize: Tuple[int, int] = (12, 8),
) -> list[OmegaAnalysisResult]:
    """
    Compare omega analysis for multiple systems on a single plot.

    Useful for understanding how matrix structure affects optimal omega.

    Parameters
    ----------
    systems : list[Tuple[np.ndarray, str]]
        List of (matrix, label) tuples to analyze
    omega_range : Optional[np.ndarray]
        Range of omega values (default: None for auto)
    figsize : Tuple[int, int]
        Figure size (default: (12, 8))

    Returns
    -------
    list[OmegaAnalysisResult]
        Analysis results for each system

    Examples
    --------
    >>> A1 = np.array([[4, -1, 0], [-1, 4, -1], [0, -1, 4]])
    >>> A2 = np.array([[10, -1, 2, 0], [-1, 11, -1, 3],
    ...                [2, -1, 10, -1], [0, 3, -1, 8]])
    >>> systems = [(A1, "3x3 Tridiagonal"), (A2, "4x4 System")]
    >>> results = compare_omega_systems(systems)
    """
    # Analyze each system without individual plots
    results = []
    for A, label in systems:
        result = jomega(A, omega_range=omega_range, plot=False)
        results.append(result)

    # Create unified plot
    plt.figure(figsize=figsize)

    colors = ["b", "r", "g", "c", "m", "y"]

    # Plot convergence regions first (background)
    for i, (result, (_, label)) in enumerate(zip(results, systems)):
        color = colors[i % len(colors)]
        if result.omega_conv is not None:
            y_fill = [0, 0, 1, 1]
            x_fill = [
                result.omega_conv[0],
                result.omega_conv[1],
                result.omega_conv[1],
                result.omega_conv[0],
            ]
            plt.fill(
                x_fill,
                y_fill,
                color=color,
                alpha=0.05,
                edgecolor="none",
                label=f"Conv region {i+1}",
            )

    # Convergence boundary
    plt.axhline(
        y=1,
        color="k",
        linestyle="--",
        linewidth=1.5,
        label="ρ = 1 (convergence boundary)",
    )

    # Plot spectral radius curves
    for i, (result, (_, label)) in enumerate(zip(results, systems)):
        color = colors[i % len(colors)]
        plt.plot(
            result.omega_values,
            result.rho_values,
            color=color,
            linestyle="-",
            linewidth=2,
            label=f"System {i+1}: {label}",
        )

        # Mark optimal points
        plt.plot(
            result.omega_opt,
            result.rho_opt,
            "o",
            color=color,
            markersize=10,
            markerfacecolor=color,
            label=f"Opt {i+1}: ω={result.omega_opt:.3f}",
        )

    plt.grid(True, alpha=0.3)
    plt.xlabel("ω (relaxation parameter)", fontsize=13)
    plt.ylabel("ρ(T_ω) (spectral radius)", fontsize=13)
    plt.title(
        "Soothed Jacobi Parameter Analysis - All Systems Comparison",
        fontsize=15,
        fontweight="bold",
    )
    plt.legend(loc="best", fontsize=11)
    plt.tight_layout()
    plt.show()

    return results


if __name__ == "__main__":
    # Test with sample matrix
    print("Test: Soothed Jacobi omega parameter analysis")
    print("=" * 60)

    A = np.array([[4, -1, 0], [-1, 4, -1], [0, -1, 4]], dtype=float)
    print("Matrix A:")
    print(A)
    print()

    result = jomega(A)
    print(f"\nOptimal omega: {result.omega_opt:.4f}")
    print(f"Optimal spectral radius: {result.rho_opt:.4f}")
    if result.omega_conv:
        print(
            f"Convergence interval: [{result.omega_conv[0]:.4f}, {result.omega_conv[1]:.4f}]"
        )
