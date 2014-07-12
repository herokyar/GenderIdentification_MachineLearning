function testing(testdir, n, code)
% testing
% Input:
%       testdir : directory name for testing  
%       n       : number of test files in the directory
%       code    : codewords for trained speakers


for k = 1:n                     
    file = sprintf('%ss%d.wav', testdir, k);
    [s, fs] = wavread(file);   
    
    v = mfcc(s, fs);            %find mfccs
   
    distmin = inf;
    k1 = 0;
    
    for l = 1:length(code)      
        d = disteu(v, code{l}); 
        dist = sum(min(d,[],2)) / size(d,1);
      
        if dist < distmin
            distmin = dist;
            k1 = l;
        end      
    end
    msg = sprintf('Speaker %d is %d', k, k1);
    disp(msg);
end
