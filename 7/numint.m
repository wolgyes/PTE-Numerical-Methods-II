function result = numint(integrand, a, b, n, method)
% NUMINT Numerical integration using composite quadrature formulas
%
% Inputs:
%   integrand - Function to integrate (as a string, e.g., 'x.^2' or 'sin(x)')
%   a         - Left endpoint of integration interval
%   b         - Right endpoint of integration interval
%   n         - Number of subintervals (divisors)
%   method    - Type of quadrature formula:
%               'rectangle' - Composite midpoint/rectangle rule
%               'trapezoid' - Composite trapezoidal rule
%               'simpson'   - Composite Simpson's rule (requires even n)
%
% Output:
%   result - Approximation of the integral
%
% Notes:
%   - For Simpson's rule, n must be even. If n is odd, it will be incremented by 1.
%   - The integrand string should use element-wise operations (e.g., '.*', '.^', './')
%   - Use 'x' as the variable in the integrand string

    % Input validation
    if a >= b
        error('Left endpoint must be less than right endpoint (a < b)');
    end

    if n <= 0
        error('Number of subintervals must be positive');
    end

    % Calculate step size
    h = (b - a) / n;

    % Create anonymous function from string
    f = str2func(['@(x) ' integrand]);

    % Apply the selected quadrature method
    switch lower(method)
        case 'rectangle'
            % Composite midpoint rule
            % Integral ≈ h * sum(f(x_i)) where x_i are midpoints
            result = 0;
            for i = 1:n
                x_mid = a + (i - 0.5) * h;
                result = result + f(x_mid);
            end
            result = h * result;

        case 'trapezoid'
            % Composite trapezoidal rule
            % Integral ≈ (h/2) * [f(a) + 2*sum(f(x_i)) + f(b)]
            result = f(a) + f(b);
            for i = 1:(n-1)
                x_i = a + i * h;
                result = result + 2 * f(x_i);
            end
            result = (h / 2) * result;

        case 'simpson'
            % Composite Simpson's rule (requires even n)
            % Integral ≈ (h/3) * [f(x_0) + 4*sum(f(x_odd)) + 2*sum(f(x_even)) + f(x_n)]

            % Ensure n is even
            if mod(n, 2) ~= 0
                warning('Simpson''s rule requires even n. Incrementing n from %d to %d.', n, n+1);
                n = n + 1;
                h = (b - a) / n;
            end

            result = f(a) + f(b);

            % Add odd-indexed points (multiplied by 4)
            for i = 1:2:(n-1)
                x_i = a + i * h;
                result = result + 4 * f(x_i);
            end

            % Add even-indexed points (multiplied by 2)
            for i = 2:2:(n-2)
                x_i = a + i * h;
                result = result + 2 * f(x_i);
            end

            result = (h / 3) * result;

        otherwise
            error('Unknown method: %s. Use ''rectangle'', ''trapezoid'', or ''simpson''.', method);
    end
end
