
dim_vec = [3,6,9];
n_exem = 90;
n_sim = 10000;
dist_summary = zeros(3,3);
for i_dim = 1:3
    n_dim = dim_vec(i_dim);
    trainlow = 2*randn(n_exem,n_dim);
    trainmed = 4*randn(n_exem,n_dim);
    trainhigh = 6*randn(n_exem,n_dim);
    testhigh = 6*randn(n_sim,n_dim);
    dist_summary(i_dim,1) = mean(pdist2(testhigh,trainlow),[1,2]);
    dist_summary(i_dim,2) = mean(pdist2(testhigh,trainmed),[1,2]);
    dist_summary(i_dim,3) = mean(pdist2(testhigh,trainhigh),[1,2]);
end
writematrix(dist_summary,'distortion distance.csv');
