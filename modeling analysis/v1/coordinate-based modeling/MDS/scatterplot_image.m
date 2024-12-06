clear
clc
%load coord_MDS.mat
load act18_MDS.mat
scale_cat = [1.1,1.3,1];%.4
dimScale = 300;%60
border = 10;

% plot patterns from each category
D = cat(3,[feature_mds_test_newhigh(6,:);feature_mds_test_newlow(2,:);feature_mds_test_newmed(2,:);feature_mds_test_newmed(3,:);feature_mds_test_newmed(5,:);feature_mds_test_old(1,:);feature_mds_test_old(5,:);feature_mds_proto(1,:)],...
    [feature_mds_test_newhigh(13,:);feature_mds_test_newhigh(16,:);feature_mds_test_newhigh(17,:);feature_mds_test_newlow(6,:);feature_mds_test_newmed(10,:);feature_mds_test_old(12,:);feature_mds_test_old(17,:);feature_mds_proto(2,:)],...
    [feature_mds_test_newhigh(25,:);feature_mds_test_newhigh(26,:);feature_mds_test_newmed(13,:);feature_mds_test_newmed(14,:);feature_mds_test_newmed(18,:);feature_mds_test_old(19,:);feature_mds_test_old(21,:);feature_mds_proto(3,:)]);
image_location = [pwd '\image_plot\'];
files_cat1 = dir([image_location 'cat1\image*.jpg']);
files_cat2 = dir([image_location 'cat2\image*.jpg']);
files_cat3 = dir([image_location 'cat3\image*.jpg']);

numpat_cat = length(files_cat1);
for ipat = 1:numpat_cat
    names_cat1{ipat} = [files_cat1(ipat).folder '\' files_cat1(ipat).name];
    names_cat2{ipat} = [files_cat2(ipat).folder '\' files_cat2(ipat).name];
    names_cat3{ipat} = [files_cat3(ipat).folder '\' files_cat3(ipat).name];
end
names = [names_cat1;names_cat2;names_cat3]';


for icat = 1:3
    f = figure(icat);
    hold on
    for ipat = 1:size(names,1)
        dimScaleX = dimScale;
        dimScaleY = dimScale;
        [A, ~] = imread(names{ipat,icat});
        A = flipud(A);
        img = padarray(A,[border,border],0);
        img(:,:,icat) = padarray(A(:,:,1),[border,border],255);
        img = imresize(img, scale_cat(icat));
        [imgheight,imgwidth] = size(img,[1 2]);
        
        x_orig(ipat) = D(ipat,1,icat);
        y_orig(ipat) = D(ipat,2,icat);
        x_center(ipat) = dimScaleX*x_orig(ipat);
        y_center(ipat) = dimScaleY*y_orig(ipat);
        x_corner = x_center(ipat) - imgwidth/2;
        y_corner = y_center(ipat) - imgheight/2;
        image('XData', x_corner, 'YData', y_corner,'CData',img,'AlphaData',.7);
        %clear img
    end
    if icat == 1
        x_range =  0:8;
        y_range = -4:1;
    elseif icat == 2
        x_range = -4:4;
        y_range =  1:9;
    elseif icat == 3
        x_range =  -4:2;
        y_range =  -6:0;
    end
    xticks(dimScale * x_range);
    yticks(dimScale * y_range);
    xticklabels(x_range);
    yticklabels(y_range);
    axis equal
    hold off
end

% plot patterns across categories
D = [feature_mds_test_newhigh(6,:);feature_mds_test_newmed(3,:);feature_mds_test_old(1,:);feature_mds_proto(1,:);...
     feature_mds_test_newhigh(16,:);feature_mds_test_newlow(6,:);feature_mds_test_old(15,:);feature_mds_proto(2,:);...
     feature_mds_test_newmed(14,:);feature_mds_test_newmed(18,:);feature_mds_test_old(21,:);feature_mds_proto(3,:)];
image_location = [pwd '\image_plot_3cat\'];
files_cat1 = dir([image_location 'cat1\image*.jpg']);
files_cat2 = dir([image_location 'cat2\image*.jpg']);
files_cat3 = dir([image_location 'cat3\image*.jpg']);
numpat_cat = 4;% per category
for ipat = 1:numpat_cat
    names_cat1{ipat} = [files_cat1(ipat).folder '\' files_cat1(ipat).name];
    names_cat2{ipat} = [files_cat2(ipat).folder '\' files_cat2(ipat).name];
    names_cat3{ipat} = [files_cat3(ipat).folder '\' files_cat3(ipat).name];
end
names = [names_cat1,names_cat2,names_cat3];

cat_index = repelem([1,2,3],numpat_cat);
f = figure;
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
    
    x_orig(ipat) = D(ipat,1);
    y_orig(ipat) = D(ipat,2);
    x_center(ipat) = dimScaleX*x_orig(ipat);
    y_center(ipat) = dimScaleY*y_orig(ipat);
    x_corner = x_center(ipat) - imgwidth/2;
    y_corner = y_center(ipat) - imgheight/2;
    image('XData', x_corner, 'YData', y_corner,'CData',img,'AlphaData',.7);
    clear img
end
xticks(dimScale*(-8:2:10));
yticks(dimScale*(-8:2:10));
xticklabels(-8:2:10);
yticklabels(-8:2:10);
axis equal
hold off


