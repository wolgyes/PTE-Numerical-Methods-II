function hhgraph()
% HHGRAPH Interactive 2D graphical interface for Householder transformations
%   hhgraph() prompts the user to select two points (P and P') graphically,
%   displays the reflection line (hyperplane), then asks for a test point
%   and shows its reflection using the Householder transformation.

    % Create figure
    figure('Name', 'Householder Transformation - 2D Interactive Demo', ...
           'NumberTitle', 'off');
    hold on;
    grid on;
    axis equal;
    xlabel('x');
    ylabel('y');
    title('Click to select point P and its image P''');

    % Set axis limits
    xlim([-10, 10]);
    ylim([-10, 10]);

    % Get first point P
    fprintf('Select point P (original point) by clicking on the figure...\n');
    [x1, y1] = ginput(1);
    P = [x1; y1];

    % Plot P
    plot(P(1), P(2), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r', ...
         'DisplayName', 'P (original)');
    text(P(1), P(2), '  P', 'FontSize', 12, 'Color', 'r');

    % Get second point P'
    fprintf('Select point P'' (image point) by clicking on the figure...\n');
    title('Click to select the image point P''');
    [x2, y2] = ginput(1);
    P_prime = [x2; y2];

    % Plot P'
    plot(P_prime(1), P_prime(2), 'bs', 'MarkerSize', 10, ...
         'MarkerFaceColor', 'b', 'DisplayName', 'P'' (image)');
    text(P_prime(1), P_prime(2), '  P''', 'FontSize', 12, 'Color', 'b');

    % Compute midpoint (on the reflection line)
    midpoint = (P + P_prime) / 2;

    % Compute direction perpendicular to P - P'
    v = P - P_prime;
    perp_dir = [-v(2); v(1)];  % Perpendicular direction
    perp_dir = perp_dir / norm(perp_dir);  % Normalize

    % Draw the reflection line (hyperplane in 2D)
    % Line passes through midpoint and is perpendicular to P - P'
    t = linspace(-15, 15, 100);
    line_x = midpoint(1) + t * perp_dir(1);
    line_y = midpoint(2) + t * perp_dir(2);
    plot(line_x, line_y, 'g--', 'LineWidth', 1.5, ...
         'DisplayName', 'Reflection line');

    % Draw line connecting P and P'
    plot([P(1), P_prime(1)], [P(2), P_prime(2)], 'k:', ...
         'LineWidth', 1, 'DisplayName', 'P to P''');

    % Get Householder transformation matrix
    H = householder(P, P_prime);

    % Ask for test point
    fprintf('Select a test point to see its reflection...\n');
    title('Click to select a test point to see its reflection');
    [x_test, y_test] = ginput(1);
    test_point = [x_test; y_test];

    % Plot test point
    plot(test_point(1), test_point(2), 'mo', 'MarkerSize', 10, ...
         'MarkerFaceColor', 'm', 'DisplayName', 'Test point');
    text(test_point(1), test_point(2), '  Test', 'FontSize', 12, 'Color', 'm');

    % Apply Householder transformation
    reflected_point = H * test_point;

    % Plot reflected point
    plot(reflected_point(1), reflected_point(2), 'co', 'MarkerSize', 10, ...
         'MarkerFaceColor', 'c', 'DisplayName', 'Reflected point');
    text(reflected_point(1), reflected_point(2), '  Reflected', ...
         'FontSize', 12, 'Color', 'c');

    % Draw line connecting test point and reflected point
    plot([test_point(1), reflected_point(1)], ...
         [test_point(2), reflected_point(2)], 'm:', 'LineWidth', 1, ...
         'DisplayName', 'Test to reflected');

    % Final title
    title('Householder Transformation - Complete');

    % Add legend
    legend('Location', 'best');

    hold off;

    % Print results
    fprintf('\n=== Results ===\n');
    fprintf('Point P: [%.4f, %.4f]\n', P(1), P(2));
    fprintf('Point P'': [%.4f, %.4f]\n', P_prime(1), P_prime(2));
    fprintf('Test point: [%.4f, %.4f]\n', test_point(1), test_point(2));
    fprintf('Reflected point: [%.4f, %.4f]\n', reflected_point(1), reflected_point(2));
    fprintf('\nHouseholder matrix H:\n');
    disp(H);

    % Verify that H is orthogonal
    fprintf('Verification: H * H'' (should be identity):\n');
    disp(H * H');

end
