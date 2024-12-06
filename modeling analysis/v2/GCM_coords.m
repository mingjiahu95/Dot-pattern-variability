function [Pr_corr,Pr_corr_pat] = GCM_coords(c,gamma,condition)
%condition: 1 low 2 med 3 high 4 mix
%item type: 1 proto 2 old 3 newlow 4 newmed 5 newhigh 6 newhigh_hard
clearvars -except c gamma condition
load("stim_info.mat");
pat_train = squeeze(reshape(coord_train(:,:,:,condition),[18,1,27]));
pat_test_old = squeeze(reshape(coord_test_old(:,:,:,condition),[18,1,27]));
pat_test_newlow = squeeze(reshape(coord_test_newlow(:,:,:,condition),[18,1,9]));
pat_test_newmed = squeeze(reshape(coord_test_newmed(:,:,:,condition),[18,1,18]));
pat_test_newhigh = squeeze(reshape(coord_test_newhigh(:,:,:,condition),[18,1,27]));
pat_proto = squeeze(reshape(coord_proto,[18,1,3]));
pat_test_newhigh_hard = squeeze(reshape(coord_test_newhigh_hard,[18,1,3]));
cat_train = cat_train(:,condition);
cat_test_old = cat_test_old(:,condition);
cat_test_newlow = cat_test_newlow(:,condition);
cat_test_newmed = cat_test_newmed(:,condition);
cat_test_newhigh = cat_test_newhigh(:,condition);
cat_proto = cat_proto';
cat_test_newhigh_hard = cat_test_newhigh_hard';

Pr_corr_proto = NaN([1,3]);
for ipat = 1:3
    sim_by_cat_proto = coord2sim(pat_train,pat_proto(:,ipat),cat_train,c);
    Pr_corr_proto(ipat) = sim_by_cat_proto(cat_proto(ipat))^gamma/sum(sim_by_cat_proto.^gamma);
end

Pr_corr_old = NaN([1,27]);
for ipat = 1:27
    sim_by_cat_old = coord2sim(pat_train,pat_test_old(:,ipat),cat_train,c);
    Pr_corr_old(ipat) = sim_by_cat_old(cat_test_old(ipat))^gamma/sum(sim_by_cat_old.^gamma);
end

Pr_corr_newlow = NaN([1,9]);
for ipat = 1:9
    sim_by_cat_newlow = coord2sim(pat_train,pat_test_newlow(:,ipat),cat_train,c);
    Pr_corr_newlow(ipat) = sim_by_cat_newlow(cat_test_newlow(ipat))^gamma/sum(sim_by_cat_newlow.^gamma);
end

Pr_corr_newmed = NaN([1,18]);
for ipat = 1:18
    sim_by_cat_newmed = coord2sim(pat_train,pat_test_newmed(:,ipat),cat_train,c);
    Pr_corr_newmed(ipat) = sim_by_cat_newmed(cat_test_newmed(ipat))^gamma/sum(sim_by_cat_newmed.^gamma);
end

Pr_corr_newhigh = NaN([1,27]);
for ipat = 1:27
    sim_by_cat_newhigh = coord2sim(pat_train,pat_test_newhigh(:,ipat),cat_train,c);
    Pr_corr_newhigh(ipat) = sim_by_cat_newhigh(cat_test_newhigh(ipat))^gamma/sum(sim_by_cat_newhigh.^gamma);
end

Pr_corr_newhigh_hard = NaN([1,3]);
for ipat = 1:3
    sim_by_cat_newhigh_hard = coord2sim(pat_train,pat_test_newhigh_hard(:,ipat),cat_train,c);
    Pr_corr_newhigh_hard(ipat) = sim_by_cat_newhigh_hard(cat_test_newhigh_hard(ipat))^gamma/sum(sim_by_cat_newhigh_hard.^gamma);
end

Pr_corr_proto = NaN([1,3]);
for ipat = 1:3
    sim_by_cat_proto = coord2sim(pat_train,pat_proto(:,ipat),cat_train,c);
    Pr_corr_proto(ipat) = sim_by_cat_proto(cat_proto(ipat))^gamma/sum(sim_by_cat_proto.^gamma);
end

Pr_corr_pat = struct;
Pr_corr_pat.proto = Pr_corr_proto;
Pr_corr_pat.old = Pr_corr_old;
Pr_corr_pat.newlow = Pr_corr_newlow;
Pr_corr_pat.newmed = Pr_corr_newmed;
Pr_corr_pat.newhigh = Pr_corr_newhigh;
Pr_corr_pat.newhigh_hard = Pr_corr_newhigh_hard;

Pr_corr = [mean(Pr_corr_proto),mean(Pr_corr_old),mean(Pr_corr_newlow),mean(Pr_corr_newmed),mean(Pr_corr_newhigh),mean(Pr_corr_newhigh_hard)];
end

function [sim_by_cat,ncat,ntrain] = coord2sim(train_coords,test_coord,train_cats,sensitivity)
ncat = unique(max(train_cats)); %train_cats are coded as consecutive integers from 1 to ncat
ntrain = size(train_coords,2); %train_coords should have the size 18 x ntrain
sim_by_cat = NaN([1,ncat]);
for icat = 1:ncat
    diff_coords = train_coords(:,train_cats == icat) - test_coord;
    dist_coords = sqrt(sum(diff_coords.^2,1));
    sim_by_cat(icat) = sum(exp(-sensitivity*dist_coords));
end
end
    



