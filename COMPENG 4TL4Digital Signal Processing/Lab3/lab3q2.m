clear
close all
clc
%a
% myDFT;

%b
N_values = [16, 32, 64, 128, 256];
for N = N_values
    x = [ones(1, 16), zeros(1, N-16)];
    X = myDFT(x);
    figure;
    plot(abs(X));
    title(['(b) DFT Magnitude for N = ', num2str(N)]);
    xlabel('Frequency Index');
    ylabel('Magnitude');
end

%c
disp('(c) As the zero-padding at the tail end of the rectangular signal increases in length, the main lobe of the DFT becomes narrower and the side lobes become less pronounced.');

%d

for N = N_values
    x = [ones(1, 16), zeros(1, N-16)];
    w = 2 * pi * (0:N-1) / N;  % 与 DFT 相同的频率点
    X = myDTFT(x, w);
    figure;
    plot(w, abs(X));
    title(['(d) DTFT Magnitude for N = ', num2str(N)]);
    xlabel('Frequency (rad/s)');
    ylabel('Magnitude');
end

%e
N_values = [16, 32, 64, 128, 256];
for N = N_values
    x = [ones(1, 16), zeros(1, N-16)];
    X_fft = fft(x);
    figure;
    plot(abs(X_fft));
    title(['(b) DFT Magnitude for N = ', num2str(N)]);
    xlabel('Frequency Index');
    ylabel('Magnitude');
end