clear
clc
load pat_feature.mat%act18_MDS.mat
scale_cat = [.3,.3,.3];%controls the image size for patterns from each category 3
dimScale = 300;
border = 10;

% plot patterns across category
D12 = [mds_test_newhigh(8,:);mds_test_newhigh(16,:);mds_test_newhigh(17,:);mds_test_newhigh(19,:);...
       mds_test_newhigh(21,:);mds_test_newmed(2,:);mds_test_newmed(17,:);mds_test_old(15,:);...
       mds_test_old(21,:);mds_test_old(25,:);mds_test_old(27,:);mds_proto(1,:);...
       mds_proto(2,:);mds_proto(3,:)];
% D23 = [mds_test_newhigh(5,:);mds_test_newhigh(8,:);mds_test_newhigh(19,:);mds_test_newhigh(24,:);...
%        mds_test_newmed(16,:);mds_test_newmed(18,:);mds_test_old(24,:);mds_test_old(25,:);...
%        mds_proto(1,:);mds_proto(2,:);mds_proto(3,:)];
D = D12;
image_location = [pwd '\image_plot\'];
files = dir([image_location 'dim1 vs. dim2\image*.jpg']);%change dim labels
numpat = size(D,1);
for ipat = 1:numpat
    names{ipat} = [files(ipat).folder '\' files(ipat).name];
end
cat_index = [1,2,2,3,3,1,3,2,3,3,3,1,2,3];
% cat_index = [1,1,3,3,3,3,3,3,1,2,3];
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
    
    x_orig(ipat) = D(ipat,1);%change dim coordinates
    y_orig(ipat) = D(ipat,2);
    x_center(ipat) = dimScaleX*x_orig(ipat);
    y_center(ipat) = dimScaleY*y_orig(ipat);
    x_corner = x_center(ipat) - imgwidth/2;
    y_corner = y_center(ipat) - imgheight/2;
    image('XData', x_corner, 'YData', y_corner,'CData',img,'AlphaData',.7);
    clear img
end
scale_display = -8:2:10;%change dim axes
xticks(dimScale*scale_display);
yticks(dimScale*scale_display);
xticklabels(scale_display);
yticklabels(scale_display);
xlabel('dim 1');%change dim labels
ylabel('dim 2');
axis equal
hold off


% % plot patterns across categories
% D = [feature_mds_test_newhigh(6,:);feature_mds_test_newmed(3,:);feature_mds_test_old(1,:);feature_mds_proto(1,:);...
%      feature_mds_test_newhigh(16,:);feature_mds_test_newlow(6,:);feature_mds_test_old(15,:);feature_mds_proto(2,:);...
%      feature_mds_test_newmed(14,:);feature_mds_test_newmed(18,:);feature_mds_test_old(21,:);feature_mds_proto(3,:)];
% image_location = [pwd '\image_plot_3cat\'];
% files_cat1 = dir([image_location 'cat1\image*.jpg']);
% files_cat2 = dir([image_location 'cat2\image*.jpg']);
% files_cat3 = dir([image_location 'cat3\image*.jpg']);
% numpat_cat = 4;% per category
% for ipat = 1:numpat_cat
%     names_cat1{ipat} = [files_cat1(ipat).folder '\' files_cat1(ipat).name];
%     names_cat2{ipat} = [files_cat2(ipat).folder '\' files_cat2(ipat).name];
%     names_cat3{ipat} = [files_cat3(ipat).folder '\' files_cat3(ipat).name];
% end
% names = [names_cat1,names_cat2,names_cat3];
% 
% cat_index = repelem([1,2,3],numpat_cat);
% f = figure;
% hold on
% for ipat = 1:length(names)
%     icat = cat_index(ipat);
%     dimScaleX = dimScale;
%     dimScaleY = dimScale;
%     [A, ~] = imread(names{ipat});
%     A = flipud(A);
%     img = padarray(A,[border,border],0);
%     if contains(names{ipat},"proto")
%         img(:,:,icat) = padarray(A(:,:,1),[border,border],150);
%     else
%         img(:,:,icat) = padarray(A(:,:,1),[border,border],255);
%     end
%     img = imresize(img, scale_cat(icat));
%     [imgheight,imgwidth] = size(img,[1 2]);
%     
%     x_orig(ipat) = D(ipat,1);
%     y_orig(ipat) = D(ipat,2);
%     x_center(ipat) = dimScaleX*x_orig(ipat);
%     y_center(ipat) = dimScaleY*y_orig(ipat);
%     x_corner = x_center(ipat) - imgwidth/2;
%     y_corner = y_center(ipat) - imgheight/2;
%     image('XData', x_corner, 'YData', y_corner,'CData',img,'AlphaData',.7);
%     clear img
% end
% scale_display = -8:2:10;
% xticks(dimScale*scale_display);
% yticks(dimScale*scale_display);
% xticklabels(scale_display);
% yticklabels(scale_display);
% axis equal
% hold off


