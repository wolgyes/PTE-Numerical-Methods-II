function [Q, R] = hhalg(A)
% HHALG QR-decomposition using Householder algorithm
%   [Q, R] = hhalg(A) computes the QR-decomposition of a square matrix A
%   such that A = Q*R, where Q is an orthogonal matrix and R is upper triangular.
%   Uses Householder reflections to zero out below-diagonal elements.
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

    % Initialize Q as identity and R as A
    Q = eye(n);
    R = A;

    % Apply Householder reflections for each column
    for k = 1:n-1
        % Extract the subvector from column k, row k to end
        x = R(k:n, k);

        % Compute the target vector (first element = norm, rest = 0)
        % Use sign convention for numerical stability
        sigma = -sign(x(1)) * norm(x);

        % If x(1) is zero, use -1 as default sign
        if x(1) == 0
            sigma = -norm(x);
        end

        % Construct target vector e1
        e1 = zeros(length(x), 1);
        e1(1) = 1;

        % Compute Householder vector: v = x - sigma*e1
        v = x - sigma * e1;

        % Normalize v (optional, but helps with numerical stability)
        v_norm = norm(v);

        % Check if reflection is needed
        if v_norm < eps * norm(x)
            % No reflection needed, column already in correct form
            continue;
        end

        % Compute Householder matrix for subspace: H_sub = I - 2*v*v'/(v'*v)
        H_sub = eye(length(v)) - 2 * (v * v') / (v' * v);

        % Embed into full-size matrix
        H_full = eye(n);
        H_full(k:n, k:n) = H_sub;

        % Apply Householder reflection to R
        R = H_full * R;

        % Accumulate into Q
        % Since A = Q*R, and we're doing R = H*R, we need Q = Q*H'
        % But H is symmetric (H' = H), so Q = Q*H
        Q = Q * H_full;
    end

    % Q should be accumulated as product of Householder matrices
    % Since A = H1*H2*...*Hn-1*A = R, we have:
    % A = (H1*H2*...*Hn-1)'*R
    % Since each Hi is symmetric (Hi' = Hi), we get:
    % A = (H1*H2*...*Hn-1)*R, so Q = H1*H2*...*Hn-1
    % We accumulated Q = H1*H2*...*Hn-1 in the loop, so no transpose needed!

    % Clean up numerical errors for R (set near-zero below-diagonal to exactly zero)
    for i = 1:n
        for j = 1:i-1
            if abs(R(i,j)) < 1e-10
                R(i,j) = 0;
            end
        end
    end

    % Verification (optional - can be commented out for production)
    % error_norm = norm(A - Q*R, 'fro');
    % fprintf('Reconstruction error ||A - Q*R||_F = %e\n', error_norm);

end
