T = readtable('pattern_index.csv');
 
train_low_idx = T{T.condition == 1 & T.phase == 1,6:8};
train_med_idx = T{T.condition == 2 & T.phase == 1,6:8};
train_high_idx = T{T.condition == 3 & T.phase == 1,6:8};
train_mix_idx = T{T.condition == 4 & T.phase == 1,6:8};
test_old_low_idx = T{T.condition == 1 & T.phase == 2 & T.itemtype == 1,6:8};
test_old_med_idx = T{T.condition == 2 & T.phase == 2 & T.itemtype == 1,6:8};
test_old_high_idx = T{T.condition == 3 & T.phase == 2 & T.itemtype == 1,6:8};
test_old_mix_idx = T{T.condition == 4 & T.phase == 2 & T.itemtype == 1,6:8};
test_newlow_low_idx = T{T.condition == 1 & T.phase == 2 & T.itemtype == 3,6:8};
test_newlow_med_idx = T{T.condition == 2 & T.phase == 2 & T.itemtype == 3,6:8};
test_newlow_high_idx = T{T.condition == 3 & T.phase == 2 & T.itemtype == 3,6:8};
test_newlow_mix_idx = T{T.condition == 4 & T.phase == 2 & T.itemtype == 3,6:8};
test_newmed_low_idx = T{T.condition == 1 & T.phase == 2 & T.itemtype == 4,6:8};
test_newmed_med_idx = T{T.condition == 2 & T.phase == 2 & T.itemtype == 4,6:8};
test_newmed_high_idx = T{T.condition == 3 & T.phase == 2 & T.itemtype == 4,6:8};
test_newmed_mix_idx = T{T.condition == 4 & T.phase == 2 & T.itemtype == 4,6:8};
test_newhigh_low_idx = T{T.condition == 1 & T.phase == 2 & T.itemtype == 5,6:8};
test_newhigh_med_idx = T{T.condition == 2 & T.phase == 2 & T.itemtype == 5,6:8};
test_newhigh_high_idx = T{T.condition == 3 & T.phase == 2 & T.itemtype == 5,6:8};
test_newhigh_mix_idx = T{T.condition == 4 & T.phase == 2 & T.itemtype == 5,6:8};

dot_coords = cat(5,cat(4,ld1,md1,hd1),cat(4,ld2,md2,hd2),cat(4,ld3,md3,hd3));
dot_coords = permute(dot_coords,[5,4,3,1,2]);
coord_index_mat = [1:9;cat2_index;cat3_index];

coord_train = NaN([9,2,27,4]);
cat_train = NaN([27,4]);
for i = 1:27
    coord_index = coord_index_mat(icat,:);    
    coord_train(:,:,i,1) = squeeze(dot_coords(train_low_idx(i,1),train_low_idx(i,2),train_low_idx(i,3),coord_index,:));
    cat_train(i,1) = train_low_idx(i,1);
    coord_index = coord_index_mat(train_med_idx(i,1),:);
    coord_train(:,:,i,2) = squeeze(dot_coords(train_med_idx(i,1),train_med_idx(i,2),train_med_idx(i,3),coord_index,:));
    cat_train(i,2) = train_med_idx(i,1);
    coord_index = coord_index_mat(train_high_idx(i,1),:);
    coord_train(:,:,i,3) = squeeze(dot_coords(train_high_idx(i,1),train_high_idx(i,2),train_high_idx(i,3),coord_index,:));
    cat_train(i,3) = train_high_idx(i,1);
    coord_index = coord_index_mat(train_mix_idx(i,1),:);
    coord_train(:,:,i,4) = squeeze(dot_coords(train_mix_idx(i,1),train_mix_idx(i,2),train_mix_idx(i,3),coord_index,:));
    cat_train(i,4) = train_mix_idx(i,1);
end
    
coord_test_old = NaN([9,2,27,4]);
cat_test_old = NaN([27,4]);
for i = 1:27
    coord_index = coord_index_mat(test_old_low_idx(i,1),:);
    coord_test_old(:,:,i,1) = squeeze(dot_coords(test_old_low_idx(i,1),test_old_low_idx(i,2),test_old_low_idx(i,3),coord_index,:));
    cat_test_old(i,1) = test_old_low_idx(i,1);
    coord_index = coord_index_mat(test_old_med_idx(i,1),:);
    coord_test_old(:,:,i,2) = squeeze(dot_coords(test_old_med_idx(i,1),test_old_med_idx(i,2),test_old_med_idx(i,3),coord_index,:));
    cat_test_old(i,2) = test_old_med_idx(i,1);
    coord_index = coord_index_mat(test_old_high_idx(i,1),:);
    coord_test_old(:,:,i,3) = squeeze(dot_coords(test_old_high_idx(i,1),test_old_high_idx(i,2),test_old_high_idx(i,3),coord_index,:));
    cat_test_old(i,3) = test_old_high_idx(i,1);
    coord_index = coord_index_mat(test_old_mix_idx(i,1),:);
    coord_test_old(:,:,i,4) = squeeze(dot_coords(test_old_mix_idx(i,1),test_old_mix_idx(i,2),test_old_mix_idx(i,3),coord_index,:));
    cat_test_old(i,4) = test_old_mix_idx(i,1);
end

