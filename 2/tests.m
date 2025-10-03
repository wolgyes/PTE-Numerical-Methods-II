function tests()
% TESTS - Comprehensive test suite for all Gaussian Elimination functions

fprintf('=====================================\n');
fprintf('GAUSSIAN ELIMINATION TEST SUITE\n');
fprintf('=====================================\n\n');

total_tests = 0;
total_passed = 0;

fprintf('-------------------------------------\n');
fprintf('Testing gaussel1 function\n');
fprintf('-------------------------------------\n');
[tests1, passed1] = test_gaussel1_suite();
total_tests = total_tests + tests1;
total_passed = total_passed + passed1;

fprintf('\n-------------------------------------\n');
fprintf('Testing gaussel2 function\n');
fprintf('-------------------------------------\n');
[tests2, passed2] = test_gaussel2_suite();
total_tests = total_tests + tests2;
total_passed = total_passed + passed2;

fprintf('\n-------------------------------------\n');
fprintf('Testing gaussel3 function\n');
fprintf('-------------------------------------\n');
[tests3, passed3] = test_gaussel3_suite();
total_tests = total_tests + tests3;
total_passed = total_passed + passed3;

fprintf('\n=====================================\n');
fprintf('FINAL TEST SUMMARY\n');
fprintf('=====================================\n');
fprintf('Total tests run: %d\n', total_tests);
fprintf('Total tests passed: %d\n', total_passed);
fprintf('Total tests failed: %d\n', total_tests - total_passed);
fprintf('Success rate: %.1f%%\n', 100 * total_passed / total_tests);

if total_passed == total_tests
    fprintf('\n✓ ALL TESTS PASSED!\n');
else
    fprintf('\n✗ Some tests failed. Please review the output above.\n');
end

end

function [test_count, pass_count] = test_gaussel1_suite()

    fprintf('\nRunning gaussel1 tests...\n\n');

    test_count = 0;
    pass_count = 0;

    test_count = test_count + 1;
    fprintf('Test %d: Simple 3x3 system\n', test_count);
    A = [2 1 -1; -3 -1 2; -2 1 2];
    b = [8; -11; -3];
    expected_x = [2; 3; -1];
    x = gaussel1(A, b);
    if norm(x - expected_x) < 1e-10
        fprintf('  PASS\n');
        pass_count = pass_count + 1;
    else
        fprintf('  FAIL: Expected [2; 3; -1], got [%.4f; %.4f; %.4f]\n', x(1), x(2), x(3));
    end

    test_count = test_count + 1;
    fprintf('Test %d: 2x2 system\n', test_count);
    A = [3 -2; 1 4];
    b = [1; 11];
    expected_x = [13/7; 16/7];
    x = gaussel1(A, b);
    if norm(x - expected_x) < 1e-10
        fprintf('  PASS\n');
        pass_count = pass_count + 1;
    else
        fprintf('  FAIL: Expected [%.4f; %.4f], got [%.4f; %.4f]\n', expected_x(1), expected_x(2), x(1), x(2));
    end

    test_count = test_count + 1;
    fprintf('Test %d: Identity matrix\n', test_count);
    A = eye(3);
    b = [1; 2; 3];
    expected_x = [1; 2; 3];
    x = gaussel1(A, b);
    if norm(x - expected_x) < 1e-10
        fprintf('  PASS\n');
        pass_count = pass_count + 1;
    else
        fprintf('  FAIL: Expected [1; 2; 3], got [%.4f; %.4f; %.4f]\n', x(1), x(2), x(3));
    end

    test_count = test_count + 1;
    fprintf('Test %d: Multiple right-hand sides\n', test_count);
    A = [1 2; 3 4];
    b = [5 1; 11 2];
    expected_x = [1 0; 2 0.5];
    x = gaussel1(A, b);
    if norm(x - expected_x) < 1e-10
        fprintf('  PASS\n');
        pass_count = pass_count + 1;
    else
        fprintf('  FAIL: Multiple RHS test failed\n');
    end

    test_count = test_count + 1;
    fprintf('Test %d: System requiring row swap\n', test_count);
    A = [0 2 1; 1 -1 3; 2 1 -1];
    b = [1; 8; 1];
    try
        x = gaussel1(A, b);
        verification = A * x;
        if norm(verification - b) < 1e-10
            fprintf('  PASS\n');
            pass_count = pass_count + 1;
        else
            fprintf('  FAIL: Ax != b\n');
        end
    catch ME
        fprintf('  FAIL: Function should handle this case with row swapping\n');
    end

    test_count = test_count + 1;
    fprintf('Test %d: Incompatible dimensions error\n', test_count);
    A = [1 2; 3 4];
    b = [1; 2; 3];
    try
        x = gaussel1(A, b);
        fprintf('  FAIL: Should have thrown error for incompatible dimensions\n');
    catch ME
        if contains(ME.message, 'incompatible')
            fprintf('  PASS\n');
            pass_count = pass_count + 1;
        else
            fprintf('  FAIL: Wrong error message\n');
        end
    end

    test_count = test_count + 1;
    fprintf('Test %d: Singular matrix error\n', test_count);
    A = [1 2; 2 4];
    b = [1; 2];
    try
        x = gaussel1(A, b);
        fprintf('  FAIL: Should have thrown error for singular matrix\n');
    catch ME
        if contains(ME.message, 'pivoting')
            fprintf('  PASS\n');
            pass_count = pass_count + 1;
        else
            fprintf('  FAIL: Wrong error message\n');
        end
    end

    fprintf('\ngaussel1 summary: %d/%d tests passed\n', pass_count, test_count);
