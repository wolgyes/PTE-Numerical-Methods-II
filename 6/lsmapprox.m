function c = lsmapprox(n, x, y)
% LSMAPPROX Least squares polynomial approximation
%
% Syntax: c = lsmapprox(n, x, y)
%
% Input:
%   n - degree of the approximating polynomial
%   x - vector of data points (nodes)
%   y - vector of function values at nodes (same size as x)
%
% Output:
%   c - coefficients of the polynomial in descending powers
%       c(1)*x^n + c(2)*x^(n-1) + ... + c(n)*x + c(n+1)
%       (compatible with MATLAB's polyval function)
%
% Method:
%   Solves the normal equations: A'*A*c = A'*y
%   where A is the Vandermonde matrix [x^n, x^(n-1), ..., x, 1]
%
%   This minimizes the sum of squared errors: sum((p(x_i) - y_i)^2)

    % Input validation
    if length(x) ~= length(y)
        error('Vectors x and y must have the same length');
    end

    if n < 0
        error('Polynomial degree n must be non-negative');
    end

    m = length(x);  % number of data points

    if n >= m
        warning('Degree n >= number of points: this is interpolation, not approximation');
    end

    % Convert to column vectors
    x = x(:);
    y = y(:);

    % Build the Vandermonde matrix A
    % A(i,j) = x(i)^(n-j+1) for i=1..m, j=1..(n+1)
    A = zeros(m, n+1);
    for j = 1:(n+1)
        A(:, j) = x.^(n-j+1);
    end

    % Solve the normal equations: A'*A*c = A'*y
    % Using the backslash operator for numerical stability
    c = (A' * A) \ (A' * y);

    % Alternative: could use MATLAB's polyfit
    % c_polyfit = polyfit(x, y, n);

    % Visualization
    figure;

    % Plot the data points
    plot(x, y, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r', ...
        'DisplayName', 'Data Points');
    hold on;

    % Generate points for smooth plotting of the approximation polynomial
    x_plot = linspace(min(x), max(x), 200);
    y_plot = polyval(c, x_plot);

    % Plot the approximation polynomial
    plot(x_plot, y_plot, 'b-', 'LineWidth', 2, ...
        'DisplayName', sprintf('LSM Polynomial (degree %d)', n));

    % Calculate and display residuals
    y_approx = polyval(c, x);
    residuals = y - y_approx;
    rms_error = sqrt(mean(residuals.^2));
    max_error = max(abs(residuals));

    % Plot residuals as vertical lines
    for i = 1:length(x)
        plot([x(i), x(i)], [y(i), y_approx(i)], 'g--', 'LineWidth', 1, ...
            'HandleVisibility', 'off');
    end
    plot(NaN, NaN, 'g--', 'LineWidth', 1, 'DisplayName', 'Residuals');

    grid on;
    xlabel('x', 'FontSize', 12);
    ylabel('y', 'FontSize', 12);
    title('Least Squares Polynomial Approximation', 'FontSize', 14);
    legend('Location', 'best');

    % Add information text
    info_str = sprintf('Degree: %d\nData points: %d\nRMS Error: %.4e\nMax Error: %.4e', ...
        n, m, rms_error, max_error);
    text(0.02, 0.98, info_str, 'Units', 'normalized', ...
        'VerticalAlignment', 'top', 'FontSize', 10, ...
        'BackgroundColor', 'white', 'EdgeColor', 'black');

    hold off;

    % Display numerical results
    fprintf('Least Squares Approximation Results:\n');
    fprintf('  Polynomial degree: %d\n', n);
    fprintf('  Number of data points: %d\n', m);
    fprintf('  RMS error: %.6e\n', rms_error);
    fprintf('  Maximum error: %.6e\n', max_error);
    fprintf('  Coefficients (descending powers):\n');
    for i = 1:length(c)
        fprintf('    c(%d) = %.8f  (x^%d term)\n', i, c(i), n-i+1);
    end
    fprintf('\n');
end
