clear
clc

load pat_feature.mat
%rescale features to be between 0 and 1
pat_feature = bsxfun(@rdivide, pat_feature_store - min(pat_feature_store,[],2), range(pat_feature_store,2));
feature_test_old = pat_feature(:,1:27);
feature_proto = pat_feature(:,28:30);
feature_test_newlow = pat_feature(:,31:39);
feature_test_newmed = pat_feature(:,40:57);
feature_test_newhigh = pat_feature(:,58:84);
feature_test_newhigh_sepcial = pat_feature(:,85:87);

%full distribution
item_type = repelem(['m','k','r','b','c','g'],[27,3,9,18,27,3]);
text_size = repelem([3,4,3,2,1,1],[27,3,9,18,27,3]);
old_pat_idx = [compose('A%d',1:9),compose('B%d',1:9),compose('C%d',1:9)];%repelem({'A','B','C'},[9,9,9]);
proto_pat_idx = {'A1','B1','C1'};%{'A','B','C'}
newlow_pat_idx = [compose('A%d',1:3),compose('B%d',1:3),compose('C%d',1:3)];%repelem({'A','B','C'},[3,3,3]);
newmed_pat_idx = [compose('A%d',1:6),compose('B%d',1:6),compose('C%d',1:6)];%repelem({'A','B','C'},[6,6,6]);
newhigh_pat_idx = [compose('A%d',1:9),compose('B%d',1:9),compose('C%d',1:9)];%repelem({'A','B','C'},[9,9,9]);
special_pat_idx = {'A1','B1','C1'};%{'A','B','C'};
pat_idx = [old_pat_idx,proto_pat_idx,newlow_pat_idx,newmed_pat_idx,newhigh_pat_idx,special_pat_idx];
%dim 1 vs. dim 2
f = figure('Name','dim1 vs. dim2');
for ipat = 1:87
    scatter(pat_feature(1,ipat),pat_feature(2,ipat),'w.');
    text(pat_feature(1,ipat),pat_feature(2,ipat),pat_idx{ipat},'Color',item_type(ipat),'FontSize',text_size(ipat)+6);
    hold on
end
xticks(0:.1:1);
grid on
axis equal
hold off
%dim 2 vs. dim 3
f = figure('Name','dim2 vs. dim3');
for ipat = 1:87
    scatter(pat_feature(2,ipat),pat_feature(3,ipat),'w.');
    text(pat_feature(2,ipat),pat_feature(3,ipat),pat_idx{ipat},'Color',item_type(ipat),'FontSize',text_size(ipat)+6);
    hold on
end
xticks(0:.1:1);
grid on
axis equal
hold off



