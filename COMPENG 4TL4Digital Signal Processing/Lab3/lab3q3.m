clear
close all
clc

% (a) Load "yes.wav" and "no.wav" files and plot the magnitude of the FFT
[y_yes, fs_yes] = audioread('yes.wav');
[y_no, fs_no] = audioread('no.wav');

X_yes = abs(fft(y_yes));
X_no = abs(fft(y_no));

figure;
plot(X_yes);
title('Yes');
xlabel('Frequency Index');
ylabel('Magnitude');
figure;
plot(X_no);
title('No');
xlabel('Frequency Index');
ylabel('Magnitude');

% (b) Use the code to find a threshold that can distinguish between "yes" and "no"
recording = false;  % true or false
if recording == true  % record audio data from a microphone
    fs = 16000;
    nBits = 16;
    nChannels = 1;
    ID = -1;  % default audio input device
    recObj = audiorecorder(fs, nBits, nChannels, ID);
    disp('Start speaking. Recording ends in 3 seconds.')
    recordblocking(recObj, 3);
    disp('End of Recording.');
    play(recObj);
    y = getaudiodata(recObj);
else
    filename = 'no.wav';  % change filename to test provided 'yes' and 'no'
    [y, fs] = audioread(filename);
    soundsc(y, fs);
end

N = length(y);
k1 = round(N/4);  % FFT component corresponding to fs/4 Hz
k2 = round(N/2);  % FFT component corresponding to fs/2 Hz
X = abs(fft(y));
f = sum(X(1:k1)) / sum(X(k1+1:k2));

threshold = 0;  % Set a value to distinguish words 'yes' and 'no'
if f < threshold
    disp('yes');
else
    disp('no');
end
