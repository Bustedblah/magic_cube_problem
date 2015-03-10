function output = lcms(numberArray)

numberArray = reshape(numberArray, 1, []);

%% prime factorization array
for i = 1:size(numberArray,2)
    temp = factor(numberArray(i));
   
    for j = 1:size(temp,2)
        output(i,j) = temp(1,j);
    end
end

%% generate prime number list
p = primes(max(max(output)));
%% prepare list of occurences of each prime number
q = zeros(size(p));

%% generate the list of the maximum occurences of each prime number
for i = 1:size(p,2)
    for j = 1:size(output,1)
        temp = length(find(output(j,:) == p(i)));
        if(temp > q(1,i))
            q(1,i) = temp;
        end
    end
end

%% the algorithm
z = p.^q;

output = 1;

for i = 1:size(z,2)
    output = output*z(1,i);
end



% Copyright (c) 2009, Joshua
% All rights reserved.

% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:

% * Redistributions of source code must retain the above copyright
% notice, this list of conditions and the following disclaimer.
% * Redistributions in binary form must reproduce the above copyright
% notice, this list of conditions and the following disclaimer in
% the documentation and/or other materials provided with the distribution

% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
%					   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% 					   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.
