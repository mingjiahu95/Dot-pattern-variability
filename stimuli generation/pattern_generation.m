clear all
clc

% num = 300;%300
% rng(1246);%1246%1234
% p1 = genDotPatterns(9, 'prototype');
% p2 = genDotPatterns(9, 'prototype');
% p3 = genDotPatterns(9, 'prototype');
% for i = 1:num; ld1(:,:,i) = genDotPatterns(9, 'low', p1); end
% for i = 1:num; md1(:,:,i) = genDotPatterns(9, 'med', p1); end
% for i = 1:num; hd1(:,:,i) = genDotPatterns(9, 'high', p1); end
% 
% for i = 1:num; ld2(:,:,i) = genDotPatterns(9, 'low', p2); end
% for i = 1:num; md2(:,:,i) = genDotPatterns(9, 'med', p2); end
% for i = 1:num; hd2(:,:,i) = genDotPatterns(9, 'high', p2); end
% 
% for i = 1:num; ld3(:,:,i) = genDotPatterns(9, 'low', p3); end
% for i = 1:num; md3(:,:,i) = genDotPatterns(9, 'med', p3); end
% for i = 1:num; hd3(:,:,i) = genDotPatterns(9, 'high', p3); end
load('coord_info.mat');


f = figure('PaperPosition',[.25 .25 2 2]);
plot(p1(:,1), p1(:,2), '.k','MarkerSize',8);
set(gca, 'XLim', [-25 25], 'YLim', [-25 25], 'XTick', [], 'YTick', []);
axis square
axis off
filename = strcat('images\proto1');
print(f,filename,'-djpeg','-r112');
f = figure('PaperPosition',[.25 .25 2 2]);
plot(p2(:,1), p2(:,2), '.k','MarkerSize',8);
set(gca, 'XLim', [-25 25], 'YLim', [-25 25], 'XTick', [], 'YTick', [])
axis square
axis off
filename = strcat('images\proto2');
print(f,filename,'-djpeg','-r112');
f = figure('PaperPosition',[.25 .25 2 2]);
plot(p3(:,1), p3(:,2), '.k','MarkerSize',8);
set(gca, 'XLim', [-25 25], 'YLim', [-25 25], 'XTick', [], 'YTick', [])
axis square
axis off
filename = strcat('images\proto3');
print(f,filename,'-djpeg','-r112');

for icnt = 1:300
    f = figure('PaperPosition',[.25 .25 2 2]);
    plot(ld1(:,1,icnt), ld1(:,2,icnt), '.k','MarkerSize',8);
    set(gca, 'XLim', [-25 25], 'YLim', [-25 25], 'XTick', [], 'YTick', [])
    axis square
    axis off
    filename = strcat('images\cat1_low\image',num2str(icnt));
    print(f,filename,'-djpeg','-r112');
    
    
    f = figure('PaperPosition',[.25 .25 2 2]);
    plot(ld2(:,1,icnt), ld2(:,2,icnt), '.k','MarkerSize',8);
    set(gca, 'XLim', [-25 25], 'YLim', [-25 25], 'XTick', [], 'YTick', [])
    axis square
    axis off
    filename = strcat('images\cat2_low\image',num2str(icnt));
    print(f,filename,'-djpeg','-r112');
    
    
    f = figure('PaperPosition',[.25 .25 2 2]);
    plot(ld3(:,1,icnt), ld3(:,2,icnt), '.k','MarkerSize',8);
    axis([-25,24,-25,24]);
    set(gca, 'XLim', [-25 25], 'YLim', [-25 25], 'XTick', [], 'YTick', [])
    axis square
    axis off
    filename = strcat('images\cat3_low\image',num2str(icnt));
    print(f,filename,'-djpeg','-r112');
    
    
    f = figure('PaperPosition',[.25 .25 2 2]);
    plot(md1(:,1,icnt), md1(:,2,icnt), '.k','MarkerSize',8);
    set(gca, 'XLim', [-25 25], 'YLim', [-25 25], 'XTick', [], 'YTick', [])
    axis square
    axis off
    filename = strcat('images\cat1_med\image',num2str(icnt));
    print(f,filename,'-djpeg','-r112');
    
    
    f = figure('PaperPosition',[.25 .25 2 2]);
    plot(md2(:,1,icnt), md2(:,2,icnt), '.k','MarkerSize',8);
    set(gca, 'XLim', [-25 25], 'YLim', [-25 25], 'XTick', [], 'YTick', [])
    axis square
    axis off
    filename = strcat('images\cat2_med\image',num2str(icnt));
    print(f,filename,'-djpeg','-r112');
    
    
    f = figure('PaperPosition',[.25 .25 2 2]);
    plot(md3(:,1,icnt), md3(:,2,icnt), '.k','MarkerSize',8);
    set(gca, 'XLim', [-25 25], 'YLim', [-25 25], 'XTick', [], 'YTick', [])
    axis square
    axis off
    filename = strcat('images\cat3_med\image',num2str(icnt));
    print(f,filename,'-djpeg','-r112');
    
    
    f = figure('PaperPosition',[.25 .25 2 2]);
    plot(hd1(:,1,icnt), hd1(:,2,icnt), '.k','MarkerSize',8);
    set(gca, 'XLim', [-25 25], 'YLim', [-25 25], 'XTick', [], 'YTick', [])
    axis square
    axis off
    filename = strcat('images\cat1_high\image',num2str(icnt));
    print(f,filename,'-djpeg','-r112');
    
    
    f = figure('PaperPosition',[.25 .25 2 2]);
    plot(hd2(:,1,icnt), hd2(:,2,icnt), '.k','MarkerSize',8);
    set(gca, 'XLim', [-25 25], 'YLim', [-25 25], 'XTick', [], 'YTick', [])
    axis square
    axis off
    filename = strcat('images\cat2_high\image',num2str(icnt));
    print(f,filename,'-djpeg','-r112');
    
    
    f = figure('PaperPosition',[.25 .25 2 2]);
    plot(hd3(:,1,icnt), hd3(:,2,icnt), '.k','MarkerSize',8);
    set(gca, 'XLim', [-25 25], 'YLim', [-25 25], 'XTick', [], 'YTick', [])
    axis square
    axis off
    filename = strcat('images\cat3_high\image',num2str(icnt));
    print(f,filename,'-djpeg','-r112');
    close all
