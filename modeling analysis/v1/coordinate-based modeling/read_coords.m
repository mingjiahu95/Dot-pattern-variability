clearvars -except cat2_index cat3_index p1 p2_aligned p3_aligned
T = readtable('pattern_info.csv');
coord_index_mat = [1:9;cat2_index;cat3_index];

coord_train = NaN([9,2,27,4]);
cat_train = NaN([27,4]);
for icond = 1:4
    for icat = 1:3
        for itoken = 1:9
            coord_index = coord_index_mat(icat,:);
            ipat = (icat - 1)*9 + itoken;
            coord_pat = T{T.condition==icond & T.phase==1 & T.category==icat & T.token==itoken,8:25};
            coord_pat = reshape(coord_pat,[2,9])';
            coord_train(:,:,ipat,icond) = coord_pat(coord_index,:);
            cat_train(ipat,icond) = icat;   
        end
    end
end
    
coord_test_old = NaN([9,2,27,4]);
cat_test_old = NaN([27,4]);
for icond = 1:4
    for icat = 1:3
        for itoken = 1:9
            coord_index = coord_index_mat(icat,:);
            ipat = (icat - 1)*9 + itoken;
            coord_pat = T{T.condition==icond & T.phase==2 & T.itemtype==1 & T.category==icat & T.token==itoken,8:25};
            coord_pat = reshape(coord_pat,[2,9])';
            coord_test_old(:,:,ipat,icond) = coord_pat(coord_index,:);
            cat_test_old(ipat,icond) = icat;   
        end
    end
end

coord_test_newlow = NaN([9,2,9,4]);
cat_test_newlow = NaN([9,4]);
for icond = 1:4
    for icat = 1:3
        for itoken = 1:3
            coord_index = coord_index_mat(icat,:);
            ipat = (icat - 1)*3 + itoken;
            coord_pat = T{T.condition==icond & T.phase==2 & T.itemtype==3 & T.category==icat & T.token==itoken,8:25};
            coord_pat = reshape(coord_pat,[2,9])';
            coord_test_newlow(:,:,ipat,icond) = coord_pat(coord_index,:);
            cat_test_newlow(ipat,icond) = icat;   
        end
    end
end

coord_test_newmed = NaN([9,2,18,4]);
cat_test_newmed = NaN([18,4]);
for icond = 1:4
    for icat = 1:3
        for itoken = 1:6
            coord_index = coord_index_mat(icat,:);
            ipat = (icat - 1)*6 + itoken;
            coord_pat = T{T.condition==icond & T.phase==2 & T.itemtype==4 & T.category==icat & T.token==itoken,8:25};
            coord_pat = reshape(coord_pat,[2,9])';
            coord_test_newmed(:,:,ipat,icond) = coord_pat(coord_index,:);
            cat_test_newmed(ipat,icond) = icat;   
        end
    end
end

coord_test_newhigh = NaN([9,2,27,4]);
cat_test_newhigh = NaN([27,4]);
for icond = 1:4
    for icat = 1:3
        for itoken = 1:9
            coord_index = coord_index_mat(icat,:);
            ipat = (icat - 1)*9 + itoken;
            coord_pat = T{T.condition==icond & T.phase==2 & T.itemtype==5 & T.category==icat & T.token==itoken,8:25};
            coord_pat = reshape(coord_pat,[2,9])';
            coord_test_newhigh(:,:,ipat,icond) = coord_pat(coord_index,:);
            cat_test_newhigh(ipat,icond) = icat;   
        end
    end
end


%special high distortions
coord_test_newhigh_hard = NaN([9,2,3]);
cat_test_newhigh_hard = NaN([1,3]);
for icat = 1:3
    coord_index = coord_index_mat(icat,:);
    coord_pat = unique(T{T.phase==2 & T.itemtype==6 & T.category==icat,8:25},'rows');
    coord_pat = reshape(coord_pat,[2,9])';
    coord_test_newhigh_hard(:,:,icat) = coord_pat(coord_index,:);
    cat_test_newhigh_hard(icat) = icat;
end


%prototypes
coord_proto = cat(3,p1,p2_aligned,p3_aligned);
cat_proto = [1,2,3];

%save coord data as a mat file
save("coord_info.mat",'cat_proto','cat_train','cat_test*','coord_proto','coord_train','coord_test*');
