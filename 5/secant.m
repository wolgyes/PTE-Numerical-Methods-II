function x_star = secant(f, a, b, n)
% SECANT Secant method for finding roots of nonlinear equations
%
% Input:
%   f  - function handle for which we want to find a root
%   a  - first starting point
%   b  - second starting point
%   n  - number of iterations
%
% Output:
%   x_star - approximation of the root
%
% The function uses linear interpolation between successive points.
% It also creates a plot showing the iterations graphically.

    % Evaluate function at starting points
    fa = f(a);
    fb = f(b);

    % Check if starting points are valid
    if fa == fb
        error('f(a) = f(b), cannot proceed with secant method (division by zero)');
    end

    % Check if there's likely a root (sign change)
    if fa * fb > 0
        warning('No sign change between a and b. Root may not exist in interval.');
    end

    % Store iteration history for plotting
    x_history = [a, b];
    f_history = [fa, fb];

    % Initialize
    x0 = a;
    x1 = b;
    f0 = fa;
    f1 = fb;

    % Secant iterations
    for i = 1:n
        % Check for division by zero
        if f1 == f0
            warning('Division by zero at iteration %d. Stopping.', i);
            break;
        end

        % Secant formula: x_new = x1 - f(x1) * (x1 - x0) / (f(x1) - f(x0))
        x_new = x1 - f1 * (x1 - x0) / (f1 - f0);
        f_new = f(x_new);

        % Store for plotting
        x_history = [x_history, x_new];
        f_history = [f_history, f_new];

        % Update for next iteration
        x0 = x1;
        f0 = f1;
        x1 = x_new;
        f1 = f_new;

        % Check convergence
        if abs(f_new) < 1e-10
            fprintf('Converged to root at iteration %d\n', i);
            break;
        end
    end

    x_star = x1;

    fprintf('Secant method completed after %d iterations\n', length(x_history) - 2);
    fprintf('Root approximation: x* = %.10f\n', x_star);
    fprintf('Function value: f(x*) = %.2e\n', f(x_star));

    % Create visualization
    plot_secant_iterations(f, x_history, f_history);
end

function plot_secant_iterations(f, x_history, f_history)
% Helper function to plot the iterations

    figure('Position', [100, 100, 900, 600]);

    % Convert function handle to string for title
    f_str = func2str(f);
    % Clean up the string: remove @(x) prefix if present
    if startsWith(f_str, '@(x)')
        f_str = strrep(f_str, '@(x)', 'f(x) = ');
    else
        f_str = ['f(x) = ' f_str];
    end

    % Determine plotting range
    x_range = max(x_history) - min(x_history);
    x_min = min(x_history) - 0.4 * x_range;
    x_max = max(x_history) + 0.4 * x_range;
    x_plot = linspace(x_min, x_max, 1000);

    % Plot the function
    y_plot = arrayfun(f, x_plot);
    plot(x_plot, y_plot, 'b-', 'LineWidth', 2, 'DisplayName', 'f(x)');
    hold on;

    % Plot zero line
    plot([x_min, x_max], [0, 0], 'k-', 'LineWidth', 0.5, 'HandleVisibility', 'off');

    % Plot secant lines (only between the two points, not extended)
    for i = 1:length(x_history)-1
        x1 = x_history(i);
        x2 = x_history(i+1);
        y1 = f_history(i);
        y2 = f_history(i+1);

        % Draw simple secant line between the two points only
        if i == 1
            plot([x1, x2], [y1, y2], 'g-', 'LineWidth', 1.5, 'DisplayName', 'Secant lines');
        else
            plot([x1, x2], [y1, y2], 'g-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
        end
    end

    % Plot iteration points
    plot(x_history, f_history, 'ro', 'MarkerSize', 7, 'MarkerFaceColor', 'r', ...
         'DisplayName', 'Iterations');

    % Add iteration number labels
    y_range = max(y_plot) - min(y_plot);
    for i = 1:length(x_history)
        % Offset label slightly above or below point
        y_offset = 0.015 * y_range;
        if f_history(i) > 0
            valign = 'bottom';
            y_pos = f_history(i) + y_offset;
        else
            valign = 'top';
            y_pos = f_history(i) - y_offset;
        end

        text(x_history(i), y_pos, sprintf('%d', i-1), ...
             'FontSize', 9, 'Color', 'red', 'HorizontalAlignment', 'center', ...
             'VerticalAlignment', valign);
    end

    grid on;
    xlabel('x', 'FontSize', 12);
    ylabel('f(x)', 'FontSize', 12);
    title(sprintf('Secant Method: %s', f_str), 'FontSize', 13, 'FontWeight', 'bold');
    legend('Location', 'best');
    hold off;

    fprintf('\nPlot created showing %d iterations\n', length(x_history) - 1);
end