% % plot patterns from each category
% D = cat(3,[feature_mds_test_newhigh(6,:);feature_mds_test_newlow(2,:);feature_mds_test_newmed(2,:);feature_mds_test_newmed(3,:);feature_mds_test_newmed(5,:);feature_mds_test_old(1,:);feature_mds_test_old(5,:);feature_mds_proto(1,:)],...
%     [feature_mds_test_newhigh(13,:);feature_mds_test_newhigh(16,:);feature_mds_test_newhigh(17,:);feature_mds_test_newlow(6,:);feature_mds_test_newmed(10,:);feature_mds_test_old(12,:);feature_mds_test_old(17,:);feature_mds_proto(2,:)],...
%     [feature_mds_test_newhigh(25,:);feature_mds_test_newhigh(26,:);feature_mds_test_newmed(13,:);feature_mds_test_newmed(14,:);feature_mds_test_newmed(18,:);feature_mds_test_old(19,:);feature_mds_test_old(21,:);feature_mds_proto(3,:)]);
% image_location = [pwd '\image_plot\'];
% files_cat1 = dir([image_location 'cat1\image*.jpg']);
% files_cat2 = dir([image_location 'cat2\image*.jpg']);
% files_cat3 = dir([image_location 'cat3\image*.jpg']);
% 
% numpat_cat = length(files_cat1);
% for ipat = 1:numpat_cat
%     names_cat1{ipat} = [files_cat1(ipat).folder '\' files_cat1(ipat).name];
%     names_cat2{ipat} = [files_cat2(ipat).folder '\' files_cat2(ipat).name];
%     names_cat3{ipat} = [files_cat3(ipat).folder '\' files_cat3(ipat).name];
% end
% names = [names_cat1;names_cat2;names_cat3]';
% 
% 
% for icat = 1:3
%     f = figure(icat);
%     hold on
%     for ipat = 1:size(names,1)
%         dimScaleX = dimScale;
%         dimScaleY = dimScale;
%         [A, ~] = imread(names{ipat,icat});
%         A = flipud(A);
%         img = padarray(A,[border,border],0);
%         img(:,:,icat) = padarray(A(:,:,1),[border,border],255);
%         img = imresize(img, scale_cat(icat));
%         [imgheight,imgwidth] = size(img,[1 2]);
%         
%         x_orig(ipat) = D(ipat,1,icat);
%         y_orig(ipat) = D(ipat,2,icat);
%         x_center(ipat) = dimScaleX*x_orig(ipat);
%         y_center(ipat) = dimScaleY*y_orig(ipat);
%         x_corner = x_center(ipat) - imgwidth/2;
%         y_corner = y_center(ipat) - imgheight/2;
%         image('XData', x_corner, 'YData', y_corner,'CData',img,'AlphaData',.7);
%         %clear img
%     end
%     if icat == 1
%         x_range =  0:8;
%         y_range = -4:1;
%     elseif icat == 2
%         x_range = -4:4;
%         y_range =  1:9;
%     elseif icat == 3
%         x_range =  -4:2;
%         y_range =  -6:0;
%     end
%     xticks(dimScale * x_range);
%     yticks(dimScale * y_range);
%     xticklabels(x_range);
%     yticklabels(y_range);
%     axis equal
%     hold off
% end

% display settings
scale_cat = [1,1,1];
dimScale = 2500;
border = 10;
scale_display = 0:.1:1;

% plot patterns across categories
% fig 1: dim 1 vs. dim 2
D = [feature_test_newhigh(:,13),feature_test_newhigh(:,15),feature_test_newhigh(:,20),feature_test_newhigh(:,6),...
     feature_test_newmed(:,1),feature_test_newmed(:,10),feature_test_newmed(:,14),feature_test_newmed(:,3),...
     feature_test_newmed(:,6),feature_test_newmed(:,9),feature_test_old(:,1),feature_test_old(:,3),...
     feature_test_old(:,4),feature_test_old(:,5),feature_proto(:,1),feature_proto(:,2),feature_proto(:,3)];
image_location = [pwd '\image_plot_3cat\'];
files = dir([image_location 'dim1 vs. dim2\image*.jpg']);
numpat = size(D,2);
for ipat = 1:numpat
    names{ipat} = [files(ipat).folder '\' files(ipat).name];
end
cat_index = [1,2,2,3,1,1,1,2,2,3,1,1,1,1,1,2,3];
figure('Name','dim 1 vs. dim 2');
hold on
for ipat = 1:length(names)
    icat = cat_index(ipat);
    dimScaleX = dimScale;
    dimScaleY = dimScale;
    [A, ~] = imread(names{ipat});
    A = flipud(A);
    img = padarray(A,[border,border],0);
    if contains(names{ipat},"proto")
        img(:,:,icat) = padarray(A(:,:,1),[border,border],150);
    else
        img(:,:,icat) = padarray(A(:,:,1),[border,border],255);
    end
    img = imresize(img, scale_cat(icat));
    [imgheight,imgwidth] = size(img,[1 2]);
    
    x_orig(ipat) = D(1,ipat);
    y_orig(ipat) = D(2,ipat);
    x_center(ipat) = dimScaleX*x_orig(ipat);
    y_center(ipat) = dimScaleY*y_orig(ipat);
    x_corner = x_center(ipat) - imgwidth/2;
    y_corner = y_center(ipat) - imgheight/2;
    image('XData', x_corner, 'YData', y_corner,'CData',img,'AlphaData',.7);
    clear img
end
scale_display = 0:.1:1;
xticks(dimScale*scale_display);
yticks(dimScale*scale_display);
xticklabels(scale_display);
yticklabels(scale_display);
xlabel('width-to-height ratio');
ylabel('horizontal splitness');
axis equal
hold off


% fig 2: dim 2 vs. dim 3
dimScale = 2800;
D = [feature_test_newhigh(:,19),feature_test_newlow(:,5),feature_test_newlow(:,7),feature_test_newmed(:,11),...
     feature_test_newmed(:,14),feature_test_newmed(:,8),feature_test_old(:,17),feature_test_old(:,18),...
     feature_test_old(:,2),feature_test_old(:,6),feature_test_old(:,7),feature_test_old(:,8),...
     feature_proto(:,1),feature_proto(:,2),feature_proto(:,3)];
image_location = [pwd '\image_plot_3cat\'];
files = dir([image_location 'dim2 vs. dim3\image*.jpg']);
numpat = size(D,2);
names = cell(1,numpat);
for ipat = 1:numpat
    names{ipat} = [files(ipat).folder '\' files(ipat).name];
end
cat_index = [3,2,2,3,2,3,1,1,1,1,2,2,1,2,3];
figure('Name','dim 2 vs. dim 3');
hold on
for ipat = 1:length(names)
    icat = cat_index(ipat);
    dimScaleX = dimScale;
    dimScaleY = dimScale;
    [A, ~] = imread(names{ipat});
    A = flipud(A);
    img = padarray(A,[border,border],0);
    if contains(names{ipat},"proto")
        img(:,:,icat) = padarray(A(:,:,1),[border,border],150);
    else
        img(:,:,icat) = padarray(A(:,:,1),[border,border],255);
    end
    img = imresize(img, scale_cat(icat));
    [imgheight,imgwidth] = size(img,[1 2]);
    
    x_orig(ipat) = D(2,ipat);
    y_orig(ipat) = D(3,ipat);
    x_center(ipat) = dimScaleX*x_orig(ipat);
    y_center(ipat) = dimScaleY*y_orig(ipat);
    x_corner = x_center(ipat) - imgwidth/2;
    y_corner = y_center(ipat) - imgheight/2;
    image('XData', x_corner, 'YData', y_corner,'CData',img,'AlphaData',.7);
    clear img
end
scale_display = 0:.1:1;
xticks(dimScale*scale_display);
yticks(dimScale*scale_display);
xticklabels(scale_display);
yticklabels(scale_display);
xlabel('horizontal splitness');
ylabel('dual centrality');
axis equal
hold off


