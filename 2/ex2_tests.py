"""
Comprehensive unit tests for Gaussian elimination functions
Tests for gaussel1, gaussel2, and gaussel3 functions using pytest
"""

import pytest
import numpy as np
import warnings
from ex2_gaussel1 import gaussel1
from ex2_gaussel2 import gaussel2
from ex2_gaussel3 import gaussel3


class TestGaussel1:
    """Tests for gaussel1 function (Basic Gaussian Elimination)"""

    def test_simple_3x3_system(self) -> None:
        """Test solving a simple 3x3 system"""
        A = np.array([[2, 1, -1], [-3, -1, 2], [-2, 1, 2]], dtype=float)
        b = np.array([8, -11, -3], dtype=float)
        expected = np.array([2, 3, -1], dtype=float)

        x = gaussel1(A, b)
        assert np.allclose(x, expected, atol=1e-10), f"Expected {expected}, got {x}"

        # Verify solution
        residual = A @ x - b
        assert (
            np.linalg.norm(residual) < 1e-10
        ), f"Residual too large: {np.linalg.norm(residual)}"

    def test_multiple_rhs(self) -> None:
        """Test system with multiple right-hand sides"""
        A = np.array([[4, -2, 1], [2, 1, -3], [-1, 3, 2]], dtype=float)
        b = np.array([[5, 2], [1, -1], [8, 4]], dtype=float)

        x = gaussel1(A, b)
        assert x.shape == (3, 2), f"Expected shape (3, 2), got {x.shape}"

        # Verify both solutions
        residual = A @ x - b
        assert (
            np.linalg.norm(residual) < 1e-10
        ), f"Residual too large: {np.linalg.norm(residual)}"

    def test_zero_pivot_with_row_swap(self) -> None:
        """Test system requiring row swapping due to zero pivot"""
        A = np.array([[0, 2, 1], [1, -1, 3], [2, 1, -1]], dtype=float)
        b = np.array([1, 8, 1], dtype=float)

        x = gaussel1(A, b)

        # Verify solution
        residual = A @ x - b
        assert (
            np.linalg.norm(residual) < 1e-10
        ), f"Residual too large: {np.linalg.norm(residual)}"

    def test_identity_matrix(self) -> None:
        """Test solving system with identity matrix"""
        A = np.eye(3)
        b = np.array([1, 2, 3], dtype=float)
        expected = b.copy()

        x = gaussel1(A, b)
        assert np.allclose(x, expected, atol=1e-10), f"Expected {expected}, got {x}"

    def test_singular_matrix(self) -> None:
        """Test that singular matrix raises appropriate error"""
        A = np.array(
            [[1, 2, 3], [4, 5, 6], [7, 8, 9]], dtype=float  # Linearly dependent row
        )
        b = np.array([1, 2, 3], dtype=float)

        with pytest.raises(ValueError, match="cannot proceed without pivoting"):
            gaussel1(A, b)

    def test_incompatible_dimensions(self) -> None:
        """Test error handling for incompatible dimensions"""
        A = np.array([[1, 2], [3, 4]], dtype=float)
        b = np.array([1, 2, 3], dtype=float)  # Wrong size

        with pytest.raises(ValueError, match="dimensions are incompatible"):
            gaussel1(A, b)

    def test_overdetermined_system(self) -> None:
        """Test handling of overdetermined system (more rows than columns)"""
        A = np.array(
            [[1, 2], [3, 4], [5, 6]], dtype=float
        )  # 3x2 matrix - overdetermined
        b = np.array([1, 2, 3], dtype=float)

        # This should work and give a solution with a warning
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            x = gaussel1(A, b)
            assert len(x) == 2  # Should get solution for 2 variables

    def test_display_matrices_option(self) -> None:
        """Test that display_matrices option works without error"""
        A = np.array([[1, 2], [3, 4]], dtype=float)
        b = np.array([5, 11], dtype=float)

        # Should not raise any errors
        x = gaussel1(A, b, display_matrices=True)

        # Verify solution
        residual = A @ x - b
        assert np.linalg.norm(residual) < 1e-10


