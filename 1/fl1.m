function real_num = fl1(machine_vec)
% FL1 Converts a machine number to its real number representation
%
% Input: machine_vec - vector where last element is characteristic (ternary),
%                      other elements are signed mantissa bits (0 or 1)
% Output: real_num - the real number represented by the machine number

    % Input validation
    if ~isvector(machine_vec) || length(machine_vec) < 2
        error('Input must be a vector with at least 2 elements');
    end
    
    % Check if all mantissa bits are 0 or 1
    mantissa_bits = machine_vec(1:end-1);
    if any(mantissa_bits ~= 0 & mantissa_bits ~= 1)
        error('Mantissa bits must be 0 or 1');
    end
    
    % Check if characteristic is an integer
    characteristic = machine_vec(end);
    if ~isinteger(characteristic) && characteristic ~= round(characteristic)
        error('Characteristic must be an integer');
    end
    
    % Handle zero case (all mantissa bits are 0)
    if all(mantissa_bits == 0)
        real_num = 0;
        return;
    end
    
    % Extract sign bit (first bit of mantissa)
    sign_bit = mantissa_bits(1);
    if sign_bit == 0
        sign = 1;  % positive
    else
        sign = -1; % negative
    end
    
    % Extract fractional part of mantissa (remaining bits)
    frac_bits = mantissa_bits(2:end);
    
    % Convert fractional part from binary to decimal
    % Each bit represents 2^(-i) where i is the position
    fractional_part = 0;
    for i = 1:length(frac_bits)
        fractional_part = fractional_part + frac_bits(i) * (2^(-i));
    end
    
    % Calculate the real number: sign * (1 + fractional_part) * 3^characteristic
    real_num = sign * (1 + fractional_part) * (3^characteristic);
    
end