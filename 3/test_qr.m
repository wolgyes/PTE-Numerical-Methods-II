% TEST_QR Comprehensive test suite for QR decomposition functions
% Tests gramschmidt, householder, and hhalg implementations

fprintf('========================================\n');
fprintf('QR Decomposition Test Suite\n');
fprintf('========================================\n\n');

%% Test 1: Small 3x3 matrix
fprintf('Test 1: Standard 3x3 matrix\n');
fprintf('----------------------------------------\n');
A1 = [12 -51 4; 6 167 -68; -4 24 -41];
fprintf('Matrix A1:\n');
disp(A1);

% Test gramschmidt
[Q_gs, R_gs] = gramschmidt(A1);
err_gs = norm(A1 - Q_gs*R_gs, 'fro');
orth_gs = norm(Q_gs'*Q_gs - eye(3), 'fro');
fprintf('gramschmidt:\n');
fprintf('  ||A - Q*R||_F = %.4e\n', err_gs);
fprintf('  ||Q''*Q - I||_F = %.4e\n', orth_gs);
fprintf('  R is upper triangular: %s\n', mat2str(istriu(R_gs)));

% Test hhalg
[Q_hh, R_hh] = hhalg(A1);
err_hh = norm(A1 - Q_hh*R_hh, 'fro');
orth_hh = norm(Q_hh'*Q_hh - eye(3), 'fro');
fprintf('hhalg:\n');
fprintf('  ||A - Q*R||_F = %.4e\n', err_hh);
fprintf('  ||Q''*Q - I||_F = %.4e\n', orth_hh);
fprintf('  R is upper triangular: %s\n', mat2str(istriu(R_hh)));

% Compare with MATLAB's qr
[Q_mat, R_mat] = qr(A1);
err_mat = norm(A1 - Q_mat*R_mat, 'fro');
fprintf('MATLAB qr (reference):\n');
fprintf('  ||A - Q*R||_F = %.4e\n', err_mat);

fprintf('\n');

%% Test 2: Identity matrix (edge case)
fprintf('Test 2: Identity matrix (edge case)\n');
fprintf('----------------------------------------\n');
A2 = eye(3);

[Q_gs2, R_gs2] = gramschmidt(A2);
err_gs2 = norm(A2 - Q_gs2*R_gs2, 'fro');
fprintf('gramschmidt: ||A - Q*R||_F = %.4e\n', err_gs2);

[Q_hh2, R_hh2] = hhalg(A2);
err_hh2 = norm(A2 - Q_hh2*R_hh2, 'fro');
fprintf('hhalg:       ||A - Q*R||_F = %.4e\n', err_hh2);

fprintf('\n');

%% Test 3: Random matrix
fprintf('Test 3: Random 5x5 matrix\n');
fprintf('----------------------------------------\n');
rng(42);  % For reproducibility
A3 = randn(5, 5);

[Q_gs3, R_gs3] = gramschmidt(A3);
err_gs3 = norm(A3 - Q_gs3*R_gs3, 'fro');
orth_gs3 = norm(Q_gs3'*Q_gs3 - eye(5), 'fro');
fprintf('gramschmidt:\n');
fprintf('  ||A - Q*R||_F = %.4e\n', err_gs3);
fprintf('  ||Q''*Q - I||_F = %.4e\n', orth_gs3);

[Q_hh3, R_hh3] = hhalg(A3);
err_hh3 = norm(A3 - Q_hh3*R_hh3, 'fro');
orth_hh3 = norm(Q_hh3'*Q_hh3 - eye(5), 'fro');
fprintf('hhalg:\n');
fprintf('  ||A - Q*R||_F = %.4e\n', err_hh3);
fprintf('  ||Q''*Q - I||_F = %.4e\n', orth_hh3);

fprintf('\n');

%% Test 4: Householder transformation verification
fprintf('Test 4: Householder transformation\n');
fprintf('----------------------------------------\n');
P = [3; 4];
P_prime = [5; 0];
fprintf('P = [%.1f; %.1f], P'' = [%.1f; %.1f]\n', P(1), P(2), P_prime(1), P_prime(2));

H = householder(P, P_prime);
P_reflected = H * P;
fprintf('H * P = [%.4f; %.4f]\n', P_reflected(1), P_reflected(2));
fprintf('Expected P'' = [%.1f; %.1f]\n', P_prime(1), P_prime(2));
fprintf('Error: %.4e\n', norm(P_reflected - P_prime));
fprintf('H is orthogonal (||H''*H - I||_F): %.4e\n', norm(H'*H - eye(2), 'fro'));

% Test symmetry: H*P' should give P
P_prime_reflected = H * P_prime;
fprintf('H * P'' = [%.4f; %.4f]\n', P_prime_reflected(1), P_prime_reflected(2));
fprintf('Expected P = [%.1f; %.1f]\n', P(1), P(2));
fprintf('Error: %.4e\n', norm(P_prime_reflected - P));

fprintf('\n');

%% Test 5: Higher dimensional Householder
fprintf('Test 5: Householder in R^4\n');
fprintf('----------------------------------------\n');
P_4d = [1; 2; 3; 4];
P_prime_4d = [4; 3; 2; 1];
H_4d = householder(P_4d, P_prime_4d);
P_4d_reflected = H_4d * P_4d;
fprintf('||H*P - P''||: %.4e\n', norm(P_4d_reflected - P_prime_4d));
fprintf('||H''*H - I||_F: %.4e\n', norm(H_4d'*H_4d - eye(4), 'fro'));

fprintf('\n');

%% Summary
fprintf('========================================\n');
fprintf('SUMMARY\n');
fprintf('========================================\n');
fprintf('All tests completed!\n\n');

% Check if all tests passed (error < 1e-10)
all_passed = true;
threshold = 1e-10;

if err_gs > threshold || err_hh > threshold
    fprintf('WARNING: Test 1 failed (error > %.0e)\n', threshold);
    all_passed = false;
end

if err_gs2 > threshold || err_hh2 > threshold
    fprintf('WARNING: Test 2 failed (error > %.0e)\n', threshold);
    all_passed = false;
end

if err_gs3 > threshold || err_hh3 > threshold
    fprintf('WARNING: Test 3 failed (error > %.0e)\n', threshold);
    all_passed = false;
end

if norm(P_reflected - P_prime) > threshold || norm(P_prime_reflected - P) > threshold
    fprintf('WARNING: Test 4 failed (error > %.0e)\n', threshold);
    all_passed = false;
end

if norm(P_4d_reflected - P_prime_4d) > threshold
    fprintf('WARNING: Test 5 failed (error > %.0e)\n', threshold);
    all_passed = false;
end

if all_passed
    fprintf('✓ All tests PASSED!\n');
else
    fprintf('✗ Some tests FAILED - review output above\n');
end
