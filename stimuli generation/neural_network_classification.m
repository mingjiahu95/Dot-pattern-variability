%% Preliminaries
clear
clc
clf
rng(2936);

%% Loading data

% Image data
image_location = [pwd '\images\'];
files_cat1 = dir([image_location 'cat1*\image*.jpg']);
files_cat2 = dir([image_location 'cat2*\image*.jpg']);
files_cat3 = dir([image_location 'cat3*\image*.jpg']);
files = [files_cat1;files_cat2;files_cat3];

numpats = numel(files);
names = cell(numpats, 1);
for i = 1:numpats
    names{i} = [files(i).folder '\' files(i).name];
end

% ground truth classification data
values = [repmat(1,[numel(files_cat1),1]);repmat(2,[numel(files_cat2),1]);repmat(3,[numel(files_cat3),1])];
cat_label = categorical(values,[1,2,3],{'cat1','cat2','cat3'});


% Make a table
data = table(names, cat_label);

%% Preprocessing and group assignment

% Define proportion of images assigned to each group
trainProp = 0.6;
valProp = 0.2;
testProp = 0.2;

% Determine starting/stopping numbers for patterns in each
% category/distortion
numpats_dist = numpats/9; % divided by 9 for 3 category x 3 distortion levels
trainStart = 1;
trainStop = numpats_dist * trainProp;
valStart = trainStop + 1;
valStop = trainStop + numpats_dist * valProp ;
testStart = valStop + 1;
testStop = valStop + numpats_dist * testProp;

% Create randomized order indices for images in each category/distortion
% type (i.e. indices 1-200 permuted, indices 201-400 permuted,...,indices 1600-1800 permuted)
order_tmp = cell2mat(arrayfun(@(x) x+randperm(200),0:numpats_dist:numpats_dist*8,'UniformOutput',false));
% Partition the order indices into training, validation and test datasets
% (sample the corresponding proportions of images in each group into the three datasets)
idx_train = cell2mat(arrayfun(@(x) order_tmp(x+(trainStart:trainStop)),0:numpats_dist:numpats_dist*8,'UniformOutput',false));
idx_val = cell2mat(arrayfun(@(x) order_tmp(x+(valStart:valStop)),0:numpats_dist:numpats_dist*8,'UniformOutput',false));
idx_test = cell2mat(arrayfun(@(x) order_tmp(x+(testStart:testStop)),0:numpats_dist:numpats_dist*8,'UniformOutput',false));
% Randomize the order of images from different groups of category and distortion levels
order_train = idx_train(randperm(length(idx_train)));
order_val = idx_val(randperm(length(idx_val)));
order_test = idx_test(randperm(length(idx_test)));
% apply the order indices to the image data to create separate tables for three datasets
trainTbl = data(order_train,:);
valTbl = data(order_val,:);
testTbl = data(order_test,:);
% extract distortion level and image index information from the file names
testdist = regexp(testTbl.names,'((?<=cat\d_)[a-z]*(?=\\image))','match');
testimageidx = regexp(testTbl.names,'((?<=image)[0-9]*(?=\.jpg))','match');

% data preprocessing (e.g. rotation, reflection, resize etc; optional)
% augs = imageDataAugmenter(...
%     'RandXReflection', true, ...
%     'RandYReflection', true, ...
%     'RandRotation', [0, 360] ...
%     );
augs = imageDataAugmenter();

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

%% Visualize extracted dimensions
% layer = 'dimension';
% channels = 1:numFeatures;
% 
% I = deepDreamImage(dotNet,layer,channels, ...
%     'InitialImage',ones(224,224),...
%     'PyramidLevels',2, ...
%     'NumIterations',100,...
%     'PyramidScale',1.2,...
%     'Verbose',0);
% 
% figure
% I = imtile(I,'ThumbnailSize',[150 150]);
% imshow(I)
% title([layer,' Features'],'Interpreter','none')

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










