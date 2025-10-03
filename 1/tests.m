% TESTS - Comprehensive unit tests for fl1, fl2, fl3, and fl4 functions
% This script performs thorough testing of all machine number functions using MATLAB assert functions

function tests()
    fprintf('=== Machine Number Functions Unit Tests ===\n\n');
    
    try
        % Test fl1 function
        fprintf('Testing fl1 (machine number to real number conversion):\n');
        test_fl1();
        fprintf('  ✓ All fl1 tests passed\n');
        
        % Test fl2 function
        fprintf('\nTesting fl2 (machine number set analysis):\n');
        test_fl2();
        fprintf('  ✓ All fl2 tests passed\n');
        
        % Test fl3 function
        fprintf('\nTesting fl3 (real number to machine number conversion):\n');
        test_fl3();
        fprintf('  ✓ All fl3 tests passed\n');
        
        % Test fl4 function
        fprintf('\nTesting fl4 (machine number addition):\n');
        test_fl4();
        fprintf('  ✓ All fl4 tests passed\n');
        
        fprintf('\n=== ✓ ALL TESTS PASSED! ===\n');
        
    catch ME
        fprintf('\n=== ✗ TEST FAILED ===\n');
        fprintf('Error: %s\n', ME.message);
        fprintf('In function: %s\n', ME.stack(1).name);
        fprintf('At line: %d\n', ME.stack(1).line);
        rethrow(ME);
    end
end

%% FL1 Tests
function test_fl1()
    
    % Test 1: Zero case
    machine_vec = [0, 0, 0, 0, 0];
    expected = 0;
    result = fl1(machine_vec);
    assert(abs(result - expected) < 1e-10, 'fl1: Zero case failed - Expected %.6f, got %.6f', expected, result);
    fprintf('    Test 1: Zero case ✓\n');
    
    % Test 2: Positive number
    machine_vec = [0, 1, 1, 0, 1]; % sign=0, frac=110 (0.75), k=1
    expected = (1 + 0.75) * 3^1; % 5.25
    result = fl1(machine_vec);
    assert(abs(result - expected) < 1e-10, 'fl1: Positive number failed - Expected %.6f, got %.6f', expected, result);
    fprintf('    Test 2: Positive number ✓\n');
    
    % Test 3: Negative number
    machine_vec = [1, 0, 1, 0, 0]; % sign=1, frac=010 (0.25), k=0
    expected = -(1 + 0.25) * 3^0; % -1.25
    result = fl1(machine_vec);
    assert(abs(result - expected) < 1e-10, 'fl1: Negative number failed - Expected %.6f, got %.6f', expected, result);
    fprintf('    Test 3: Negative number ✓\n');
    
    % Test 4: Minimum positive normalized number
    machine_vec = [0, 0, 0, 1, -2]; % sign=0, frac=001 (0.125), k=-2
    expected = (1 + 0.125) * 3^(-2); % 1.125 / 9 = 0.125
    result = fl1(machine_vec);
    assert(abs(result - expected) < 1e-10, 'fl1: Minimum positive normalized failed - Expected %.6f, got %.6f', expected, result);
    fprintf('    Test 4: Minimum positive normalized ✓\n');
    
    % Test 5: Large positive number
    machine_vec = [0, 1, 1, 1, 2]; % sign=0, frac=111 (0.875), k=2
    expected = (1 + 0.875) * 3^2; % 1.875 * 9 = 16.875
    result = fl1(machine_vec);
    assert(abs(result - expected) < 1e-10, 'fl1: Large positive number failed - Expected %.6f, got %.6f', expected, result);
    fprintf('    Test 5: Large positive number ✓\n');
    
    % Test 6: Input validation - non-binary mantissa
    try
        fl1([0, 2, 1, 0, 1]); % Invalid mantissa bit
        assert(false, 'fl1: Should have thrown error for non-binary mantissa');
    catch ME
        assert(contains(ME.message, 'Mantissa bits must be 0 or 1'), 'fl1: Wrong error message for non-binary mantissa');
        fprintf('    Test 6: Input validation - non-binary mantissa ✓\n');
    end
    
    % Test 7: Input validation - non-integer characteristic
    try
        fl1([0, 1, 0, 1, 1.5]); % Invalid characteristic
        assert(false, 'fl1: Should have thrown error for non-integer characteristic');
    catch ME
        assert(contains(ME.message, 'Characteristic must be an integer'), 'fl1: Wrong error message for non-integer characteristic');
        fprintf('    Test 7: Input validation - non-integer characteristic ✓\n');
    end
    
    % Test 8: Input validation - too short vector
    try
        fl1([1]); % Too short
        assert(false, 'fl1: Should have thrown error for short vector');
    catch ME
        assert(contains(ME.message, 'Input must be a vector with at least 2 elements'), 'fl1: Wrong error message for short vector');
        fprintf('    Test 8: Input validation - too short vector ✓\n');
    end
