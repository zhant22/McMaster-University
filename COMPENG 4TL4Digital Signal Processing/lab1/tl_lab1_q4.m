%(a) Load the supplied speech signal into MATLAB using the command:
[y, fs] = audioread('defineit.wav');

fprintf("the fs here is %d",fs); %16000
time = (0:length(y)-1)/fs; 

%(b) Plot the speech waveform and a histogram of amplitude values:

% Plot the speech waveform sample number vs amplitude 
figure;
subplot(3,1,1);
plot(y);
xlabel('sample number');
ylabel('amplitude');
title('speech waveform vs smaple number ');
grid on;

% Plot the speech waveform time vs amplitude 
subplot(3,1,2);
plot(time,y);
xlabel('time');
ylabel('amplitude');
title('Speech Waveform vs time');
grid on;

% Plot a histogram of amplitude values
subplot(3,1,3);
histogram(y, 50);  % 50 bins 
xlabel('amplitude value');
ylabel('count');
title('histogram of amplitude values');
grid on;

info = audioinfo('defineit.wav')
bits_per_sample = info.BitsPerSample;

fprintf('\n The speech signal was quantized using %d bits per sample.\n', bits_per_sample);


%%
%(c) Listen to y using the soundsc(y, fs) command. Describe the sound quality.
%soundsc(y, fs);

%(d)Write a MATLAB script for a 3-bit rounding uniform quantizer for the range [-1 1].
bit_size =3;
num_bin = 2^bit_size; % with 3 bit, we have 8 bins 
step_size = 2 / num_bin; %  from -1 to 1 , the delta is 0.25 in this case. 
% [-1 -0.75] [-0.75 -0.5]  [-0.5 -0.25]  [-0.25 0]  [0 -0.25]  [-0.25 0.5] [0.5 0.75] [0.75 1.0]

% here we define the quantization function as below which follow the rule
% as we first drived the original signal by the step_size with round
% funtion we  rounded the divided value to the whole integer which is the
% same opration as assign the value to the bin value, then we times
% step_size to the orignal scale. 
quantize = @(signal) round(signal / step_size) * step_size;


%(e) Scale the speech signal to prevent saturation:
% there are two ways of scalling the signal
% first: hard code to find -1 to 1 perfectly , second: using lambda as
% constant like 1/4 but in this case, the amplitude of the signal is too
% small, from the first wave form plot, we can see the high amp is not
% even 0.1, so we need to scale up the signal
max_amplitude = max(abs(y));
y_scaled = y / max_amplitude; %now we increase the signal to about -1 to 1 

%second: using lambda as constant like 


%(f) Quantize the scaled signal and analyze the quantized signal:
% Quantize the scaled signal
y3bit = quantize(y_scaled);
%soundsc(y3bit, fs);

% Plot the quantized waveform
figure;
subplot(5,1,1);
plot(y3bit);
xlabel('Sample Number');
ylabel('Amplitude');
title('Quantized Speech Waveform (3-bit)');
grid on;

subplot(5,1,2);
plot(y);
xlabel('Sample Number');
ylabel('Amplitude');
title('Speech Waveform vs smaple number ');
grid on;

% Plot a histogram of quantized amplitude values
subplot(5,1,3);
histogram(y3bit, 50);
xlabel('Quantized Amplitude Value');
ylabel('Count');
title('Histogram of Quantized Amplitude Values (3-bit)');
grid on;

% Calculate and analyze quantization error
error = y_scaled - y3bit;

% quantization error

subplot(5,1,4);
plot(error);
xlabel('Time');
ylabel('Amplitude');
title('Error Amplitude vs Sample number');
grid on;

% Plot a histogram of quantized amplitude values
subplot(5,1,5);
histogram(error, 50);
xlabel('error');
ylabel('number of error');
title('Histogram of error (3-bit)');
grid on;


%%
%(g) Rescale y to exceed the maximum scale range of your 3-bit quantizer:
y_pclip = 50 * y; % Increase the scale by a factor
y3bit_pclip = quantize(y_pclip); % Quantize the scaled signal
%soundsc(y3bit_pclip, fs);
% Plot the quantized waveform
figure;
subplot(5,1,1);
plot(y3bit_pclip);
xlabel('Sample Number');
ylabel('Amplitude');
title('Quantized Speech Waveform (exceed 3-bit)');
grid on;
ylim([-1, 1]); % Set the y-axis limits


subplot(5,1,2);
plot(y3bit);
xlabel('Sample Number');
ylabel('Amplitude');
title('Quantized Speech Waveform (3-bit)');
grid on;


% Plot a histogram of quantized amplitude values
subplot(5,1,3);
histogram(y3bit_pclip, 50);
xlabel('Quantized Amplitude Value');
ylabel('Count');
title('Histogram of Quantized Amplitude Values (exceed 3-bit)');
grid on;

% Calculate and analyze quantization error
error_pclip = y_pclip - y3bit_pclip;

% quantization error
subplot(5,1,4);
plot(time,error_pclip);
xlabel('time');
ylabel('amp');
title('error vs time');
grid on;

% Plot a histogram of quantized amplitude values
subplot(5,1,5);
histogram(error_pclip, 50);
xlabel('error');
ylabel('number of error');
title('Histogram of error (3-bit)');
grid on;





