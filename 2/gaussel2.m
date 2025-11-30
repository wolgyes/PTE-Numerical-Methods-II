function x = gaussel2(A, b, use_partial_pivoting, display_matrices)
    % GAUSSEL2 Solves linear equation system Ax = b using Gaussian elimination with pivoting
    %
    % Inputs:
    %   A - coefficient matrix (n x n or n x m)
    %   b - right-hand side vector(s) (n x 1 or n x k for multiple RHS)
    %   use_partial_pivoting - boolean, true for partial pivoting, false for full pivoting
    %   display_matrices - optional boolean to display intermediate matrices
    %
    % Output:
    %   x - solution vector(s)
    
    if nargin < 4
        display_matrices = false;
    end
    
    if nargin < 3
        use_partial_pivoting = true;
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
    [nrows, ncols] = size(augmented);
    
    row_permutation = 1:n;
    col_permutation = 1:m;
    pivoting_switched = false;
    
    if display_matrices
        fprintf('Initial matrix A(0):\n');
        disp(A);
    end
    
    for i = 1:min(n, m)
        max_val = 0;
        max_row = i;
        max_col = i;
    
        if use_partial_pivoting && ~pivoting_switched
            for k = i:n
                if abs(augmented(k, i)) > max_val
                    max_val = abs(augmented(k, i));
                    max_row = k;
                end
            end
    
            if max_val < eps
                if i <= m
                    fprintf('Warning: Partial pivoting stuck, switching to full pivoting\n');
                    use_partial_pivoting = false;
                    pivoting_switched = true;
                end
            end
        end
    
        if ~use_partial_pivoting || pivoting_switched
            for k = i:n
                for j = i:m
                    if abs(augmented(k, j)) > max_val
                        max_val = abs(augmented(k, j));
                        max_row = k;
                        max_col = j;
                    end
                end
            end
        end
    
        if max_val < eps
            if i == n
                warning('System is underdetermined. Providing base solution.');
                break;
            else
                error('Matrix is singular - cannot proceed');
            end
        end
    
        if max_row ~= i
            augmented([i max_row], :) = augmented([max_row i], :);
            row_permutation([i max_row]) = row_permutation([max_row i]);
            if display_matrices
                fprintf('Row swap: %d <-> %d\n', i, max_row);
            end
        end
    
        if max_col ~= i && (~use_partial_pivoting || pivoting_switched)
            augmented(:, [i max_col]) = augmented(:, [max_col i]);
            col_permutation([i max_col]) = col_permutation([max_col i]);
            if display_matrices
                fprintf('Column swap: %d <-> %d\n', i, max_col);
            end
        end
    
        for j = i+1:n
            if abs(augmented(j, i)) > eps
                factor = augmented(j, i) / augmented(i, i);
                augmented(j, :) = augmented(j, :) - factor * augmented(i, :);
            end
        end
    
        if display_matrices
            fprintf('Matrix A(%d) after pivoting and elimination:\n', i);
            disp(augmented(:, 1:m));
        end
    end
    
    if pivoting_switched
        fprintf('Note: Full pivoting was used instead of partial pivoting\n');
    end
    
    if m < n
        warning('System is underdetermined. Providing base solution.');
    end
    
    x_temp = zeros(m, kb);
    
    for col = 1:kb
        rhs = augmented(:, m + col);
    
        for i = min(n, m):-1:1
            if abs(augmented(i, i)) < eps
                continue;
            end
            x_temp(i, col) = rhs(i);
            for j = i+1:m
                x_temp(i, col) = x_temp(i, col) - augmented(i, j) * x_temp(j, col);
            end
            x_temp(i, col) = x_temp(i, col) / augmented(i, i);
        end
    end
    
    x = zeros(m, kb);
    for i = 1:m
        x(col_permutation(i), :) = x_temp(i, :);
    end
    
    end