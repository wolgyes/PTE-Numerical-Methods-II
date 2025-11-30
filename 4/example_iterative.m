% Example script demonstrating Jacobi and Gauss-Seidel iterative methods
% for solving linear systems Ax = b

clear; clc;

fprintf('====================================================\n');
fprintf('Example 1: Small 3x3 system (diagonally dominant)\n');
fprintf('====================================================\n\n');

% Define a diagonally dominant system
A1 = [4, -1, 0;
     -1, 4, -1;
      0, -1, 4];
b1 = [1; 5; 0];

fprintf('System: A*x = b\n');
fprintf('Matrix A:\n');
disp(A1);
fprintf('Vector b:\n');
disp(b1');

% Exact solution using MATLAB's backslash operator
x_exact1 = A1 \ b1;
fprintf('Exact solution:\n');
disp(x_exact1');

% Solve using Jacobi iteration
fprintf('\n--- Jacobi Method ---\n');
x_jacobi1 = jacobi(A1, b1);
fprintf('Solution: [%.6f, %.6f, %.6f]\n', x_jacobi1(1), x_jacobi1(2), x_jacobi1(3));
fprintf('Error: %.2e\n', norm(x_jacobi1 - x_exact1));

% Solve using Gauss-Seidel iteration
fprintf('\n--- Gauss-Seidel Method ---\n');
x_gs1 = gaussseid(A1, b1);
fprintf('Solution: [%.6f, %.6f, %.6f]\n', x_gs1(1), x_gs1(2), x_gs1(3));
fprintf('Error: %.2e\n', norm(x_gs1 - x_exact1));

fprintf('\n====================================================\n');
fprintf('Example 2: 4x4 system\n');
fprintf('====================================================\n\n');

% Define another diagonally dominant system
A2 = [10, -1, 2, 0;
      -1, 11, -1, 3;
       2, -1, 10, -1;
       0, 3, -1, 8];
b2 = [6; 25; -11; 15];

fprintf('System: A*x = b\n');
fprintf('Matrix A:\n');
disp(A2);
fprintf('Vector b:\n');
disp(b2');

% Exact solution
x_exact2 = A2 \ b2;
fprintf('Exact solution:\n');
disp(x_exact2');

% Solve using Jacobi iteration
fprintf('\n--- Jacobi Method ---\n');
x_jacobi2 = jacobi(A2, b2);
fprintf('Solution: [%.6f, %.6f, %.6f, %.6f]\n', x_jacobi2(1), x_jacobi2(2), x_jacobi2(3), x_jacobi2(4));
fprintf('Error: %.2e\n', norm(x_jacobi2 - x_exact2));

% Solve using Gauss-Seidel iteration
fprintf('\n--- Gauss-Seidel Method ---\n');
x_gs2 = gaussseid(A2, b2);
fprintf('Solution: [%.6f, %.6f, %.6f, %.6f]\n', x_gs2(1), x_gs2(2), x_gs2(3), x_gs2(4));
fprintf('Error: %.2e\n', norm(x_gs2 - x_exact2));

fprintf('\n====================================================\n');
fprintf('Example 3: Comparing convergence speed\n');
fprintf('====================================================\n\n');

% Create a tridiagonal system (common in finite difference methods)
n = 5;
A3 = 4*eye(n) - diag(ones(n-1,1),1) - diag(ones(n-1,1),-1);
b3 = ones(n, 1);

fprintf('Tridiagonal %dx%d system\n', n, n);
fprintf('Matrix A:\n');
disp(A3);
fprintf('Vector b:\n');
disp(b3');

% Exact solution
x_exact3 = A3 \ b3;
fprintf('Exact solution:\n');
disp(x_exact3');

% Solve using Jacobi iteration
fprintf('\n--- Jacobi Method ---\n');
x_jacobi3 = jacobi(A3, b3);
fprintf('Solution:\n');
disp(x_jacobi3');
fprintf('Error: %.2e\n', norm(x_jacobi3 - x_exact3));

% Solve using Gauss-Seidel iteration
fprintf('\n--- Gauss-Seidel Method ---\n');
x_gs3 = gaussseid(A3, b3);
fprintf('Solution:\n');
disp(x_gs3');
fprintf('Error: %.2e\n', norm(x_gs3 - x_exact3));
