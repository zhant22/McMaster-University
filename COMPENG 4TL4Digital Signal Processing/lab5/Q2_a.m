[b, a] = butter(10, 0.5, 'low');
fs = 8000;
f1 = 1500;
f2 = 750;
L = 8000 * 5;
n = (0:L-1);
A = 1/5; % adjust playback volume
x1 = A * cos(2 * pi * n * f1 / fs);
x2 = A * cos(2 * pi * n * f2 / fs);
x = x1 + x2;

% Filter the signals through the designed filter
sound(x, fs);
% Find the group delay for each filtered signal
[gd1, ~] = grpdelay(b, a, L, fs);
[gd2, ~] = grpdelay(b, a, L, fs);

% Calculate the difference in group delay
f1_w=f1/(fs/2)
f2_w=f2/(fs/2)

% Display the results
disp(['Group delay for f1: ', num2str(gd1(f1 * L / fs + 1))]);
disp(['Group delay for f2: ', num2str(gd2(f2 * L / fs + 1))]);

% Assuming you have your IIR filter coefficients (b, a)
[gd, f] = grpdelay(b, a);
figure;
plot(f/pi, abs(gd));
title('Group Delay Response');
xlabel('Frequency (pi)');
ylabel('Group Delay (samples)');