end

%% FL2 Tests
function test_fl2()
    
    % Test parameters
    t = 3; k1 = -1; k2 = 1;
    
    % Test 1: Basic functionality
    [M_inf, eps_0, eps_1, num_elements] = fl2(t, k1, k2, false);
    assert(M_inf > 0, 'fl2: M_inf should be positive, got %.6f', M_inf);
    assert(eps_0 > 0, 'fl2: eps_0 should be positive, got %.6f', eps_0);
    assert(num_elements > 0, 'fl2: num_elements should be positive, got %d', num_elements);
    fprintf('    Test 1: Basic functionality ✓\n');
    
    % Test 2: M_inf calculation for known case
    % For t=3, k2=1: Maximum mantissa is [0,1,1] = 1 + 0.75 = 1.75
    % M_inf = 1.75 * 3^1 = 5.25
    expected_M_inf = 1.75 * 3;
    assert(abs(M_inf - expected_M_inf) < 1e-10, 'fl2: M_inf calculation failed - Expected %.6f, got %.6f', expected_M_inf, M_inf);
    fprintf('    Test 2: M_inf calculation ✓\n');
    
    % Test 3: eps_0 calculation for known case  
    % For t=3, k1=-1: Minimum mantissa is [0,0,1] = 1 + 0.25 = 1.25
    % eps_0 = 1.25 * 3^(-1) = 0.416667
    expected_eps_0 = 1.25 / 3;
    assert(abs(eps_0 - expected_eps_0) < 1e-10, 'fl2: eps_0 calculation failed - Expected %.6f, got %.6f', expected_eps_0, eps_0);
    fprintf('    Test 3: eps_0 calculation ✓\n');
    
    % Test 4: Element count reasonableness
    assert(num_elements >= 10, 'fl2: Element count too low: %d', num_elements);
    assert(num_elements <= 100, 'fl2: Element count too high: %d', num_elements);
    fprintf('    Test 4: Element count reasonableness ✓\n');
    
    % Test 5: Parameter validation - invalid t
    try
        fl2(0, k1, k2, false); % Invalid t
        assert(false, 'fl2: Should have thrown error for invalid t');
    catch ME
        assert(contains(ME.message, 't must be a positive integer'), 'fl2: Wrong error message for invalid t');
        fprintf('    Test 5: Input validation - invalid t ✓\n');
    end
    
    % Test 6: Parameter validation - k1 >= k2
    try
        fl2(t, 1, -1, false); % k1 > k2
        assert(false, 'fl2: Should have thrown error for k1 >= k2');
    catch ME
        assert(contains(ME.message, 'k1 must be less than k2'), 'fl2: Wrong error message for k1 >= k2');
        fprintf('    Test 6: Input validation - k1 >= k2 ✓\n');
    end
    
    % Test 7: Parameter validation - non-integer k values
    try
        fl2(t, 1.5, 2, false); % Non-integer k1
        assert(false, 'fl2: Should have thrown error for non-integer k1');
    catch ME
        assert(contains(ME.message, 'k1 and k2 must be integers'), 'fl2: Wrong error message for non-integer k values');
        fprintf('    Test 7: Input validation - non-integer k values ✓\n');
    end
end

