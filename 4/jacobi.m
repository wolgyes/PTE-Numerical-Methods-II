function x = jacobi(A, b, x0, tol, maxiter)
% JACOBI Solves linear system Ax=b using Jacobi iteration
%
% Input:
%   A        - coefficient matrix (must be square)
%   b        - right-hand side vector
%   x0       - initial guess (optional, default is zero vector)
%   tol      - tolerance for convergence (optional, default 1e-6)
%   maxiter  - maximum number of iterations (optional, default 1000)
%
% Output:
%   x        - approximate solution vector

    n = length(b);

    % Set default values for optional parameters
    if nargin < 3 || isempty(x0)
        x0 = zeros(n, 1);
    end
    if nargin < 4 || isempty(tol)
        tol = 1e-6;
    end
    if nargin < 5 || isempty(maxiter)
        maxiter = 1000;
    end

    % Extract diagonal matrix D
    D = diag(diag(A));

    % Compute R = L + U (off-diagonal part)
    R = A - D;

    % Initialize
    x = x0;

    % Jacobi iteration using vectorial form
    for iter = 1:maxiter
        x_new = D \ (b - R * x);

        % Check convergence
        if norm(x_new - x, inf) < tol
            x = x_new;
            fprintf('Jacobi converged in %d iterations\n', iter);
            return;
        end

        x = x_new;
    end

    warning('Jacobi did not converge within %d iterations', maxiter);
end