class TestGaussel2:
    """Tests for gaussel2 function (Gaussian Elimination with Pivoting)"""

    def test_partial_pivoting(self) -> None:
        """Test basic functionality with partial pivoting"""
        A = np.array([[0, 2, 3], [4, 5, 6], [7, 8, 0]], dtype=float)
        b = np.array([13, 32, 23], dtype=float)

        x = gaussel2(A, b, use_partial_pivoting=True)

        # Verify solution
        residual = A @ x - b
        assert (
            np.linalg.norm(residual) < 1e-10
        ), f"Residual too large: {np.linalg.norm(residual)}"

    def test_full_pivoting(self) -> None:
        """Test basic functionality with full pivoting"""
        A = np.array([[0, 2, 3], [4, 5, 6], [7, 8, 0]], dtype=float)
        b = np.array([13, 32, 23], dtype=float)

        x = gaussel2(A, b, use_partial_pivoting=False)

        # Verify solution
        residual = A @ x - b
        assert (
            np.linalg.norm(residual) < 1e-10
        ), f"Residual too large: {np.linalg.norm(residual)}"

    def test_ill_conditioned_system(self) -> None:
        """Test system with very small pivot"""
        A = np.array([[1e-14, 1, 0], [1, 1, 1], [0, 1, 2]], dtype=float)
        b = np.array([1, 3, 3], dtype=float)

        x = gaussel2(A, b, use_partial_pivoting=True)

        # Solution should still be reasonable
        residual = A @ x - b
        assert (
            np.linalg.norm(residual) < 1e-8
        ), f"Residual too large for ill-conditioned system"

    def test_pivoting_switch(self) -> None:
        """Test automatic switch from partial to full pivoting"""
        # Create a matrix where partial pivoting might struggle
        A = np.array([[0, 0, 1], [0, 1, 1], [1, 1, 1]], dtype=float)
        b = np.array([1, 2, 3], dtype=float)

        x = gaussel2(A, b, use_partial_pivoting=True)

        # Verify solution
        residual = A @ x - b
        assert (
            np.linalg.norm(residual) < 1e-10
        ), f"Residual too large: {np.linalg.norm(residual)}"

    def test_multiple_rhs_with_pivoting(self) -> None:
        """Test multiple right-hand sides with pivoting"""
        A = np.array([[0, 2, 1], [1, -1, 3], [2, 1, -1]], dtype=float)
        b = np.array([[1, 5], [8, 2], [1, -3]], dtype=float)

        x = gaussel2(A, b, use_partial_pivoting=False)
        assert x.shape == (3, 2), f"Expected shape (3, 2), got {x.shape}"

        # Verify both solutions
        residual = A @ x - b
        assert (
            np.linalg.norm(residual) < 1e-10
        ), f"Residual too large: {np.linalg.norm(residual)}"

    def test_display_matrices_with_pivoting(self) -> None:
        """Test display option with pivoting operations"""
        A = np.array([[0, 1], [1, 0]], dtype=float)
        b = np.array([2, 1], dtype=float)

        # Should not raise any errors
        x = gaussel2(A, b, use_partial_pivoting=True, display_matrices=True)

        # Verify solution
        residual = A @ x - b
        assert np.linalg.norm(residual) < 1e-10


class TestGaussel3:
    """Tests for gaussel3 function (Matrix Inverse and LU Decomposition)"""

    def test_invertible_matrix(self) -> None:
        """Test inverse of a well-conditioned matrix"""
        A = np.array([[2, 1, -1], [-3, -1, 2], [-2, 1, 2]], dtype=float)

        A_inv, det_A, L, U = gaussel3(A, verbose=False)

        assert A_inv is not None, "Matrix should be invertible"
        assert abs(det_A) > 1e-10, f"Determinant too small: {det_A}"
        assert L is not None, "L matrix should not be None"
        assert U is not None, "U matrix should not be None"

        # Test A * A_inv = I
        identity_check = A @ A_inv
        error = np.linalg.norm(identity_check - np.eye(3))
        assert error < 1e-10, f"A * A_inv error too large: {error}"

        # Test L * U = A
        lu_check = L @ U
        lu_error = np.linalg.norm(lu_check - A)
        assert lu_error < 1e-10, f"L * U error too large: {lu_error}"

    def test_singular_matrix(self) -> None:
        """Test handling of singular matrix"""
        A = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]], dtype=float)  # Singular matrix

        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            A_inv, det_A, L, U = gaussel3(A, verbose=False)

        assert A_inv is None, "Singular matrix should not have inverse"
        assert abs(det_A) < 1e-10, f"Determinant should be ~0, got {det_A}"
        assert L is None, "L should be None for singular matrix"
        assert U is None, "U should be None for singular matrix"

    def test_identity_matrix_inverse(self) -> None:
        """Test inverse of identity matrix"""
        A = np.eye(3)

        A_inv, det_A, L, U = gaussel3(A, verbose=False)

        assert A_inv is not None, "Identity matrix should be invertible"
        assert abs(det_A - 1.0) < 1e-10, f"Determinant should be 1, got {det_A}"

        # Inverse of identity should be identity
        error = np.linalg.norm(A_inv - np.eye(3))
        assert error < 1e-10, f"Identity inverse error: {error}"

        # L should be identity, U should be identity
        if L is not None and U is not None:
            l_error = np.linalg.norm(L - np.eye(3))
            u_error = np.linalg.norm(U - np.eye(3))
            assert l_error < 1e-10, f"L matrix error: {l_error}"
            assert u_error < 1e-10, f"U matrix error: {u_error}"

    def test_2x2_matrix(self) -> None:
        """Test with a simple 2x2 matrix"""
        A = np.array([[1, 2], [3, 4]], dtype=float)

        A_inv, det_A, L, U = gaussel3(A, verbose=False)

        assert A_inv is not None, "2x2 matrix should be invertible"

        # Analytical determinant: 1*4 - 2*3 = -2
        expected_det = -2.0
        assert (
            abs(det_A - expected_det) < 1e-10
        ), f"Expected det={expected_det}, got {det_A}"

        # Test inversion
        identity_check = A @ A_inv
        error = np.linalg.norm(identity_check - np.eye(2))
        assert error < 1e-10, f"2x2 inversion error: {error}"

    def test_non_square_matrix(self) -> None:
        """Test error handling for non-square matrix"""
        A = np.array([[1, 2, 3], [4, 5, 6]], dtype=float)  # 2x3 matrix

        with pytest.raises(ValueError, match="square matrix"):
            gaussel3(A, verbose=False)

    def test_empty_matrix(self) -> None:
        """Test error handling for empty matrix"""
        A = np.array([], dtype=float).reshape(0, 0)

        with pytest.raises(ValueError, match="cannot be empty"):
            gaussel3(A, verbose=False)

    def test_verbose_output(self) -> None:
        """Test that verbose mode works without error"""
        A = np.array([[1, 0], [0, 1]], dtype=float)

        # Should not raise any errors
        A_inv, det_A, L, U = gaussel3(A, verbose=True)
        assert A_inv is not None


