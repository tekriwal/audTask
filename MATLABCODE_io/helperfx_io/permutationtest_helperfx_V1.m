function [outputArg1,outputArg2] = permutationtest_helperfx_V1(input1,input2, iterations)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

iterations = 1000;

combinedinput = [input1, input2];

% [M, I] = permn([combinedinput], 33,1);
[p, observeddifference, effectsize] = permutationTest(input1, input2, 100000, ...
          'sidedness', 'both', 'plotresult', 1, 'showprogress', 250);

 n = length(combinedinput);
 nr=round(n/2)
 out=combinedinput(randperm(n,nr))







outputArg1 = inputArg1;
outputArg2 = inputArg2;
end

