clear
close all
clc
%Q2
%% Load the supplied acoustic impulse response of a room
[impr, fs] = audioread('impr.wav');
soundsc(impr, fs); %the sound of clap? 

%Plot the impulse-response waveform impr using the plot() command and listen to it
%using the soundsc() command.
figure;
plot(impr);
title('Impulse Response');
xlabel('Sample');
ylabel('Amplitude');



%% Load the orignal speech 
[y, fs] = audioread('oilyrag.wav');
soundsc(y, fs); %listen to the original speach. 

figure; %plot the original speech. 
plot(y);
title('original speech');
xlabel('Sample');
ylabel('Amplitude');

%% Convolve the speech signal with the impulse response,
convolved_signal = conv(y, impr);
soundsc(convolved_signal, fs); % dont ask me to carry all the rag like that? 

figure;
plot(convolved_signal);
title('Convolved Signal');
xlabel('Sample');
ylabel('Amplitude');

