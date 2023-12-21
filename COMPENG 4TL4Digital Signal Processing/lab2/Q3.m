clear
close all
clc
% (b) Calculate the DTFTs
w = linspace(-3*pi, 3*pi, 1000); % Frequency vector covering the range [-3π, 3π]

% Impulse responses h1[n] and h2[n]
n = -2:2;
h1 = [1/4, 1/2, 1/4];
h2 = [-1/4, 1/2, -1/4];

% using the function we defined to Calculate the DTFTs
H1_w = calculate_dtft(h1, w);
H2_w = calculate_dtft(h2, w);

is_H1_real = isreal(H1_w); % Check if the resulting DTFTs are real or complex valued
is_H2_real = isreal(H2_w);


%% (c) Plot the magnitude of the DTFTs
figure;
subplot(2, 1, 1);
plot(w, abs(H1_w));
title('Magnitude of DTFT of h1[n] vs. Frequency');
xlabel('Frequency (w)');
ylabel('|H1(w)|');

subplot(2, 1, 2);
plot(w, abs(H2_w));
title('Magnitude of DTFT of h2[n] vs. Frequency');
xlabel('Frequency (w)');
ylabel('|H2(w)|');

