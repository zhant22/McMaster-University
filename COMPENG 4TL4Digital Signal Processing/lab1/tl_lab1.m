Fs = 100; % Sampling frequency is 100HZ
t = 0:1/Fs:0.5; % Time vector is 0s to 0.5s
n = t*Fs; % sampling number 

%we define the parameter here 
Amp = 5; % Amplitudes which is [5,5,5,5,5,5]
f = [10, 25, 40, 60, 40, 60]; % Frequencies (Hz)
phase = [0, 0, 0, 0, pi/2, pi/2]; % Phases (radians)

% Initialize arrays to store sampled values
xt = zeros(length(t), 6);% 6 is the length of the amplitude which is [5,5,5,5,5,5]

% here we assign the continuous time sinusoid
for i = 1:6 % 6 is the length of the amplitude which is [5,5,5,5,5,5]
    xt(:, i) = Amp * cos(2 * pi * f(i) * t + phase(i)); %store the ith signal into i-th col of the matrix
end


% Plot starts here
figure;
subplot(3, 2, 1);
stem(n, xt(:, 1));
title(['discrete-time sequence x[n] versus sample numbersignal ', char('A' )]);
xlabel('sampling number');
ylabel('Amplitude');
grid on;

subplot(3, 2, 2);
stem(n, xt(:, 2));
title(['discrete-time sequence x[n] versus sample numbersignal ', char('B' )]);
xlabel('sampling number');
ylabel('Amplitude');
grid on;

subplot(3, 2, 3);
stem(n, xt(:, 3));
title(['discrete-time sequence x[n] versus sample numbersignal ', char('C' )]);
xlabel('Time');
ylabel('Amplitude');
grid on;

subplot(3, 2, 4);
stem(n, xt(:, 4));
title(['discrete-time sequence x[n] versus sample numbersignal ', char('D' )]);
xlabel('sampling number');
ylabel('Amplitude');
grid on;

subplot(3, 2, 5);
stem(n, xt(:, 5));
title(['discrete-time sequence x[n] versus sample numbersignal ', char('E' )]);
xlabel('sampling number');
ylabel('Amplitude');
grid on;

subplot(3, 2, 6);
stem(n, xt(:, 6));
title(['discrete-time sequence x[n] versus sample numbersignal ', char('F' )]);
xlabel('sampling number ');
ylabel('Amplitude');
grid on;




