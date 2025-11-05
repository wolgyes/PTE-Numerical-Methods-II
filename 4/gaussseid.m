function x = gaussseid(A, b, x0, tol, maxiter)
% GAUSSSEID Solves linear system Ax=b using Gauss-Seidel iteration
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

    % Extract D (diagonal), L (strictly lower), U (strictly upper)
    D = diag(diag(A));
    L = tril(A, -1);
    U = triu(A, 1);

    % Initialize
    x = x0;

    % Gauss-Seidel iteration using vectorial form
    for iter = 1:maxiter
        x_new = (D + L) \ (b - U * x);

        % Check convergence
        if norm(x_new - x, inf) < tol
            x = x_new;
            fprintf('Gauss-Seidel converged in %d iterations\n', iter);
            return;
        end

        x = x_new;
    end

    warning('Gauss-Seidel did not converge within %d iterations', maxiter);
end
