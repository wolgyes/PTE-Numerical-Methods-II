function examples()
% EXAMPLES - Comprehensive examples for all Gaussian Elimination functions

fprintf('=====================================\n');
fprintf('GAUSSIAN ELIMINATION EXAMPLES\n');
fprintf('=====================================\n\n');

fprintf('Select which examples to run:\n');
fprintf('1. gaussel1 examples (Basic Gaussian Elimination)\n');
fprintf('2. gaussel2 examples (Gaussian Elimination with Pivoting)\n');
fprintf('3. gaussel3 examples (Matrix Inverse and LU Decomposition)\n');
fprintf('4. Run all examples\n');
fprintf('0. Exit\n');

choice = input('Enter your choice (0-4): ');

switch choice
    case 1
        examples_gaussel1();
    case 2
        examples_gaussel2();
    case 3
        examples_gaussel3();
    case 4
        examples_gaussel1();
        fprintf('\nPress any key to continue to gaussel2 examples...\n');
        pause;
        examples_gaussel2();
        fprintf('\nPress any key to continue to gaussel3 examples...\n');
        pause;
        examples_gaussel3();
    case 0
        fprintf('Exiting...\n');
        return;
    otherwise
        fprintf('Invalid choice. Please run the function again.\n');
end

end

function examples_gaussel1()
    fprintf('\n=====================================\n');
    fprintf('GAUSSEL1 EXAMPLES\n');
    fprintf('Basic Gaussian Elimination\n');
    fprintf('=====================================\n\n');

    fprintf('Example 1: Solving a simple 3x3 system\n');
    fprintf('----------------------------------------\n');
    fprintf('System of equations:\n');
    fprintf('  2x + y - z = 8\n');
    fprintf(' -3x - y + 2z = -11\n');
    fprintf(' -2x + y + 2z = -3\n\n');

    A1 = [2 1 -1; -3 -1 2; -2 1 2];
    b1 = [8; -11; -3];
    fprintf('Matrix A:\n');
    disp(A1);
    fprintf('Vector b:\n');
    disp(b1);

    x1 = gaussel1(A1, b1);
    fprintf('Solution x:\n');
    disp(x1);

    fprintf('Verification (Ax = b):\n');
    disp(A1 * x1);
    fprintf('Original b = [8; -11; -3]\n\n');

    fprintf('Press any key to continue...\n');
    pause;

    fprintf('\nExample 2: System with multiple right-hand sides\n');
    fprintf('------------------------------------------------\n');
    fprintf('Solving Ax = b1 and Ax = b2 simultaneously\n\n');

    A2 = [4 -2 1; 2 1 -3; -1 3 2];
    b2 = [5 2; 1 -1; 8 4];
    fprintf('Matrix A:\n');
    disp(A2);
    fprintf('Multiple RHS matrix B (each column is a different b vector):\n');
    disp(b2);

    x2 = gaussel1(A2, b2);
    fprintf('Solutions X (each column corresponds to each b):\n');
    disp(x2);

    fprintf('Verification AX = B:\n');
    disp(A2 * x2);
    fprintf('Should equal B\n\n');

    fprintf('Press any key to continue...\n');
    pause;

    fprintf('\nExample 3: Displaying intermediate matrices\n');
    fprintf('--------------------------------------------\n');
    fprintf('Solving system with display_matrices = true\n\n');

    A3 = [1 2 -1; 3 1 2; 2 -1 1];
    b3 = [2; 12; 5];
    fprintf('Matrix A:\n');
    disp(A3);
    fprintf('Vector b:\n');
    disp(b3);

    fprintf('\nSolving with intermediate steps shown:\n');
    fprintf('---------------------------------------\n');
    x3 = gaussel1(A3, b3, true);

    fprintf('\nFinal solution:\n');
    disp(x3);

    fprintf('Verification Ax = b:\n');
    disp(A3 * x3);

    fprintf('Press any key to continue...\n');
    pause;

    fprintf('\nExample 4: System requiring row swapping\n');
    fprintf('-----------------------------------------\n');
    fprintf('System where first pivot is zero\n\n');

    A4 = [0 2 1; 1 -1 3; 2 1 -1];
    b4 = [1; 8; 1];
    fprintf('Matrix A (note zero in position (1,1)):\n');
    disp(A4);
    fprintf('Vector b:\n');
    disp(b4);

    x4 = gaussel1(A4, b4);
    fprintf('Solution x:\n');
    disp(x4);

    fprintf('Verification Ax = b:\n');
    disp(A4 * x4);
    fprintf('Original b = [1; 8; 1]\n\n');

    fprintf('Press any key to continue...\n');
    pause;

    fprintf('\nExample 5: Upper triangular system (already in REF)\n');
    fprintf('----------------------------------------------------\n');
    A5 = [2 -1 3; 0 4 -2; 0 0 5];
    b5 = [7; 2; 10];
    fprintf('Matrix A (upper triangular):\n');
    disp(A5);
    fprintf('Vector b:\n');
    disp(b5);

    x5 = gaussel1(A5, b5);
    fprintf('Solution x (obtained by back substitution):\n');
    disp(x5);

    fprintf('Verification Ax = b:\n');
    disp(A5 * x5);

    fprintf('\n=== End of gaussel1 examples ===\n');
