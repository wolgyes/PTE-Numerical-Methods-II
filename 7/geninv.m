function Aplus = geninv(A)
% GENINV Compute the generalised inverse (Moore-Penrose pseudoinverse) of a matrix
%
% Input:
%   A - Input matrix (m x n)
%
% Output:
%   Aplus - Generalised inverse (n x m)
%
% Method:
%   - If A has full rank, uses direct formula based on whether m >= n or m < n
%   - If A is rank-deficient, uses rank factorisation A = F*G where
%     F is m x r and G is r x n (r = rank(A)), then A+ = G'*(G*G')^(-1)*(F'*F)^(-1)*F'
%
% The Moore-Penrose pseudoinverse satisfies:
%   1. A*A+*A = A
%   2. A+*A*A+ = A+
%   3. (A*A+)' = A*A+
%   4. (A+*A)' = A+*A

    [m, n] = size(A);
    r = rank(A);

    % Check if matrix has full rank
    if r == min(m, n)
        % Full rank case - use direct formulas
        if m >= n
            % Full column rank: A+ = (A'*A)^(-1)*A'
            Aplus = inv(A' * A) * A';
        else
            % Full row rank: A+ = A'*(A*A')^(-1)
            Aplus = A' * inv(A * A');
        end
    else
        % Rank-deficient case - use rank factorisation
        % Find rank factorisation A = F*G where F is m x r and G is r x n

        % Use SVD to find rank factorisation (more robust)
        [U, S, V] = svd(A);

        % Extract the first r columns (corresponding to non-zero singular values)
        U_r = U(:, 1:r);
        S_r = S(1:r, 1:r);
        V_r = V(:, 1:r);

        % Rank factorisation: A = F*G where
        % F = U_r * sqrt(S_r) and G = sqrt(S_r) * V_r'
        % Or simply: F = U_r and G = S_r * V_r'
        F = U_r;
        G = S_r * V_r';

        % Compute generalised inverse using rank factorisation formula
        % A+ = G' * (G*G')^(-1) * (F'*F)^(-1) * F'
        GGt = G * G';
        FtF = F' * F;

        Aplus = G' * inv(GGt) * inv(FtF) * F';
    end

    % Note: For verification, one can check that A*Aplus*A ≈ A
end
