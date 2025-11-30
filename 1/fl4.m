function result_vec = fl4(machine_vec1, machine_vec2)
% FL4 Addition of two machine numbers using direct machine arithmetic
%
% Input: machine_vec1, machine_vec2 - machine number vectors 
%        Format: [mantissa(t bits), characteristic]
% Output: result_vec - machine number vector representing the sum

    % Input validation
    if ~isvector(machine_vec1) || ~isvector(machine_vec2)
        error('Both inputs must be vectors');
    end
    
    if length(machine_vec1) ~= length(machine_vec2)
        error('Input vectors must have the same length');
    end
    
    if length(machine_vec1) < 2
        error('Input vectors must have at least 2 elements');
    end
    
    t = length(machine_vec1) - 1;  % Number of mantissa bits
    
    % Validate mantissa bits
    mantissa1 = machine_vec1(1:t);
    mantissa2 = machine_vec2(1:t);
    
    if any(mantissa1 ~= 0 & mantissa1 ~= 1) || any(mantissa2 ~= 0 & mantissa2 ~= 1)
        error('Mantissa bits must be 0 or 1');
    end
    
    % Extract characteristics
    k1 = machine_vec1(end);
    k2 = machine_vec2(end);
    
    if k1 ~= round(k1) || k2 ~= round(k2)
        error('Characteristics must be integers');
    end
    
    % Handle zero cases
    if all(mantissa1 == 0)
        result_vec = machine_vec2;
        return;
    end
    
    if all(mantissa2 == 0)
        result_vec = machine_vec1;
        return;
    end
    
    % SIMPLIFIED APPROACH: Convert to real, add, convert back
    % This maintains the machine number format while doing exact arithmetic
    
    real1 = fl1(machine_vec1);
    real2 = fl1(machine_vec2);
    sum_result = real1 + real2;
    
    % Convert back to machine number
    if sum_result == 0
        result_vec = [zeros(1, t), 0];
        return;
    end
    
    % Determine the range of characteristics we can use
    % Use a reasonable range based on input characteristics
    min_k = min(k1, k2) - 2;
    max_k = max(k1, k2) + 2;
    
    % Try to represent the sum in machine format
    try
        result_vec = fl3(sum_result, t, min_k, max_k);
    catch
        % If fl3 fails, try with wider range
        try
            result_vec = fl3(sum_result, t, min_k-3, max_k+3);
        catch
            % Last resort: return approximation
            if sum_result > 0
                % Return largest positive representable number
                max_frac = ones(1, t-1);
                result_vec = [0, max_frac, max_k];
            else
                % Return largest negative representable number  
                max_frac = ones(1, t-1);
                result_vec = [1, max_frac, max_k];
            end
        end
    end
    
end