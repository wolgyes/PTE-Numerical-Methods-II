% Example script demonstrating the jomega function with unified visualization
% This version displays all three systems on a SINGLE plot for direct comparison

clear; clc; close all;

fprintf('====================================================\n');
fprintf('Jomega Analysis: Unified Single Plot Visualization\n');
fprintf('====================================================\n\n');

%% System 1: Highly Asymmetric Matrix (Very Curved)
fprintf('Analyzing System 1: Highly Asymmetric Matrix...\n');

A1 = [10, -3, 2, -1;
      1, 8, -2, 1;
      -2, 1, 9, -3;
      1, -1, 2, 12];

[omega_opt1, rho_opt1, omega_conv1, rho_vals1, omega_vals1] = jomega(A1, [], true);

%% System 2: Symmetric Positive Definite Matrix
fprintf('Analyzing System 2: Symmetric Positive Definite Matrix...\n');

A2 = [4, -1, 0, 0;
      -1, 4, -1, 0;
      0, -1, 4, -1;
      0, 0, -1, 4];

[omega_opt2, rho_opt2, omega_conv2, rho_vals2, omega_vals2] = jomega(A2, [], true);

%% System 3: Laplace-like Matrix (Very Structured)
fprintf('Analyzing System 3: Laplace-like Matrix...\n');

n = 6;
A3 = 4*eye(n) - diag(ones(n-1,1),1) - diag(ones(n-1,1),-1);

[omega_opt3, rho_opt3, omega_conv3, rho_vals3, omega_vals3] = jomega(A3, 0:0.005:2, true);

%% Create single unified plot
figure('Position', [100, 100, 900, 600]);

% Mark convergence regions first (so they are in the background)
y_fill = [0, 0, 1, 1];

if ~isempty(omega_conv1)
    x_fill1 = [omega_conv1(1), omega_conv1(2), omega_conv1(2), omega_conv1(1)];
    fill(x_fill1, y_fill, 'b', 'FaceAlpha', 0.05, 'EdgeColor', 'none', 'DisplayName', 'Conv region 1');
end
hold on;

if ~isempty(omega_conv2)
    x_fill2 = [omega_conv2(1), omega_conv2(2), omega_conv2(2), omega_conv2(1)];
    fill(x_fill2, y_fill, 'r', 'FaceAlpha', 0.05, 'EdgeColor', 'none', 'DisplayName', 'Conv region 2');
end

if ~isempty(omega_conv3)
    x_fill3 = [omega_conv3(1), omega_conv3(2), omega_conv3(2), omega_conv3(1)];
    fill(x_fill3, y_fill, 'g', 'FaceAlpha', 0.05, 'EdgeColor', 'none', 'DisplayName', 'Conv region 3');
end

% Mark convergence boundary
yline(1, 'k--', 'LineWidth', 1.5, 'DisplayName', '\rho = 1 (convergence boundary)');

% Plot all three spectral radius curves
plot(omega_vals1, rho_vals1, 'b-', 'LineWidth', 2, 'DisplayName', 'System 1 (3x3)');
plot(omega_vals2, rho_vals2, 'r-', 'LineWidth', 2, 'DisplayName', 'System 2 (4x4)');
plot(omega_vals3, rho_vals3, 'g-', 'LineWidth', 2, 'DisplayName', 'System 3 (5x5)');

% Mark optimal points
plot(omega_opt1, rho_opt1, 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b', ...
     'DisplayName', sprintf('Opt 1: \\omega=%.3f', omega_opt1));
plot(omega_opt2, rho_opt2, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r', ...
     'DisplayName', sprintf('Opt 2: \\omega=%.3f', omega_opt2));
plot(omega_opt3, rho_opt3, 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g', ...
     'DisplayName', sprintf('Opt 3: \\omega=%.3f', omega_opt3));

grid on;
xlabel('\omega (relaxation parameter)', 'FontSize', 13);
ylabel('\rho(T_\omega) (spectral radius)', 'FontSize', 13);
title('Soothed Jacobi Parameter Analysis - All Systems Comparison', 'FontSize', 15, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 11);
hold off;

%% Print comparison table
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
fprintf('      All three systems are now visible side-by-side for comparison.\n\n');