%% FL3 Tests
function test_fl3()
    
    % Test parameters
    t = 4; k1 = -2; k2 = 2;
    
    % Test 1: Zero conversion
    machine_vec = fl3(0, t, k1, k2);
    expected = [zeros(1, t), 0];
    assert(isequal(machine_vec, expected), 'fl3: Zero conversion failed');
    fprintf('    Test 1: Zero conversion ✓\n');
    
    % Test 2: Round-trip conversion (positive)
    original_real = 2.5;
    machine_vec = fl3(original_real, t, k1, k2);
    reconstructed = fl1(machine_vec);
    rel_error = abs(reconstructed - original_real) / abs(original_real);
    assert(rel_error < 0.3, 'fl3: Round-trip error too large for positive number: %.6f', rel_error);
    fprintf('    Test 2: Round-trip conversion (positive) ✓\n');
    
    % Test 3: Round-trip conversion (negative)
    original_real = -1.8;
    machine_vec = fl3(original_real, t, k1, k2);
    reconstructed = fl1(machine_vec);
    rel_error = abs(reconstructed - original_real) / abs(original_real);
    assert(rel_error < 0.3, 'fl3: Round-trip error too large for negative number: %.6f', rel_error);
    fprintf('    Test 3: Round-trip conversion (negative) ✓\n');
    
    % Test 4: Sign bit correctness
    pos_machine = fl3(1.5, t, k1, k2);
    neg_machine = fl3(-1.5, t, k1, k2);
    assert(pos_machine(1) == 0, 'fl3: Positive number should have sign bit 0');
    assert(neg_machine(1) == 1, 'fl3: Negative number should have sign bit 1');
    fprintf('    Test 4: Sign bit correctness ✓\n');
    
    % Test 5: Output vector length
    machine_vec = fl3(3.14, t, k1, k2);
    assert(length(machine_vec) == t + 1, 'fl3: Output vector should have length t+1=%d, got %d', t+1, length(machine_vec));
    fprintf('    Test 5: Output vector length ✓\n');
    
    % Test 6: Input validation - non-real input
    try
        fl3(1 + 2i, t, k1, k2); % Complex number
        assert(false, 'fl3: Should have thrown error for complex input');
    catch ME
        assert(contains(ME.message, 'Input must be a real scalar'), 'fl3: Wrong error message for complex input');
        fprintf('    Test 6: Input validation - complex input ✓\n');
    end
    
    % Test 7: Input validation - invalid parameters
    try
        fl3(1.0, -1, k1, k2); % Invalid t
        assert(false, 'fl3: Should have thrown error for invalid t');
    catch ME
        assert(contains(ME.message, 't must be a positive integer'), 'fl3: Wrong error message for invalid t');
        fprintf('    Test 7: Input validation - invalid parameters ✓\n');
    end
    
    % Test 8: Boundary values (small positive number)
    [~, eps_0, ~, ~] = fl2(t, k1, k2, false);
    small_num = eps_0 * 1.1; % Just above minimum
    machine_vec = fl3(small_num, t, k1, k2);
    reconstructed = fl1(machine_vec);
    assert(reconstructed > 0, 'fl3: Small positive number should reconstruct to positive value');
    fprintf('    Test 8: Boundary values (small positive) ✓\n');
end

