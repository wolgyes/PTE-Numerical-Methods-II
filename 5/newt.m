function x_star = newt(f, x0, n)
% NEWT Newton-Raphson method for finding roots of nonlinear equations
%
% Input:
%   f  - function handle for which we want to find a root
%        (must work with symbolic variables)
%   x0 - starting point
%   n  - number of iterations
%
% Output:
%   x_star - approximation of the root
%
% The function uses symbolic differentiation to compute f'(x) automatically.
% Newton-Raphson formula: x_new = x - f(x) / f'(x)

    % Compute derivative symbolically
    try
        % Check if Symbolic Math Toolbox is available
        if ~exist('sym', 'file')
            error('Symbolic Math Toolbox not found');
        end

        x_sym = sym('x');

        % Evaluate function symbolically
        f_sym = f(x_sym);

        % Compute derivative using symbolic diff
        f_prime_sym = diff(f_sym, x_sym);

        % Convert symbolic derivative back to function handle
        f_prime = matlabFunction(f_prime_sym);

        fprintf('Symbolic derivative computed: f''(x) = %s\n', char(f_prime_sym));
    catch ME
        warning('Symbolic differentiation failed: %s', ME.message);
        fprintf('Falling back to numerical differentiation (finite difference)\n');

        % Numerical differentiation using central difference
        h = 1e-8;
        f_prime = @(x) (f(x + h) - f(x - h)) / (2 * h);
    end

    % Newton-Raphson iterations
    x = x0;
    fprintf('\nNewton-Raphson Method:\n');
    fprintf('Iter |      x          |     f(x)       |    f''(x)\n');
    fprintf('-----|-----------------|----------------|---------------\n');

    for i = 1:n
        fx = f(x);
        fpx = f_prime(x);

        fprintf('%4d | %14.8f | %14.6e | %14.6e\n', i-1, x, fx, fpx);

        % Check for zero derivative
        if abs(fpx) < eps
            warning('Derivative near zero at iteration %d. Newton method may fail.', i);
            break;
        end

        % Newton-Raphson update: x_new = x - f(x) / f'(x)
        x_new = x - fx / fpx;

        % Check convergence
        if abs(x_new - x) < 1e-10
            fprintf('\nConverged after %d iterations\n', i);
            x = x_new;
            break;
        end

        x = x_new;
    end

    x_star = x;

    fprintf('\nNewton-Raphson completed\n');
    fprintf('Root approximation: x* = %.10f\n', x_star);
    fprintf('Function value: f(x*) = %.2e\n', f(x_star));
end
