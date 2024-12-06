function [Pr_resp_pat,Pr_corr_pat,Pr_corr] = GCM_coords18(params,condition)
%condition: 1 low 2 med 3 high 4 mix
%item type: 1 proto 2 old 3 newlow 4 newmed 5 newhigh 6 newhigh_hard
clearvars -except params condition weights
c = params.c;
gamma = params.gamma;
load("coord_info.mat");
pat_train = reshape(permute(coord_train(:,:,:,condition),[2 1 3 4]),[18,27]);
pat_test_old = reshape(permute(coord_test_old(:,:,:,condition),[2 1 3 4]),[18,27]);
pat_test_newlow = reshape(permute(coord_test_newlow(:,:,:,condition),[2 1 3 4]),[18,9]);
pat_test_newmed = reshape(permute(coord_test_newmed(:,:,:,condition),[2 1 3 4]),[18,18]);
pat_test_newhigh = reshape(permute(coord_test_newhigh(:,:,:,condition),[2 1 3 4]),[18,27]);
pat_proto = reshape(permute(coord_proto,[2 1 3]),[18,3]);
pat_test_newhigh_special = reshape(permute(coord_test_newhigh_special,[2 1 3]),[18,3]);
cat_train = repelem([1,2,3],[9,9,9]);

Pr_resp_proto = NaN([3,3]);
for ipat = 1:3
    sim_by_cat_proto = coord2sim(pat_train,pat_proto(:,ipat),cat_train,c);
    Pr_resp_proto(ipat,:) = (sim_by_cat_proto.^gamma)/sum(sim_by_cat_proto.^gamma);
end

Pr_resp_old = NaN([27,3]);
for ipat = 1:27
    sim_by_cat_old = coord2sim(pat_train,pat_test_old(:,ipat),cat_train,c);
    Pr_resp_old(ipat,:) = sim_by_cat_old.^gamma/sum(sim_by_cat_old.^gamma);
end

Pr_resp_newlow = NaN([9,3]);
for ipat = 1:9
    sim_by_cat_newlow = coord2sim(pat_train,pat_test_newlow(:,ipat),cat_train,c);
    Pr_resp_newlow(ipat,:) = (sim_by_cat_newlow.^gamma)/sum(sim_by_cat_newlow.^gamma);
end

Pr_resp_newmed = NaN([18,3]);
for ipat = 1:18
    sim_by_cat_newmed = coord2sim(pat_train,pat_test_newmed(:,ipat),cat_train,c);
    Pr_resp_newmed(ipat,:) = (sim_by_cat_newmed.^gamma)/sum(sim_by_cat_newmed.^gamma);
end

Pr_resp_newhigh = NaN([27,3]);
for ipat = 1:27
    sim_by_cat_newhigh = coord2sim(pat_train,pat_test_newhigh(:,ipat),cat_train,c);
    Pr_resp_newhigh(ipat,:) = (sim_by_cat_newhigh.^gamma)/sum(sim_by_cat_newhigh.^gamma);
end

Pr_resp_newhigh_special = NaN([3,3]);
for ipat = 1:3
    sim_by_cat_newhigh_special = coord2sim(pat_train,pat_test_newhigh_special(:,ipat),cat_train,c);
    Pr_resp_newhigh_special(ipat,:) = (sim_by_cat_newhigh_special.^gamma)/sum(sim_by_cat_newhigh_special.^gamma);
end


Pr_resp_pat = struct;
Pr_resp_pat.old = Pr_resp_old;
Pr_resp_pat.proto = Pr_resp_proto;
Pr_resp_pat.newlow = Pr_resp_newlow;
Pr_resp_pat.newmed = Pr_resp_newmed;
Pr_resp_pat.newhigh = Pr_resp_newhigh;
Pr_resp_pat.newhigh_special = Pr_resp_newhigh_special;

Pr_corr_pat = [];
Pr_corr_pat.old = [Pr_resp_old(1:9,1);Pr_resp_old(10:18,2);Pr_resp_old(19:27,3)];
Pr_corr_pat.proto = [Pr_resp_proto(1,1);Pr_resp_proto(2,2);Pr_resp_proto(3,3)];
Pr_corr_pat.newlow = [Pr_resp_newlow(1:3,1);Pr_resp_newlow(4:6,2);Pr_resp_newlow(7:9,3)];
Pr_corr_pat.newmed = [Pr_resp_newmed(1:6,1);Pr_resp_newmed(7:12,2);Pr_resp_newmed(13:18,3)];
Pr_corr_pat.newhigh = [Pr_resp_newhigh(1:9,1);Pr_resp_newhigh(10:18,2);Pr_resp_newhigh(19:27,3)];
Pr_corr_pat.newhigh_special = [Pr_resp_newhigh_special(1,1);Pr_resp_newhigh_special(2,2);Pr_resp_newhigh_special(3,3)];

Pr_corr = [mean(Pr_corr_pat.old),mean(Pr_corr_pat.proto),mean(Pr_corr_pat.newlow),mean(Pr_corr_pat.newmed),mean(Pr_corr_pat.newhigh),mean(Pr_corr_pat.newhigh_special)];
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
    



