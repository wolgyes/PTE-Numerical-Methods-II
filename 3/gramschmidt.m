function [Q, R] = gramschmidt(A)
% GRAMSCHMIDT QR-decomposition using Gram-Schmidt orthogonalization
%   [Q, R] = gramschmidt(A) computes the QR-decomposition of a square matrix A
%   such that A = Q*R, where Q is an orthogonal matrix and R is upper triangular.
%
%   Input:
%       A - square matrix (n x n)
%
%   Output:
%       Q - orthogonal matrix (n x n)
%       R - upper triangular matrix (n x n)

    % Get dimensions
    [m, n] = size(A);

    % Check if A is square
    if m ~= n
        error('Matrix A must be square');
    end

    % Check if columns are linearly independent
    if rank(A) ~= n
        error('Columns of A must be linearly independent for QR-decomposition');
    end

    % Initialize Q and R
    Q = zeros(n, n);
    R = zeros(n, n);

    % Modified Gram-Schmidt algorithm
    V = A;  % Working copy

    for j = 1:n
        % Compute R(j,j) as the norm of current column
        R(j, j) = norm(V(:, j));

        % Normalize to get Q(:,j)
        Q(:, j) = V(:, j) / R(j, j);

        % Orthogonalize remaining columns against Q(:,j)
        for k = j+1:n
            R(j, k) = Q(:, j)' * V(:, k);
            V(:, k) = V(:, k) - R(j, k) * Q(:, j);
        end
    end

    % Verification (optional - can be commented out for production)
    % error_norm = norm(A - Q*R, 'fro');
    % fprintf('Reconstruction error ||A - Q*R||_F = %e\n', error_norm);

end