end

function [test_count, pass_count] = test_gaussel2_suite()

    fprintf('\nRunning gaussel2 tests...\n\n');

    test_count = 0;
    pass_count = 0;

    test_count = test_count + 1;
    fprintf('Test %d: Simple 3x3 system with partial pivoting\n', test_count);
    A = [2 1 -1; -3 -1 2; -2 1 2];
    b = [8; -11; -3];
    expected_x = [2; 3; -1];
    x = gaussel2(A, b, true);
    if norm(x - expected_x) < 1e-10
        fprintf('  PASS\n');
        pass_count = pass_count + 1;
    else
        fprintf('  FAIL: Expected [2; 3; -1], got [%.4f; %.4f; %.4f]\n', x(1), x(2), x(3));
    end

    test_count = test_count + 1;
    fprintf('Test %d: Simple 3x3 system with full pivoting\n', test_count);
    A = [2 1 -1; -3 -1 2; -2 1 2];
    b = [8; -11; -3];
    x = gaussel2(A, b, false);
    verification = A * x;
    if norm(verification - b) < 1e-10
        fprintf('  PASS\n');
        pass_count = pass_count + 1;
    else
        fprintf('  FAIL: Ax != b\n');
    end

    test_count = test_count + 1;
    fprintf('Test %d: System requiring row pivoting\n', test_count);
    A = [0 2 1; 1 -1 3; 2 1 -1];
    b = [1; 8; 1];
    x = gaussel2(A, b, true);
    verification = A * x;
    if norm(verification - b) < 1e-10
        fprintf('  PASS\n');
        pass_count = pass_count + 1;
    else
        fprintf('  FAIL: Ax != b\n');
    end

    test_count = test_count + 1;
    fprintf('Test %d: System needing full pivoting\n', test_count);
    A = [0 0 1; 0 2 3; 1 4 5];
    b = [3; 8; 10];
    x = gaussel2(A, b, false);
    verification = A * x;
    if norm(verification - b) < 1e-10
        fprintf('  PASS\n');
        pass_count = pass_count + 1;
    else
        fprintf('  FAIL: Ax != b\n');
    end

    test_count = test_count + 1;
    fprintf('Test %d: Multiple right-hand sides with partial pivoting\n', test_count);
    A = [1 2; 3 4];
    b = [5 1; 11 2];
    x = gaussel2(A, b, true);
    verification = A * x;
    if norm(verification - b) < 1e-10
        fprintf('  PASS\n');
        pass_count = pass_count + 1;
    else
        fprintf('  FAIL: AX != B\n');
    end

    test_count = test_count + 1;
    fprintf('Test %d: Well-conditioned system\n', test_count);
    A = [4 -1 0; -1 4 -1; 0 -1 4];
    b = [15; 10; 10];
    x = gaussel2(A, b, true);
    verification = A * x;
    if norm(verification - b) < 1e-10
        fprintf('  PASS\n');
        pass_count = pass_count + 1;
    else
        fprintf('  FAIL: Ax != b\n');
    end

    test_count = test_count + 1;
    fprintf('Test %d: Incompatible dimensions error\n', test_count);
    A = [1 2; 3 4];
    b = [1; 2; 3];
    try
        x = gaussel2(A, b, true);
        fprintf('  FAIL: Should have thrown error for incompatible dimensions\n');
    catch ME
        if contains(ME.message, 'incompatible')
            fprintf('  PASS\n');
            pass_count = pass_count + 1;
        else
            fprintf('  FAIL: Wrong error message\n');
        end
    end

    test_count = test_count + 1;
    fprintf('Test %d: Automatic switch from partial to full pivoting\n', test_count);
    A = [0 1 2; 0 0 3; 1 2 3];
    b = [5; 6; 6];
    oldState = warning('query', 'all');
    warning('off', 'all');
    x = gaussel2(A, b, true, false);
    warning(oldState);
    verification = A * x;
    if norm(verification - b) < 1e-10
        fprintf('  PASS\n');
        pass_count = pass_count + 1;
    else
        fprintf('  FAIL: Ax != b after automatic switch\n');
    end

    test_count = test_count + 1;
    fprintf('Test %d: Identity matrix with partial pivoting\n', test_count);
    A = eye(3);
    b = [1; 2; 3];
    expected_x = [1; 2; 3];
    x = gaussel2(A, b, true);
    if norm(x - expected_x) < 1e-10
        fprintf('  PASS\n');
        pass_count = pass_count + 1;
    else
        fprintf('  FAIL: Expected [1; 2; 3], got [%.4f; %.4f; %.4f]\n', x(1), x(2), x(3));
    end

    fprintf('\ngaussel2 summary: %d/%d tests passed\n', pass_count, test_count);
