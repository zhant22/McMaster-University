clc;
clear;

A = 1.1578;
B = 0.561;
C = 0.0794;
R1 = [A B C 0 0 0 0 0 0 0 0];
R2 = [B A B C 0 0 0 0 0 0 0];
R3 = [C B A B C 0 0 0 0 0 0];
R4 = [0 C B A B C 0 0 0 0 0];
R5 = [0 0 C B A B C 0 0 0 0];
R6 = [0 0 0 C B A B C 0 0 0];
R7 = [0 0 0 0 C B A B C 0 0];
R8 = [0 0 0 0 0 C B A B C 0];
R9 = [0 0 0 0 0 0 C B A B C];
R10 = [0 0 0 0 0 0 0 C B A B];
R11 = [0 0 0 0 0 0 0 0 C B A];

% Create a 2D matrix by stacking these rows
matrix_11x11 = [R1; R2; R3; R4; R5; R6; R7; R8; R9; R10; R11];

% Display the 11x11 matrix in a visually appealing format
fprintf('%8.4f %8.4f %8.4f %8.4f %8.4f %8.4f %8.4f %8.4f %8.4f %8.4f %8.4f\n', matrix_11x11.');

auto_correlation = [R1; R2; R3; R4; R5; R6; R7; R8; R9; R10; R11];
cross_correlation = transpose([0.28 1 0.28 0 0 0 0 0 0 0 0]);
wopt = inv(auto_correlation) * cross_correlation
Error_mean_square = transpose(wopt) * auto_correlation * wopt - 2 * transpose(wopt) * cross_correlation + 1;

w = transpose([1 1 1 1 1 1 1 1 1 1 1]);
miu = 0.025
size = 1:1:2000;
threshold = 0.01; % Threshold variable
excessive_means_quare_error = zeros(1, 200); % Initialize the array

for i = size
    w = w - 0.5 * miu * 2 * ((auto_correlation) * w - cross_correlation);
    error_w = transpose(w) * auto_correlation * w - 2 * transpose(w) * cross_correlation + 1;
    excessive_means_quare_error(i) = error_w - Error_mean_square;
    
    if excessive_means_quare_error(i) <= threshold
        fprintf('After %.1f iterations, the minimum error is smaller than %.2f.\n', i, threshold);
        fprintf('current excessive mean square error = %.4f\n', excessive_means_quare_error(i));
        fprintf('Excess Mean Square Error = Mean Sqaure Error - Min = %.4f\n', excessive_means_quare_error(i) - Error_mean_square );

        break; % Exit the loop when the condition is met
    end
end

plot(1:i, excessive_means_quare_error(1:i)); % Plot only the data up to the stopping point
