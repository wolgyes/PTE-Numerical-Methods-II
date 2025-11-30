function y = newtoneval(c, x_nodes, x)
% NEWTONEVAL Evaluate Newton interpolation polynomial
%
% Syntax: y = newtoneval(c, x_nodes, x)
%
% Input:
%   c       - coefficients from Newton interpolation (from newtonip.m)
%   x_nodes - original interpolation nodes
%   x       - points at which to evaluate the polynomial (scalar or vector)
%
% Output:
%   y - values of the interpolation polynomial at points x
%
% The Newton form is:
%   P(x) = c(1) + c(2)*(x-x(1)) + c(3)*(x-x(1))*(x-x(2)) + ...
%          + c(n)*(x-x(1))*...*(x-x(n-1))
%
% The evaluation uses Horner's method (nested multiplication) for efficiency:
%   P(x) = c(1) + (x-x(1))*(c(2) + (x-x(2))*(c(3) + ... ))

    % Input validation
    if length(c) ~= length(x_nodes)
        error('Length of coefficients must equal length of nodes');
    end

    % Convert to column vectors
    c = c(:);
    x_nodes = x_nodes(:);

    % Store original shape of x
    original_shape = size(x);
    x = x(:);  % Convert to column vector for processing

    n = length(c);
    y = zeros(size(x));

    % Evaluate using Horner's method (nested multiplication)
    % Start from the last coefficient and work backwards
    for i = 1:length(x)
        % Start with the last coefficient
        y(i) = c(n);

        % Work backwards through the coefficients
        for j = (n-1):-1:1
            y(i) = c(j) + (x(i) - x_nodes(j)) * y(i);
        end
    end

    % Reshape output to match input shape
    y = reshape(y, original_shape);
end
