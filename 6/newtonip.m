function c = newtonip(x, y)
% NEWTONIP Newton interpolation polynomial coefficients
%
% Syntax: c = newtonip(x, y)
%
% Input:
%   x - vector of interpolation nodes (must be distinct)
%   y - vector of function values at nodes (same size as x)
%
% Output:
%   c - coefficients of Newton interpolation polynomial
%       c(1) + c(2)*(t-x(1)) + c(3)*(t-x(1))*(t-x(2)) + ...
%
% The function computes divided differences using the recursive formula:
%   f[x_i] = y_i
%   f[x_i, x_{i+1}, ..., x_{i+k}] = (f[x_{i+1},...,x_{i+k}] - f[x_i,...,x_{i+k-1}]) / (x_{i+k} - x_i)
%
% The coefficients are the divided differences: c(k) = f[x_0, x_1, ..., x_{k-1}]

    % Input validation
    if length(x) ~= length(y)
        error('Vectors x and y must have the same length');
    end

    if length(unique(x)) ~= length(x)
        error('Interpolation nodes must be distinct');
    end

    % Convert to column vectors
    x = x(:);
    y = y(:);

    n = length(x);

    % Initialize divided difference table
    % Each column k contains divided differences of order k-1
    D = zeros(n, n);
    D(:, 1) = y;  % First column is just the function values

    % Compute divided differences using the recursive formula
    for j = 2:n
        for i = 1:(n-j+1)
            % f[x_i, ..., x_{i+j-1}] = (f[x_{i+1},...,x_{i+j-1}] - f[x_i,...,x_{i+j-2}]) / (x_{i+j-1} - x_i)
            D(i, j) = (D(i+1, j-1) - D(i, j-1)) / (x(i+j-1) - x(i));
        end
    end

    % The coefficients are the first row of the divided difference table
    c = D(1, :)';

    % Visualization
    figure;

    % Generate points for smooth plotting of the interpolation polynomial
    x_plot = linspace(min(x), max(x), 200);
    y_plot = newtoneval(c, x, x_plot);

    % Plot the interpolation polynomial
    plot(x_plot, y_plot, 'b-', 'LineWidth', 2, 'DisplayName', 'Newton Polynomial');
    hold on;

    % Plot the interpolation nodes
    plot(x, y, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r', ...
        'DisplayName', 'Interpolation Nodes');

    grid on;
    xlabel('x', 'FontSize', 12);
    ylabel('y', 'FontSize', 12);
    title('Newton Interpolation Polynomial', 'FontSize', 14);
    legend('Location', 'best');

    % Add text showing the degree
    text(0.05, 0.95, sprintf('Degree: %d', n-1), ...
        'Units', 'normalized', 'FontSize', 11, ...
        'BackgroundColor', 'white', 'EdgeColor', 'black');

    hold off;
end
