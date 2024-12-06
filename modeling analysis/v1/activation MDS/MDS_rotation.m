clear
clc
load act18_MDS_mix
load pat_feature_mix

raw_mds = mds_store;
norm_mds = pat_feature_store';


fileID = fopen('data.txt','w');
fprintf(fileID,'%6.4f %6.4f %6.4f %6.4f\n',[repmat(1,[87,1]),norm_mds]');
fprintf(fileID,'%6.4f %6.4f %6.4f\n',raw_mds');
fclose(fileID);

%run Rob's rotat program here

%read the rotat output into a matrix
%save MDS(18) solutions to a mat file
mds_store = readmatrix('rotated_MDS123_without_scaling.txt')';
mds_test_old = mds_store(:,1:27);
mds_proto = mds_store(:,28:30);
mds_test_newlow = mds_store(:,31:39);
mds_test_newmed = mds_store(:,40:57);
mds_test_newhigh = mds_store(:,58:84);
mds_newhigh_special = mds_store(:,85:87);
save('rotated_MDS_mix.mat','mds_*');



% [~,mds_rotated,transform] = procrustes(norm_mds,raw_mds);
% transform.c
% transform.T
% transform.b

% %check rotation results
% X = norm_mds;
% Y = raw_mds;
% Z = mds_rotated;
% plot3(X(:,1),X(:,2),X(:,3),'rx',Y(:,1),Y(:,2),Y(:,3),'b.',Z(:,1),Z(:,2),Z(:,3),'bx');
% SSE = sum((Z - X).^2,'all')
% corr_dim1 = corr2(X(1,:),Z(1,:))
% corr_dim2 = corr2(X(2,:),Z(2,:))
% corr_dim3 = corr2(X(3,:),Z(3,:))