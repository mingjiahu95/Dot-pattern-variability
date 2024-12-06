%%training phase
%check token indices

tabulate(token_store(phase_store == 1))
crosstab(token_store(phase_store == 1),block_store(phase_store == 1))


%%test phase
%check distortion levels :
for i = 1:5
    tabulate(distort_store(phase_store == 2 & itemtype_store == i))%(0 proto, 1 low, 2 med, 3 high)
    tabulate(cat_store(phase_store == 2 & itemtype_store == i))%cat labels (1-3)
    tabulate(token_store(phase_store == 2 & itemtype_store == i))%check token indices
end

%old item: cat structure
token_per_cat = crosstab(token_store(phase_store == 2 & itemtype_store == 1),cat_store(phase_store == 2 & itemtype_store == 1))
Num_token_per_cat = sum(token_per_cat,1)

%old item: distort structure
token_per_distort = crosstab(token_store(phase_store == 2 & itemtype_store == 1),distort_store(phase_store == 2 & itemtype_store == 1))
Num_token_per_distort = sum(token_per_distort,1)

%old item: block structure
block_vec = [];
for i = 1:3
token_cat = token_store(phase_store == 2 & itemtype_store == 1 & cat_store == i);
block_vec = [block_vec,ceil(token_cat/9)];
end
tabulate(block_vec)

%test accuracy check by itemtypes
G = findgroups(itemtype_store(phase_store == 2));
mean_corr_test = splitapply(@mean,corr_store(phase_store == 2),G);

%training accuracy check by block
G = findgroups(block_store(phase_store == 1));
mean_corr_train = splitapply(@mean,corr_store(phase_store == 1),G);
