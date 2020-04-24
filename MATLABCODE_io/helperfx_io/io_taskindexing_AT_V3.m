%V3 on 4/21/20; goal for V3 is to index appropriately for behavior - ie we want to exlcude the first three trials from consideration

function [L_SG, R_SG, L_IS, R_IS, L_SG_correct_structs, R_SG_correct_structs, L_IS_correct_structs,  R_IS_correct_structs, Errors] = io_taskindexing_AT_V3(rsp_master_v3, input_matrix_rndm, exclusionfilter)

%4/26/19 - need to create fx that will index the input matrix info into
%something more useable
% errors = zeros(size(input_matrix_rndm));  % left IS

L_IS = zeros(size(input_matrix_rndm));  % left IS
R_IS = zeros(size(input_matrix_rndm));  % right IS
L_SG = zeros(size(input_matrix_rndm));  % left SG
R_SG = zeros(size(input_matrix_rndm));  % right SG

L_IS_correct = zeros(size(input_matrix_rndm));  %correct left IS
R_IS_correct = zeros(size(input_matrix_rndm));  %correct right IS
L_SG_correct = zeros(size(input_matrix_rndm));  %correct left SG
R_SG_correct = zeros(size(input_matrix_rndm));  %correct right SG


%SG_IS_index

%AT, there could be a problem with this method of indexxing if there's a
%50/50 trials thats flanking the IS block. At least for PT8 though, this is
%OK

blocksize = 9;

for g = 1:length(input_matrix_rndm)-blocksize
    if input_matrix_rndm(g) == 301 && input_matrix_rndm(g+1) == 301 && input_matrix_rndm(g+2) == 301 && input_matrix_rndm(g+3) == 301 && input_matrix_rndm(g+4) == 301 && input_matrix_rndm(g+5) == 301 && input_matrix_rndm(g+6) == 301 && input_matrix_rndm(g+7) == 301 && input_matrix_rndm(g+8) == 301
        L_IS(g:(g+(blocksize-1))) = 1;
    elseif input_matrix_rndm(g) == 302 && input_matrix_rndm(g+1) == 302 && input_matrix_rndm(g+2) == 302 && input_matrix_rndm(g+3) == 302 && input_matrix_rndm(g+4) == 302 && input_matrix_rndm(g+5) == 302 && input_matrix_rndm(g+6) == 302 && input_matrix_rndm(g+7) == 302 && input_matrix_rndm(g+8) == 302
        R_IS(g:(g+(blocksize-1))) = 1;
    end
end

ISindex = L_IS + R_IS; %AT added 4/20/20

if exclusionfilter == 0
    for g = 1:length(input_matrix_rndm)
        if L_IS(g) == 0 && strcmp(rsp_master_v3(g).ERROR, 'GOOD') && rsp_master_v3(g).actual == 1
            L_SG(g) = 1; %this is an index for left SG trials
        elseif R_IS(g) == 0 && strcmp(rsp_master_v3(g).ERROR, 'GOOD') && rsp_master_v3(g).actual == 2
            R_SG(g) = 1; %this is an index for right SG trials
        end
    end
    
    for g = 1:length(input_matrix_rndm)
        if L_IS(g) == 1 && rsp_master_v3(g).actual == 1
            L_IS_correct(g) = 1;
        elseif R_IS(g) == 1 && rsp_master_v3(g).actual == 2
            R_IS_correct(g) = 1;
        elseif L_SG(g) == 1 && rsp_master_v3(g).actual == 1
            L_SG_correct(g) = 1;
        elseif R_SG(g) == 1 && rsp_master_v3(g).actual == 2
            R_SG_correct(g) = 1;
        end
    end
    
elseif exclusionfilter == 1
    
    for g = 1:length(input_matrix_rndm)
        if L_IS(g) == 0 && strcmp(rsp_master_v3(g).ERROR, 'GOOD') && rsp_master_v3(g).actual == 1 && input_matrix_rndm(g) ~= 301 && input_matrix_rndm(g) ~= 302
            L_SG(g) = 1; %this is an index for left SG trials
        elseif R_IS(g) == 0 && strcmp(rsp_master_v3(g).ERROR, 'GOOD') && rsp_master_v3(g).actual == 2 && input_matrix_rndm(g) ~= 301 && input_matrix_rndm(g) ~= 302
            R_SG(g) = 1; %this is an index for right SG trials
        end
    end
    
    for g = 1:length(input_matrix_rndm)
        if L_IS(g) == 1 && rsp_master_v3(g).actual == 1
            L_IS_correct(g) = 1;
        elseif R_IS(g) == 1 && rsp_master_v3(g).actual == 2
            R_IS_correct(g) = 1;
        elseif L_SG(g) == 1 && rsp_master_v3(g).actual == 1
            L_SG_correct(g) = 1;
        elseif R_SG(g) == 1 && rsp_master_v3(g).actual == 2
            R_SG_correct(g) = 1;
        end
    end
    
