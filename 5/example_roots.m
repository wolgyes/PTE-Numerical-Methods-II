% Example script demonstrating root-finding methods
% Tests bisect, secant, and newt (Newton-Raphson) methods

clear; clc; close all;

fprintf('======================================================================\n');
fprintf('ROOT FINDING METHODS - DEMONSTRATION\n');
fprintf('======================================================================\n\n');

%% Example 1: Simple quadratic function f(x) = x^2 - 4
% Exact roots: x = ±2

fprintf('----------------------------------------------------------------------\n');
fprintf('Example 1: f(x) = x^2 - 4\n');
fprintf('Expected roots: x = ±2\n');
fprintf('----------------------------------------------------------------------\n\n');

f1 = @(x) x.^2 - 4;

% Bisection method: find positive root in [0, 3]
fprintf('=== BISECTION METHOD ===\n');
[x_bisect1, eps_bisect1] = bisect(f1, 0, 3, 20);

fprintf('\n');

% Secant method: find positive root starting from 0 and 3
fprintf('=== SECANT METHOD ===\n');
x_secant1 = secant(f1, 0, 3, 10);

fprintf('\n');

% Newton-Raphson method: find positive root starting from 3
fprintf('=== NEWTON-RAPHSON METHOD ===\n');
x_newt1 = newt(f1, 3, 10);

fprintf('\n');
fprintf('COMPARISON:\n');
fprintf('Bisection:       x* = %.10f, error est = %.2e\n', x_bisect1, eps_bisect1);
fprintf('Secant:          x* = %.10f\n', x_secant1);
fprintf('Newton-Raphson:  x* = %.10f\n', x_newt1);
fprintf('Exact:           x  = %.10f\n', 2.0);
fprintf('\n');

input('Press Enter to continue to Example 2...');
close all;

%% Example 2: Transcendental equation f(x) = cos(x) - x
% One root approximately at x ≈ 0.739085

fprintf('\n======================================================================\n');
fprintf('Example 2: f(x) = cos(x) - x\n');
fprintf('Expected root: x ≈ 0.739085\n');
fprintf('======================================================================\n\n');

f2 = @(x) cos(x) - x;

% Bisection method: root in [0, 1]
fprintf('=== BISECTION METHOD ===\n');
[x_bisect2, eps_bisect2] = bisect(f2, 0, 1, 20);

fprintf('\n');

% Secant method
fprintf('=== SECANT METHOD ===\n');
x_secant2 = secant(f2, 0, 1, 10);

fprintf('\n');

% Newton-Raphson method: start from x0 = 0.5
fprintf('=== NEWTON-RAPHSON METHOD ===\n');
x_newt2 = newt(f2, 0.5, 10);

fprintf('\n');
fprintf('COMPARISON:\n');
fprintf('Bisection:       x* = %.10f, error est = %.2e\n', x_bisect2, eps_bisect2);
fprintf('Secant:          x* = %.10f\n', x_secant2);
fprintf('Newton-Raphson:  x* = %.10f\n', x_newt2);
fprintf('\n');

input('Press Enter to continue to Example 3...');
close all;

%% Example 3: Cubic polynomial f(x) = x^3 - 2*x - 5
% One real root approximately at x ≈ 2.0946

fprintf('\n======================================================================\n');
fprintf('Example 3: f(x) = x^3 - 2*x - 5\n');
fprintf('Expected root: x ≈ 2.0946\n');
fprintf('======================================================================\n\n');

f3 = @(x) x.^3 - 2*x - 5;

% Bisection method: root in [2, 3]
fprintf('=== BISECTION METHOD ===\n');
[x_bisect3, eps_bisect3] = bisect(f3, 2, 3, 20);

fprintf('\n');

% Secant method
fprintf('=== SECANT METHOD ===\n');
x_secant3 = secant(f3, 2, 3, 10);

fprintf('\n');

% Newton-Raphson method: start from x0 = 2
fprintf('=== NEWTON-RAPHSON METHOD ===\n');
x_newt3 = newt(f3, 2, 10);

fprintf('\n');
fprintf('COMPARISON:\n');
fprintf('Bisection:       x* = %.10f, error est = %.2e\n', x_bisect3, eps_bisect3);
fprintf('Secant:          x* = %.10f\n', x_secant3);
fprintf('Newton-Raphson:  x* = %.10f\n', x_newt3);
fprintf('\n');

input('Press Enter to continue to Example 4...');
close all;

%% Example 4: Exponential function f(x) = exp(x) - 3*x
% Two roots: one near x ≈ 0.619 and another near x ≈ 1.512

fprintf('\n======================================================================\n');
fprintf('Example 4: f(x) = exp(x) - 3*x\n');
fprintf('Finding first root (near x ≈ 0.619)\n');
fprintf('======================================================================\n\n');

f4 = @(x) exp(x) - 3*x;

% Bisection method: first root in [0, 1]
fprintf('=== BISECTION METHOD ===\n');
[x_bisect4, eps_bisect4] = bisect(f4, 0, 1, 20);

fprintf('\n');

% Secant method
fprintf('=== SECANT METHOD ===\n');
x_secant4 = secant(f4, 0, 1, 10);

fprintf('\n');

% Newton-Raphson method: start from x0 = 0.5
fprintf('=== NEWTON-RAPHSON METHOD ===\n');
x_newt4 = newt(f4, 0.5, 10);

fprintf('\n');
fprintf('COMPARISON:\n');
fprintf('Bisection:       x* = %.10f, error est = %.2e\n', x_bisect4, eps_bisect4);
fprintf('Secant:          x* = %.10f\n', x_secant4);
fprintf('Newton-Raphson:  x* = %.10f\n', x_newt4);
fprintf('\n');

fprintf('\n======================================================================\n');
fprintf('ALL EXAMPLES COMPLETED\n');
fprintf('======================================================================\n');

%% Summary
fprintf('\nSUMMARY OF METHODS:\n\n');
fprintf('BISECTION METHOD:\n');
fprintf('  - Guaranteed convergence if root exists in interval\n');
fprintf('  - Linear convergence (slow but reliable)\n');
fprintf('  - Requires sign change: f(a)*f(b) < 0\n\n');

fprintf('SECANT METHOD:\n');
fprintf('  - Faster than bisection (superlinear convergence)\n');
fprintf('  - Doesn''t require derivative\n');
fprintf('  - May fail if f(x1) ≈ f(x0)\n\n');

fprintf('NEWTON-RAPHSON METHOD:\n');
fprintf('  - Fastest convergence (quadratic)\n');
fprintf('  - Requires derivative computation\n');
fprintf('  - May fail if f''(x) ≈ 0\n');
fprintf('  - Sensitive to starting point\n\n');
