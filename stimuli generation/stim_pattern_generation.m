clear all
clc

load('coord_info.mat');

for icond = 1:4
    filepath = "stim_images/cond" + num2str(icond) + "/train";
    mkdir(filepath);
    for ipat = 1:size(coord_train,3)
        f = figure('PaperPosition',[.25 .25 2 2]);
        plot(coord_train(:,1,ipat,icond), coord_train(:,2,ipat,icond), '.k','MarkerSize',8);
        set(gca, 'XLim', [-25 25], 'YLim', [-25 25], 'XTick', [], 'YTick', []);
        axis square;
        axis off;
        filename = filepath + "/image" + num2str(ipat);
        print(f,filename,'-djpeg','-r300');
    end

    filepath = "stim_images/cond" + num2str(icond) + "/test_old";
    mkdir(filepath);
    for ipat = 1:size(coord_test_old,3)
        f = figure('PaperPosition',[.25 .25 2 2]);
        plot(coord_test_old(:,1,ipat,icond), coord_test_old(:,2,ipat,icond), '.k','MarkerSize',8);
        set(gca, 'XLim', [-25 25], 'YLim', [-25 25], 'XTick', [], 'YTick', []);
        axis square;
        axis off;
        filename = filepath + "/image" + num2str(ipat);
        print(f,filename,'-djpeg','-r300');
    end

    filepath = "stim_images/cond" + num2str(icond) + "/test_newlow";
    mkdir(filepath);
    for ipat = 1:size(coord_test_newlow,3)
        f = figure('PaperPosition',[.25 .25 2 2]);
        plot(coord_test_newlow(:,1,ipat,icond), coord_test_newlow(:,2,ipat,icond), '.k','MarkerSize',8);
        set(gca, 'XLim', [-25 25], 'YLim', [-25 25], 'XTick', [], 'YTick', []);
        axis square;
        axis off;
        filename = filepath + "/image" + num2str(ipat);
        print(f,filename,'-djpeg','-r300');
    end

    filepath = "stim_images/cond" + num2str(icond) + "/test_newmed";
    mkdir(filepath);
    for ipat = 1:size(coord_test_newmed,3)
        f = figure('PaperPosition',[.25 .25 2 2]);
        plot(coord_test_newmed(:,1,ipat,icond), coord_test_newmed(:,2,ipat,icond), '.k','MarkerSize',8);
        set(gca, 'XLim', [-25 25], 'YLim', [-25 25], 'XTick', [], 'YTick', []);
        axis square;
        axis off;
        filename = filepath + "/image" + num2str(ipat);
        print(f,filename,'-djpeg','-r300');
    end

    filepath = "stim_images/cond" + num2str(icond) + "/test_newhigh";
    mkdir(filepath);
    for ipat = 1:size(coord_test_newhigh,3)
        f = figure('PaperPosition',[.25 .25 2 2]);
        plot(coord_test_newhigh(:,1,ipat,icond), coord_test_newhigh(:,2,ipat,icond), '.k','MarkerSize',8);
        set(gca, 'XLim', [-25 25], 'YLim', [-25 25], 'XTick', [], 'YTick', []);
        axis square;
        axis off;
        filename = filepath + "/image" + num2str(ipat);
        print(f,filename,'-djpeg','-r300');
    end    
end

filepath = "stim_images/proto";
mkdir(filepath);
for ipat = 1:size(coord_proto,3)
    f = figure('PaperPosition',[.25 .25 2 2]);
    plot(coord_proto(:,1,ipat), coord_proto(:,2,ipat), '.k','MarkerSize',8);
    set(gca, 'XLim', [-25 25], 'YLim', [-25 25], 'XTick', [], 'YTick', []);
    axis square;
    axis off;
    filename = filepath + "/image" + num2str(ipat);
    print(f,filename,'-djpeg','-r300');
end

filepath = "stim_images/test_newhigh_hard";
mkdir(filepath);
for ipat = 1:size(coord_test_newhigh_hard,3)
    f = figure('PaperPosition',[.25 .25 2 2]);
    plot(coord_test_newhigh_hard(:,1,ipat), coord_test_newhigh_hard(:,2,ipat), '.k','MarkerSize',8);
    set(gca, 'XLim', [-25 25], 'YLim', [-25 25], 'XTick', [], 'YTick', []);
    axis square;
    axis off;
    filename = filepath + "/image" + num2str(ipat);
    print(f,filename,'-djpeg','-r300');
end



