clear;
clc;
cond = 4;%mixed distortion
load act18_info.mat


%MDS on feature18
act_18 = [feature18_test_old(:,:,cond)';feature18_proto(:,:,cond)';...
          feature18_test_newlow(:,:,cond)';feature18_test_newmed(:,:,cond)';...
          feature18_test_newhigh(:,:,cond)'; feature18_test_newhigh_special(:,:,cond)'];

Dist = pdist(act_18);
opts = statset('MaxIter',1000);
for p = 1:10
    [Y,S,D] = mdscale(Dist,p,'Criterion','metricstress','Options',opts);
    stress_act18(p) = S;
    if p == 3
        MDScoord = Y;
        Disparities = D;       
    end
end

% %shepard plot
% dissimilarities = Dist;
% distances = pdist(MDScoord);
% [dum,ord] = sortrows([Disparities(:) dissimilarities(:)]);
% plot(dissimilarities,distances,'bx', ...
%      dissimilarities(ord),Disparities(ord),'r.-')
% xlabel('Dissimilarities')
% ylabel('Distances/Disparities')
% legend({'Distances' 'Disparities'},...
%        'Location','NorthWest');
   
%plot act18_MDS
act18_mds = double(MDScoord);
%load act18_MDS
item_type = repelem(['m','k','r','b','c','g'],[27,3,9,18,27,3]);
pt_size = repelem([3,6,3,2,1,1],[27,3,9,18,27,3]);
old_pat_idx = 1:27;%compose('A%d',1:9),compose('B%d',1:9),compose('C%d',1:9);
proto_pat_idx = 1:3;%{'A1','B1','C1'}
newlow_pat_idx = 1:9;%[compose('A%d',1:3),compose('B%d',1:3),compose('C%d',1:3)];
newmed_pat_idx = 1:18;%[compose('A%d',1:6),compose('B%d',1:6),compose('C%d',1:6)];
newhigh_pat_idx = 1:27;%[compose('A%d',1:9),compose('B%d',1:9),compose('C%d',1:9)];
special_pat_idx = 1:3;%{'A1','B1','C1'};
pat_idx = [old_pat_idx,proto_pat_idx,newlow_pat_idx,newmed_pat_idx,newhigh_pat_idx,special_pat_idx];
%dim 1 vs. dim 2
figure('Name','dim 1 vs. dim 2');
for i = 1:87
    scatter(mds_store(i,1),mds_store(i,2),'w.');
    text(mds_store(i,1),mds_store(i,2),num2str(pat_idx(i)),'Color',item_type(i),'FontSize',pt_size(i)+6);
    hold on
end
axis square
hold off
%dim 2 vs. dim 3
figure('Name','dim 2 vs. dim 3');
for i = 1:87
    scatter(mds_store(i,2),mds_store(i,3),'w.');
    text(mds_store(i,2),mds_store(i,3),num2str(pat_idx(i)),'Color',item_type(i),'FontSize',pt_size(i)+6);
    hold on
end
axis square
hold off
grid on
axis equal
xlim([-8 14]);
ylim([-8 10]);
hold off

%save MDS(18) solutions to a mat file
mds_test_old(:,:,1) = act18_mds(1:27,:);
mds_proto(:,:,1) = act18_mds(28:30,:);
mds_test_newlow(:,:,1) = act18_mds(31:39,:);
mds_test_newmed(:,:,1) = act18_mds(40:57,:);
mds_test_newhigh(:,:,1) = act18_mds(58:84,:);
mds_newhigh_special(:,:,1) = act18_mds(85:87,:);
mds_store = act18_mds;
save('act18_MDS_mix.mat','mds_*')

% draw stress plot
x = 1:10;
plot(x,stress_act18(x),'-xk');
title('Stress Plot')
ylabel('Metric Stress');
xlabel('Dimensionality');

