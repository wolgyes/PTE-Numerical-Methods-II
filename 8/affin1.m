function A = affin1(img01, img10)
% AFFIN1 Returns the matrix of an affine transform with fixed point at Origin
%
% Input arguments:
%   img01 - Image of point (0,1) as [x; y] or [x, y]
%   img10 - Image of point (1,0) as [x; y] or [x, y]
%
% Output argument:
%   A - 2x2 transformation matrix
%
% If called without input arguments, allows graphical input of the image points.
%
% Mathematical background:
% For an affine transform with fixed point at origin, we have:
%   T([x; y]) = A * [x; y]
% where A is a 2x2 matrix [a b; c d]
%
% Given that (0,1) maps to img01 and (1,0) maps to img10:
%   A * [1; 0] = img10  (first column of A)
%   A * [0; 1] = img01  (second column of A)

    % Check if called without input arguments - enable graphical input
    if nargin == 0
        fprintf('Graphical input mode:\n');
        fprintf('Click to select the image of point (0,1)\n');

        % Create figure for graphical input
        figure('Name', 'Affin Transform with Fixed Point at Origin', 'NumberTitle', 'off');
        axis equal;
        grid on;
        hold on;

        % Draw coordinate system
        xlim([-5 5]);
        ylim([-5 5]);
        plot([-5 5], [0 0], 'k-', 'LineWidth', 0.5);
        plot([0 0], [-5 5], 'k-', 'LineWidth', 0.5);

        % Draw original points
        plot(0, 0, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
        plot(0, 1, 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b');
        plot(1, 0, 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');

        text(0, 0, '  Origin (0,0)', 'FontSize', 10);
        text(0, 1, '  (0,1)', 'FontSize', 10);
        text(1, 0, '  (1,0)', 'FontSize', 10);

        title('Select image of (0,1) and (1,0)');

        % Get image of (0,1)
        fprintf('Click on the image of point (0,1):\n');
        [x1, y1] = ginput(1);
        img01 = [x1; y1];
        plot(x1, y1, 'bs', 'MarkerSize', 12, 'MarkerFaceColor', 'b');
        text(x1, y1, sprintf('  Image of (0,1): (%.2f,%.2f)', x1, y1), 'FontSize', 10);

        % Get image of (1,0)
        fprintf('Click on the image of point (1,0):\n');
        [x2, y2] = ginput(1);
        img10 = [x2; y2];
        plot(x2, y2, 'gs', 'MarkerSize', 12, 'MarkerFaceColor', 'g');
        text(x2, y2, sprintf('  Image of (1,0): (%.2f,%.2f)', x2, y2), 'FontSize', 10);

        % Draw transformation arrows
        quiver(0, 1, x1, y1-1, 0, 'b-', 'LineWidth', 2, 'MaxHeadSize', 0.5);
        quiver(1, 0, x2-1, y2, 0, 'g-', 'LineWidth', 2, 'MaxHeadSize', 0.5);

        hold off;
    end

    % Ensure column vectors
    if size(img01, 2) > size(img01, 1)
        img01 = img01';
    end
    if size(img10, 2) > size(img10, 1)
        img10 = img10';
    end

    % Construct the transformation matrix
    % A * [1; 0] = img10  =>  first column is img10
    % A * [0; 1] = img01  =>  second column is img01
    A = [img10, img01];

    % Display the result
    fprintf('\nTransformation matrix A:\n');
    disp(A);
    fprintf('Verification:\n');
    fprintf('  A * [1; 0] = [%.4f; %.4f] (should be img10)\n', A * [1; 0]);
    fprintf('  A * [0; 1] = [%.4f; %.4f] (should be img01)\n', A * [0; 1]);
    fprintf('  A * [0; 0] = [%.4f; %.4f] (should be [0; 0])\n', A * [0; 0]);
end
