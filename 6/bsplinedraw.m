function bsplinedraw(i, k)
% BSPLINEDRAW Draw B-spline basis functions
%
% Syntax: bsplinedraw(i, k)
%
% Input:
%   i - index of the B-spline (starting position)
%   k - order of the B-spline (degree = k-1)
%       k=1: piecewise constant (degree 0)
%       k=2: piecewise linear (degree 1)
%       k=3: piecewise quadratic (degree 2)
%       k=4: piecewise cubic (degree 3)
%
% Output:
%   None - function creates a visualization
%
% The function uses the Cox-de Boor recursion formula on [0,1]:
%   B_{i,1}(x) = 1 if t_i <= x < t_{i+1}, 0 otherwise
%   B_{i,k}(x) = (x-t_i)/(t_{i+k-1}-t_i) * B_{i,k-1}(x) +
%                (t_{i+k}-x)/(t_{i+k}-t_{i+1}) * B_{i+1,k-1}(x)
%
% The knot vector is uniform on [0,1] with multiplicity at endpoints

    % Input validation
    if k < 1
        error('Order k must be at least 1');
    end

    if i < 0
        error('Index i must be non-negative');
    end

    % Setup uniform knot vector on [0,1]
    % We need enough knots to define the B-spline
    % For a B-spline of order k starting at index i, we need knots from t_i to t_{i+k}
    n_knots = i + k + 10;  % Extra knots for safety
    t = linspace(0, 1, n_knots);

    % Create evaluation points
    x = linspace(0, 1, 500);

    % Evaluate the B-spline
    y = bspline_recursive(x, i, k, t);

    % Visualization
    figure;

    % Plot the B-spline
    plot(x, y, 'b-', 'LineWidth', 2);
    hold on;

    % Mark the support (non-zero interval)
    support_start = t(i+1);
    support_end = min(t(i+k), 1);

    % Shade the support region
    y_lim = get(gca, 'YLim');
    patch([support_start, support_end, support_end, support_start], ...
          [y_lim(1), y_lim(1), y_lim(2), y_lim(2)], ...
          [0.9, 0.9, 1.0], 'FaceAlpha', 0.3, 'EdgeColor', 'none', ...
          'DisplayName', 'Support');

    % Plot knots
    knot_range = max(1, i):min(i+k+1, length(t));
    plot(t(knot_range), zeros(size(knot_range)), 'rv', ...
        'MarkerSize', 8, 'MarkerFaceColor', 'r', 'DisplayName', 'Knots');

    % Formatting
    grid on;
    xlabel('x', 'FontSize', 12);
    ylabel(sprintf('B_{%d,%d}(x)', i, k), 'FontSize', 12);
    title(sprintf('B-Spline Basis Function: i=%d, k=%d (degree %d)', i, k, k-1), ...
        'FontSize', 14);
    legend('Location', 'best');
    xlim([0, 1]);
    ylim([min(-0.1, min(y)-0.1), max(y)+0.1]);

    % Add information text
    info_str = sprintf('Order: %d\nDegree: %d\nSupport: [%.3f, %.3f]', ...
        k, k-1, support_start, support_end);
    text(0.02, 0.98, info_str, 'Units', 'normalized', ...
        'VerticalAlignment', 'top', 'FontSize', 10, ...
        'BackgroundColor', 'white', 'EdgeColor', 'black');

    hold off;
end

%% Helper function for recursive B-spline evaluation
function y = bspline_recursive(x, i, k, t)
% BSPLINE_RECURSIVE Recursive evaluation of B-spline basis function
%
% Input:
%   x - evaluation points
%   i - index of B-spline
%   k - order of B-spline
%   t - knot vector
%
% Output:
%   y - values of B_{i,k}(x) at points x

    % Initialize output
    y = zeros(size(x));

    % Base case: k = 1 (piecewise constant)
    if k == 1
        % B_{i,1}(x) = 1 if t_i <= x < t_{i+1}, 0 otherwise
        if i+1 < length(t) && i+2 <= length(t)
            y = (x >= t(i+1) & x < t(i+2));
            % Handle right endpoint specially
            if t(i+2) == max(t)
                y = y | (x == t(i+2));
            end
        end
        return;
    end

    % Recursive case: k > 1
    % B_{i,k}(x) = alpha * B_{i,k-1}(x) + (1-beta) * B_{i+1,k-1}(x)
    % where alpha = (x-t_i)/(t_{i+k-1}-t_i)
    %       beta = (x-t_{i+1})/(t_{i+k}-t_{i+1})

    % First term: (x-t_i)/(t_{i+k-1}-t_i) * B_{i,k-1}(x)
    if i+1 <= length(t) && i+k-1 <= length(t)
        denom1 = t(i+k-1) - t(i+1);
        if abs(denom1) > eps
            alpha = (x - t(i+1)) / denom1;
            y = y + alpha .* bspline_recursive(x, i, k-1, t);
        end
    end

    % Second term: (t_{i+k}-x)/(t_{i+k}-t_{i+1}) * B_{i+1,k-1}(x)
    if i+2 <= length(t) && i+k <= length(t)
        denom2 = t(i+k) - t(i+2);
        if abs(denom2) > eps
            beta = (t(i+k) - x) / denom2;
            y = y + beta .* bspline_recursive(x, i+1, k-1, t);
        end
    end
end
