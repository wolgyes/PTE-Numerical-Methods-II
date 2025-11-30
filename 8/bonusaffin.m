function vertices = bonusaffin(S, P, Q)
% BONUSAFFIN Find vertices of a regular triangle given its center of gravity and two points on different sides
% (+1 Bonus exercise)
%
% Input arguments:
%   S - Center of gravity (centroid) of the triangle: [x; y] or [x, y]
%   P - Point on one side of the triangle: [x; y] or [x, y]
%   Q - Point on another side of the triangle: [x; y] or [x, y]
%
% Output argument:
%   vertices - 2x3 matrix containing the vertices [V1, V2, V3]
%
% If called without input arguments, allows graphical input.
%
% Mathematical background:
% A regular (equilateral) triangle has:
% - All sides of equal length
% - All angles equal to 60 degrees
% - The centroid divides each median in ratio 2:1
%
% Strategy:
% 1. Use a reference equilateral triangle (e.g., with centroid at origin)
% 2. Find where P and Q would lie on this reference triangle
% 3. Use affine transformation to map the reference to the actual triangle
%
% Example from the exercise:
%   P(2, 3) and Q(4, 2) lie on different sides
%   S(3, 3) is the center of gravity

    % Check if called without input arguments - enable graphical input
    if nargin == 0
        fprintf('Graphical input mode:\n');
        fprintf('Select: 1) Center of gravity (S)\n');
        fprintf('        2) Point on first side (P)\n');
        fprintf('        3) Point on second side (Q)\n');

        % Create figure for graphical input
        figure('Name', 'Regular Triangle - Find Vertices', 'NumberTitle', 'off');
        axis equal;
        grid on;
        hold on;

        xlim([0 10]);
        ylim([0 10]);
        plot([0 10], [0 0], 'k-', 'LineWidth', 0.5);
        plot([0 0], [0 10], 'k-', 'LineWidth', 0.5);

        title('Click: Center of gravity (S)');

        % Get center of gravity
        fprintf('\nClick on the center of gravity (S):\n');
        [x, y] = ginput(1);
        fprintf('  S: (%.2f, %.2f)\n', x, y);
        S = [x; y];
        plot(x, y, 'ko', 'MarkerSize', 12, 'MarkerFaceColor', 'k');
        text(x, y, '  S (centroid)', 'FontSize', 10);

        title('Click: Point on first side (P)');

        % Get first point on a side
        fprintf('Click on point P (on one side):\n');
        [x, y] = ginput(1);
        fprintf('  P: (%.2f, %.2f)\n', x, y);
        P = [x; y];
        plot(x, y, 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b');
        text(x, y, '  P', 'FontSize', 10, 'Color', 'b');

        title('Click: Point on second side (Q)');

        % Get second point on another side
        fprintf('Click on point Q (on another side):\n');
        [x, y] = ginput(1);
        fprintf('  Q: (%.2f, %.2f)\n', x, y);
        Q = [x; y];
        plot(x, y, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
        text(x, y, '  Q', 'FontSize', 10, 'Color', 'r');

        hold off;
    end

    % Ensure column vectors
    if size(S, 2) > size(S, 1), S = S'; end
    if size(P, 2) > size(P, 1), P = P'; end
    if size(Q, 2) > size(Q, 1), Q = Q'; end

    fprintf('\nSolving for regular triangle vertices...\n');
    fprintf('Given:\n');
    fprintf('  Centroid S = (%.4f, %.4f)\n', S(1), S(2));
    fprintf('  Point P = (%.4f, %.4f) on one side\n', P(1), P(2));
    fprintf('  Point Q = (%.4f, %.4f) on another side\n', Q(1), Q(2));

    % Create a reference equilateral triangle with centroid at origin
    % Use vertices at angles 90°, 210°, 330° from the positive x-axis
    % For an equilateral triangle with centroid at origin and circumradius R:
    angle1 = pi/2;          % 90 degrees
    angle2 = pi/2 + 2*pi/3; % 210 degrees
    angle3 = pi/2 + 4*pi/3; % 330 degrees

    % We'll use R = 1 for the reference triangle
    R_ref = 1;
    V1_ref = R_ref * [cos(angle1); sin(angle1)];
    V2_ref = R_ref * [cos(angle2); sin(angle2)];
    V3_ref = R_ref * [cos(angle3); sin(angle3)];

    % Side length of reference triangle
    side_ref = norm(V2_ref - V1_ref);

    % Points P and Q should lie on two different sides
    % We need to find which configuration works
    % There are 3 sides and we need to check different cases

    % The sides of the reference triangle are:
    % Side 1: V1_ref to V2_ref
    % Side 2: V2_ref to V3_ref
    % Side 3: V3_ref to V1_ref

    % We'll try different combinations and rotations
    best_vertices = [];
    min_error = inf;

    % Try different rotations and scales
    for rotation_angle = 0:pi/180:2*pi
        for scale = 0.1:0.1:10
            % Create rotated and scaled reference triangle
            R_transform = scale * [cos(rotation_angle), -sin(rotation_angle);
                                    sin(rotation_angle), cos(rotation_angle)];

            V1 = R_transform * V1_ref + S;
            V2 = R_transform * V2_ref + S;
            V3 = R_transform * V3_ref + S;

            % Check if P and Q lie on different sides
            [on_side_P, param_P] = point_on_triangle_side(P, V1, V2, V3);
            [on_side_Q, param_Q] = point_on_triangle_side(Q, V1, V2, V3);

            if on_side_P > 0 && on_side_Q > 0 && on_side_P ~= on_side_Q
                % Calculate error
                error = 0;
                if on_side_P == 1
                    point_on_side = V1 + param_P * (V2 - V1);
                elseif on_side_P == 2
                    point_on_side = V2 + param_P * (V3 - V2);
                else
                    point_on_side = V3 + param_P * (V1 - V3);
                end
                error = error + norm(P - point_on_side);

                if on_side_Q == 1
                    point_on_side = V1 + param_Q * (V2 - V1);
                elseif on_side_Q == 2
                    point_on_side = V2 + param_Q * (V3 - V2);
                else
                    point_on_side = V3 + param_Q * (V1 - V3);
                end
                error = error + norm(Q - point_on_side);

                if error < min_error
                    min_error = error;
                    best_vertices = [V1, V2, V3];
                end
            end
        end
    end

    % If brute force didn't work well, use analytical approach
    if min_error > 0.1 || isempty(best_vertices)
        fprintf('Using analytical approach...\n');
        vertices = solve_analytical(S, P, Q);
    else
        vertices = best_vertices;
    end

    % Display results
    fprintf('\nVertices of the regular triangle:\n');
    fprintf('  V1 = (%.4f, %.4f)\n', vertices(1,1), vertices(2,1));
    fprintf('  V2 = (%.4f, %.4f)\n', vertices(1,2), vertices(2,2));
    fprintf('  V3 = (%.4f, %.4f)\n', vertices(1,3), vertices(2,3));

    % Verify it's a regular triangle
    side1 = norm(vertices(:,2) - vertices(:,1));
    side2 = norm(vertices(:,3) - vertices(:,2));
    side3 = norm(vertices(:,1) - vertices(:,3));
    centroid = mean(vertices, 2);

    fprintf('\nVerification:\n');
    fprintf('  Side 1: %.4f\n', side1);
    fprintf('  Side 2: %.4f\n', side2);
    fprintf('  Side 3: %.4f\n', side3);
    fprintf('  Max side difference: %.2e\n', max([abs(side1-side2), abs(side2-side3), abs(side3-side1)]));
    fprintf('  Centroid: (%.4f, %.4f)\n', centroid(1), centroid(2));
    fprintf('  Centroid error: %.2e\n', norm(centroid - S));

    % Visualize the result
    visualize_result(S, P, Q, vertices);
end

function [side, param] = point_on_triangle_side(Pt, V1, V2, V3)
    % Check if point Pt lies on any side of triangle (V1, V2, V3)
    % Returns: side number (1, 2, or 3) and parameter (0 to 1), or 0 if not on any side
    tol = 0.01;

    % Check side 1: V1 to V2
    [dist, t] = point_to_segment_distance(Pt, V1, V2);
    if dist < tol && t >= -tol && t <= 1+tol
        side = 1;
        param = t;
        return;
    end

    % Check side 2: V2 to V3
    [dist, t] = point_to_segment_distance(Pt, V2, V3);
    if dist < tol && t >= -tol && t <= 1+tol
        side = 2;
        param = t;
        return;
    end

    % Check side 3: V3 to V1
    [dist, t] = point_to_segment_distance(Pt, V3, V1);
    if dist < tol && t >= -tol && t <= 1+tol
        side = 3;
        param = t;
        return;
    end

    side = 0;
    param = 0;
end

function [dist, t] = point_to_segment_distance(P, A, B)
    % Calculate distance from point P to line segment AB
    % Also returns parameter t where closest point = A + t*(B-A)
    AB = B - A;
    AP = P - A;
    t = dot(AP, AB) / dot(AB, AB);
    t = max(0, min(1, t));
    closest = A + t * AB;
    dist = norm(P - closest);
end

function vertices = solve_analytical(S, P, Q)
    % Analytical solution using optimization
    % Minimize the constraint violations for a regular triangle

    % Initial guess: use P and Q to estimate scale and rotation
    dist_PS = norm(P - S);
    dist_QS = norm(Q - S);
    avg_dist = (dist_PS + dist_QS) / 2;

    % For equilateral triangle, circumradius R relates to side length a by: R = a/sqrt(3)
    % Centroid to vertex distance is R
    % Estimate scale from average distance
    R_estimate = avg_dist * 1.5;

    % Estimate rotation from angle to P
    angle_estimate = atan2(P(2) - S(2), P(1) - S(1));

    % Define vertices as function of angle and scale
    objective = @(x) cost_function(x, S, P, Q);

    % x = [angle, scale]
    x0 = [angle_estimate, R_estimate];

    % Use optimization
    options = optimset('Display', 'off', 'TolX', 1e-8, 'TolFun', 1e-8);
    x_opt = fminsearch(objective, x0, options);

    angle = x_opt(1);
    R = x_opt(2);

    % Construct vertices
    V1 = S + R * [cos(angle + pi/2); sin(angle + pi/2)];
    V2 = S + R * [cos(angle + pi/2 + 2*pi/3); sin(angle + pi/2 + 2*pi/3)];
    V3 = S + R * [cos(angle + pi/2 + 4*pi/3); sin(angle + pi/2 + 4*pi/3)];

    vertices = [V1, V2, V3];
end

function cost = cost_function(x, S, P, Q)
    % Cost function for optimization
    angle = x(1);
    R = x(2);

    % Construct vertices
    V1 = S + R * [cos(angle + pi/2); sin(angle + pi/2)];
    V2 = S + R * [cos(angle + pi/2 + 2*pi/3); sin(angle + pi/2 + 2*pi/3)];
    V3 = S + R * [cos(angle + pi/2 + 4*pi/3); sin(angle + pi/2 + 4*pi/3)];

    % Calculate distance from P and Q to triangle sides
    dist_P = min([point_to_segment_distance(P, V1, V2), ...
                   point_to_segment_distance(P, V2, V3), ...
                   point_to_segment_distance(P, V3, V1)]);

    dist_Q = min([point_to_segment_distance(Q, V1, V2), ...
                   point_to_segment_distance(Q, V2, V3), ...
                   point_to_segment_distance(Q, V3, V1)]);

    cost = dist_P^2 + dist_Q^2;

    % Penalize if R is too small or negative
    if R < 0.1
        cost = cost + 1000;
    end
end

function visualize_result(S, P, Q, vertices)
    % Create visualization figure
    figure('Name', 'Regular Triangle Solution', 'NumberTitle', 'off');
    axis equal;
    grid on;
    hold on;

    % Draw the triangle
    fill([vertices(1,:), vertices(1,1)], [vertices(2,:), vertices(2,1)], ...
         'g', 'FaceAlpha', 0.2, 'EdgeColor', 'g', 'LineWidth', 2);

    % Plot vertices
    plot(vertices(1,:), vertices(2,:), 'go', 'MarkerSize', 12, 'MarkerFaceColor', 'g');

    % Label vertices
    text(vertices(1,1), vertices(2,1), '  V1', 'FontSize', 11, 'Color', 'g', 'FontWeight', 'bold');
    text(vertices(1,2), vertices(2,2), '  V2', 'FontSize', 11, 'Color', 'g', 'FontWeight', 'bold');
    text(vertices(1,3), vertices(2,3), '  V3', 'FontSize', 11, 'Color', 'g', 'FontWeight', 'bold');

    % Plot centroid
    plot(S(1), S(2), 'ko', 'MarkerSize', 14, 'MarkerFaceColor', 'k');
    text(S(1), S(2), '  S (centroid)', 'FontSize', 11, 'FontWeight', 'bold');

    % Plot P and Q
    plot(P(1), P(2), 'bo', 'MarkerSize', 12, 'MarkerFaceColor', 'b');
    text(P(1), P(2), '  P', 'FontSize', 11, 'Color', 'b', 'FontWeight', 'bold');

    plot(Q(1), Q(2), 'ro', 'MarkerSize', 12, 'MarkerFaceColor', 'r');
    text(Q(1), Q(2), '  Q', 'FontSize', 11, 'Color', 'r', 'FontWeight', 'bold');

    % Draw medians from centroid to vertices (hidden from legend)
    for i = 1:3
        plot([S(1), vertices(1,i)], [S(2), vertices(2,i)], 'k--', 'LineWidth', 1, ...
             'HandleVisibility', 'off');
    end

    legend('Triangle', 'Vertices', 'Centroid', 'Point P', 'Point Q', 'Location', 'best');
    title('Regular Triangle with Given Centroid and Points on Sides');

    hold off;
end
