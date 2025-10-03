"""
Comprehensive unit tests for fl1, fl2, fl3, and fl4 functions
This script performs thorough testing of all machine number functions using pytest
"""

import pytest
import numpy as np
from ex1_machine_numbers import fl1, fl2, fl3, fl4


class TestFL1:
    """Tests for fl1 function (machine number to real number conversion)"""

    def test_zero_case(self) -> None:
        """Test zero case"""
        machine_vec = [0, 0, 0, 0, 0]
        expected = 0
        result = fl1(machine_vec)
        assert (
            abs(result - expected) < 1e-10
        ), f"fl1: Zero case failed - Expected {expected:.6f}, got {result:.6f}"

    def test_positive_number(self) -> None:
        """Test positive number"""
        machine_vec = [0, 1, 1, 0, 1]  # sign=0, frac=110 (0.75), k=1
        expected = (1 + 0.75) * 3**1  # 5.25
        result = fl1(machine_vec)
        assert (
            abs(result - expected) < 1e-10
        ), f"fl1: Positive number failed - Expected {expected:.6f}, got {result:.6f}"

    def test_negative_number(self) -> None:
        """Test negative number"""
        machine_vec = [1, 0, 1, 0, 0]  # sign=1, frac=010 (0.25), k=0
        expected = -(1 + 0.25) * 3**0  # -1.25
        result = fl1(machine_vec)
        assert (
            abs(result - expected) < 1e-10
        ), f"fl1: Negative number failed - Expected {expected:.6f}, got {result:.6f}"

    def test_minimum_positive_normalized(self) -> None:
        """Test minimum positive normalized number"""
        machine_vec = [0, 0, 0, 1, -2]  # sign=0, frac=001 (0.125), k=-2
        expected = (1 + 0.125) * 3 ** (-2)  # 1.125 / 9 = 0.125
        result = fl1(machine_vec)
        assert (
            abs(result - expected) < 1e-10
        ), f"fl1: Minimum positive normalized failed - Expected {expected:.6f}, got {result:.6f}"

    def test_large_positive_number(self) -> None:
        """Test large positive number"""
        machine_vec = [0, 1, 1, 1, 2]  # sign=0, frac=111 (0.875), k=2
        expected = (1 + 0.875) * 3**2  # 1.875 * 9 = 16.875
        result = fl1(machine_vec)
        assert (
            abs(result - expected) < 1e-10
        ), f"fl1: Large positive number failed - Expected {expected:.6f}, got {result:.6f}"

    def test_non_binary_mantissa(self) -> None:
        """Test input validation - non-binary mantissa"""
        with pytest.raises(ValueError, match="Mantissa bits must be 0 or 1"):
            fl1([0, 2, 1, 0, 1])  # Invalid mantissa bit

    def test_non_integer_characteristic(self) -> None:
        """Test input validation - non-integer characteristic"""
        with pytest.raises(ValueError, match="Characteristic must be an integer"):
            fl1([0, 1, 0, 1, 1.5])  # Invalid characteristic

    def test_too_short_vector(self) -> None:
        """Test input validation - too short vector"""
        with pytest.raises(
            ValueError, match="Input must be a vector with at least 2 elements"
        ):
            fl1([1])  # Too short


class TestFL2:
    """Tests for fl2 function (machine number set analysis)"""

    def test_basic_functionality(self) -> None:
        """Test basic functionality"""
        t, k1, k2 = 3, -1, 1
        M_inf, eps_0, eps_1, num_elements = fl2(t, k1, k2, show_plot=False)
        assert M_inf > 0, f"fl2: M_inf should be positive, got {M_inf:.6f}"
        assert eps_0 > 0, f"fl2: eps_0 should be positive, got {eps_0:.6f}"
        assert (
            num_elements > 0
        ), f"fl2: num_elements should be positive, got {num_elements}"

    def test_m_inf_calculation(self) -> None:
        """Test M_inf calculation for known case"""
        t, k1, k2 = 3, -1, 1
        M_inf, _, _, _ = fl2(t, k1, k2, show_plot=False)
        # For t=3, k2=1: Maximum mantissa is [0,1,1] = 1 + 0.75 = 1.75
        # M_inf = 1.75 * 3^1 = 5.25
        expected_M_inf = 1.75 * 3
        assert (
            abs(M_inf - expected_M_inf) < 1e-10
        ), f"fl2: M_inf calculation failed - Expected {expected_M_inf:.6f}, got {M_inf:.6f}"

    def test_eps_0_calculation(self) -> None:
        """Test eps_0 calculation for known case"""
        t, k1, k2 = 3, -1, 1
        _, eps_0, _, _ = fl2(t, k1, k2, show_plot=False)
        # For t=3, k1=-1: Minimum mantissa is [0,0,1] = 1 + 0.25 = 1.25
        # eps_0 = 1.25 * 3^(-1) = 0.416667
        expected_eps_0 = 1.25 / 3
        assert (
            abs(eps_0 - expected_eps_0) < 1e-10
        ), f"fl2: eps_0 calculation failed - Expected {expected_eps_0:.6f}, got {eps_0:.6f}"

    def test_element_count_reasonableness(self) -> None:
        """Test element count reasonableness"""
        t, k1, k2 = 3, -1, 1
        _, _, _, num_elements = fl2(t, k1, k2, show_plot=False)
        assert (
            10 <= num_elements <= 100
        ), f"fl2: Element count unreasonable: {num_elements}"

    def test_invalid_t(self) -> None:
        """Test parameter validation - invalid t"""
        with pytest.raises(ValueError, match="t must be a positive integer"):
            fl2(0, -1, 1, show_plot=False)  # Invalid t

    def test_invalid_k_order(self) -> None:
        """Test parameter validation - k1 >= k2"""
        with pytest.raises(ValueError, match="k1 must be less than k2"):
            fl2(3, 1, -1, show_plot=False)  # k1 > k2

    def test_non_integer_k_values(self) -> None:
        """Test parameter validation - non-integer k values"""
        with pytest.raises(ValueError, match="k1 and k2 must be integers"):
            fl2(3, 1.5, 2, show_plot=False)  # type: ignore[arg-type]