end

function [test_count, pass_count] = test_gaussel3_suite()

    fprintf('\nRunning gaussel3 tests...\n\n');

    test_count = 0;
    pass_count = 0;

    test_count = test_count + 1;
    fprintf('Test %d: 2x2 matrix inverse\n', test_count);
    A = [3 2; 1 4];
    oldState = warning('query', 'all');
    warning('off', 'all');
    [A_inv, det_A, L, U] = gaussel3(A);
    warning(oldState);
    expected_det = 10;
    expected_inv = [0.4 -0.2; -0.1 0.3];
    if abs(det_A - expected_det) < 1e-10 && norm(A_inv - expected_inv) < 1e-10
        fprintf('  PASS\n');
        pass_count = pass_count + 1;
    else
        fprintf('  FAIL: Determinant or inverse incorrect\n');
    end

    test_count = test_count + 1;
    fprintf('Test %d: 3x3 matrix inverse\n', test_count);
    A = [1 2 3; 0 1 4; 5 6 0];
    oldState = warning('query', 'all');
    warning('off', 'all');
    [A_inv, det_A, L, U] = gaussel3(A);
    warning(oldState);
    identity_check = A * A_inv;
    if norm(identity_check - eye(3)) < 1e-10
        fprintf('  PASS\n');
        pass_count = pass_count + 1;
    else
        fprintf('  FAIL: A * A_inv != I\n');
    end

    test_count = test_count + 1;
    fprintf('Test %d: Identity matrix\n', test_count);
    A = eye(3);
    oldState = warning('query', 'all');
    warning('off', 'all');
    [A_inv, det_A, L, U] = gaussel3(A);
    warning(oldState);
    if abs(det_A - 1) < 1e-10 && norm(A_inv - eye(3)) < 1e-10
        fprintf('  PASS\n');
        pass_count = pass_count + 1;
    else
        fprintf('  FAIL: Identity matrix test failed\n');
    end

    test_count = test_count + 1;
    fprintf('Test %d: Diagonal matrix\n', test_count);
    A = diag([2, 3, 4]);
    oldState = warning('query', 'all');
    warning('off', 'all');
    [A_inv, det_A, L, U] = gaussel3(A);
    warning(oldState);
    expected_det = 24;
    expected_inv = diag([0.5, 1/3, 0.25]);
    if abs(det_A - expected_det) < 1e-10 && norm(A_inv - expected_inv) < 1e-10
        fprintf('  PASS\n');
        pass_count = pass_count + 1;
    else
        fprintf('  FAIL: Diagonal matrix test failed\n');
    end

    test_count = test_count + 1;
    fprintf('Test %d: LU decomposition verification\n', test_count);
    A = [4 3 2; 1 5 3; 2 1 6];
    oldState = warning('query', 'all');
    warning('off', 'all');
    [A_inv, det_A, L, U] = gaussel3(A);
    warning(oldState);
    LU_product = L * U;
    if norm(LU_product - A) < 1e-10
        fprintf('  PASS\n');
        pass_count = pass_count + 1;
    else
        fprintf('  FAIL: L * U != A\n');
    end

    test_count = test_count + 1;
    fprintf('Test %d: Non-square matrix error\n', test_count);
    A = [1 2 3; 4 5 6];
    try
        oldState = warning('query', 'all');
        warning('off', 'all');
        [A_inv, det_A, L, U] = gaussel3(A);
        warning(oldState);
        fprintf('  FAIL: Should have thrown error for non-square matrix\n');
    catch ME
        if contains(ME.message, 'square')
            fprintf('  PASS\n');
            pass_count = pass_count + 1;
        else
            fprintf('  FAIL: Wrong error message\n');
        end
    end

    test_count = test_count + 1;
    fprintf('Test %d: Singular matrix\n', test_count);
    A = [1 2; 2 4];
    oldState = warning('query', 'all');
    warning('off', 'all');
    [A_inv, det_A, L, U] = gaussel3(A);
    warning(oldState);
    if abs(det_A) < 1e-10 && isempty(A_inv)
        fprintf('  PASS\n');
        pass_count = pass_count + 1;
    else
        fprintf('  FAIL: Should detect singular matrix\n');
    end

    test_count = test_count + 1;
    fprintf('Test %d: Matrix requiring pivoting\n', test_count);
    A = [0 1 2; 1 3 4; 2 1 3];
    oldState = warning('query', 'all');
    warning('off', 'all');
    [A_inv, det_A, L, U] = gaussel3(A);
    warning(oldState);
    if ~isempty(A_inv)
        identity_check = A * A_inv;
        if norm(identity_check - eye(3)) < 1e-10
            fprintf('  PASS\n');
            pass_count = pass_count + 1;
        else
            fprintf('  FAIL: Matrix with pivoting failed\n');
        end
    else
        fprintf('  FAIL: Matrix is incorrectly detected as singular\n');
    end

    test_count = test_count + 1;
    fprintf('Test %d: Upper triangular matrix\n', test_count);
    A = [2 3 1; 0 4 2; 0 0 5];
    oldState = warning('query', 'all');
    warning('off', 'all');
    [A_inv, det_A, L, U] = gaussel3(A);
    warning(oldState);
    expected_det = 40;
    identity_check = A * A_inv;
    if abs(det_A - expected_det) < 1e-10 && norm(identity_check - eye(3)) < 1e-10
        fprintf('  PASS\n');
        pass_count = pass_count + 1;
    else
        fprintf('  FAIL: Upper triangular matrix test failed\n');
    end

    test_count = test_count + 1;
    fprintf('Test %d: Empty matrix error\n', test_count);
    A = [];
    try
        oldState = warning('query', 'all');
        warning('off', 'all');
        [A_inv, det_A, L, U] = gaussel3(A);
        warning(oldState);
        fprintf('  FAIL: Should have thrown error for empty matrix\n');
    catch ME
        if contains(ME.message, 'empty')
            fprintf('  PASS\n');
            pass_count = pass_count + 1;
        else
            fprintf('  FAIL: Wrong error message\n');
        end
    end

    fprintf('\ngaussel3 summary: %d/%d tests passed\n', pass_count, test_count);
end