% Example script demonstrating root-finding methods
% Tests bisect, secant, and newt (Newton-Raphson) methods
% Focus on curved functions where iterative lines are clearly visible

clear; clc; close all;

fprintf('======================================================================\n');
fprintf('ROOT FINDING METHODS - DEMONSTRATION\n');
fprintf('======================================================================\n\n');

%% Example 1: Cubic polynomial f(x) = x^3 - 2*x - 5
% One real root approximately at x ≈ 2.0946
% This is a highly curved function, great for visualizing secant iterations

fprintf('----------------------------------------------------------------------\n');
fprintf('Example 1: f(x) = x^3 - 2*x - 5 (Cubic polynomial)\n');
fprintf('Expected root: x ≈ 2.0946\n');
fprintf('----------------------------------------------------------------------\n\n');

f1 = @(x) x.^3 - 2*x - 5;

% Bisection method: root in [2, 3]
fprintf('=== BISECTION METHOD ===\n');
[x_bisect1, eps_bisect1] = bisect(f1, 2, 3, 15);

fprintf('\n');

% Secant method: highly curved function shows iterative lines clearly
fprintf('=== SECANT METHOD ===\n');
x_secant1 = secant(f1, 2, 3, 5);

fprintf('\n');

% Newton-Raphson method: start from x0 = 2
fprintf('=== NEWTON-RAPHSON METHOD ===\n');
x_newt1 = newt(f1, 2, 8);

fprintf('\n');
fprintf('COMPARISON:\n');
fprintf('Bisection:       x* = %.10f, error est = %.2e\n', x_bisect1, eps_bisect1);
fprintf('Secant:          x* = %.10f\n', x_secant1);
fprintf('Newton-Raphson:  x* = %.10f\n', x_newt1);
fprintf('Exact:           x  ≈ 2.094551482\n');
fprintf('\n');

input('Press Enter to continue to Example 2...');
close all;

%% Example 2: Exponential function f(x) = exp(-x) - 0.5*x
% Very curved exponential function
% Root approximately at x ≈ 1.2

fprintf('\n======================================================================\n');
fprintf('Example 2: f(x) = exp(-x) - 0.5*x (Exponential decay)\n');
fprintf('Expected root: x ≈ 1.2\n');
fprintf('======================================================================\n\n');

f2 = @(x) exp(-x) - 0.5*x;

% Bisection method: root in [0, 2]
fprintf('=== BISECTION METHOD ===\n');
[x_bisect2, eps_bisect2] = bisect(f2, 0, 2, 15);

fprintf('\n');

% Secant method: exponential curve makes secant lines very visible
fprintf('=== SECANT METHOD ===\n');
x_secant2 = secant(f2, 0, 2, 5);

fprintf('\n');

% Newton-Raphson method: start from x0 = 1
fprintf('=== NEWTON-RAPHSON METHOD ===\n');
x_newt2 = newt(f2, 1, 8);

fprintf('\n');
fprintf('COMPARISON:\n');
fprintf('Bisection:       x* = %.10f, error est = %.2e\n', x_bisect2, eps_bisect2);
fprintf('Secant:          x* = %.10f\n', x_secant2);
fprintf('Newton-Raphson:  x* = %.10f\n', x_newt2);
fprintf('\n');

input('Press Enter to continue to Example 3...');
close all;

%% Example 3: Transcendental equation f(x) = cos(x) - x
% Classic example with smooth curvature
% One root approximately at x ≈ 0.739085

fprintf('\n======================================================================\n');
fprintf('Example 3: f(x) = cos(x) - x (Transcendental)\n');
fprintf('Expected root: x ≈ 0.739085\n');
fprintf('======================================================================\n\n');

f3 = @(x) cos(x) - x;

% Bisection method: root in [0, 1]
fprintf('=== BISECTION METHOD ===\n');
[x_bisect3, eps_bisect3] = bisect(f3, 0, 1, 15);

fprintf('\n');

% Secant method
fprintf('=== SECANT METHOD ===\n');
x_secant3 = secant(f3, 0, 1, 5);

fprintf('\n');

% Newton-Raphson method: start from x0 = 0.5
fprintf('=== NEWTON-RAPHSON METHOD ===\n');
x_newt3 = newt(f3, 0.5, 8);

fprintf('\n');
fprintf('COMPARISON:\n');
fprintf('Bisection:       x* = %.10f, error est = %.2e\n', x_bisect3, eps_bisect3);
fprintf('Secant:          x* = %.10f\n', x_secant3);
fprintf('Newton-Raphson:  x* = %.10f\n', x_newt3);
fprintf('Exact:           x  ≈ 0.739085133\n');
fprintf('\n');

fprintf('\n======================================================================\n');
fprintf('ALL EXAMPLES COMPLETED\n');
fprintf('======================================================================\n');

%% Summary
fprintf('\nSUMMARY OF METHODS:\n\n');
fprintf('BISECTION METHOD:\n');
fprintf('  - Guaranteed convergence if root exists in interval\n');
fprintf('  - Linear convergence ("slow" but reliable)\n');
fprintf('  - Requires sign change: f(a)*f(b) < 0\n\n');

fprintf('SECANT METHOD:\n');
fprintf('  - Faster than bisection (superlinear convergence)\n');
fprintf('  - Doesn''t require derivative\n');
fprintf('  - May fail if f(x1) ≈ f(x0)\n');
fprintf('  - Visual inspection shows iterative approximation clearly\n\n');

fprintf('NEWTON-RAPHSON METHOD:\n');
fprintf('  - Fastest convergence (quadratic)\n');
fprintf('  - Requires derivative computation\n');
fprintf('  - May fail if f''(x) ≈ 0\n');
fprintf('  - Sensitive to starting point\n\n');
