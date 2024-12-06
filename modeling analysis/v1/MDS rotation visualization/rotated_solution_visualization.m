clear;
clf;
load rotated_MDS_med;
category = [repelem(['r','g','b'],9),repelem(['r','g','b'],1),repelem(['r','g','b'],3),repelem(['r','g','b'],6),repelem(['r','g','b'],9),repelem(['r','g','b'],1)];
item_type = repelem(['x','o','^','d','p','h'],[27,3,9,18,27,3]);
typicality = repelem([2,6,3,2,1,1],[27,3,9,18,27,3]);%adjust the size of old items

%dim 1 vs. dim 2
figure('Name','dim 1 vs. dim 2');
for i = 1:87
    scatter(mds_store(1,i),mds_store(2,i),typicality(i)*2+6,category(i),'Marker',item_type(i),'MarkerFaceColor',category(i));
    hold on
end

% Create a legend with custom marker shapes
labels = {'old', 'prototype', 'newlow', 'newmed', 'newhigh', 'special'};
color = 'k';
markers = {'x', 'o', '^', 'd', 'p', 'h'};
size = 7;

legend_handles = gobjects(length(labels),1);
for i = 1:length(labels)
    legend_handles(i) = plot(NaN, NaN, markers{i},'Color',color,'MarkerFaceColor',color, 'MarkerSize', size);
end
legend(legend_handles, labels, 'Location', 'northeast','FontSize', 8);
xlabel('Dim 1: width-to-height ratio');
ylabel('Dim 2: horizontal splitness');
xlim([-12 12]);
ylim([-12 12]);
axis square
hold off
clear size

%dim 2 vs. dim 3
figure('Name','dim 2 vs. dim 3');
for i = 1:87
    scatter(mds_store(2,i),mds_store(3,i),typicality(i)*2+6,category(i),'Marker',item_type(i),'MarkerFaceColor',category(i));
    axis square
    hold on
end

% Create a legend with custom marker shapes
labels = {'old', 'prototype', 'newlow', 'newmed', 'newhigh', 'special'};
color = 'k';
markers = {'x', 'o', '^', 'd', 'p', 'h'};
size = 7;

legend_handles = gobjects(length(labels),1);
for i = 1:length(labels)
    legend_handles(i) = plot(NaN, NaN, markers{i},'Color',color,'MarkerFaceColor',color, 'MarkerSize', size);
end
legend(legend_handles, labels, 'Location', 'northeast','FontSize', 8);
xlabel('Dim 2: horizontal splitness');
ylabel('Dim 3: dual centrality');
xlim([-12 12]);
ylim([-12 12]);
axis square
hold off
clear size