class TestFL3:
    """Tests for fl3 function (real number to machine number conversion)"""

    def test_zero_conversion(self) -> None:
        """Test zero conversion"""
        t, k1, k2 = 4, -2, 2
        machine_vec = fl3(0, t, k1, k2)
        expected = np.append(np.zeros(t), 0)
        assert np.array_equal(machine_vec, expected), "fl3: Zero conversion failed"

    def test_round_trip_positive(self) -> None:
        """Test round-trip conversion (positive)"""
        t, k1, k2 = 4, -2, 2
        original_real = 2.5
        machine_vec = fl3(original_real, t, k1, k2)
        reconstructed = fl1(machine_vec)
        rel_error = abs(reconstructed - original_real) / abs(original_real)
        assert (
            rel_error < 0.3
        ), f"fl3: Round-trip error too large for positive number: {rel_error:.6f}"

    def test_round_trip_negative(self) -> None:
        """Test round-trip conversion (negative)"""
        t, k1, k2 = 4, -2, 2
        original_real = -1.8
        machine_vec = fl3(original_real, t, k1, k2)
        reconstructed = fl1(machine_vec)
        rel_error = abs(reconstructed - original_real) / abs(original_real)
        assert (
            rel_error < 0.3
        ), f"fl3: Round-trip error too large for negative number: {rel_error:.6f}"

    def test_sign_bit_correctness(self) -> None:
        """Test sign bit correctness"""
        t, k1, k2 = 4, -2, 2
        pos_machine = fl3(1.5, t, k1, k2)
        neg_machine = fl3(-1.5, t, k1, k2)
        assert pos_machine[0] == 0, "fl3: Positive number should have sign bit 0"
        assert neg_machine[0] == 1, "fl3: Negative number should have sign bit 1"

    def test_output_vector_length(self) -> None:
        """Test output vector length"""
        t, k1, k2 = 4, -2, 2
        machine_vec = fl3(3.14, t, k1, k2)
        assert (
            len(machine_vec) == t + 1
        ), f"fl3: Output vector should have length t+1={t+1}, got {len(machine_vec)}"

    def test_complex_input(self) -> None:
        """Test input validation - complex input"""
        with pytest.raises(ValueError, match="Input must be a real scalar"):
            fl3(complex(1, 2), 4, -2, 2)  # type: ignore[arg-type]

    def test_invalid_parameters(self) -> None:
        """Test input validation - invalid parameters"""
        with pytest.raises(ValueError, match="t must be a positive integer"):
            fl3(1.0, -1, -2, 2)  # Invalid t

    def test_boundary_values(self) -> None:
        """Test boundary values (small positive number)"""
        t, k1, k2 = 4, -2, 2
        _, eps_0, _, _ = fl2(t, k1, k2, show_plot=False)
        small_num = eps_0 * 1.1  # Just above minimum
        machine_vec = fl3(small_num, t, k1, k2)
        reconstructed = fl1(machine_vec)
        assert (
            reconstructed > 0
        ), "fl3: Small positive number should reconstruct to positive value"


