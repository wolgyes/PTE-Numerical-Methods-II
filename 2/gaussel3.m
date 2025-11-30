function [A_inv, det_A, L, U] = gaussel3(A)
    % GAUSSEL3 Computes matrix inverse using Gaussian elimination with LU decomposition
    %
    % Input:
    %   A - square matrix to invert
    %
    % Outputs:
    %   A_inv - inverse of matrix A
    %   det_A - determinant of matrix A
    %   L - lower triangular matrix from LU decomposition
    %   U - upper triangular matrix from LU decomposition
    
    [n, m] = size(A);
    
    if n ~= m
        error('Input must be a square matrix');
    end
    
    if n == 0
        error('Input matrix cannot be empty');
    end
    
    original_A = A;
    
    try
        I = eye(n);
        A_inv = gaussel2(original_A, I, false);
    
        if isempty(A_inv)
            det_A = 0;
            L = [];
            U = [];
            warning('Matrix is singular - inverse does not exist');
            return;
        end
    
        L = eye(n);
        U = A;
        det_A = 1;
    
        for i = 1:n-1
            if abs(U(i, i)) < eps
                for k = i+1:n
                    if abs(U(k, i)) > eps
                        U([i k], :) = U([k i], :);
                        L([i k], 1:i-1) = L([k i], 1:i-1);
                        det_A = -det_A;
                        break;
                    end
                end
                if abs(U(i, i)) < eps
                    det_A = 0;
                    A_inv = [];
                    L = [];
                    U = [];
                    warning('Matrix is singular - inverse does not exist');
                    return;
                end
            end
    
            det_A = det_A * U(i, i);
    
            for j = i+1:n
                if abs(U(j, i)) > eps
                    factor = U(j, i) / U(i, i);
                    L(j, i) = factor;
                    U(j, :) = U(j, :) - factor * U(i, :);
                end
            end
        end
    
        det_A = det_A * U(n, n);
    
        if abs(det_A) < eps
            det_A = 0;
            A_inv = [];
            L = [];
            U = [];
            warning('Matrix is singular - inverse does not exist');
            return;
        end
    
    catch ME
        det_A = 0;
        A_inv = [];
        L = [];
        U = [];
        warning('Matrix is singular - inverse does not exist');
        return;
    end
    
    if nargout > 3 || nargout == 0
        fprintf('Matrix A:\n');
        disp(original_A);
        fprintf('Determinant of A: %.6f\n', det_A);
        fprintf('L matrix (lower triangular):\n');
        disp(L);
        fprintf('U matrix (upper triangular):\n');
        disp(U);
        fprintf('Verification L*U:\n');
        disp(L * U);
        fprintf('Inverse of A:\n');
        disp(A_inv);
        fprintf('Verification A * A_inv:\n');
        disp(original_A * A_inv);
    end
    
    end