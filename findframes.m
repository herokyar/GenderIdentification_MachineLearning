function M3 = findframes(s, fs, m, n)
% Put the signal into frames
%
% Inputs:s signal name
% fs is the sampling rate
% m is the distance between the beginnings of two frames
% n is the number of samples per frame
%
% Output: M3 is a matrix containing all the frames

 l = length(s);
 nbFrame = floor((l - n) / m) + 1;
for i = 1:n
for j = 1:nbFrame
 M(i, j) = s(((j - 1) * m) + i);
end
end
 h = hamming(n);
M2 = diag(h) * M;
for i = 1:nbFrame
 M3(:, i) = fft(M2(:, i));
end