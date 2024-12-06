%% Preliminaries
clear
clc
clf
rng(2936);

%% Generate network training data
% read in prototype coordinates 
subID = 1;
cond = 1;
...
% plot dots and create a matrix representation for all training patterns
N_pat_cat = 200;
proto1 = genDotPatterns(9,'prototype');
proto2 = genDotPatterns(9,'prototype');
proto3 = genDotPatterns(9,'prototype');

set(groot,'DefaultFigureVisible','off');
parfor ipat = 1:N_pat_cat
    if cond ~= 4
        switch cond
            case 1
                distort_label = 'low';
            case 2
                distort_label = 'med';
            case 3
                distort_label = 'high';
        end
        coord_pat1 =  genDotPatterns(9,distort_label,proto1);
        coord_pat2 =  genDotPatterns(9,distort_label,proto2);
        coord_pat3 =  genDotPatterns(9,distort_label,proto3);
        coord_pats = {coord_pat1,coord_pat2,coord_pat3};
        for i = 1:3
            image_cat{i}(:,:,:,ipat) = coord2im(coord_pats{i});
        end
    end
    
    if cond == 4
        coord_pat11 =  genDotPatterns(9,'low',proto1);
        coord_pat12 =  genDotPatterns(9,'med',proto1);
        coord_pat13 =  genDotPatterns(9,'high',proto1);
        coord_pat21 =  genDotPatterns(9,'low',proto2);
        coord_pat22 =  genDotPatterns(9,'med',proto2);
        coord_pat23 =  genDotPatterns(9,'high',proto2);
        coord_pat31 =  genDotPatterns(9,'low',proto3);
        coord_pat32 =  genDotPatterns(9,'med',proto3);
        coord_pat33 =  genDotPatterns(9,'high',proto3);
        coord_pats = {coord_pat11,coord_pat12,coord_pat13,coord_pat21,coord_pat22,coord_pat23,coord_pat31,coord_pat32,coord_pat33};
        for i = 1:9
            image_cat{i}(:,:,:,ipat) = coord2im(coord_pats{i});
        end
    end   
end
set(groot,'DefaultFigureVisible','on');
image_cats = cat(5,image_cat{:});


% classification labels
if cond == 4 
    label_cat = repelem(1:9,N_pat_cat);
else
    label_cat = repelem(1:3,N_pat_cat);
end


%% divide the dataset into training and validation sets

% Define number of images assigned to each group
trainNum = 0.7*N_pat_cat;
valNum = 0.3*N_pat_cat;

dims = size(image_cat(:,:,:,1:trainNum,:));
XTrain = reshape(image_cat(:,:,:,1:trainNum,:),[dims(1:end-2), prod(dims(end-1:end))]);
YTrain = reshape(label_cat(:,:,:,1:trainNum,:),[dims(1:end-2), prod(dims(end-1:end))]);
XVal = reshape(image_cat(:,:,:,trainNum+1:valNum,:),[dims(1:end-2), prod(dims(end-1:end))]);
YVal = reshape(label_cat(:,:,:,trainNum+1:valNum,:),[dims(1:end-2), prod(dims(end-1:end))]);
x_idx = randperm(length(XVal));
y_idx = randperm(length(YVal));
XTrain = XTrain(x_idx);
YTrain = YTrain(y_idx);
XVal = XVal(x_idx);
YVal = YVal(y_idx);

% construct ImageDatastore objects for feeding into the neural network
trainDs = augmentedImageDatastore([224 224],trainTbl,'cat_label','DataAugmentation',augs,'ColorPreprocessing','rgb2gray');
valDs = augmentedImageDatastore([224 224],valTbl,'cat_label','DataAugmentation',augs,'ColorPreprocessing','rgb2gray');
testDs = augmentedImageDatastore([224 224],testTbl,'cat_label','DataAugmentation',augs,'ColorPreprocessing','rgb2gray');

