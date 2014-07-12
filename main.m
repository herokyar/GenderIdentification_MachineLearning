disp('***********************************************************');
disp('Readme, How to run the simulation');
disp('Adress female training data ---> ex: train\s1.wav (within quotation)');
disp('Adress male training data ---> ex: train\s2.wav (within quotation)');
disp('Input the location of train folder ---> ex: train\ (within quotation)');
disp('Input the location of test folder ---> ex: test\ (within quotation)');
disp('Input the number of unknown files in test folder ---> ex: 6 ');
disp('***********************************************************');
%%%%%% The two training wav files are fixed(can be different)
%%%%% Reading of training data
%load speech data 
input_female=input('Adress female training data:');
input_male=input('Adress male training data:');
[s1, fs1] = wavread(input_female);
[s2 fs2] = wavread(input_male);

%plot speech data for female sound
disp('time waveforms');
figure; plot(s1);
xlabel('Samples');
ylabel('Amplitude');
title('Time waveform of female training sound data for the utterance "park" ');

%plot speech data for male sound
figure; plot(s2);
xlabel('Samples');
ylabel('Amplitude');
title('Time waveform of male training sound data for the utterance "park" ');

%the speech signal is framed, each frame has 256 samples
%and n=100 overlap value, continue framing until all the information is
%sampled in frames
l = length(s1); 
m = 100;
n = 256;
nbFrame = floor((l - n) / m) + 1;
for i = 1:n
for j = 1:nbFrame
M(i, j) = s1(((j - 1) * m) + i);
end
end

%windowing, window each frame by Hamming window
%to minimize distortion and discontinuities at the beginning
%and at the end of the each frame
%hamming window is often used in speech recognition applications
disp('windowing');
h = hamming(n);
figure; plot(h)
xlabel('Samples');
ylabel('Amplitude');
title('Hamming window for 256 samples');
M2 = diag(h) * M;


%take fft(fast fourier transform)
%convert N frames of each frame from time domain to
%frequency domain
for i = 1:nbFrame
M3(:, i) = fft(M2(:, i));
end


%plot spectrograms of the signals
%spectrogram (for female)
disp('spectrograms');
M = 100;
N = 256;
frames = findframes(s1, fs1, M, N);
t = N / 2;
tm = length(s1) / fs1;
%%%%
figure;imagesc([0 tm], [0 fs1/2], 20 * log10(abs(frames(1:t, :)).^2)), axis xy;
title('Spectrogram of the female training sound data');
xlabel('Time (s)');
ylabel('Frequency (Hz)');

%spectrogram (for male)
M = 100;
N = 256;
frames2 = findframes(s2, fs2, M, N);
t = N / 2;
tm2 = length(s2) / fs2;
figure;imagesc([0 tm2], [0 fs2/2], 20 * log10(abs(frames2(1:t, :)).^2)), axis xy;
title('Spectrogram of the male training sound data');
xlabel('Time (s)');
ylabel('Frequency (Hz)');



% Three different window sized spectrograms are used and will be 
%decided on which one is best with the apply of the algorithm
%different spectrograms for female 
disp('spectrograms with different values of N');
lN = [128 256 512];
u=220;
figure;
for i = 1:length(lN)
N = lN(i);
M = round(N / 3);
 frames = findframes(s1, fs1, M, N);
t = N / 2;
 temp = size(frames);
 nbframes = temp(2);
 u=u+1;
 subplot(u)
imagesc([0 tm], [0 fs1/2], 20 * log10(abs(frames(1:t, :)).^2)), axis xy;
title(sprintf('Spectrogram(N=%i,M=%i)', N,M));
 xlabel('Time (s)');
 ylabel('Frequency (Hz)');
end
 
%different spectrograms for male 
lN = [128 256 512];
u=220;
figure;
for i = 1:length(lN)
N = lN(i);
M = round(N / 3);
 frames2 = findframes(s2, fs2, M, N);
t = N / 2;
 temp2 = size(frames2);
 nbframes2 = temp2(2);
 u=u+1;
 subplot(u)
 imagesc([0 tm2], [0 fs2/2], 20 * log10(abs(frames2(1:t, :)).^2)), axis xy;
title(sprintf('Spectrogram(N=%i,M=%i)', N,M));
 xlabel('Time (s)');
 ylabel('Frequency (Hz)');
 end

 
  
%Plot the filter bank                
disp('Mel Space Filter Bank');
figure; plot(linspace(0, (fs1/2), 129), (melfb(20, 256, fs1))');
title('Mel Filters');
xlabel('Frequency (Hz)');
ylabel('Magnitude in dB');


%a comparison is made between spectrogram unmodified 
%and between spectrogram after MFCC algorithm
%comparison for female 
disp('Modified spectrum');
M = 100;
N = 256;
frames = findframes(s1, fs1, M, N);
n2 = 1 + floor(N / 2);
m = melfb(20, N, fs1);
z = m * abs(frames(1:n2, :)).^2;
t = N / 2;
tm = length(s1) / fs1;
figure; subplot(121)
imagesc([0 tm], [0 fs1/2],20*log10(abs(frames(1:n2, :)).^2)), axis xy;
title('Spectrogram before');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
subplot(122)
imagesc([0 tm], [0 20], 20*log10(z)), axis xy;
title('Spectrogram after Mel Cepstrum filter (Mel spectrum)');
xlabel('Time (s)');
ylabel('Number of Filters');


%comparison for male
M = 100;
N = 256;
frames2 = findframes(s2, fs2, M, N);
n2 = 1 + floor(N / 2);
m2 = melfb(20, N, fs2);
z2 = m2 * abs(frames2(1:n2, :)).^2;
t = N / 2;
tm2 = length(s2) / fs2;
figure; subplot(121)
imagesc([0 tm2], [0 fs2/2],20*log10(abs(frames2(1:n2, :)).^2)), axis xy;
title('Spectrogram before');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
subplot(122)
imagesc([0 tm2], [0 20], 20*log10(z2)), axis xy;
title('Spectrogram after Mel Cepstrum filter(Mel spectrum)');
xlabel('Time (s)');
ylabel('Number of Filters');


%2D plot of accustic vectors
disp('2D plot of MFCC vectors');
c1 = mfcc(s1, fs1);
c2 = mfcc(s2, fs2);
figure;
plot(c1(10, :), c1(11, :), 'hr');
hold on;
plot(c2(10, :), c2(11, :), 'xb');
xlabel('10th Dimension');
ylabel('11th Dimension');
legend('Female training vectors', 'Male training vectors');
title('2D plot of MFCC vectors');


%Plot of the 2D trained VQ codewords
disp('Plot of the 2D trained VQ codewords')
d1 = vq(c1,16);
d2 = vq(c2,16);
figure;
plot(c1(10, :), c1(11, :), 'hr')
hold on
plot(d1(10, :), d1(11, :), 'vk')
plot(c2(10, :), c2(11, :), 'xb')
plot(d2(10, :), d2(11, :), '+k')
xlabel('10th Dimension');
ylabel('11th Dimension');
legend('Female training vectors', 'Codewords for female training', 'Male training vectors', 'Codewords for male training');
title('2D plot of MFCC and VQ vectors');


%training and testing the code
input_train_folder=input('Input the location of train folder:');
code = training(input_train_folder, 2);


input_test_folder=input('Input the location of test folder:');
input_test=input('Input the number of unknown files in test folder:');
testing(input_test_folder, input_test , code);

disp('In this system, 1 (s1.wav) represents the female');
disp('and 2 (s2.wav) represents the male gender.');
disp('Important: Speech files in training and test folders should be represented as s1.wav, s2.wav .... sn.wav ');


