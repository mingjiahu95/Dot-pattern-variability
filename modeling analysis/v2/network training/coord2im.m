function matrix_output = coord2im(coord_pat)
figure('Position',[0 0 600 600],'Color','w');
plot(coord_pat(:,1),coord_pat(:,2), '.k','MarkerSize',12);
set(gca, 'XLim', [-25 25], 'YLim', [-25 25], 'XTick', [], 'YTick', []);
axis square;
axis off;
F = getframe(gcf);
matrix_output = imcrop(F.cdata,[150 150 600 600]);
end