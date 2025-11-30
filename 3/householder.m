function H = householder(P, P_prime)
% HOUSEHOLDER Computes Householder transformation matrix from point and image
%   H = householder(P, P_prime) computes the Householder reflection matrix H
%   that transforms point P to point P_prime (or vice versa).
%
%   Input:
%       P - original point (column vector in R^n)
%       P_prime - image point after transformation (column vector in R^n)
%
%   Output:
%       H - Householder transformation matrix (n x n)
%           H = I - 2*v*v'/(v'*v) where v is the Householder vector

    % Ensure P and P_prime are column vectors
    P = P(:);
    P_prime = P_prime(:);

    % Check dimensions match
    if length(P) ~= length(P_prime)
        error('P and P_prime must have the same dimension');
    end

    n = length(P);

    % Compute the Householder vector
    % v = P - P_prime (this defines the reflection hyperplane)
    v = P - P_prime;

    % Check if P and P_prime are the same (no reflection needed)
    if norm(v) < eps * max(norm(P), norm(P_prime))
        H = eye(n);
        return;
    end

    % Construct Householder matrix: H = I - 2*v*v'/(v'*v)
    H = eye(n) - 2 * (v * v') / (v' * v);

    % Note on stability: The formula above is stable because we're using
    % v = P - P_prime directly. For the Householder QR algorithm where we
    % want to zero out components, we would use:
    % v = x + sign(x(1)) * norm(x) * e_1
    % This choice of sign avoids catastrophic cancellation.

end
