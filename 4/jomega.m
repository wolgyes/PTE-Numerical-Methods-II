function [omega_opt, rho_opt, omega_conv, rho_values, omega_values] = jomega(A, omega_range, suppress_figure)
% JOMEGA Examines the parameter of Soothed (Weighted) Jacobi iteration
%
% Input:
%   A              - coefficient matrix of the linear system
%   omega_range    - range of omega values to test (optional, default 0:0.01:2)
%   suppress_figure- if true, suppress figure creation (optional, default false)
%
% Output:
%   omega_opt   - optimal omega parameter (minimum spectral radius)
%   rho_opt     - optimal spectral radius value
%   omega_conv  - interval of convergence [omega_min, omega_max]
%   rho_values  - spectral radius values for each omega
%   omega_values- omega values tested

    % Set default omega range if not provided
    if nargin < 2 || isempty(omega_range)
        omega_values = 0:0.01:2;
    else
        omega_values = omega_range;
    end

    % Set default suppress_figure if not provided
    if nargin < 3
        suppress_figure = false;
    end

    n = size(A, 1);

    % Extract diagonal matrix D
    D = diag(diag(A));
    D_inv = diag(1./diag(A));

    % Compute R = D - A (for the iteration matrix formulation)
    R = D - A;

    % Preallocate for spectral radius values
    rho_values = zeros(size(omega_values));

    % Compute spectral radius for each omega
    for i = 1:length(omega_values)
        omega = omega_values(i);

        % Iteration matrix for Soothed Jacobi: T_omega = I - omega * D^(-1) * A
        T_omega = eye(n) - omega * D_inv * A;

        % Compute spectral radius (maximum absolute eigenvalue)
        eigenvalues = eig(T_omega);
        rho_values(i) = max(abs(eigenvalues));
    end

    % Find optimal omega (minimum spectral radius)
    [rho_opt, idx_opt] = min(rho_values);
    omega_opt = omega_values(idx_opt);

    % Find convergence interval (where rho < 1)
    conv_indices = find(rho_values < 1);
    if ~isempty(conv_indices)
        omega_conv = [omega_values(conv_indices(1)), omega_values(conv_indices(end))];
    else
        omega_conv = [];
        warning('No convergence interval found in the given omega range');
    end

    % Create the plot (unless suppressed)
    if ~suppress_figure
        figure;
        plot(omega_values, rho_values, 'b-', 'LineWidth', 1.5);
        hold on;

        % Mark the optimal point
        plot(omega_opt, rho_opt, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');

        % Mark the convergence region
        if ~isempty(omega_conv)
            yline(1, 'k--', 'LineWidth', 1, 'Label', '\rho = 1 (convergence boundary)');
            % Shade convergence region
            y_fill = [0, 0, 1, 1];
            x_fill = [omega_conv(1), omega_conv(2), omega_conv(2), omega_conv(1)];
            fill(x_fill, y_fill, 'g', 'FaceAlpha', 0.1, 'EdgeColor', 'none');
        end

        grid on;
        xlabel('\omega (relaxation parameter)', 'FontSize', 12);
        ylabel('\rho(T_\omega) (spectral radius)', 'FontSize', 12);
        title('Spectral Radius vs Omega for Soothed Jacobi Iteration', 'FontSize', 14);

        % Add legend
        if ~isempty(omega_conv)
            legend('Spectral radius', ...
                   sprintf('Optimal: \\omega = %.3f, \\rho = %.4f', omega_opt, rho_opt), ...
                   'Convergence boundary', ...
                   sprintf('Convergence region: [%.3f, %.3f]', omega_conv(1), omega_conv(2)), ...
                   'Location', 'best');
        else
            legend('Spectral radius', ...
                   sprintf('Optimal: \\omega = %.3f, \\rho = %.4f', omega_opt, rho_opt), ...
                   'Location', 'best');
        end

        hold off;
    end

    % Display results
    fprintf('\n========================================\n');
    fprintf('Soothed Jacobi Parameter Analysis\n');
    fprintf('========================================\n');
    fprintf('Optimal omega:        %.6f\n', omega_opt);
    fprintf('Optimal rho:          %.6f\n', rho_opt);
    if ~isempty(omega_conv)
        fprintf('Convergence interval: [%.6f, %.6f]\n', omega_conv(1), omega_conv(2));
    else
        fprintf('Convergence interval: None found\n');
    end
    fprintf('========================================\n\n');
end
