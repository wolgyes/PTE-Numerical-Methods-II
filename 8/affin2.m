function M = affin2(triangle1, triangle2)
% AFFIN2 Returns the 3x3 homogeneous matrix of a general affine transform
%
% Input arguments:
%   triangle1 - Original triangle: 2x3 matrix [x1 x2 x3; y1 y2 y3]
%               where each column is a vertex
%   triangle2 - Image triangle: 2x3 matrix [x1' x2' x3'; y1' y2' y3']
%               where each column is the transformed vertex
%
% Output argument:
%   M - 3x3 homogeneous transformation matrix
%       [ a11  a12  tx ]
%       [ a21  a22  ty ]
%       [  0    0    1 ]
%
% If called without input arguments, allows graphical input of both triangles.
%
% Mathematical background:
% General affine transform: T([x; y]) = A * [x; y] + b
% where A is 2x2 and b is 2x1
%
% For three points P1, P2, P3 mapping to Q1, Q2, Q3:
%   A * P1 + b = Q1
%   A * P2 + b = Q2
%   A * P3 + b = Q3
%
% We can solve this system by first finding A from:
%   A * (P2 - P1) = Q2 - Q1
%   A * (P3 - P1) = Q3 - Q1
% Then finding b from: b = Q1 - A * P1

    % Check if called without input arguments - enable graphical input
    if nargin == 0
        fprintf('Graphical input mode:\n');
        fprintf('First, select the 3 vertices of the ORIGINAL triangle\n');
        fprintf('Then, select the 3 vertices of the IMAGE triangle\n');

        % Create figure for graphical input
        fig = figure('Name', 'General Affine Transform', 'NumberTitle', 'off');
        axis equal;
        grid on;
        hold on;

        xlim([-10 10]);
        ylim([-10 10]);
        plot([-10 10], [0 0], 'k-', 'LineWidth', 0.5);
        plot([0 0], [-10 10], 'k-', 'LineWidth', 0.5);

        title('Click 3 points for the ORIGINAL triangle');

        % Get original triangle
        fprintf('\nSelect 3 vertices of the original triangle:\n');
        triangle1 = zeros(2, 3);
        for i = 1:3
            fprintf('  Vertex %d: ', i);
            [x, y] = ginput(1);
            fprintf('(%.2f, %.2f)\n', x, y);
            triangle1(:, i) = [x; y];
            plot(x, y, 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b');
            text(x, y, sprintf('  P%d', i), 'FontSize', 10, 'Color', 'b');
        end

        % Draw original triangle
        plot([triangle1(1,:), triangle1(1,1)], [triangle1(2,:), triangle1(2,1)], ...
             'b-', 'LineWidth', 2);

        title('Click 3 points for the IMAGE triangle');

        % Get image triangle
        fprintf('\nSelect 3 vertices of the image triangle:\n');
        triangle2 = zeros(2, 3);
        for i = 1:3
            fprintf('  Vertex %d: ', i);
            [x, y] = ginput(1);
            fprintf('(%.2f, %.2f)\n', x, y);
            triangle2(:, i) = [x; y];
            plot(x, y, 'rs', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
            text(x, y, sprintf('  Q%d', i), 'FontSize', 10, 'Color', 'r');
        end

        % Draw image triangle
        plot([triangle2(1,:), triangle2(1,1)], [triangle2(2,:), triangle2(2,1)], ...
             'r-', 'LineWidth', 2);

        % Draw arrows from original to image
        for i = 1:3
            quiver(triangle1(1,i), triangle1(2,i), ...
                   triangle2(1,i) - triangle1(1,i), ...
                   triangle2(2,i) - triangle1(2,i), ...
                   0, 'g-', 'LineWidth', 1.5, 'MaxHeadSize', 0.5);
        end

        legend('', '', 'Original vertices', '', 'Original triangle', ...
               'Image vertices', '', 'Image triangle', 'Transformation', ...
               'Location', 'best');
        title('Affine Transformation Visualization');

        hold off;
    end

    % Extract vertices
    P1 = triangle1(:, 1);
    P2 = triangle1(:, 2);
    P3 = triangle1(:, 3);

    Q1 = triangle2(:, 1);
    Q2 = triangle2(:, 2);
    Q3 = triangle2(:, 3);

    % Solve for A using the system:
    % A * (P2 - P1) = Q2 - Q1
    % A * (P3 - P1) = Q3 - Q1
    %
    % This can be written as:
    % A * [P2-P1, P3-P1] = [Q2-Q1, Q3-Q1]
    %
    % Therefore: A = [Q2-Q1, Q3-Q1] * inv([P2-P1, P3-P1])

    P_matrix = [P2 - P1, P3 - P1];
    Q_matrix = [Q2 - Q1, Q3 - Q1];

    % Check if the matrix is invertible
    if abs(det(P_matrix)) < 1e-10
        error('The three points of the original triangle are collinear. Cannot determine unique affine transform.');
    end

    A = Q_matrix / P_matrix;  % This is equivalent to Q_matrix * inv(P_matrix)

    % Solve for b: b = Q1 - A * P1
    b = Q1 - A * P1;

    % Build 3x3 homogeneous matrix
    M = [A(1,1), A(1,2), b(1);
         A(2,1), A(2,2), b(2);
         0,      0,      1];

    % Display results only in graphical mode (nargin == 0)
    if nargin == 0
        fprintf('\n3x3 Homogeneous transformation matrix M:\n');
        disp(M);

        % Verify the transformation
        fprintf('\nVerification:\n');
        for i = 1:3
            Pi = triangle1(:, i);
            Qi_expected = triangle2(:, i);
            Qi_computed = A * Pi + b;
            error_i = norm(Qi_expected - Qi_computed);
            fprintf('  P%d: (%.4f, %.4f) -> Q%d computed: (%.4f, %.4f), expected: (%.4f, %.4f), error: %.2e\n', ...
                    i, Pi(1), Pi(2), i, Qi_computed(1), Qi_computed(2), ...
                    Qi_expected(1), Qi_expected(2), error_i);
        end
    end

    % Create visualization only when called directly (nargin == 0)
    % When called programmatically, skip figure creation
    if nargin == 0
        figure('Name', 'Affine Transformation Result', 'NumberTitle', 'off');
        axis equal;
        grid on;
        hold on;

        % Plot original triangle
        fill([triangle1(1,:), triangle1(1,1)], [triangle1(2,:), triangle1(2,1)], ...
             'b', 'FaceAlpha', 0.3, 'EdgeColor', 'b', 'LineWidth', 2);

        % Plot image triangle
        fill([triangle2(1,:), triangle2(1,1)], [triangle2(2,:), triangle2(2,1)], ...
             'r', 'FaceAlpha', 0.3, 'EdgeColor', 'r', 'LineWidth', 2);

        % Plot vertices
        plot(triangle1(1,:), triangle1(2,:), 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b');
        plot(triangle2(1,:), triangle2(2,:), 'rs', 'MarkerSize', 10, 'MarkerFaceColor', 'r');

        % Add labels
        for i = 1:3
            text(triangle1(1,i), triangle1(2,i), sprintf('  P%d', i), ...
                 'FontSize', 10, 'Color', 'b');
            text(triangle2(1,i), triangle2(2,i), sprintf('  Q%d', i), ...
                 'FontSize', 10, 'Color', 'r');
        end

        % Draw transformation arrows
        for i = 1:3
            quiver(triangle1(1,i), triangle1(2,i), ...
                   triangle2(1,i) - triangle1(1,i), ...
                   triangle2(2,i) - triangle1(2,i), ...
                   0, 'g-', 'LineWidth', 1.5, 'MaxHeadSize', 0.5);
        end

        legend('Original Triangle', 'Image Triangle', '', '', 'Transformation', ...
               'Location', 'best');
        title(sprintf('Affine Transform: T(x) = M*[x;y;1]\nM = [%.2f %.2f %.2f; %.2f %.2f %.2f; 0 0 1]', ...
                      M(1,1), M(1,2), M(1,3), M(2,1), M(2,2), M(2,3)));

        hold off;
    end
end
