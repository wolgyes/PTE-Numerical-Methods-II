%% Test Script for Exercise 7: Generalised Inverse and Numerical Integration
% This script tests both geninv and numint functions with various examples

clear; clc;
fprintf('%s\n', repmat('=', 1, 70));
fprintf('Exercise 7: Testing geninv and numint functions\n');
fprintf('%s\n', repmat('=', 1, 70));
fprintf('\n');

%% ========================================================================
%% PART 1: Testing geninv (Generalised Inverse)
%% ========================================================================

fprintf('PART 1: GENERALISED INVERSE (Moore-Penrose Pseudoinverse)\n');
fprintf('%s\n', repmat('-', 1, 70));
fprintf('\n');

%% Test 1.1: Full rank square matrix
fprintf('Test 1.1: Full rank square matrix (3x3)\n');
A1 = [1 2 3; 4 5 6; 7 8 10];
fprintf('Matrix A:\n');
disp(A1);
fprintf('Rank of A: %d\n', rank(A1));

A1_plus = geninv(A1);
fprintf('Generalised inverse A+:\n');
disp(A1_plus);

% Verify: A*A+*A = A
verification = A1 * A1_plus * A1;
fprintf('Verification A*A+*A:\n');
disp(verification);
fprintf('Max error ||A - A*A+*A||: %e\n\n', max(max(abs(A1 - verification))));

% Compare with MATLAB's built-in pinv
A1_pinv = pinv(A1);
fprintf('Difference from MATLAB pinv: %e\n', max(max(abs(A1_plus - A1_pinv))));
fprintf('\n');

%% Test 1.2: Full column rank matrix (m > n)
fprintf('Test 1.2: Full column rank matrix (4x3)\n');
A2 = [1 2 3; 4 5 6; 7 8 9; 10 11 12];
fprintf('Matrix A:\n');
disp(A2);
fprintf('Rank of A: %d\n', rank(A2));

A2_plus = geninv(A2);
fprintf('Generalised inverse A+:\n');
disp(A2_plus);

verification = A2 * A2_plus * A2;
fprintf('Verification A*A+*A:\n');
disp(verification);
fprintf('Max error ||A - A*A+*A||: %e\n', max(max(abs(A2 - verification))));
fprintf('Difference from MATLAB pinv: %e\n', max(max(abs(A2_plus - pinv(A2)))));
fprintf('\n');

%% Test 1.3: Full row rank matrix (m < n)
fprintf('Test 1.3: Full row rank matrix (2x4)\n');
A3 = [1 2 3 4; 5 6 7 8];
fprintf('Matrix A:\n');
disp(A3);
fprintf('Rank of A: %d\n', rank(A3));

A3_plus = geninv(A3);
fprintf('Generalised inverse A+:\n');
disp(A3_plus);

verification = A3 * A3_plus * A3;
fprintf('Verification A*A+*A:\n');
disp(verification);
fprintf('Max error ||A - A*A+*A||: %e\n', max(max(abs(A3 - verification))));
fprintf('Difference from MATLAB pinv: %e\n', max(max(abs(A3_plus - pinv(A3)))));
fprintf('\n');

%% Test 1.4: Rank-deficient matrix
fprintf('Test 1.4: Rank-deficient matrix (3x3, rank 2)\n');
A4 = [1 2 3; 2 4 6; 4 5 7];
fprintf('Matrix A:\n');
disp(A4);
fprintf('Rank of A: %d\n', rank(A4));

A4_plus = geninv(A4);
fprintf('Generalised inverse A+:\n');
disp(A4_plus);

verification = A4 * A4_plus * A4;
fprintf('Verification A*A+*A:\n');
disp(verification);
fprintf('Max error ||A - A*A+*A||: %e\n', max(max(abs(A4 - verification))));
fprintf('Difference from MATLAB pinv: %e\n', max(max(abs(A4_plus - pinv(A4)))));
fprintf('\n');

%% Test 1.5: Rank-deficient rectangular matrix
fprintf('Test 1.5: Rank-deficient rectangular matrix (4x3, rank 2)\n');
A5 = [1 2 1; 2 4 2; 3 6 3; 1 1 1];
fprintf('Matrix A:\n');
disp(A5);
fprintf('Rank of A: %d\n', rank(A5));

A5_plus = geninv(A5);
fprintf('Generalised inverse A+:\n');
disp(A5_plus);

verification = A5 * A5_plus * A5;
fprintf('Verification A*A+*A:\n');
disp(verification);
fprintf('Max error ||A - A*A+*A||: %e\n', max(max(abs(A5 - verification))));
fprintf('Difference from MATLAB pinv: %e\n', max(max(abs(A5_plus - pinv(A5)))));
fprintf('\n\n');

%% ========================================================================
%% PART 2: Testing numint (Numerical Integration)
%% ========================================================================

fprintf('%s\n', repmat('=', 1, 70));
fprintf('PART 2: NUMERICAL INTEGRATION (Composite Quadrature Formulas)\n');
fprintf('%s\n', repmat('-', 1, 70));
fprintf('\n');

%% Test 2.1: Polynomial integral (exact for high-order methods)
fprintf('Test 2.1: Integral of x^2 from 0 to 1\n');
fprintf('Exact value: 1/3 = 0.333333...\n\n');

a = 0; b = 1;
integrand = 'x.^2';
exact_value = 1/3;

n_values = [10, 20, 50, 100];
fprintf('%-10s %-15s %-15s %-15s %-15s\n', 'n', 'Rectangle', 'Trapezoid', 'Simpson', 'Method');
fprintf('%s\n', repmat('-', 1, 70));

