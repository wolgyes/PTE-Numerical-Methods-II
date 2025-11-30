function [x_star, epsilon] = bisect(f, a, b, n)
% BISECT Bisection method for finding roots of nonlinear equations
%
% Input:
%   f  - function handle for which we want to find a root
%   a  - left endpoint of starting interval
%   b  - right endpoint of starting interval
%   n  - number of iterations
%
% Output:
%   x_star  - approximation of the root
%   epsilon - error estimation (half-width of final interval)
%
% The function checks if there is a root in [a,b] by verifying that
% f(a) and f(b) have opposite signs.

    % Evaluate function at endpoints
    fa = f(a);
    fb = f(b);

    % Check if there is a root in the interval
    if fa * fb > 0
        error('No sign change in interval [%.4f, %.4f]. Cannot guarantee root exists.', a, b);
    end

    % Special cases: root is exactly at an endpoint
    if fa == 0
        x_star = a;
        epsilon = 0;
        fprintf('Root found exactly at a = %.10f\n', a);
        return;
    end
    if fb == 0
        x_star = b;
        epsilon = 0;
        fprintf('Root found exactly at b = %.10f\n', b);
        return;
    end

    % Bisection iterations
    for i = 1:n
        % Compute midpoint
        c = (a + b) / 2;
        fc = f(c);

        % Check if we found the exact root
        if fc == 0
            x_star = c;
            epsilon = 0;
            fprintf('Exact root found at iteration %d: x = %.10f\n', i, c);
            return;
        end

        % Determine which half contains the root
        if fa * fc < 0
            % Root is in [a, c]
            b = c;
            fb = fc;
        else
            % Root is in [c, b]
            a = c;
            fa = fc;
        end
    end

    % Final approximation is the midpoint of the last interval
    x_star = (a + b) / 2;

    % Error estimation is half the width of the final interval
    epsilon = (b - a) / 2;

    fprintf('Bisection completed after %d iterations\n', n);
    fprintf('Root approximation: x* = %.10f\n', x_star);
    fprintf('Error estimate: ε = %.2e\n', epsilon);
    fprintf('Function value: f(x*) = %.2e\n', f(x_star));
end
