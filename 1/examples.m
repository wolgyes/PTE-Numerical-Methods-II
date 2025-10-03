% TEST_FUNCTIONS - Test script for fl1, fl2, fl3, and fl4 functions
% This script demonstrates the usage of all four functions

fprintf('=== Testing Machine Number Functions ===\n\n');

% Test parameters
t = 4;   % 4-bit mantissa
k1 = -2; % minimum characteristic
k2 = 2;  % maximum characteristic

fprintf('Using parameters: t=%d, k1=%d, k2=%d\n\n', t, k1, k2);

%% Test fl1 - Machine number to real number conversion
fprintf('1. Testing fl1 (machine number to real number):\n');

% Test case 1: Positive number
% Mantissa: [0, 1, 1, 0] (sign=0, fractional=110 in binary = 0.75)
% Characteristic: 1
% Should be: (1 + 0.75) * 3^1 = 1.75 * 3 = 5.25
machine_num1 = [0, 1, 1, 0, 1];
real_val1 = fl1(machine_num1);
fprintf('   Machine: [0,1,1,0,1] -> Real: %.6f\n', real_val1);

% Test case 2: Negative number
% Mantissa: [1, 0, 1, 0] (sign=1, fractional=010 in binary = 0.25)
% Characteristic: 0  
% Should be: -(1 + 0.25) * 3^0 = -1.25
machine_num2 = [1, 0, 1, 0, 0];
real_val2 = fl1(machine_num2);
fprintf('   Machine: [1,0,1,0,0] -> Real: %.6f\n', real_val2);

% Test case 3: Zero
machine_num3 = [0, 0, 0, 0, 0];
real_val3 = fl1(machine_num3);
fprintf('   Machine: [0,0,0,0,0] -> Real: %.6f\n', real_val3);

%% Test fl2 - Display machine number set
fprintf('\n2. Testing fl2 (machine number set analysis):\n');
[M_inf, eps_0, eps_1, num_elements] = fl2(t, k1, k2);

%% Test fl3 - Real number to machine number conversion
fprintf('\n3. Testing fl3 (real number to machine number):\n');

try
    % Test with the real values we got from fl1
    machine_reconstructed1 = fl3(real_val1, t, k1, k2);
    fprintf('   Real: %.6f -> Machine: [%s]\n', real_val1, ...
            sprintf('%d,', machine_reconstructed1));
    
    % Verify by converting back
    verification1 = fl1(machine_reconstructed1);
    fprintf('   Verification: %.6f (error: %.2e)\n', verification1, ...
            abs(verification1 - real_val1));
    
    % Test with a simple number
    test_real = 2.0;
    machine_test = fl3(test_real, t, k1, k2);
    fprintf('   Real: %.6f -> Machine: [%s]\n', test_real, ...
            sprintf('%d,', machine_test));
    verification_test = fl1(machine_test);
    fprintf('   Verification: %.6f (error: %.2e)\n', verification_test, ...
            abs(verification_test - test_real));
            
catch ME
    fprintf('   Error in fl3: %s\n', ME.message);
end

%% Test fl4 - Machine number addition
fprintf('\n4. Testing fl4 (machine number addition):\n');

try
    % Add two positive numbers
    sum_result = fl4(machine_num1, [0, 1, 0, 0, 0]);  % Add [0,1,0,0,0]
    real_sum = fl1(sum_result);
    second_num_real = fl1([0, 1, 0, 0, 0]);
    
    fprintf('   Adding: %.6f + %.6f\n', real_val1, second_num_real);
    fprintf('   Result machine: [%s]\n', sprintf('%d,', sum_result));
    fprintf('   Result real: %.6f\n', real_sum);
    fprintf('   Expected: %.6f (error: %.2e)\n', real_val1 + second_num_real, ...
            abs(real_sum - (real_val1 + second_num_real)));
    
    % Test subtraction (positive + negative)
    sub_result = fl4(machine_num1, machine_num2);
    real_sub = fl1(sub_result);
    
    fprintf('\n   Subtracting: %.6f + (%.6f)\n', real_val1, real_val2);
    fprintf('   Result machine: [%s]\n', sprintf('%d,', sub_result));
    fprintf('   Result real: %.6f\n', real_sub);
    fprintf('   Expected: %.6f (error: %.2e)\n', real_val1 + real_val2, ...
            abs(real_sub - (real_val1 + real_val2)));
            
catch ME
    fprintf('   Error in fl4: %s\n', ME.message);
end

%% Summary
fprintf('\n=== Test Summary ===\n');
fprintf('All functions have been tested with basic examples.\n');
fprintf('Check the results above for accuracy and consistency.\n');

% Display some machine number set statistics
fprintf('\nMachine number set statistics:\n');
fprintf('- Total elements: %d\n', num_elements);
fprintf('- Largest number (M∞): %.6f\n', M_inf);
fprintf('- Smallest positive (ε₀): %.6f\n', eps_0);
if ~isnan(eps_1)
    fprintf('- Machine epsilon (ε₁): %.6f\n', eps_1);
else
    fprintf('- Machine epsilon (ε₁): undefined\n');
end