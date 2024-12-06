%read in data
load pat_feature
load act18_MDS_med
orig_mds = mds_store';
load rotated_MDS_med
rotated_mds = mds_store;
clearvars -except pat_feature_store orig_mds rotated_mds

%plot overlaid scatterplots
%dim 1 vs. dim 2
figure('Name','dim 1 vs. dim 2');
hold on
plot(pat_feature_store(1,:),pat_feature_store(2,:),'xb');
plot(orig_mds(1,:),orig_mds(2,:),'.r');
plot(rotated_mds(1,:),rotated_mds(2,:),'xr');
xlabel('dim 1');
ylabel('dim 2');
xlim([-6 10]);
ylim([-6 10]);
hold off

%dim 2 vs. dim 3
figure('Name','dim 2 vs. dim 3');
hold on
plot(pat_feature_store(2,:),pat_feature_store(3,:),'xb');
plot(orig_mds(2,:),orig_mds(3,:),'.r');
plot(rotated_mds(2,:),rotated_mds(3,:),'xr');
xlabel('dim 2');
ylabel('dim 3');
xlim([-6 10]);
ylim([-6 10]);
hold off

% %plot individual dimensions: rotated MDS vs. normative
% %dim 1
% [norm_val,order_idx] = sort(pat_feature_store(1,:));
% mds_val = rotated_mds(1,order_idx);
% figure('Name','dim 1');
% x_val = 1:length(order_idx);
% plot(x_val,norm_val,'-ob',x_val,mds_val,'-or','MarkerSize',3);
% xticks(x_val);
% xticklabels(order_idx);
% xtickangle(-45)
% xlabel('pattern index');
% ax = gca;
% ax.FontSize = 6;
% ax.XGrid = 'on';
% 
% %dim 2
% [norm_val,order_idx] = sort(pat_feature_store(2,:));
% mds_val = rotated_mds(2,order_idx);
% figure('Name','dim 2');
% x_val = 1:length(order_idx);
% plot(x_val,norm_val,'-ob',x_val,mds_val,'-or','MarkerSize',3);
% xticks(x_val);
% xticklabels(order_idx);
% xtickangle(-45)
% xlabel('pattern index');
% ax = gca;
% ax.FontSize = 6;
% ax.XGrid = 'on';
% 
% 
% %dim 3
% [norm_val,order_idx] = sort(pat_feature_store(3,:));
% mds_val = rotated_mds(3,order_idx);
% figure('Name','dim 3');
% x_val = 1:length(order_idx);
% plot(x_val,norm_val,'-ob',x_val,mds_val,'-or','MarkerSize',3);
% xticks(x_val);
% xticklabels(order_idx);
% xtickangle(-45)
% xlabel('pattern index');
% ax = gca;
% ax.FontSize = 6;
% ax.XGrid = 'on';
% 
% 
% %read in data
% fileID = fopen('rotated_MDS_dim23_without_scaling.txt','r');
% rotated_mds = fscanf(fileID,'%f %f %f\n');
% rotated_mds = reshape(rotated_mds,[3,87]);
% fclose(fileID);
% 
% mds_test_old = rotated_mds(:,1:27);
% mds_proto = rotated_mds(:,28:30);
% mds_test_newlow = rotated_mds(:,31:39);
% mds_test_newmed = rotated_mds(:,40:57);
% mds_test_newhigh = rotated_mds(:,58:84);
% mds_newhigh_special = rotated_mds(:,58:87);
% mds_store = rotated_mds;


