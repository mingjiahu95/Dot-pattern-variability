T = readtable("pattern_info.csv");
p1 = unique(T{T.itemtype == 2 & T.category == 1,8:25},'rows');%dot1x:dot9y
p2 = unique(T{T.itemtype == 2 & T.category == 2,8:25},'rows');%dot1x:dot9y
p3 = unique(T{T.itemtype == 2 & T.category == 3,8:25},'rows');%dot1x:dot9y
p1 = reshape(p1,[2,9])';
p2 = reshape(p2,[2,9])';
p3 = reshape(p3,[2,9])';



for idot = 1:9
    dist_dot(idot) = sqrt(sum((p1(idot,:)- p2(idot,:)).^2));
end
dist_pat = sum(dist_dot);


all_perm = perms(1:9);
for iperm = 1:size(all_perm,1)
    p2_permuted = p2(all_perm(iperm,:),:);
    for idot = 1:9
    dist_dot(idot) = sqrt(sum((p1(idot,:)- p2_permuted(idot,:)).^2));
    end
    dist_perm_p2(iperm) = sum(dist_dot);
end
[M,I] = min(dist_perm_p2);
cat2_index = all_perm(I,:);
p2_aligned = p2(cat2_index,:);

dist_perm_p3 = NaN(size(all_perm,1),3);
for iperm = 1:size(all_perm,1)
    p3_permuted = p3(all_perm(iperm,:),:);
    for idot = 1:9
    dist_dotvp1(idot) = sqrt(sum((p1(idot,:)- p3_permuted(idot,:)).^2));
    dist_dotvp2(idot) = sqrt(sum((p2_aligned(idot,:)- p3_permuted(idot,:)).^2));
    end
    dist_perm_p3(iperm,:) = [sum(dist_dotvp1),sum(dist_dotvp2),sum(dist_dotvp1)+sum(dist_dotvp2)];
end
[M,I] = min(dist_perm_p3);
[~,II] = min(dist_perm_p3(I,3));
cat3_index = all_perm(I(II),:);
p3_aligned = p3(cat3_index,:);






