function code = training(traindir, n)
% 
% training function
% Input:
%       traindir : directory name
% Output:
%       code     : trained VQ codewords
%
%
k = 16;                         % number of codewords 
for i = 1:n                     % train codeword for each speaker
    file = sprintf('%ss%d.wav', traindir, i);           
    disp(file);
    [s, fs] = wavread(file);    
    v = mfcc(s, fs);            % find mfcc  
    code{i} = vq(v, k);      % Train vq codewords
end