class TestFL4:
    """Tests for fl4 function (machine number addition)"""

    def test_addition_positive_numbers(self) -> None:
        """Test addition of two positive numbers"""
        vec1 = [0, 1, 1, 0, 1]  # Positive number
        vec2 = [0, 1, 0, 0, 0]  # Another positive number

        real1 = fl1(vec1)
        real2 = fl1(vec2)
        expected_sum = real1 + real2

        result_vec = fl4(vec1, vec2)
        result_real = fl1(result_vec)

        rel_error = abs(result_real - expected_sum) / abs(expected_sum)
        assert rel_error < 0.3, f"fl4: Addition error too large: {rel_error:.6f}"

    def test_addition_different_characteristics(self) -> None:
        """Test addition with different characteristics"""
        vec1 = [0, 1, 1, 0, 2]  # Higher characteristic
        vec2 = [0, 1, 0, 0, 0]  # Lower characteristic

        real1 = fl1(vec1)
        real2 = fl1(vec2)
        expected_sum = real1 + real2

        result_vec = fl4(vec1, vec2)
        result_real = fl1(result_vec)

        rel_error = abs(result_real - expected_sum) / abs(expected_sum)
        assert (
            rel_error < 0.3
        ), f"fl4: Addition with different characteristics error too large: {rel_error:.6f}"

    def test_subtraction(self) -> None:
        """Test subtraction (pos + neg)"""
        vec1 = [0, 1, 1, 0, 1]  # Positive number
        vec2 = [1, 1, 0, 0, 1]  # Negative number with same characteristic

        real1 = fl1(vec1)
        real2 = fl1(vec2)
        expected_diff = real1 + real2

        result_vec = fl4(vec1, vec2)
        result_real = fl1(result_vec)

        rel_error = abs(result_real - expected_diff) / max(abs(expected_diff), 1e-10)
        assert rel_error < 0.5, f"fl4: Subtraction error too large: {rel_error:.6f}"

    def test_adding_zero(self) -> None:
        """Test adding zero"""
        vec1 = [0, 1, 1, 0, 1]  # Non-zero number
        vec_zero = [0, 0, 0, 0, 0]  # Zero

        result_vec = fl4(vec1, vec_zero)
        assert np.array_equal(
            result_vec, vec1
        ), "fl4: Adding zero should return original vector"

        result_vec2 = fl4(vec_zero, vec1)
        assert np.array_equal(
            result_vec2, vec1
        ), "fl4: Zero + number should return number"

    def test_commutativity(self) -> None:
        """Test commutativity (a + b = b + a)"""
        vec1 = [0, 1, 1, 0, 1]
        vec2 = [0, 1, 0, 1, 0]

        result1 = fl4(vec1, vec2)
        result2 = fl4(vec2, vec1)

        real1 = fl1(result1)
        real2 = fl1(result2)

        assert (
            abs(real1 - real2) < 1e-8
        ), f"fl4: Commutativity failed: {real1:.6f} vs {real2:.6f}"

    def test_output_vector_structure(self) -> None:
        """Test output vector structure"""
        vec1 = [0, 1, 1, 0, 1]
        vec2 = [0, 1, 0, 0, 0]
        result_vec = fl4(vec1, vec2)

        assert len(result_vec) == len(
            vec1
        ), "fl4: Output vector should have same length as input"
        mantissa_bits = result_vec[:-1]
        assert np.all(
            (mantissa_bits == 0) | (mantissa_bits == 1)
        ), "fl4: All mantissa bits should be 0 or 1"
        assert result_vec[-1] == int(
            result_vec[-1]
        ), "fl4: Characteristic should be integer"

    def test_different_lengths(self) -> None:
        """Test input validation - different lengths"""
        vec1 = [0, 1, 1, 0, 1]
        vec2 = [0, 1, 1, 0]  # Different length
        with pytest.raises(ValueError, match="Input vectors must have the same length"):
            fl4(vec1, vec2)

    def test_invalid_mantissa_bits(self) -> None:
        """Test input validation - invalid mantissa bits"""
        vec1 = [0, 1, 2, 0, 1]  # Invalid bit
        vec2 = [0, 1, 1, 0, 1]
        with pytest.raises(ValueError, match="Mantissa bits must be 0 or 1"):
            fl4(vec1, vec2)

    def test_non_integer_characteristic(self) -> None:
        """Test input validation - non-integer characteristic"""
        vec1 = [0, 1, 1, 0, 1.5]  # Non-integer characteristic
        vec2 = [0, 1, 1, 0, 1]
        with pytest.raises(ValueError, match="Characteristics must be integers"):
            fl4(vec1, vec2)


def test_all_functions_integration() -> None:
    """Integration test using all functions together"""
    print("=== Integration Test ===")

    # Parameters
    t, k1, k2 = 4, -2, 2

    # Get machine number set properties
    M_inf, eps_0, eps_1, num_elements = fl2(t, k1, k2, show_plot=False)
    print(
        f"Machine number set: {num_elements} elements, M_∞={M_inf:.3f}, ε_0={eps_0:.6f}"
    )

    # Test real -> machine -> real conversion
    test_real = 3.5
    machine_rep = fl3(test_real, t, k1, k2)
    reconstructed = fl1(machine_rep)
    print(
        f"Real {test_real} -> Machine {[int(x) for x in machine_rep]} -> Real {reconstructed:.6f}"
    )

    # Test machine arithmetic
    vec1 = fl3(2.0, t, k1, k2)
    vec2 = fl3(1.5, t, k1, k2)
    sum_vec = fl4(vec1, vec2)
    sum_real = fl1(sum_vec)
    print(f"Machine addition: 2.0 + 1.5 = {sum_real:.6f}")

    assert abs(sum_real - 3.5) < 0.5, "Integration test failed"
    print("Integration test passed!")


if __name__ == "__main__":
    # Run the integration test when script is run directly
    test_all_functions_integration()

    # Run all tests with pytest when imported
    pytest.main([__file__, "-v"])
