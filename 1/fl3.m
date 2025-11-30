function machine_vec = fl3(real_num, t, k1, k2)
% FL3 Converts a real number to machine number representation
%
% Input: real_num - real number to convert
%        t        - number of mantissa bits (positive integer)
%        k1       - minimum characteristic (integer)  
%        k2       - maximum characteristic (integer)
% Output: machine_vec - vector with t+1 elements: [mantissa(t bits), characteristic]

    % Input validation
    if ~isscalar(t) || t <= 0 || t ~= round(t)
        error('t must be a positive integer');
    end
    
    if ~isscalar(k1) || ~isscalar(k2) || k1 ~= round(k1) || k2 ~= round(k2)
        error('k1 and k2 must be integers');
    end
    
    if k1 >= k2
        error('k1 must be less than k2');
    end
    
    if ~isscalar(real_num) || ~isreal(real_num)
        error('Input must be a real scalar');
    end
    
    % Handle zero case
    if real_num == 0
        machine_vec = [zeros(1, t), 0];
        return;
    end
    
    % Calculate range bounds using fl2 to get eps_0 and M_inf
    [M_inf, eps_0, ~, ~] = fl2(t, k1, k2, false);
    
    % Check if number is representable
    if abs(real_num) < eps_0
        error('Number too small: |r| < ε_0 = %.6f', eps_0);
    end
    
    if abs(real_num) > M_inf
        error('Number too large: |r| > M_∞ = %.6f', M_inf);
    end
    
    % Determine sign
    if real_num > 0
        sign_bit = 0;
        abs_num = real_num;
    else
        sign_bit = 1;
        abs_num = -real_num;
    end
    
    % Find the characteristic k such that 3^k ≤ abs_num < 3^(k+1)
    % This means abs_num = (1 + fractional_part) * 3^k where 0 ≤ fractional_part < 1
    k = floor(log(abs_num) / log(3));
    
    % Ensure k is within bounds
    if k < k1
        k = k1;
    elseif k > k2
        k = k2;
    end
    
    % Calculate the mantissa: abs_num = (1 + fractional_part) * 3^k
    mantissa_value = abs_num / (3^k);
    fractional_part = mantissa_value - 1;
    
    % Ensure fractional part is in [0, 1)
    if fractional_part < 0
        fractional_part = 0;
    elseif fractional_part >= 1
        fractional_part = 1 - eps; % Just under 1
    end
    
    % Convert fractional part to binary representation
    frac_bits = zeros(1, t-1);  % t-1 bits for fractional part (first bit is sign)
    temp_frac = fractional_part;
    
    for i = 1:(t-1)
        temp_frac = temp_frac * 2;
        if temp_frac >= 1
            frac_bits(i) = 1;
            temp_frac = temp_frac - 1;
        else
            frac_bits(i) = 0;
        end
    end
    
    % Construct mantissa: [sign_bit, fractional_bits]
    mantissa = [sign_bit, frac_bits];
    
    % Construct machine number vector
    machine_vec = [mantissa, k];
    
    % Verify the result by converting back
    reconstructed = fl1(machine_vec);
    relative_error = abs(reconstructed - real_num) / abs(real_num);
    
    if relative_error > 0.5  % If error is too large, try rounding
        % Try rounding the last bit
        if frac_bits(end) == 0
            frac_bits(end) = 1;
        else
            % Carry propagation for rounding
            carry = 1;
            for i = (t-1):-1:1
                if frac_bits(i) == 0 && carry == 1
                    frac_bits(i) = 1;
                    carry = 0;
                    break;
                elseif frac_bits(i) == 1 && carry == 1
                    frac_bits(i) = 0;
                else
                    break;
                end
            end
            
            % If carry propagated through all bits, increment characteristic
            if carry == 1 && k < k2
                k = k + 1;
                frac_bits = zeros(1, t-1);
            end
        end
        
        % Reconstruct with rounded values
        mantissa = [sign_bit, frac_bits];
        machine_vec = [mantissa, k];
    end
    
end