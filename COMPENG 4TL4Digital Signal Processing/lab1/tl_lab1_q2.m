% samples n = 1, 2, . . . , 30
n = 1:30;

% (a) Create and plot the unit impulse and unit step signals
delta = zeros(size(n)); 
u = zeros(size(n));   

delta(16) = 1; % Set the impulse at n = 16

u(12:end) = 1; % Set the step starting from n = 12

% Plot the unit impulse signal and unit step signal
figure;
subplot(2, 1, 1);
stem(n, delta);
title('Unit Impulse Signal \delta[n - 16]');
xlabel('n');
ylabel('\delta[n - 16]');
grid on;

subplot(2, 1, 2);
stem(n, u);
title('Unit Step Signal u[n - 12]');
xlabel('n');
ylabel('u[n - 12]');
grid on;

%%
% (b) Create and plot x1[n] = u[n − 14] − u[n − 15].
step1 = n>=14;
step2 = n>=15;
x1=step1 - step2;

% Plot x1[n]
figure;
stem(n, x1);
title('x1[n] = u[n - 14] - u[n - 15]');
xlabel('n');
ylabel('x1[n]');
grid on;

fprintf("K vlaue is 14 becasue for n-14, the value is 1 after n =14, for n-15, the value is 1 after n =15, so when")
fprintf("\nu[n-14]-u[n-15], the value is 14 since all the n over 14 is 1-1 =0")

%%
% Set x1[n] values at specific indices
step1 = n>=9;
step2 = n>=16;
x2=step1 - step2;


% Plot x2[n] = u[n − 9] − u[n − 16].
figure;
subplot(2, 1, 1);
stem(n, x2);
title('x2[n] = u[n - 9] - u[n - 16]');
xlabel('n');
ylabel('x2[n]');
grid on;

fprintf("width of the resulting rectangular “pulse” is 15 - 9 =6")

% Express x2[n] as a sum of unit impulses
impulse = zeros(size(n)); % initial impulse_sum 
impulse(9:15) = 1; % adding them up. 
impulse(n == 16) = -1;

% Plot the expression as a sum of unit impulses
subplot(2, 1, 2);
stem(n, impulse);
title('x2[n] as a Sum of Unit Impulses');
xlabel('n');
ylabel('Impulse Sum');
grid on;


