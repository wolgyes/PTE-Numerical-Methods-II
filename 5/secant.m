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

    % Determine plotting range
    x_min = min(x_history) - 0.5 * abs(max(x_history) - min(x_history));
    x_max = max(x_history) + 0.5 * abs(max(x_history) - min(x_history));
    x_plot = linspace(x_min, x_max, 1000);

    % Plot the function
    y_plot = arrayfun(f, x_plot);
    plot(x_plot, y_plot, 'b-', 'LineWidth', 2, 'DisplayName', 'f(x)');
    hold on;

    % Plot zero line
    plot([x_min, x_max], [0, 0], 'k--', 'LineWidth', 1, 'DisplayName', 'y = 0');

    % Plot iteration points
    plot(x_history, f_history, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r', ...
         'DisplayName', 'Iteration points');

    % Plot secant lines
    for i = 1:length(x_history)-1
        x1 = x_history(i);
        x2 = x_history(i+1);
        y1 = f_history(i);
        y2 = f_history(i+1);

        % Draw secant line connecting two points
        plot([x1, x2], [y1, y2], 'g--', 'LineWidth', 1.5, 'HandleVisibility', 'off');

        % Add iteration number label
        text(x2, y2, sprintf(' %d', i), 'FontSize', 10, 'Color', 'red');
    end

    % Mark the final approximation
    x_final = x_history(end);
    plot([x_final, x_final], [0, f_history(end)], 'r:', 'LineWidth', 2, ...
         'DisplayName', 'Final approximation');

    grid on;
    xlabel('x', 'FontSize', 12);
    ylabel('f(x)', 'FontSize', 12);
    title('Secant Method - Iteration Visualization', 'FontSize', 14, 'FontWeight', 'bold');
    legend('Location', 'best');
    hold off;

    fprintf('\nPlot created showing %d iterations\n', length(x_history) - 1);
end