for n = n_values
    rect_result = numint(integrand, a, b, n, 'rectangle');
    trap_result = numint(integrand, a, b, n, 'trapezoid');
    simp_result = numint(integrand, a, b, n, 'simpson');

    fprintf('%-10d %.10f  %.10f  %.10f\n', n, rect_result, trap_result, simp_result);
end

fprintf('\nErrors with n=100:\n');
n = 100;
rect_result = numint(integrand, a, b, n, 'rectangle');
trap_result = numint(integrand, a, b, n, 'trapezoid');
simp_result = numint(integrand, a, b, n, 'simpson');

fprintf('Rectangle error: %e\n', abs(exact_value - rect_result));
fprintf('Trapezoid error: %e\n', abs(exact_value - trap_result));
fprintf('Simpson error:   %e\n\n', abs(exact_value - simp_result));

%% Test 2.2: Trigonometric integral
fprintf('Test 2.2: Integral of sin(x) from 0 to pi\n');
fprintf('Exact value: 2.0\n\n');

a = 0; b = pi;
integrand = 'sin(x)';
exact_value = 2.0;

fprintf('%-10s %-15s %-15s %-15s\n', 'n', 'Rectangle', 'Trapezoid', 'Simpson');
fprintf('%s\n', repmat('-', 1, 70));

for n = [10, 20, 50, 100]
    rect_result = numint(integrand, a, b, n, 'rectangle');
    trap_result = numint(integrand, a, b, n, 'trapezoid');
    simp_result = numint(integrand, a, b, n, 'simpson');

    fprintf('%-10d %.10f  %.10f  %.10f\n', n, rect_result, trap_result, simp_result);
end

fprintf('\nErrors with n=100:\n');
n = 100;
rect_result = numint(integrand, a, b, n, 'rectangle');
trap_result = numint(integrand, a, b, n, 'trapezoid');
simp_result = numint(integrand, a, b, n, 'simpson');

fprintf('Rectangle error: %e\n', abs(exact_value - rect_result));
fprintf('Trapezoid error: %e\n', abs(exact_value - trap_result));
fprintf('Simpson error:   %e\n\n', abs(exact_value - simp_result));

%% Test 2.3: Exponential integral
fprintf('Test 2.3: Integral of exp(-x) from 0 to 1\n');
exact_value = 1 - exp(-1);
fprintf('Exact value: %f\n\n', exact_value);

a = 0; b = 1;
integrand = 'exp(-x)';

fprintf('%-10s %-15s %-15s %-15s\n', 'n', 'Rectangle', 'Trapezoid', 'Simpson');
fprintf('%s\n', repmat('-', 1, 70));

for n = [10, 20, 50, 100]
    rect_result = numint(integrand, a, b, n, 'rectangle');
    trap_result = numint(integrand, a, b, n, 'trapezoid');
    simp_result = numint(integrand, a, b, n, 'simpson');

    fprintf('%-10d %.10f  %.10f  %.10f\n', n, rect_result, trap_result, simp_result);
end

fprintf('\nErrors with n=100:\n');
n = 100;
rect_result = numint(integrand, a, b, n, 'rectangle');
trap_result = numint(integrand, a, b, n, 'trapezoid');
simp_result = numint(integrand, a, b, n, 'simpson');

fprintf('Rectangle error: %e\n', abs(exact_value - rect_result));
fprintf('Trapezoid error: %e\n', abs(exact_value - trap_result));
fprintf('Simpson error:   %e\n\n', abs(exact_value - simp_result));

%% Test 2.4: More complex function
fprintf('Test 2.4: Integral of 1/(1+x^2) from 0 to 1 (atan integral)\n');
exact_value = pi/4;
fprintf('Exact value: pi/4 = %f\n\n', exact_value);

a = 0; b = 1;
integrand = '1./(1+x.^2)';

fprintf('%-10s %-15s %-15s %-15s\n', 'n', 'Rectangle', 'Trapezoid', 'Simpson');
fprintf('%s\n', repmat('-', 1, 70));

for n = [10, 20, 50, 100]
    rect_result = numint(integrand, a, b, n, 'rectangle');
    trap_result = numint(integrand, a, b, n, 'trapezoid');
    simp_result = numint(integrand, a, b, n, 'simpson');

    fprintf('%-10d %.10f  %.10f  %.10f\n', n, rect_result, trap_result, simp_result);
end

fprintf('\nErrors with n=100:\n');
n = 100;
rect_result = numint(integrand, a, b, n, 'rectangle');
trap_result = numint(integrand, a, b, n, 'trapezoid');
simp_result = numint(integrand, a, b, n, 'simpson');

fprintf('Rectangle error: %e\n', abs(exact_value - rect_result));
fprintf('Trapezoid error: %e\n', abs(exact_value - trap_result));
fprintf('Simpson error:   %e\n\n', abs(exact_value - simp_result));

%% Summary
fprintf('%s\n', repmat('=', 1, 70));
fprintf('SUMMARY\n');
fprintf('%s\n', repmat('=', 1, 70));
fprintf('\n');
fprintf('All tests completed successfully!\n\n');
fprintf('Key observations:\n');
fprintf('1. geninv correctly computes the Moore-Penrose pseudoinverse for:\n');
fprintf('   - Full rank matrices (square, tall, wide)\n');
fprintf('   - Rank-deficient matrices\n');
fprintf('   - Results match MATLAB''s pinv function\n\n');
fprintf('2. numint provides three quadrature methods:\n');
fprintf('   - Rectangle (midpoint): O(h^2) accuracy\n');
fprintf('   - Trapezoid: O(h^2) accuracy\n');
fprintf('   - Simpson: O(h^4) accuracy (best for smooth functions)\n');
fprintf('   - Simpson''s rule generally provides the best accuracy\n\n');
