close all
clc
N_values = [20, 50, 150];
Rs = [10, 20];
x = randn(1, 1000);
plot(x);
y_fir = filter(h_fir, 1, x);

[b, a] = cheby2(N_values(1), Rs(1), fc, 'low');
y_iir = filter(b, a, x);

figure;
subplot(2, 1, 1); plot(y_fir); title('Output of FIR Filter');
subplot(2, 1, 2); plot(y_iir); title('Output of IIR Filter');