%% FL4 Tests
function test_fl4()
    
    t = 4;
    
    % Test 1: Addition of two positive numbers
    vec1 = [0, 1, 1, 0, 1]; % Positive number
    vec2 = [0, 1, 0, 0, 0]; % Another positive number
    
    real1 = fl1(vec1);
    real2 = fl1(vec2);
    expected_sum = real1 + real2;
    
    result_vec = fl4(vec1, vec2);
    result_real = fl1(result_vec);
    
    rel_error = abs(result_real - expected_sum) / abs(expected_sum);
    assert(rel_error < 0.3, 'fl4: Addition error too large: %.6f', rel_error);
    fprintf('    Test 1: Addition of positive numbers ✓\n');
    
    % Test 2: Addition with different characteristics
    vec1 = [0, 1, 1, 0, 2]; % Higher characteristic
    vec2 = [0, 1, 0, 0, 0]; % Lower characteristic
    
    real1 = fl1(vec1);
    real2 = fl1(vec2);
    expected_sum = real1 + real2;
    
    result_vec = fl4(vec1, vec2);
    result_real = fl1(result_vec);
    
    rel_error = abs(result_real - expected_sum) / abs(expected_sum);
    assert(rel_error < 0.3, 'fl4: Addition with different characteristics error too large: %.6f', rel_error);
    fprintf('    Test 2: Addition with different characteristics ✓\n');
    
    % Test 3: Subtraction (pos + neg)
    vec1 = [0, 1, 1, 0, 1]; % Positive number
    vec2 = [1, 1, 0, 0, 1]; % Negative number with same characteristic
    
    real1 = fl1(vec1);
    real2 = fl1(vec2);
    expected_diff = real1 + real2;
    
    result_vec = fl4(vec1, vec2);
    result_real = fl1(result_vec);
    
    rel_error = abs(result_real - expected_diff) / max(abs(expected_diff), 1e-10);
    assert(rel_error < 0.5, 'fl4: Subtraction error too large: %.6f', rel_error);
    fprintf('    Test 3: Subtraction (pos + neg) ✓\n');
    
    % Test 4: Adding zero
    vec1 = [0, 1, 1, 0, 1]; % Non-zero number
    vec_zero = [0, 0, 0, 0, 0]; % Zero
    
    result_vec = fl4(vec1, vec_zero);
    assert(isequal(result_vec, vec1), 'fl4: Adding zero should return original vector');
    
    result_vec2 = fl4(vec_zero, vec1);
    assert(isequal(result_vec2, vec1), 'fl4: Zero + number should return number');
    fprintf('    Test 4: Adding zero ✓\n');
    
    % Test 5: Commutativity (a + b = b + a)
    vec1 = [0, 1, 1, 0, 1];
    vec2 = [0, 1, 0, 1, 0];
    
    result1 = fl4(vec1, vec2);
    result2 = fl4(vec2, vec1);
    
    real1 = fl1(result1);
    real2 = fl1(result2);
    
    assert(abs(real1 - real2) < 1e-8, 'fl4: Commutativity failed: %.6f vs %.6f', real1, real2);
    fprintf('    Test 5: Commutativity ✓\n');
    
    % Test 6: Output vector structure
    vec1 = [0, 1, 1, 0, 1];
    vec2 = [0, 1, 0, 0, 0];
    result_vec = fl4(vec1, vec2);
    
    assert(length(result_vec) == length(vec1), 'fl4: Output vector should have same length as input');
    mantissa_bits = result_vec(1:end-1);
    assert(all(mantissa_bits == 0 | mantissa_bits == 1), 'fl4: All mantissa bits should be 0 or 1');
    assert(result_vec(end) == round(result_vec(end)), 'fl4: Characteristic should be integer');
    fprintf('    Test 6: Output vector structure ✓\n');
    
    % Test 7: Input validation - different lengths
    try
        vec1 = [0, 1, 1, 0, 1];
        vec2 = [0, 1, 1, 0]; % Different length
        fl4(vec1, vec2);
        assert(false, 'fl4: Should have thrown error for different lengths');
    catch ME
        assert(contains(ME.message, 'Input vectors must have the same length'), 'fl4: Wrong error message for different lengths');
        fprintf('    Test 7: Input validation - different lengths ✓\n');
    end
    
    % Test 8: Input validation - invalid mantissa bits
    try
        vec1 = [0, 1, 2, 0, 1]; % Invalid bit
        vec2 = [0, 1, 1, 0, 1];
        fl4(vec1, vec2);
        assert(false, 'fl4: Should have thrown error for invalid mantissa bits');
    catch ME
        assert(contains(ME.message, 'Mantissa bits must be 0 or 1'), 'fl4: Wrong error message for invalid mantissa bits');
        fprintf('    Test 8: Input validation - invalid mantissa bits ✓\n');
    end
    
    % Test 9: Input validation - non-integer characteristic
    try
        vec1 = [0, 1, 1, 0, 1.5]; % Non-integer characteristic
        vec2 = [0, 1, 1, 0, 1];
        fl4(vec1, vec2);
        assert(false, 'fl4: Should have thrown error for non-integer characteristic');
    catch ME
        assert(contains(ME.message, 'Characteristics must be integers'), 'fl4: Wrong error message for non-integer characteristic');
        fprintf('    Test 9: Input validation - non-integer characteristic ✓\n');
    end
end