end

function examples_gaussel2()
    fprintf('\n=====================================\n');
    fprintf('GAUSSEL2 EXAMPLES\n');
    fprintf('Gaussian Elimination with Pivoting\n');
    fprintf('=====================================\n\n');

    fprintf('Example 1: Partial pivoting on a standard system\n');
    fprintf('-------------------------------------------------\n');
    fprintf('System of equations:\n');
    fprintf('  2x + y - z = 8\n');
    fprintf(' -3x - y + 2z = -11\n');
    fprintf(' -2x + y + 2z = -3\n\n');

    A1 = [2 1 -1; -3 -1 2; -2 1 2];
    b1 = [8; -11; -3];
    fprintf('Matrix A:\n');
    disp(A1);
    fprintf('Vector b:\n');
    disp(b1);

    fprintf('Solving with partial pivoting:\n');
    x1 = gaussel2(A1, b1, true);
    fprintf('Solution x:\n');
    disp(x1);

    fprintf('Verification Ax = b:\n');
    disp(A1 * x1);

    fprintf('Press any key to continue...\n');
    pause;

    fprintf('\nExample 2: System requiring row pivoting\n');
    fprintf('-----------------------------------------\n');
    fprintf('System where first element is zero\n\n');

    A2 = [0 2 1; 1 -1 3; 2 1 -1];
    b2 = [1; 8; 1];
    fprintf('Matrix A (note zero in (1,1)):\n');
    disp(A2);
    fprintf('Vector b:\n');
    disp(b2);

    fprintf('Solving with partial pivoting (will handle zero pivot):\n');
    fprintf('Showing intermediate steps:\n');
    fprintf('----------------------------\n');
    x2 = gaussel2(A2, b2, true, true);

    fprintf('\nSolution x:\n');
    disp(x2);

    fprintf('Verification Ax = b:\n');
    disp(A2 * x2);

    fprintf('Press any key to continue...\n');
    pause;

    fprintf('\nExample 3: Full pivoting vs partial pivoting\n');
    fprintf('---------------------------------------------\n');
    fprintf('Comparing solutions with different pivoting strategies\n\n');

    A3 = [1e-15 1 2; 1 2 3; 2 3 4];
    b3 = [3; 6; 9];
    fprintf('Matrix A (with very small element at (1,1)):\n');
    disp(A3);
    fprintf('Vector b:\n');
    disp(b3);

    fprintf('Solving with partial pivoting:\n');
    x3_partial = gaussel2(A3, b3, true);
    fprintf('Solution with partial pivoting:\n');
    disp(x3_partial);

    fprintf('Solving with full pivoting:\n');
    x3_full = gaussel2(A3, b3, false);
    fprintf('Solution with full pivoting:\n');
    disp(x3_full);

    fprintf('Verification (partial): A * x = '); disp((A3 * x3_partial)');
    fprintf('Verification (full): A * x = '); disp((A3 * x3_full)');

    fprintf('Press any key to continue...\n');
    pause;

    fprintf('\nExample 4: Automatic switch from partial to full pivoting\n');
    fprintf('----------------------------------------------------------\n');
    fprintf('System that will trigger automatic switch\n\n');

    A4 = [0 1 2; 0 0 3; 1 2 3];
    b4 = [5; 6; 6];
    fprintf('Matrix A (multiple zeros in first column):\n');
    disp(A4);
    fprintf('Vector b:\n');
    disp(b4);

    fprintf('Solving with partial pivoting (will auto-switch to full):\n');
    fprintf('Watch for the warning message:\n');
    fprintf('-------------------------------\n');
    x4 = gaussel2(A4, b4, true, true);

    fprintf('\nSolution x:\n');
    disp(x4);

    fprintf('Verification Ax = b:\n');
    disp(A4 * x4);

    fprintf('Press any key to continue...\n');
    pause;

    fprintf('\nExample 5: Multiple right-hand sides with pivoting\n');
    fprintf('---------------------------------------------------\n');
    A5 = [3 -1 2; 1 4 -1; 2 -3 5];
    b5 = [7 1; 10 3; 4 2];
    fprintf('Matrix A:\n');
    disp(A5);
    fprintf('Multiple RHS matrix B:\n');
    disp(b5);

    fprintf('Solving with full pivoting:\n');
    fprintf('Showing intermediate steps:\n');
    fprintf('----------------------------\n');
    x5 = gaussel2(A5, b5, false, true);

    fprintf('\nSolutions X (each column is a solution):\n');
    disp(x5);

    fprintf('Verification AX = B:\n');
    disp(A5 * x5);

    fprintf('Press any key to continue...\n');
    pause;

    fprintf('\nExample 6: Showing intermediate matrices during computation\n');
    fprintf('------------------------------------------------------------\n');
    A6 = [1 2 -1; 3 1 2; 2 -1 1];
    b6 = [2; 12; 5];
    fprintf('Matrix A:\n');
    disp(A6);
    fprintf('Vector b:\n');
    disp(b6);

    fprintf('Solving with display_matrices = true:\n');
    fprintf('--------------------------------------\n');
    x6 = gaussel2(A6, b6, true, true);

    fprintf('\nFinal solution:\n');
    disp(x6);

    fprintf('\n=== End of gaussel2 examples ===\n');
end

function examples_gaussel3()
    fprintf('\n=====================================\n');
    fprintf('GAUSSEL3 EXAMPLES\n');
    fprintf('Matrix Inverse & LU Decomposition\n');
    fprintf('=====================================\n\n');

    fprintf('Example 1: Simple 2x2 matrix inverse\n');
    fprintf('-------------------------------------\n');
    A1 = [3 2; 1 4];
    fprintf('Matrix A:\n');
    disp(A1);

    oldState = warning('query', 'all');
    warning('off', 'all');
    [A1_inv, det_A1, L1, U1] = gaussel3(A1);
    warning(oldState);

    fprintf('Inverse of A:\n');
    disp(A1_inv);
    fprintf('Determinant: %.6f\n', det_A1);
    fprintf('L matrix (lower triangular):\n');
    disp(L1);
    fprintf('U matrix (upper triangular):\n');
    disp(U1);

    fprintf('\nVerification A * A_inv = I:\n');
    disp(A1 * A1_inv);
    fprintf('Verification L * U = A:\n');
    disp(L1 * U1);

    fprintf('Press any key to continue...\n');
    pause;

    fprintf('\nExample 2: 3x3 matrix with mixed values\n');
    fprintf('----------------------------------------\n');
    A2 = [1 2 3; 0 1 4; 5 6 0];
    fprintf('Matrix A:\n');
    disp(A2);

    oldState = warning('query', 'all');
    warning('off', 'all');
    [A2_inv, det_A2, L2, U2] = gaussel3(A2);
    warning(oldState);

    fprintf('Inverse of A:\n');
    disp(A2_inv);
    fprintf('Determinant: %.6f\n', det_A2);

    fprintf('\nVerification A * A_inv = I:\n');
    verification = A2 * A2_inv;
    disp(verification);
    fprintf('Maximum error from identity: %.2e\n', max(max(abs(verification - eye(3)))));

    fprintf('Press any key to continue...\n');
    pause;

    fprintf('\nExample 3: Diagonal matrix\n');
    fprintf('---------------------------\n');
    A3 = diag([2, 3, 4]);
    fprintf('Matrix A (diagonal):\n');
    disp(A3);

    oldState = warning('query', 'all');
    warning('off', 'all');
    [A3_inv, det_A3, L3, U3] = gaussel3(A3);
    warning(oldState);

    fprintf('Inverse of A:\n');
    disp(A3_inv);
    fprintf('Determinant: %.6f\n', det_A3);
    fprintf('Expected determinant (2*3*4): %d\n', 2*3*4);

    fprintf('\nNote: For diagonal matrices, L = I and U = A\n');
    fprintf('L matrix:\n');
    disp(L3);
    fprintf('U matrix:\n');
    disp(U3);

    fprintf('Press any key to continue...\n');
    pause;

    fprintf('\nExample 4: Matrix requiring row swapping\n');
    fprintf('-----------------------------------------\n');
    A4 = [0 1 2; 1 3 4; 2 1 3];
    fprintf('Matrix A (zero in (1,1)):\n');
    disp(A4);

    oldState = warning('query', 'all');
    warning('off', 'all');
    [A4_inv, det_A4, L4, U4] = gaussel3(A4);
    warning(oldState);

    fprintf('Inverse of A:\n');
    disp(A4_inv);
    fprintf('Determinant: %.6f\n', det_A4);

    fprintf('\nVerification A * A_inv = I:\n');
    disp(A4 * A4_inv);

    fprintf('Press any key to continue...\n');
    pause;

    fprintf('\nExample 5: Symmetric positive definite matrix\n');
    fprintf('----------------------------------------------\n');
    A5 = [4 -1 0; -1 4 -1; 0 -1 4];
    fprintf('Matrix A (symmetric positive definite):\n');
    disp(A5);

    oldState = warning('query', 'all');
    warning('off', 'all');
    [A5_inv, det_A5, L5, U5] = gaussel3(A5);
    warning(oldState);

    fprintf('Inverse of A:\n');
    disp(A5_inv);
    fprintf('Determinant: %.6f\n', det_A5);

    fprintf('\nChecking symmetry of inverse:\n');
    fprintf('A_inv - A_inv^T (should be near zero):\n');
    disp(A5_inv - A5_inv');

    fprintf('Press any key to continue...\n');
    pause;

    fprintf('\nExample 6: Upper triangular matrix\n');
    fprintf('-----------------------------------\n');
    A6 = [2 3 1; 0 4 2; 0 0 5];
    fprintf('Matrix A (upper triangular):\n');
    disp(A6);

    oldState = warning('query', 'all');
    warning('off', 'all');
    [A6_inv, det_A6, L6, U6] = gaussel3(A6);
    warning(oldState);

    fprintf('Inverse of A:\n');
    disp(A6_inv);
    fprintf('Determinant: %.6f\n', det_A6);
    fprintf('Expected determinant (2*4*5): %d\n', 2*4*5);

    fprintf('\nNote: L should be identity for upper triangular input:\n');
    fprintf('L matrix:\n');
    disp(L6);

    fprintf('Press any key to continue...\n');
    pause;

    fprintf('\nExample 7: Singular matrix (should fail)\n');
    fprintf('-----------------------------------------\n');
    A7 = [1 2; 2 4];
    fprintf('Matrix A (singular - rows are proportional):\n');
    disp(A7);

    fprintf('Attempting to invert singular matrix:\n');
    oldState = warning('query', 'all');
    warning('off', 'all');
    [A7_inv, det_A7, L7, U7] = gaussel3(A7);
    warning(oldState);

    if isempty(A7_inv)
        fprintf('✓ Correctly detected singular matrix\n');
        fprintf('Determinant: %.6f (should be zero)\n', det_A7);
    else
        fprintf('✗ ERROR: Should have detected singular matrix\n');
    end

    fprintf('Press any key to continue...\n');
    pause;

    fprintf('\nExample 8: Identity matrix\n');
    fprintf('---------------------------\n');
    A8 = eye(4);
    fprintf('Matrix A (4x4 identity):\n');
    disp(A8);

    oldState = warning('query', 'all');
    warning('off', 'all');
    [A8_inv, det_A8, L8, U8] = gaussel3(A8);
    warning(oldState);

    fprintf('Inverse of A (should be identity):\n');
    disp(A8_inv);
    fprintf('Determinant: %.6f (should be 1)\n', det_A8);

    fprintf('\n=== End of gaussel3 examples ===\n');
end