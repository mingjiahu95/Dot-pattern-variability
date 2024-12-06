clear;
clc;
% load("network and data_f18.mat");

%% Loading experiment stimuli data
%create datastore files from image files

%proto
image_location = [pwd '\stim_images\'];
files_proto = dir([image_location 'proto\image*.jpg']);

numpats = numel(files_proto);
names = cell(numpats, 1);
for i = 1:numpats
    names{i} = [files_proto(i).folder '\' files_proto(i).name];
end

values = [1,2,3];
cat_label = categorical(values,[1,2,3],{'cat1','cat2','cat3'});
proto_Tbl = table(names, cat_label','VariableNames',{'image_name','true_category'});

%test_newhigh_hard
image_location = [pwd '\stim_images\'];
files_test_newhigh_hard = dir([image_location 'test_newhigh_hard\image*.jpg']);

numpats = numel(files_test_newhigh_hard);
names = cell(numpats, 1);
for i = 1:numpats
    names{i} = [files_test_newhigh_hard(i).folder '\' files_test_newhigh_hard(i).name];
end

values = [1,2,3];
cat_label = categorical(values,[1,2,3],{'cat1','cat2','cat3'});
test_newhigh_hard_Tbl = table(names, cat_label','VariableNames',{'image_name','true_category'});

for icond = 1:4
    image_location = [pwd '\stim_images\cond' num2str(icond)];

    %test_old
    files_test_old = dir([image_location '\test_old\image*.jpg']);
    numpats = numel(files_test_old);
    names = cell(numpats, 1);
    for i = 1:numpats
        names{i} = [files_test_old(i).folder '\' 'image' num2str(i) '.jpg'];
    end    
    values = [repmat(1,[1,9]),repmat(2,[1,9]),repmat(3,[1,9])];
    cat_label = categorical(values,[1,2,3],{'cat1','cat2','cat3'});
    test_old_Tbl{icond} = table(names, cat_label','VariableNames',{'image_name','true_category'});

    %test_newlow
    files_test_newlow = dir([image_location '\test_newlow\image*.jpg']);
    numpats = numel(files_test_newlow);
    names = cell(numpats, 1);
    for i = 1:numpats
        names{i} = [files_test_newlow(i).folder '\' 'image' num2str(i) '.jpg'];
    end    
    values = [repmat(1,[1,3]),repmat(2,[1,3]),repmat(3,[1,3])];
    cat_label = categorical(values,[1,2,3],{'cat1','cat2','cat3'});
    test_newlow_Tbl{icond} = table(names, cat_label','VariableNames',{'image_name','true_category'});

    %test_newmed
    files_test_newmed = dir([image_location '\test_newmed\image*.jpg']);
    numpats = numel(files_test_newmed);
    names = cell(numpats, 1);
    for i = 1:numpats
        names{i} = [files_test_newmed(i).folder '\' 'image' num2str(i) '.jpg'];
    end    
    values = [repmat(1,[1,6]),repmat(2,[1,6]),repmat(3,[1,6])];
    cat_label = categorical(values,[1,2,3],{'cat1','cat2','cat3'});
    test_newmed_Tbl{icond} = table(names, cat_label','VariableNames',{'image_name','true_category'});

    %test_newhigh
    files_test_newhigh = dir([image_location '\test_newhigh\image*.jpg']);
    numpats = numel(files_test_newhigh);
    names = cell(numpats, 1);
    for i = 1:numpats
        names{i} = [files_test_newhigh(i).folder '\' 'image' num2str(i) '.jpg'];
    end    
    values = [repmat(1,[1,9]),repmat(2,[1,9]),repmat(3,[1,9])];
    cat_label = categorical(values,[1,2,3],{'cat1','cat2','cat3'});
    test_newhigh_Tbl{icond} = table(names, cat_label','VariableNames',{'image_name','true_category'});

    %train
    files_train = dir([image_location '\train\image*.jpg']);
    numpats = numel(files_train);
    names = cell(numpats, 1);
    for i = 1:numpats
        names{i} = [files_train(i).folder '\' 'image' num2str(i) '.jpg'];
    end    
    values = [repmat(1,[1,9]),repmat(2,[1,9]),repmat(3,[1,9])];
    cat_label = categorical(values,[1,2,3],{'cat1','cat2','cat3'});
    train_Tbl{icond} = table(names, cat_label','VariableNames',{'image_name','true_category'});
end

% Augmented datastores
protoDs = augmentedImageDatastore([224 224],proto_Tbl,'true_category','ColorPreprocessing','rgb2gray');
test_newhigh_hardDs = augmentedImageDatastore([224 224],test_newhigh_hard_Tbl,'true_category','ColorPreprocessing','rgb2gray');
for icond = 1:4
    trainDs{icond} = augmentedImageDatastore([224 224],train_Tbl{icond},'true_category','ColorPreprocessing','rgb2gray');
    test_oldDs{icond} = augmentedImageDatastore([224 224],test_old_Tbl{icond},'true_category','ColorPreprocessing','rgb2gray');
    test_newlowDs{icond} = augmentedImageDatastore([224 224],test_newlow_Tbl{icond},'true_category','ColorPreprocessing','rgb2gray');
    test_newmedDs{icond} = augmentedImageDatastore([224 224],test_newmed_Tbl{icond},'true_category','ColorPreprocessing','rgb2gray');
    test_newhighDs{icond} = augmentedImageDatastore([224 224],test_newhigh_Tbl{icond},'true_category','ColorPreprocessing','rgb2gray');
end

%% Loading network training data

% Image data
image_location = [pwd '\images\'];
files_cat1_mix = dir([image_location 'cat1*\image*.jpg']);
files_cat2_mix = dir([image_location 'cat2*\image*.jpg']);
files_cat3_mix = dir([image_location 'cat3*\image*.jpg']);
files_cat1_low = dir([image_location 'cat1_low\image*.jpg']);
files_cat2_low = dir([image_location 'cat2_low\image*.jpg']);
files_cat3_low = dir([image_location 'cat3_low\image*.jpg']);
files_cat1_med = dir([image_location 'cat1_med\image*.jpg']);
files_cat2_med = dir([image_location 'cat2_med\image*.jpg']);
files_cat3_med = dir([image_location 'cat3_med\image*.jpg']);
files_cat1_high = dir([image_location 'cat1_high\image*.jpg']);
files_cat2_high = dir([image_location 'cat2_high\image*.jpg']);
files_cat3_high = dir([image_location 'cat3_high\image*.jpg']);

files_low = [files_cat1_low;files_cat2_low;files_cat3_low];
files_med = [files_cat1_med;files_cat2_med;files_cat3_med];
files_high = [files_cat1_high;files_cat2_high;files_cat3_high];
files_mix = [files_cat1_mix;files_cat2_mix;files_cat3_mix];

numpats_pure = unique([numel(files_low),numel(files_med),numel(files_high)]);
numpats_mix = numel(files_mix);

names = cell(numpats_pure, 1);
for i = 1:numpats_pure
    names_low{i} = [files_low(i).folder '\' files_low(i).name];
end

names = cell(numpats_pure, 1);
for i = 1:numpats_pure
    names_med{i} = [files_med(i).folder '\' files_med(i).name];
end

names = cell(numpats_pure, 1);
for i = 1:numpats_pure
    names_high{i} = [files_high(i).folder '\' files_high(i).name];
end

names = cell(numpats_mix, 1);
for i = 1:numpats_mix
    names_mix{i} = [files_mix(i).folder '\' files_mix(i).name];
end

% ground truth classification data
values_pure = [repmat(1,[numpats_pure/3,1]);repmat(2,[numpats_pure/3,1]);repmat(3,[numpats_pure/3,1])];
values_mix = [repmat(1,[numpats_mix/3,1]);repmat(2,[numpats_mix/3,1]);repmat(3,[numpats_mix/3,1])];
cat_label_low = categorical(values_pure,[1,2,3],{'cat1','cat2','cat3'});
cat_label_med = categorical(values_pure,[1,2,3],{'cat1','cat2','cat3'});
cat_label_high = categorical(values_pure,[1,2,3],{'cat1','cat2','cat3'});
cat_label_mix = categorical(values_mix,[1,2,3],{'cat1','cat2','cat3'});

%break data up into training and validation sets
numpats_dist_cat = 200;
order_tmp_pure = cell2mat(arrayfun(@(x) x+randperm(200),0:numpats_dist_cat:numpats_dist_cat*2,'UniformOutput',false));
idx_train_pure= cell2mat(arrayfun(@(x) order_tmp_pure(x+(1:133)),0:numpats_dist_cat:numpats_dist_cat*2,'UniformOutput',false));
idx_val_pure = cell2mat(arrayfun(@(x) order_tmp_pure(x+(134:200)),0:numpats_dist_cat:numpats_dist_cat*2,'UniformOutput',false));
order_train_pure = idx_train_pure(randperm(length(idx_train_pure)));
order_val_pure = idx_val_pure(randperm(length(idx_val_pure)));


order_tmp_mix = cell2mat(arrayfun(@(x) x+randperm(200),0:numpats_dist_cat:numpats_dist_cat*8,'UniformOutput',false));
idx_train_mix = cell2mat(arrayfun(@(x) order_tmp_mix(x+(1:133)),0:numpats_dist_cat:numpats_dist_cat*8,'UniformOutput',false));
idx_val_mix = cell2mat(arrayfun(@(x) order_tmp_mix(x+(134:200)),0:numpats_dist_cat:numpats_dist_cat*8,'UniformOutput',false));
order_train_mix = idx_train_mix(randperm(length(idx_train_mix)));
order_val_mix = idx_val_mix(randperm(length(idx_val_mix)));

names_low_train = names_low(order_train_pure);
names_med_train = names_med(order_train_pure);
names_high_train = names_high(order_train_pure);
names_mix_train = names_mix(order_train_mix);

cat_label_low_train = cat_label_low(order_train_pure);
cat_label_med_train = cat_label_med(order_train_pure);
cat_label_high_train = cat_label_high(order_train_pure);
cat_label_mix_train = cat_label_mix(order_train_mix);

names_low_val = names_low(order_val_pure);
names_med_val = names_med(order_val_pure);
names_high_val = names_high(order_val_pure);
names_mix_val = names_mix(order_val_mix);

cat_label_low_val = cat_label_low(order_val_pure);
cat_label_med_val = cat_label_med(order_val_pure);
cat_label_high_val = cat_label_high(order_val_pure);
cat_label_mix_val = cat_label_mix(order_val_mix);

% Make a table
network_train_Tbl_low = table(names_low_train', cat_label_low_train);
network_train_Tbl_med = table(names_med_train', cat_label_med_train);
network_train_Tbl_high = table(names_high_train', cat_label_high_train);
network_train_Tbl_mix = table(names_mix_train', cat_label_mix_train);
network_val_Tbl_low = table(names_low_val', cat_label_low_val);
network_val_Tbl_med = table(names_med_val', cat_label_med_val);
network_val_Tbl_high = table(names_high_val', cat_label_high_val);
network_val_Tbl_mix = table(names_mix_val', cat_label_mix_val);

network_trainDs{1} = augmentedImageDatastore([224 224],network_train_Tbl_low,'cat_label_low_train','ColorPreprocessing','rgb2gray');
network_trainDs{2} = augmentedImageDatastore([224 224],network_train_Tbl_med,'cat_label_med_train','ColorPreprocessing','rgb2gray');
network_trainDs{3} = augmentedImageDatastore([224 224],network_train_Tbl_high,'cat_label_high_train','ColorPreprocessing','rgb2gray');
network_trainDs{4} = augmentedImageDatastore([224 224],network_train_Tbl_mix,'cat_label_mix_train','ColorPreprocessing','rgb2gray');
network_valDs{1} = augmentedImageDatastore([224 224],network_val_Tbl_low,'cat_label_low_val','ColorPreprocessing','rgb2gray');
network_valDs{2} = augmentedImageDatastore([224 224],network_val_Tbl_med,'cat_label_med_val','ColorPreprocessing','rgb2gray');
network_valDs{3} = augmentedImageDatastore([224 224],network_val_Tbl_high,'cat_label_high_val','ColorPreprocessing','rgb2gray');
network_valDs{4} = augmentedImageDatastore([224 224],network_val_Tbl_mix,'cat_label_mix_val','ColorPreprocessing','rgb2gray');

%% Alter resnet18 to be a classification network
lgraph = resnet18('Weights','none');
input_layer = imageInputLayer([224,224,1],'Normalization','zscore','Name','data');
conv_layer = convolution2dLayer([7,7],64,'Stride',[2,2],'Padding',[3,3,3,3],'Name','conv1');
conv_layer.Weights = mean(lgraph.Layers(2).Weights,3);
conv_layer.Bias = lgraph.Layers(2).Bias;
lgraph = replaceLayer(lgraph,'data',input_layer);
lgraph = replaceLayer(lgraph,'conv1',conv_layer);

numFeatures = 18; %set number of features for the penultimate layer
numCategorys = numel(categories(cat_label));
layers_removed = {lgraph.Layers(end-2:end).Name};
lgraph = removeLayers(lgraph,layers_removed);
layers_added = [fullyConnectedLayer(numFeatures,'Name','dimension')
           eluLayer('Name','dim_elu')
           fullyConnectedLayer(numCategorys,'Name','category')
           softmaxLayer('Name','prob') 
           classificationLayer('Classes',{'cat1','cat2','cat3'},'Name','classout')];
lgraph = addLayers(lgraph,layers_added);
lgraph = connectLayers(lgraph,'pool5', layers_added(1).Name);
% newLayers = [fullyConnectedLayer(500); reluLayer(); dropoutLayer(0.5); fullyConnectedLayer(numCoordinates); regressionLayer()];
% newLayers = [convolution2dLayer([3,3],6,'Padding',[1,1,1,1],'Name','dimension');batchNormalizationLayer('Name','dim_norm');eluLayer('Name','dim_nonlinear')];

%% Train/validate the network
dotNet = cell([1,4]);
for icond = 1:4
options = trainingOptions('adam','InitialLearnRate',0.0001, ...
                           'Plots', 'training-progress', ...
                           'MaxEpochs', 15, ...%60
                           'ValidationData',network_valDs{icond},...
                           'ValidationFrequency', 10, ...
                           'ValidationPatience', 15, ...
                           'Shuffle','every-epoch',...
                           'MiniBatchSize', 75,...
                           'ExecutionEnvironment', 'multi-gpu');

% Only include this last 'ExecutionEnvironment' line if working on a
% computer with a compatible GPU, like the Alienware.
[dotNet{icond}, info] = trainNetwork(network_trainDs{icond},lgraph,options);%set the condition manually
end

%save the neural network and training data
% dotNet_f18 = dotNet;
% save("network and data_f18.mat","dotNet_f18","*Ds","*Tbl");
% load("network and data_f18.mat")

%% extract features from dotNet18

for icond = 1:4
    network = dotNet_f18{icond};
    feature18_proto = squeeze(activations(network,protoDs,'dimension'));
    feature18_test_newhigh_special = squeeze(activations(network,test_newhigh_hardDs,'dimension'));
    feature18_train(:,:,icond) = squeeze(activations(network,trainDs{icond},'dimension'));%network_trainDs{icond}
    feature18_test_old(:,:,icond) = squeeze(activations(network,test_oldDs{icond},'dimension'));
    feature18_test_newlow(:,:,icond) = squeeze(activations(network,test_newlowDs{icond},'dimension'));
    feature18_test_newmed(:,:,icond) = squeeze(activations(network,test_newmedDs{icond},'dimension'));
    feature18_test_newhigh(:,:,icond) = squeeze(activations(network,test_newhighDs{icond},'dimension'));
end

% save feature variables
% save("feature18_info.mat","feature18_proto","feature18_test*","feature18_train")
% load("feature18_info.mat")

%% check the validity of feature values by prototype model predictions
c = .2;
for icond = 1:4
    Prob_cat = struct;
    act_train = feature18_train(:,:,icond);
    % compute the prototypes from the experiment training stimuli
    act_proto(:,1) = mean(act_train(:,train_Tbl{icond}.true_category == 'cat1'),2);
    act_proto(:,2) = mean(act_train(:,train_Tbl{icond}.true_category == 'cat2'),2);
    act_proto(:,3) = mean(act_train(:,train_Tbl{icond}.true_category == 'cat3'),2);
    act_test_proto = feature18_proto;
    act_test_old = feature18_test_old(:,:,icond);
    act_test_newlow = feature18_test_newlow(:,:,icond);
    act_test_newmed = feature18_test_newmed(:,:,icond);
    act_test_newhigh = feature18_test_newhigh(:,:,icond);
    act_test_newhigh_special = feature18_test_newhigh_special;
    for icat = 1:3
        dist_test_proto(:,icat) = sqrt(sum((act_test_proto - act_proto(:,icat)).^2,1));
        dist_test_old(:,icat) = sqrt(sum((act_test_old - act_proto(:,icat)).^2,1));
        dist_test_newlow(:,icat) = sqrt(sum((act_test_newlow - act_proto(:,icat)).^2,1));
        dist_test_newmed(:,icat) = sqrt(sum((act_test_newmed - act_proto(:,icat)).^2,1));
        dist_test_newhigh(:,icat) = sqrt(sum((act_test_newhigh - act_proto(:,icat)).^2,1));
        dist_test_newhigh_special(:,icat) = sqrt(sum((act_test_newhigh_special - act_proto(:,icat)).^2,1));
    end
    sim_test_proto = exp(-c*dist_test_proto);
    sim_test_old = exp(-c*dist_test_old);
    sim_test_newlow = exp(-c*dist_test_newlow);
    sim_test_newmed = exp(-c*dist_test_newmed);
    sim_test_newhigh = exp(-c*dist_test_newhigh);
    sim_test_newhigh_special = exp(-c*dist_test_newhigh_special);

    Prob_cat.proto = sim_test_proto'./sum(sim_test_proto',1); 
    Prob_cat.old = sim_test_old'./sum(sim_test_old',1); 
    Prob_cat.newlow = sim_test_newlow'./sum(sim_test_newlow',1);
    Prob_cat.newmed = sim_test_newmed'./sum(sim_test_newmed',1);
    Prob_cat.newhigh = sim_test_newhigh'./sum(sim_test_newhigh',1);
    Prob_cat.newhigh_special = sim_test_newhigh_special'./sum(sim_test_newhigh_special',1);

    filename = "prototype_model_prediction" + "_cond_" + num2str(icond) + ".xlsx";
    writematrix(Prob_cat.proto',filename,'Sheet','proto');
    writematrix(Prob_cat.old',filename,'Sheet','old');
    writematrix(Prob_cat.newlow',filename,'Sheet','newlow');
    writematrix(Prob_cat.newmed',filename,'Sheet','newmed');
    writematrix(Prob_cat.newhigh',filename,'Sheet','newhigh');
    writematrix(Prob_cat.newhigh_special',filename,'Sheet','newhigh_special');
end


% %% extract features from dotNet6
% feature6_proto = squeeze(activations(dotNet_f6,protoDs,'dim_elu'));
% feature6_test_newhigh_hard = squeeze(activations(dotNet_f6,test_newhigh_hardDs,'dim_elu'));
% for icond = 1:4
%     feature6_train(:,:,icond) = squeeze(activations(dotNet_f6,trainDs{icond},'dim_elu'));
%     feature6_test_old(:,:,icond) = squeeze(activations(dotNet_f6,test_oldDs{icond},'dim_elu'));
%     feature6_test_newlow(:,:,icond) = squeeze(activations(dotNet_f6,test_newlowDs{icond},'dim_elu'));
%     feature6_test_newmed(:,:,icond) = squeeze(activations(dotNet_f6,test_newmedDs{icond},'dim_elu'));
%     feature6_test_newhigh(:,:,icond) = squeeze(activations(dotNet_f6,test_newhighDs{icond},'dim_elu'));
% end
% 
% %%save feature variables
% save("feature6_info.mat","feature6_proto","feature6_test*","feature6_train")

