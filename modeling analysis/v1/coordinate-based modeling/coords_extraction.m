%% read dot coordinates for each pattern
% load trained networks and image data objects
clear
clc
load 'coord_info.mat'
% generate feature vectors
for icond = 1:4
    coord_proto_store = reshape(permute(coord_proto,[2,1,3]),[],3);
    coord_test_newhigh_special_store = reshape(permute(coord_test_newhigh_special,[2,1,3]),[],3);
    coord_test_old_store(:,:,icond) = reshape(permute(coord_test_old(:,:,:,icond),[2,1,3]),[],27);
    coord_test_newlow_store(:,:,icond) = reshape(permute(coord_test_newlow(:,:,:,icond),[2,1,3]),[],9);
    coord_test_newmed_store(:,:,icond) = reshape(permute(coord_test_newmed(:,:,:,icond),[2,1,3]),[],18);
    coord_test_newhigh_store(:,:,icond) = reshape(permute(coord_test_newhigh(:,:,:,icond),[2,1,3]),[],27);
end
% write feature vectors into spreadsheets
for icond = 1:4
    filename = ['test pattern coords',num2str(icond), '.xlsx'];
    writematrix(coord_proto_store,filename, 'Sheet','proto');
    writematrix(coord_test_old_store(:,:,icond),filename, 'Sheet','old');
    writematrix(coord_test_newlow_store(:,:,icond),filename, 'Sheet','newlow');
    writematrix(coord_test_newmed_store(:,:,icond),filename, 'Sheet','newmed');
    writematrix(coord_test_newhigh_store(:,:,icond),filename, 'Sheet','newhigh');
    writematrix(coord_test_newhigh_special_store,filename, 'Sheet','newhigh_special');
end