class TestIntegration:
    """Integration tests using all functions together"""

    def test_consistency_between_methods(self) -> None:
        """Test that all three methods give consistent results"""
        A = np.array([[2, 1, -1], [-3, -1, 2], [-2, 1, 2]], dtype=float)
        b = np.array([8, -11, -3], dtype=float)

        # Solve using different methods
        x1 = gaussel1(A, b)
        x2 = gaussel2(A, b, use_partial_pivoting=True)
        x3 = gaussel2(A, b, use_partial_pivoting=False)

        # All should give the same solution
        assert np.allclose(x1, x2, atol=1e-10), "gaussel1 and gaussel2 (partial) differ"
        assert np.allclose(x1, x3, atol=1e-10), "gaussel1 and gaussel2 (full) differ"
        assert np.allclose(x2, x3, atol=1e-10), "gaussel2 partial and full differ"

    def test_solve_using_inverse(self) -> None:
        """Test solving system using computed inverse"""
        A = np.array([[2, 1, -1], [-3, -1, 2], [-2, 1, 2]], dtype=float)
        b = np.array([8, -11, -3], dtype=float)

        # Get inverse using gaussel3
        A_inv, _, _, _ = gaussel3(A, verbose=False)
        assert A_inv is not None, "Matrix should be invertible"

        # Solve using inverse
        x_inverse = A_inv @ b

        # Solve using direct method
        x_direct = gaussel1(A, b)

        # Should give same result
        assert np.allclose(
            x_inverse, x_direct, atol=1e-10
        ), "Inverse and direct methods differ"

    def test_round_trip_accuracy(self) -> None:
        """Test numerical accuracy of round-trip operations"""
        # Create a well-conditioned matrix
        A = np.array([[4, 1, 2], [1, 5, 3], [2, 3, 6]], dtype=float)

        # Get LU decomposition
        A_inv, det_A, L, U = gaussel3(A, verbose=False)

        assert A_inv is not None, "Matrix should be invertible"
        assert L is not None and U is not None, "LU decomposition should exist"

        # Test LU decomposition accuracy
        if L is not None and U is not None:
            lu_product = L @ U
            lu_error = np.linalg.norm(lu_product - A)
            assert lu_error < 1e-12, f"LU decomposition error: {lu_error}"

        # Test inverse accuracy
        identity_product = A @ A_inv
        inverse_error = np.linalg.norm(identity_product - np.eye(3))
        assert inverse_error < 1e-12, f"Matrix inverse error: {inverse_error}"


def test_all_functions_integration() -> None:
    """Integration test using all functions together"""
    print("=== Integration Test ===")

    # Test matrix
    A = np.array([[2, 1, -1], [-3, -1, 2], [-2, 1, 2]], dtype=float)
    b = np.array([8, -11, -3], dtype=float)

    print(f"Matrix A:")
    print(A)
    print(f"Vector b: {b}")

    # Test all solving methods
    x1 = gaussel1(A, b)
    x2 = gaussel2(A, b, use_partial_pivoting=True)
    x3 = gaussel2(A, b, use_partial_pivoting=False)

    print(f"Solution gaussel1: {x1}")
    print(f"Solution gaussel2 (partial): {x2}")
    print(f"Solution gaussel2 (full): {x3}")

    # Test matrix inverse and LU
    A_inv, det_A, L, U = gaussel3(A, verbose=False)
    print(f"Determinant: {det_A}")
    print(f"Inverse exists: {A_inv is not None}")

    if A_inv is not None:
        x_inverse = A_inv @ b
        print(f"Solution via inverse: {x_inverse}")

    # Verify all solutions are equivalent
    assert np.allclose(x1, x2, atol=1e-10), "Methods should give same result"
    assert np.allclose(x1, x3, atol=1e-10), "Methods should give same result"
    if A_inv is not None:
        assert np.allclose(
            x1, x_inverse, atol=1e-10
        ), "Direct and inverse methods should agree"

    print("Integration test passed!")


if __name__ == "__main__":
    # Run the integration test when script is run directly
    test_all_functions_integration()

    # Run all tests with pytest when imported
    pytest.main([__file__, "-v"])