%% Network structure specification
% copy the pre-trained resnet 18 network
lgraph = layerGraph(resnet18);
% self-define the input and first convolutional layer to fit our grayscale images
input_layer = imageInputLayer([224,224,1],'Normalization','zscore','Name','data');
conv_layer = convolution2dLayer([7,7],64,'Stride',[2,2],'Padding',[3,3,3,3],'Name','conv1');
conv_layer.Weights = mean(lgraph.Layers(2).Weights,3);% weight parameters from resnet 18 need to be averaged over color channels
conv_layer.Bias = lgraph.Layers(2).Bias; % leave the bias parameters unchanged
lgraph = replaceLayer(lgraph,'data',input_layer);
lgraph = replaceLayer(lgraph,'conv1',conv_layer);
% remove the last 3 layers of the resnet 18
layers_removed = {lgraph.Layers(end-2:end).Name};
lgraph = removeLayers(lgraph,layers_removed);
% customize the last layers to have 18 feature nodes and 3 category nodes
numFeatures = 18;
numCategorys = numel(categories(cat_label));
layers_added = [fullyConnectedLayer(numFeatures,'Name','dimension')% feature layer
           eluLayer('Name','dim_elu')% ELU function
           fullyConnectedLayer(numCategorys,'Name','category')% category layer
           softmaxLayer('Name','prob') % softmax function
           classificationLayer('Classes',{'cat1','cat2','cat3'},'Name','classout')];% classification error function
lgraph = addLayers(lgraph,layers_added);
lgraph = connectLayers(lgraph,'pool5', layers_added(1).Name);


%% Train/validate the network
options = trainingOptions('adam','InitialLearnRate',0.0001, ...
                           'Plots', 'training-progress', ...
                           'MaxEpochs', 30, ...%60
                           'ValidationData', valDs, ...
                           'ValidationFrequency', 10, ...
                           'ValidationPatience', 15, ...
                           'MiniBatchSize', 75,...
                           'ExecutionEnvironment', 'multi-gpu');

% Only include this last 'ExecutionEnvironment' line if working on a
% computer with a compatible GPU, like the Alienware.

[dotNet, info] = trainNetwork(trainDs,lgraph,options);

%% Confirm validation is what it said it was
[catPred,probs] = classify(dotNet,valDs);
catTrue = valTbl.cat_label;
valACCU = mean(catPred == catTrue);
fprintf(['Validation Accuracy: ' num2str(valACCU) '\n']);

%% Test the network
[catPred,probs] = classify(dotNet,testDs);
catTrue = testTbl.cat_label;
testACCU = mean(catPred == catTrue);
fprintf(['Test Accuracy: ' num2str(testACCU) '\n']);

%% export Network classification data
category = catTrue;
distortion = testdist;
image = testimageidx;
Prob_cat1 = probs(:,1);
Prob_cat2 = probs(:,2);
Prob_cat3 = probs(:,3);
classification = catPred;
T = table(category,distortion,testimageidx,Prob_cat1,Prob_cat2,Prob_cat3,classification,...
    'VariableNames',{'category','distortion_level','image','Prob_cat1','Prob_cat2','Prob_cat3','classification'});
writetable(T,'network classification.xlsx','WriteRowNames',true)  

%% export prototype model classification data
% compute prototype feature coordinates from training data
act_train = squeeze(activations(dotNet,trainDs,'dimension'));
act_proto(:,1) = mean(act_train(:,trainTbl.cat_label == 'cat1'),2);
act_proto(:,2) = mean(act_train(:,trainTbl.cat_label == 'cat2'),2); 
act_proto(:,3) = mean(act_train(:,trainTbl.cat_label == 'cat3'),2);
% compute Euclidean distances between test patterns and three prototypes
act_test = squeeze(activations(dotNet,testDs,'dimension'));
dist_test(1,:) = sqrt(sum((act_test - act_proto(:,1)).^2,1));
dist_test(2,:) = sqrt(sum((act_test - act_proto(:,2)).^2,1));
dist_test(3,:) = sqrt(sum((act_test - act_proto(:,3)).^2,1));
% read out ground truth categories of test patterns 
[~,~,catTrue_num] = unique(catTrue);
% compute the classification probabilities of test patterns by GCM
c = .2;% sensitivity parameter
sim_test = exp(-c*dist_test);
Prob_cat1 = sim_test(1,:)./sum(sim_test,1);
Prob_cat2 = sim_test(2,:)./sum(sim_test,1);
Prob_cat3 = sim_test(3,:)./sum(sim_test,1);
% predict classification by maximum probability
[~,catPred_num] = max([Prob_cat1;Prob_cat2;Prob_cat3]);
classification = categorical(catPred_num,[1,2,3],{'cat1','cat2','cat3'});
% compute prediction accuracy
accuracy = mean(catPred_num == catTrue_num');
fprintf(['prototype model Accuracy: ' num2str(accuracy) '\n']);
T = table(category,distortion,testimageidx,Prob_cat1',Prob_cat2',Prob_cat3',classification',...
    'VariableNames',{'category','distortion_level','image','Prob_cat1','Prob_cat2','Prob_cat3','classification'});
writetable(T,'prototype model classification.xlsx','WriteRowNames',true)  










