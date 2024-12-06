clear;
clc;
T = readtable('pattern_coords.csv');

for isubj = unique(T.ID)'
    subj_data = T(T.ID == isubj,2:end);
    p1_tbl = subj_data(subj_data.itemtype == 2 & subj_data.category == 1,6:end);
    p2_tbl = subj_data(subj_data.itemtype == 2 & subj_data.category == 2,6:end);
    p3_tbl = subj_data(subj_data.itemtype == 2 & subj_data.category == 3,6:end);
    p1 = reshape(table2array(p1_tbl),2,9)';
    p2 = reshape(table2array(p2_tbl),2,9)';
    p3 = reshape(table2array(p3_tbl),2,9)';
    for idot = 1:9
        dist_dot(idot) = sqrt(sum((p1(idot,:)- p2(idot,:)).^2));
    end
    dist_pat = sum(dist_dot);
    subj_data_cat1 = subj_data(subj_data.category == 1,:);
    
    
    all_perm = perms(1:9);
    for iperm = 1:size(all_perm,1)
        p2_permuted = p2(all_perm(iperm,:),:);
        parfor idot = 1:9
            dist_dot(idot) = sqrt(sum((p1(idot,:)- p2_permuted(idot,:)).^2));
        end
        dist_perm_p2(iperm) = sum(dist_dot);
    end
    [~,I] = min(dist_perm_p2);
    cat2_index = all_perm(I,:);
    tbl_index = reshape([2*cat2_index-1; 2*cat2_index], 1, []);
    subj_data_cat2 = subj_data(subj_data.category == 2,[1:5,5+tbl_index]);
    p2_aligned = p2(cat2_index,:);
    
    dist_perm_p3 = NaN(size(all_perm,1),3);
    for iperm = 1:size(all_perm,1)
        p3_permuted = p3(all_perm(iperm,:),:);
        parfor idot = 1:9
            dist_dotvp1(idot) = sqrt(sum((p1(idot,:)- p3_permuted(idot,:)).^2));
            dist_dotvp2(idot) = sqrt(sum((p2_aligned(idot,:)- p3_permuted(idot,:)).^2));
        end
        dist_perm_p3(iperm,:) = [sum(dist_dotvp1),sum(dist_dotvp2),sum(dist_dotvp1)+sum(dist_dotvp2)];
    end
    [~,I] = min(dist_perm_p3);
    cat3_index = all_perm(I(3),:);
    tbl_index = reshape([2*cat3_index-1; 2*cat3_index], 1, []);
    subj_data_cat3 = subj_data(subj_data.category == 3,[1:5,5+tbl_index]);
    subj_data_store{isubj} = [subj_data_cat1;subj_data_cat2;subj_data_cat3];
    fprintf('subj %d processed\n',isubj)
end

vertcat(subj_data_store{:});
%store variable

