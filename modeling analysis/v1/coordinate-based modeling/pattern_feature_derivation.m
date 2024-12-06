clear
clc
load coord_info.mat
icond = 4;%mix distortion
pat_coord_info = cat(3,coord_test_old(:,:,:,icond),coord_proto,coord_test_newlow(:,:,:,icond),coord_test_newmed(:,:,:,icond),...
                       coord_test_newhigh(:,:,:,icond),coord_test_newhigh_hard);
pat_coord_info = permute(pat_coord_info,[2 1 3]);
clearvars -except pat_coord_info


pat_feature_store = zeros(3,87);
for ipat = 1:size(pat_coord_info,3)
    dots_xy = pat_coord_info(:,:,ipat)';
    dots_x = dots_xy(:,1);
    dots_y = dots_xy(:,2);
    %feature 1: width/height
    pat_feature_store(1,ipat) = range(dots_x)/range(dots_y);
    %feature 2: horizontal splitness
    midpoint = (max(dots_x) + min(dots_x))/2;
    dots_left = dots_x(dots_x <= midpoint);
    dots_right = dots_x(dots_x > midpoint);
    dist_within = mean(pdist(dots_left))+ mean(pdist(dots_right));
    dist_between = mean(pdist2(dots_left,dots_right),'all');
    pat_feature_store(2,ipat) = dist_between/dist_within;
%         for idiv = 1:8
%             dots_left = mink(dots_x,idiv);
%             dots_right = maxk(dots_x,9-idiv);%ndots = 9
%             if numel(dots_left) == 1
%                 dist_within = mean(pdist(dots_right));
%             elseif numel(dots_right) == 1
%                 dist_within = mean(pdist(dots_left));
%             else
%                 dist_within = mean(pdist(dots_left)) + mean(pdist(dots_right));
%             end
%             dist_between = mean(pdist2(dots_left,dots_right),'all');
%             dot_splitness(idiv) = dist_between/dist_within;
%         end
%         pat_feature_store(2,ipat) = max(dot_splitness);
    
    % feature 3: dual centrality
    centroid = mean(dots_xy,1);
    dists_to_centroid = pdist2(centroid,dots_xy);
    total_dist = mean(dists_to_centroid);
    central_dots_dist = mean(mink(dists_to_centroid,2));
    pat_feature_store(3,ipat) = total_dist/central_dots_dist;
%     for idot = 1:9
%         dists_to_other_points = maxk(pdist2(dots_xy(idot,:),dots_xy),9-2);%exlcude self-match and the other central point
%         dot_dists(idot) = mean(dists_to_other_points);
%     end
%     central_dots_dist = mean(mink(dot_dists,2));
%     pat_feature_store(3,ipat) = central_dots_dist/mean(dot_dists);
end

feature_test_old = pat_feature_store(:,1:27);
feature_proto = pat_feature_store(:,28:30);
feature_test_newlow = pat_feature_store(:,31:39);
feature_test_newmed = pat_feature_store(:,40:57);
feature_test_newhigh = pat_feature_store(:,58:84);
feature_newhigh_special = pat_feature_store(:,58:87);

save pat_feature_mix.mat  pat_feature_store feature_*