coord_test_newlow = NaN([9,2,9,4]);
cat_test_newlow = NaN([9,4]);
for i = 1:9
    coord_index = coord_index_mat(test_newlow_low_idx(i,1),:);
    coord_test_newlow(:,:,i,1) = squeeze(dot_coords(test_newlow_low_idx(i,1),test_newlow_low_idx(i,2),test_newlow_low_idx(i,3),coord_index,:));
    cat_test_newlow(i,1) = test_newlow_low_idx(i,1);
    coord_index = coord_index_mat(test_newlow_med_idx(i,1),:);
    coord_test_newlow(:,:,i,2) = squeeze(dot_coords(test_newlow_med_idx(i,1),test_newlow_med_idx(i,2),test_newlow_med_idx(i,3),coord_index,:));
    cat_test_newlow(i,2) = test_newlow_med_idx(i,1);
    coord_index = coord_index_mat(test_newlow_high_idx(i,1),:);
    coord_test_newlow(:,:,i,3) = squeeze(dot_coords(test_newlow_high_idx(i,1),test_newlow_high_idx(i,2),test_newlow_high_idx(i,3),coord_index,:));
    cat_test_newlow(i,3) = test_newlow_high_idx(i,1);
    coord_index = coord_index_mat(test_newlow_mix_idx(i,1),:);
    coord_test_newlow(:,:,i,4) = squeeze(dot_coords(test_newlow_mix_idx(i,1),test_newlow_mix_idx(i,2),test_newlow_mix_idx(i,3),coord_index,:));
    cat_test_newlow(i,4) = test_newlow_mix_idx(i,1);
end

coord_test_newmed = NaN([9,2,18,4]);
cat_test_newmed = NaN([18,4]);
for i = 1:18
    coord_index = coord_index_mat(test_newmed_low_idx(i,1),:);
    coord_test_newmed(:,:,i,1) = squeeze(dot_coords(test_newmed_low_idx(i,1),test_newmed_low_idx(i,2),test_newmed_low_idx(i,3),coord_index,:));
    cat_test_newmed(i,1) = test_newmed_low_idx(i,1);
    coord_index = coord_index_mat(test_newmed_med_idx(i,1),:);
    coord_test_newmed(:,:,i,2) = squeeze(dot_coords(test_newmed_med_idx(i,1),test_newmed_med_idx(i,2),test_newmed_med_idx(i,3),coord_index,:));
    cat_test_newmed(i,2) = test_newmed_med_idx(i,1);
    coord_index = coord_index_mat(test_newmed_high_idx(i,1),:);
    coord_test_newmed(:,:,i,3) = squeeze(dot_coords(test_newmed_high_idx(i,1),test_newmed_high_idx(i,2),test_newmed_high_idx(i,3),coord_index,:));
    cat_test_newmed(i,3) = test_newmed_high_idx(i,1);
    coord_index = coord_index_mat(test_newmed_mix_idx(i,1),:);
    coord_test_newmed(:,:,i,4) = squeeze(dot_coords(test_newmed_mix_idx(i,1),test_newmed_mix_idx(i,2),test_newmed_mix_idx(i,3),coord_index,:));
    cat_test_newmed(i,4) = test_newmed_mix_idx(i,1);
end

coord_test_newhigh = NaN([9,2,27,4]);
cat_test_newhigh = NaN([27,4]);
for i = 1:27
    coord_index = coord_index_mat(test_newhigh_low_idx(i,1),:);
    coord_test_newhigh(:,:,i,1) = squeeze(dot_coords(test_newhigh_low_idx(i,1),test_newhigh_low_idx(i,2),test_newhigh_low_idx(i,3),coord_index,:));
    cat_test_newhigh(i,1) = test_newhigh_low_idx(i,1);
    coord_index = coord_index_mat(test_newhigh_med_idx(i,1),:);
    coord_test_newhigh(:,:,i,2) = squeeze(dot_coords(test_newhigh_med_idx(i,1),test_newhigh_med_idx(i,2),test_newhigh_med_idx(i,3),coord_index,:));
    cat_test_newhigh(i,2) = test_newhigh_med_idx(i,1);
    coord_index = coord_index_mat(test_newhigh_high_idx(i,1),:);
    coord_test_newhigh(:,:,i,3) = squeeze(dot_coords(test_newhigh_high_idx(i,1),test_newhigh_high_idx(i,2),test_newhigh_high_idx(i,3),coord_index,:));
    cat_test_newhigh(i,3) = test_newhigh_high_idx(i,1);
    coord_index = coord_index_mat(test_newhigh_mix_idx(i,1),:);
    coord_test_newhigh(:,:,i,4) = squeeze(dot_coords(test_newhigh_mix_idx(i,1),test_newhigh_mix_idx(i,2),test_newhigh_mix_idx(i,3),coord_index,:));
    cat_test_newhigh(i,4) = test_newhigh_mix_idx(i,1);
end



%special high distortions
test_newhigh_hard_idx = table2array(unique(T(T.phase == 2 & T.itemtype == 6,6:8)));
coord_test_newhigh_hard = NaN([9,2,3]);
cat_test_newhigh_hard = NaN([1,3]);
for i = 1:3
    coord_index = coord_index_mat(test_newhigh_hard_idx(i,1),:);
    coord_test_newhigh_hard(:,:,i) = squeeze(dot_coords(test_newhigh_hard_idx(i,1),test_newhigh_hard_idx(i,2),test_newhigh_hard_idx(i,3),coord_index,:));
    cat_test_newhigh_hard(i) = test_newhigh_hard_idx(i,1);
end

%prototypes
coord_proto = cat(3,p1,p2_aligned,p3_aligned);
cat_proto = [1,2,3];