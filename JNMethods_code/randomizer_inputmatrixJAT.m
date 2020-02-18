function [input_matrix_rndm] = randomizer_inputmatrixJAT()
% as of 10/15/17 6:00PM, fx well, saves ouput

total_blocks = 16;
trials = 9;

mat1 = zeros(trials, total_blocks); %will overwrite with what we want

ratio_3easy_1diff_1middle = [1, 1, 1, 2, 3, 4, 5, 5, 5]; %easiest block
ratio_2easy_2diff_1middle = [1, 1, 2, 2, 3, 4, 4, 5, 5];
ratio_2easy_1diff_3middle = [1, 1, 2, 3, 3, 3, 4, 5, 5];
ratio_1easy_2diff_3middle = [1, 2, 2, 3, 3, 3, 4, 4, 5]; %hardest block

blockends_norm = [1,1,2,2,4,4,5,5]; %we want the program to end on one of these values, and to draw from each digit equally
blocke_RNDM = blockends_norm(randperm(length(blockends_norm)));
blockends_RNDM = reshape([blocke_RNDM; zeros(size(blocke_RNDM))],[],1);
blockends_RNDM = blockends_RNDM';

blockstarts_norm = [1,1,2,2,4,4,5,5]; %we want the program to start on one of these values, and to draw from each digit equally
blocks_RNDM = blockstarts_norm(randperm(length(blockstarts_norm)));
blockstarts_RNDM = reshape([blocks_RNDM; zeros(size(blocks_RNDM))],[],1);
blockstarts_RNDM = blockstarts_RNDM';

%% for column 1; 3_1_1 trial
cellNAMES = {'FIRST COLUMN' ,'2', 'THIRD COLUMN' ,'4', 'FIFTH COLUMN' , '6',...
             'SEVENTH COLUMN', '8' , 'NINTH COLUMN' , '10' , 'ELEVENTH COLUMN',...
             '12', 'THIRTEENTH COLUMN', '14' , 'FIFTEENTH COLUMN', '16'};

for ci = 1:2:16
    
    COLUMN = ci;
    
    if ismember(ci,[1 , 15])
        trialtemplate = ratio_3easy_1diff_1middle;
    elseif ismember(ci,3)
        trialtemplate = ratio_2easy_2diff_1middle;
    elseif ismember(ci,[5 , 7, 9])
        trialtemplate = ratio_2easy_1diff_3middle;
    elseif ismember(ci,[11 , 13])
        trialtemplate = ratio_1easy_2diff_3middle;
    end
    
    
    x = 1;
    while x == 1
        trialtemplate_RNDM = trialtemplate(randperm(length(trialtemplate)));
        if trialtemplate_RNDM(trials) == blockends_RNDM(COLUMN) && trialtemplate_RNDM(1) ~= 3
            break;
        else
            x = 1;
        end
    end
    
    I = find(trialtemplate_RNDM==3);
    ruempty = isempty(I);
    if ruempty == 0 %means it is NOT empty
        for ii = 1:length(I)
            coinflip = [1,2]; %flips coin for each ambiguous trial
            coinflipresult = coinflip(randperm(length(coinflip)));
            result = coinflipresult(1);
            if result == 1
                trialtemplate_RNDM(I(ii)) = 301; %LEFT
            elseif result == 2
                trialtemplate_RNDM(I(ii)) = 302; %RIGHT
            end
        end
    end
    
    mat1(:,COLUMN) = trialtemplate_RNDM;
    
    if mat1(trials,COLUMN) == blockends_RNDM(COLUMN)
        disp(['GOOD - ' , cellNAMES{ci}])
    else
        disp(['BAD - ' , cellNAMES{ci}])
    end
    

end

%%
LEFTs = [2,6,10,14];
RIGHTs = [4,8,12,16];

mat1(:,LEFTs) = 301;
mat1(:,RIGHTs) = 302;
%% suppress the below to see in easier to view format
input_matrix_rndm = reshape(mat1,144,1);
filename = 'input_matrix_rndm.mat';
save(filename)
save filename.mat
end