% Example script demonstrating the jomega function for analyzing
% the omega parameter in Soothed Jacobi iteration

clear; clc; close all;

fprintf('====================================================\n');
fprintf('Example 1: 3x3 Diagonally Dominant System\n');
fprintf('====================================================\n\n');

% Define a diagonally dominant system
A1 = [4, -1, 0;
     -1, 4, -1;
      0, -1, 4];

fprintf('Matrix A:\n');
disp(A1);

% Analyze omega parameter
[omega_opt1, rho_opt1, omega_conv1, rho_vals1, omega_vals1] = jomega(A1);

fprintf('\n====================================================\n');
fprintf('Example 2: 4x4 System\n');
fprintf('====================================================\n\n');

A2 = [10, -1, 2, 0;
      -1, 11, -1, 3;
       2, -1, 10, -1;
       0, 3, -1, 8];

fprintf('Matrix A:\n');
disp(A2);

% Analyze omega parameter
[omega_opt2, rho_opt2, omega_conv2] = jomega(A2);

fprintf('\n====================================================\n');
fprintf('Example 3: 5x5 Tridiagonal System\n');
fprintf('====================================================\n\n');

% Create a tridiagonal system (common in finite difference methods)
n = 5;
A3 = 4*eye(n) - diag(ones(n-1,1),1) - diag(ones(n-1,1),-1);

fprintf('Matrix A (tridiagonal):\n');
disp(A3);

% Analyze omega parameter with finer resolution
[omega_opt3, rho_opt3, omega_conv3] = jomega(A3, 0:0.005:2);

fprintf('\n====================================================\n');
fprintf('Comparison of Results\n');
fprintf('====================================================\n');
fprintf('System | Optimal Omega | Optimal Rho | Conv. Interval\n');
fprintf('-------|---------------|-------------|----------------\n');
fprintf('  1    |    %.4f     |   %.4f    | [%.3f, %.3f]\n', ...
        omega_opt1, rho_opt1, omega_conv1(1), omega_conv1(2));
fprintf('  2    |    %.4f     |   %.4f    | [%.3f, %.3f]\n', ...
        omega_opt2, rho_opt2, omega_conv2(1), omega_conv2(2));
fprintf('  3    |    %.4f     |   %.4f    | [%.3f, %.3f]\n', ...
        omega_opt3, rho_opt3, omega_conv3(1), omega_conv3(2));
fprintf('====================================================\n\n');

fprintf('Note: The optimal omega value minimizes the spectral radius,\n');
fprintf('      leading to fastest convergence of the Soothed Jacobi method.\n');
fprintf('      Convergence occurs when the spectral radius is less than 1.\n');
