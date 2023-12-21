%part a: 

n = 1:40;% Define the sample range
A = 1;% Amplitude
omega = pi/10;% Angular frequency

% Generate the complex signal x[n]
xn = A * exp(1j * omega * n);

% Plot x[n] in the complex plane
figure;
plot(real(xn), imag(xn)); %ℑ(x[n]) imaginary part versus ℜ(x[n]) real part
xlabel('Real Part');
ylabel('Imaginary Part');
title('Complex Plane Plot of x[n]');
grid on;


%%
%part b: 
% Create a new figure for real and imaginary parts
figure;

% Real part
subplot(2,1,1);
stem(n, real(xn)); %plot them versus the sample number n
xlabel('sample number n');
ylabel('Real Part');
title('Real Part of x[n]');
grid on;

% Imaginary part
subplot(2,1,2);
stem(n, imag(xn)); %plot them versus the sample number n
xlabel('sample number n');
ylabel('Imaginary Part');
title('Imaginary Part of x[n]');
grid on;


%%
% part c : 
% Create a new figure for magnitude and phase
magnitude = abs(xn);
phase = angle(xn);

figure;

subplot(2,1,1);
stem(n, magnitude);
xlabel('sample number n');
ylabel('magnitude');
title('magnitude of x[n] versus sample number n');
grid on;

subplot(2,1,2);
stem(n, phase);
xlabel('sample number n');
ylabel('phase (radians)');
title('phase of x[n] versus sample number n');
grid on;

fprintf("the slope of the plot is %d",omega);