end






cnt = ones(1,3); 
f = figure;
for i = 1:60
    subplot_tight(6,10,i,[0,0]);
    if ismember(i, 1:20)
        plot(ld1(:,1, cnt(1)), ld1(:,2, cnt(1)), '.r','MarkerSize',6); cnt(1) = cnt(1) + 1;
    elseif ismember(i, 21:40)
        plot(ld2(:,1, cnt(2)), ld2(:,2, cnt(2)), '.g','MarkerSize',6); cnt(2) = cnt(2) + 1;
    elseif ismember(i, 41:60)
        plot(ld3(:,1, cnt(3)), ld3(:,2, cnt(3)), '.b','MarkerSize',6); cnt(3) = cnt(3) + 1;
    end
    set(gca, 'XLim', [-25 25], 'YLim', [-25 25], 'XTick', [], 'YTick', [])
    axis square
end
filename = strcat('images\low_show');
print(f,filename,'-djpeg','-r500');

cnt = ones(1,3);
f = figure;
for i = 1:60
    subplot_tight(6,10,i,[0,0]);
    if ismember(i, 1:20)
        plot(md1(:,1, cnt(1)), md1(:,2, cnt(1)), '.r','MarkerSize',6); cnt(1) = cnt(1) + 1;
    elseif ismember(i, 21:40)
        plot(md2(:,1, cnt(2)), md2(:,2, cnt(2)), '.g','MarkerSize',6); cnt(2) = cnt(2) + 1;
    elseif ismember(i, 41:60)
        plot(md3(:,1, cnt(3)), md3(:,2, cnt(3)), '.b','MarkerSize',6); cnt(3) = cnt(3) + 1;
    end
    set(gca, 'XLim', [-25 25], 'YLim', [-25 25], 'XTick', [], 'YTick', [])
    axis square
end
filename = strcat('images\med_show');
print(f,filename,'-djpeg','-r500');

cnt = ones(1,3);
f = figure;
for i = 1:60
    subplot_tight(6,10,i,[0,0]);
    if ismember(i, 1:20)
        plot(hd1(:,1, cnt(1)), hd1(:,2, cnt(1)), '.r','MarkerSize',6); cnt(1) = cnt(1) + 1;
    elseif ismember(i, 21:40)
        plot(hd2(:,1, cnt(2)), hd2(:,2, cnt(2)), '.g','MarkerSize',6); cnt(2) = cnt(2) + 1;
    elseif ismember(i, 41:60)
        plot(hd3(:,1, cnt(3)), hd3(:,2, cnt(3)), '.b','MarkerSize',6); cnt(3) = cnt(3) + 1;
    end
    set(gca, 'XLim', [-25 25], 'YLim', [-25 25], 'XTick', [], 'YTick', [])
    axis square
end
filename = strcat('images\high_show');
print(f,filename,'-djpeg','-r500');


