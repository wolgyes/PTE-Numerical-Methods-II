function [M_inf, eps_0, eps_1, num_elements] = fl2(t, k1, k2, show_plot)
% FL2 Displays machine number set on real axis and computes parameters
%
% Input: t  - number of mantissa bits (positive integer)
%        k1 - minimum characteristic (integer)
%        k2 - maximum characteristic (integer)
%        show_plot - optional boolean to show plot (default: true)
% Output: M_inf - largest representable number
%         eps_0 - smallest positive normalized number
%         eps_1 - machine epsilon (relative precision)
%         num_elements - total number of elements in the set

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
    
    % Handle optional show_plot parameter
    if nargin < 4
        show_plot = true;
    end
    
    % Generate all possible mantissa combinations
    % First bit is sign bit (0 or 1), remaining t-1 bits are fractional part
    mantissa_combinations = [];
    for i = 0:(2^t - 1)
        % Convert i to binary representation with t bits
        binary_repr = zeros(1, t);
        temp = i;
        for j = t:-1:1
            binary_repr(j) = mod(temp, 2);
            temp = floor(temp / 2);
        end
        mantissa_combinations = [mantissa_combinations; binary_repr];
    end
    
    % Generate all machine numbers
    machine_numbers = [];
    
    % Add zero (special case)
    machine_numbers = [machine_numbers, 0];
    
    % Generate positive and negative numbers for each characteristic
    for k = k1:k2
        for i = 1:size(mantissa_combinations, 1)
            mantissa = mantissa_combinations(i, :);
            
            % Skip if mantissa represents zero (all zeros after sign bit)
            if all(mantissa == 0)
                continue;
            end
            
            % Create machine number vector: [mantissa, characteristic]
            machine_vec = [mantissa, k];
            
            % Convert to real number using fl1
            real_val = fl1(machine_vec);
            machine_numbers = [machine_numbers, real_val];
        end
    end
    
    % Remove duplicates and sort
    machine_numbers = unique(machine_numbers);
    machine_numbers = sort(machine_numbers);
    
    % Count total elements
    num_elements = length(machine_numbers);
    
    % Calculate parameters
    positive_numbers = machine_numbers(machine_numbers > 0);
    
    % M_inf: largest representable number
    M_inf = max(abs(machine_numbers));
    
    % eps_0: smallest positive normalized number
    eps_0 = min(positive_numbers);
    
    % eps_1: machine epsilon (gap between 1 and next larger number)
    % Find the number just larger than 1
    larger_than_1 = positive_numbers(positive_numbers > 1);
    if ~isempty(larger_than_1)
        next_after_1 = min(larger_than_1);
        eps_1 = next_after_1 - 1;
    else
        eps_1 = NaN;
    end
    
    % Display results only if show_plot is true
    if show_plot
        fprintf('Machine Number Set Parameters:\n');
        fprintf('t = %d, k1 = %d, k2 = %d\n', t, k1, k2);
        fprintf('Number of elements: %d\n', num_elements);
        fprintf('M_∞ = %.6f\n', M_inf);
        fprintf('ε_0 = %.6f\n', eps_0);
        fprintf('ε_1 = %.6f\n', eps_1);
        
        % Plot on real axis
        figure;
        plot(machine_numbers, zeros(size(machine_numbers)), 'ro', 'MarkerSize', 4);
        grid on;
        xlabel('Real Numbers');
        title(sprintf('Machine Number Set (t=%d, k1=%d, k2=%d)', t, k1, k2));
        
        % Highlight special values
        hold on;
        if eps_0 ~= 0
            plot(eps_0, 0, 'bs', 'MarkerSize', 8, 'DisplayName', 'ε_0');
            plot(-eps_0, 0, 'bs', 'MarkerSize', 8);
        end
        plot(M_inf, 0, 'gs', 'MarkerSize', 8, 'DisplayName', 'M_∞');
        plot(-M_inf, 0, 'gs', 'MarkerSize', 8);
        
        if ~isnan(eps_1)
            plot(1 + eps_1, 0, 'ms', 'MarkerSize', 8, 'DisplayName', '1+ε_1');
        end
        
        legend('Machine Numbers', 'ε_0', 'M_∞', '1+ε_1', 'Location', 'best');
        hold off;
    end
    
end