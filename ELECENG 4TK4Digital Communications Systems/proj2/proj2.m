% Close all figures, clear workspace, and clear command window
close all;
clear;
clc;

% Constants and Variable Setup
Plot_or_not = 1;   % Set to 1 to plot generated noise and signals
n0 = 4;            % Used for w1 in BFSK
n1 = 1;            % Used for w2 in BFSK
N = 20;            % Choose Ts to be unity and N = 20
Ts = 1;            % Sampling period of binary sequence
Tb = N * Ts;       % Period of binary sequence
eta = 2;           % Fix η = 2
SNRe = -4:4;       % Effective input signal-to-noise ratio range of -4 dB to 4 dB
t = 0:N-1;         % Timing for simulation
bitLength = 500;   % Chosen arbitrarily
vi = 1;            % Virtual index

% Number of bit errors
error_fsk = 0;
error_psk = 0;

% Decoded output sequences
bko_fsk = zeros(1, bitLength);
bko_psk = zeros(1, bitLength);

% Set up shift keying frequencies
w1 = 2 * pi * (n0 + n1) / Tb;    % First BFSK frequency
w2 = 2 * pi * (n0 - n1) / Tb;    % Second BFSK frequency
wc = n0 * 2 * pi / Tb;            % Carrier frequency for BPSK

% Generate random binary sequence
bk = round(rand(1, bitLength));

% Compute A for varying SNR levels
A = sqrt(2 * eta / Tb * 10.^(SNRe / 10));

for SNR_loop=1:length(SNRe)
    for TRIAL_loop=1:N % 20 independent trials
    error_fsk=0;
    error_psk=0;
    noise=randn(1,bitLength*N); %2. generate zero-mean white Gaussian noise
    vi=1;

    %Use A to setup signal functions 
    s1_fsk=A(SNR_loop)*cos(w1*t); % bfsk 1
    s2_fsk=A(SNR_loop)*cos(w2*t); % bfsk 0
    s1_psk=A(SNR_loop)*cos(wc*t); % bpsk 1
    s2_psk=-A(SNR_loop)*cos(wc*t); % bpsk 0
    d=length(s1_fsk); % signal duration

    for i=1:bitLength %4. generate FSK and PSK mod signals
        if(bk(i)==1) % virtual index
            s_fsk(vi:vi+(N-1))=s1_fsk(1:N);
            s_psk(vi:vi+(N-1))=s1_psk(1:N);
        else
            s_fsk(vi:vi+(N-1))=s2_fsk(1:N);
            s_psk(vi:vi+(N-1))=s2_psk(1:N);
        end

        vi=vi+N;
    end

    v_fsk=s_fsk+noise; %5. generate noisy signals
    v_psk=s_psk+noise;

    if(Plot_or_not==1) % display preliminary output if desired
        figure(1)
        plot(s_fsk);
        axis([0,100,-1/2,1/2]);
        title('Random Binary FSK Signal');
        ylabel('Amplitude');
        xlabel('Time');
        set(gcf,'Color',[1 1 1])
        grid on
        
        figure(2)
        plot(s_psk);
        axis([0,100,-1/2,1/2]);
        title('Random Binary PSK Signal');
        ylabel('Amplitude');
        xlabel('Time');
        set(gcf,'Color',[1 1 1])
        grid on
        
        figure(3)
        plot(v_fsk);
        axis([0,100,-3,3]);
        title('Random Binary FSK Signal');
        ylabel('Amplitude');
        xlabel('Time');
        set(gcf,'Color',[1 1 1])
        grid on
        
        figure(4)
        plot(v_psk);
        axis([0,100,-3,3]);
        title('Random Binary PSK Signal');
        ylabel('Amplitude');
        xlabel('Time');
        set(gcf,'Color',[1 1 1])
        grid on
        
    end
    Plot_or_not=0;
    
    %6. create matched filters and corresponding signal through each
    mf_fsk=fliplr(s1_fsk-s2_fsk); % BFSK output
    mf_psk=fliplr(s1_psk-s2_psk); % BPSK output
    vo_fsk=conv(v_fsk,mf_fsk);
    vo_psk=conv(v_psk,mf_psk);
    % adjustment for detection
    vo_fsk=vo_fsk(1:bitLength*N);
    vo_psk=vo_psk(1:bitLength*N);
    % sample the output signal
    for m=N:N:(bitLength*N)
        vo_fsk(m/N)=vo_fsk(m);
        vo_psk(m/N)=vo_psk(m);
    end
    %7. threshold detection
    for m=1:bitLength*N;
        if(vo_fsk(m)<=0) % PSK detection
            bko_fsk(m)=0;
        else
            bko_fsk(m)=1;
        end
        if(vo_psk(m)<=0) % PSK detection
            bko_psk(m)=0;
        else
            bko_psk(m)=1;
        end
    end
    %8. find bit error rates
    for m=1:bitLength;
        if(bk(m)~=bko_fsk(m))
            error_fsk=error_fsk+1;
        end
        if(bk(m)~=bko_psk(m))
            error_psk=error_psk+1;
        end
    end
    
    ber_fsk(TRIAL_loop)=error_fsk/bitLength;
    ber_psk(TRIAL_loop)=error_psk/bitLength;
    
    end
    
    fprintf(' Bit Error Rates, SNR=%ddB\n',SNRe(SNR_loop));
    fprintf(' FSK: \t%.4f\n',mean(ber_fsk));
    fprintf(' PSK: \t%.4f\n',mean(ber_psk));
    fprintf('\n');
    performance_fsk(SNR_loop)=mean(ber_fsk);
    performance_psk(SNR_loop)=mean(ber_psk);
end


% Plot the final results
figure(5)
semilogy(SNRe, performance_fsk, '-ok');
hold on
semilogy(SNRe, performance_psk, '-or');
title('Performance of FSK vs PSK');
ylabel('Bit Error Rate');
xlabel('SNR');
legend('FSK', 'PSK');
grid on

figure(6)
plot(SNRe, performance_fsk - performance_psk);
title('Error Rate Reduction, PSK vs FSK');
ylabel('Reduction')
xlabel('SNR')
axis([-4, 4, 0, 0.1]);
grid on

figure(7)
semilogy(SNRe, 1/2 * erfc(1/2 * sqrt(Tb / eta * A.^2)), 'r');
hold on
semilogy(SNRe, performance_psk);
title('Theoretical and Experimental PSK Performance');
ylabel('Performance')
xlabel('SNR')
legend('Theoretical', 'Experimental');
grid on

figure(8)
semilogy(SNRe, 1/2 * erfc(1/2 * sqrt(Tb / eta / 2 * A.^2)), 'r');
hold on
semilogy(SNRe, performance_fsk);
title('Theoretical and Experimental FSK Performance');
ylabel('Performance')
xlabel('SNR')
legend('Theoretical', 'Experimental');
grid on