elseif exclusionfilter == 2
    
    for g = 1:length(input_matrix_rndm)
        if L_IS(g) == 0 && strcmp(rsp_master_v3(g).ERROR, 'GOOD') && rsp_master_v3(g).actual == 1 && input_matrix_rndm(g) ~= 301 && input_matrix_rndm(g) ~= 302 && input_matrix_rndm(g) ~= 2 && input_matrix_rndm(g) ~= 4
            L_SG(g) = 1; %this is an index for left SG trials
        elseif R_IS(g) == 0 && strcmp(rsp_master_v3(g).ERROR, 'GOOD') && rsp_master_v3(g).actual == 2 && input_matrix_rndm(g) ~= 301 && input_matrix_rndm(g) ~= 302  && input_matrix_rndm(g) ~= 2 && input_matrix_rndm(g) ~= 4
            R_SG(g) = 1; %this is an index for right SG trials
        end
    end
    
    for g = 1:length(input_matrix_rndm)
        if L_IS(g) == 1 && rsp_master_v3(g).actual == 1
            L_IS_correct(g) = 1;
        elseif R_IS(g) == 1 && rsp_master_v3(g).actual == 2
            R_IS_correct(g) = 1;
        elseif L_SG(g) == 1 && rsp_master_v3(g).actual == 1
            L_SG_correct(g) = 1;
        elseif R_SG(g) == 1 && rsp_master_v3(g).actual == 2
            R_SG_correct(g) = 1;
        end
    end
    
end



%AT editting below on 3/29/20
% errors1 = [rsp_master_v3.Response] == 'f';
errors_index = [rsp_master_v3.Postholdtime] < 0.10;

errors_index = errors_index';



for g = 1:length(input_matrix_rndm)
    if errors_index(g) == 1
        L_IS(g) = 0;
        R_IS(g) = 0;
        L_SG(g) = 0;
        R_SG(g) = 0;
    end
end


%     L_IS_rsp = [rsp_master_v3(L_IS)]



L_SG = L_SG(~errors_index);
R_SG = R_SG(~errors_index);
L_IS = L_IS(~errors_index);
R_IS = R_IS(~errors_index);

% % % % % rsp_master_v3(g).Response == rsp_master_v3(g).actual
if length(input_matrix_rndm) ~= sum(L_IS) + sum(R_IS) + sum(L_SG) + sum(R_SG) + sum(errors_index)
    disp('ERROR, mismatch in indexing, fx io_taskindexing_AT_V2')
else
    disp('GOOD, no-mismatch in indexing, fx io_taskindexing_AT_V2')
end

% IS_correct=find([rsp_master_v3.Response] == 1 & [rsp_master_v3.actual] == 1 & input_matrix_rndm| [rsp_master_v3.Response] == 2 & [rsp_master_v3.actual] == 2);
% SG_correct=find([rsp_master_v3.Response] == 2 & [rsp_master_v3.actual] == 1 | [rsp_master_v3.Response] == 1 & [rsp_master_v3.actual] == 2);
% dist_correct=find([rsp_master_v3.Response] == 'f' & [rsp_master_v3.actual] == 'f';
L_IS_correct_structs = rsp_master_v3(L_IS_correct==1);
R_IS_correct_structs = rsp_master_v3(R_IS_correct==1);
L_SG_correct_structs = rsp_master_v3(L_SG_correct==1);
R_SG_correct_structs = rsp_master_v3(R_SG_correct==1);
% input_matrix_rndm


%AT adding below 4/20/20 to account errors, note that we're not counting
%first three trials
Errors.ISerrors = sum(errors_index == 1 & ISindex == 1); %gives numb of errors that occurred during IS trials
Errors.SGerrors = sum(errors_index(4:end)) - Errors.ISerrors;
Errors.sumErrors = sum(errors_index(4:end));


end