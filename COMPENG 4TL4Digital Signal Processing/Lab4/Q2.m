% (a) Design linear-phase lowpass filters with the cutoff frequency fc = 0.3 using the Parks-McClellan method for filter orders M = 20, 50, and 150.

% Cutoff frequency
fc = 0.333;  %pi/3 equals to 0.333pi 

% Filter orders
M_values = [20, 50, 150];

% (a) Design filters using firpm()
for i = 1:length(M_values)
    M = M_values(i);
    
    % Design filter
    f = [0, fc, fc+0.1, 1]; % the passband is 0 to 0.333pi(pi/3), stopband is 0.433pi to pi 
    a = [1 1 0 0];
    b = firpm(M, f, a);  % Adjust the passband and stopband frequencies
    
    % Plot frequency response

    [h,w] = freqz(b,1,1024);
    figure
    plot(f,a,w/pi,abs(h))
    title(['Parks-McClellan Method - Order ', num2str(M)]);
    legend('Ideal','firpm Design')
    xlabel 'Radian Frequency (\omega/\pi)', ylabel 'Magnitude'
end

