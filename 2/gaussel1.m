function x = gaussel1(A, b, display_matrices)
    % GAUSSEL1 Solves linear equation system Ax = b using Gaussian elimination
    %
    % Inputs:
    %   A - coefficient matrix (n x n or n x m)
    %   b - right-hand side vector(s) (n x 1 or n x k for multiple RHS)
    %   display_matrices - optional boolean to display intermediate matrices
    %
    % Output:
    %   x - solution vector(s)
    
    if nargin < 3
        display_matrices = false;
    end
    
    [n, m] = size(A);
    [nb, kb] = size(b);
    
    if n ~= nb
        error('Matrix A and vector b dimensions are incompatible');
    end
    
    if m > n
        error('Matrix A has more columns than rows - underdetermined system');
    end
    
    augmented = [A b];
    %   [nrows, ncols] = size(augmented);
    
    if display_matrices
        fprintf('Initial matrix A(0):\n');
        disp(A);
    end
    
    for i = 1:min(n, m)
        if abs(augmented(i, i)) < eps
            for k = i+1:n
                if abs(augmented(k, i)) > eps
                    augmented([i k], :) = augmented([k i], :);
                    break;
                end
            end
            if abs(augmented(i, i)) < eps
                error('Gaussian elimination cannot proceed without pivoting');
            end
        end
    
        for j = i+1:n
            if abs(augmented(j, i)) > eps
                factor = augmented(j, i) / augmented(i, i);
                augmented(j, :) = augmented(j, :) - factor * augmented(i, :);
            end
        end
    
        if display_matrices
            fprintf('Matrix A(%d):\n', i);
            disp(augmented(:, 1:m));
        end
    end
    
    if m < n
        warning('System is underdetermined. Providing base solution.');
    end
    
    for i = n:-1:1
        if i <= m && abs(augmented(i, i)) < eps
            error('Matrix is singular');
        end
    end
    
    x = zeros(m, kb);
    
    for col = 1:kb
        rhs = augmented(:, m + col);
    
        for i = min(n, m):-1:1
            if i > m || abs(augmented(i, i)) < eps
                continue;
            end
            x(i, col) = rhs(i);
            for j = i+1:min(m, n)
                x(i, col) = x(i, col) - augmented(i, j) * x(j, col);
            end
            x(i, col) = x(i, col) / augmented(i, i);
        end
    end
    
    end