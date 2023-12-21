clear
close all
clc
%Q1
%% (a) Create the discrete-time sequence x[n] = u[n] - u[n - 10]
n = 0:20;
u_n = zeros(size(n));
u_n(n >= 0) = 1;
u_n_10 = zeros(size(n)); 
u_n_10(n >= 10) = 1; 
x = u_n - u_n_10;
x1=x(x ~= 0);
figure;
stem(0:length(x1)-1, x1);
title('x[n] = u[n] - u[n - 10]');
xlabel('n');
ylabel('x[n]');


%% (b) Convolution operations
an = conv(x, x, 'full'); % In order to better obvious the signal, we chose Returns the full convolution, 
bn = conv(an, x, 'full'); % The output signal is the full-length convolution of the two signals 
cn = conv(bn, x, 'full');
dn = conv(cn, x, 'full');

%% (c) Plot a[n], b[n], c[n], d[n]
n_a = 0:length(an) - 1;
n_b = 0:length(bn) - 1;
n_c = 0:length(cn) - 1;
n_d = 0:length(dn) - 1;

figure;
subplot(2, 2, 1);
stem(n_a, an);
title('a[n] = x[n] * x[n]');
xlabel('n');
ylabel('a[n]');

subplot(2, 2, 2);
stem(n_b, bn);
title('b[n] = a[n] * x[n]');
xlabel('n');
ylabel('b[n]');

subplot(2, 2, 3);
stem(n_c, cn);
title('c[n] = b[n] * x[n]');
xlabel('n');
ylabel('c[n]');

subplot(2, 2, 4);
stem(n_d, dn);
title('d[n] = c[n] * x[n]');
xlabel('n');
ylabel('d[n]');
