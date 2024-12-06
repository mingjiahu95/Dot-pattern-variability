function [Pr_resp_pat,Pr_corr_pat,Pr_corr] = GCM_baseline(params,condition)
%condition: 1 low 2 med 3 high *4 mix
%item type: 1 proto 2 old 3 newlow 4 newmed 5 newhigh
S_p = params.S_p;
S_l = params.S_l;
S_m = params.S_m;
S_h = params.S_h;
S_c = params.S_c;
gamma = params.gamma;
ntrain_per_cat = 9;
ncat = 3;


S_within_proto = ntrain_per_cat*S_p;
S_within_low = ntrain_per_cat*S_l;
S_within_med = ntrain_per_cat*S_m;
S_within_high = ntrain_per_cat*S_h;
switch condition
    case 1
        S_within_old = 1 + (ntrain_per_cat - 1)*S_l;
    case 2
        S_within_old = 1 + (ntrain_per_cat - 1)*S_m;
    case 3
        S_within_old = 1 + (ntrain_per_cat - 1)*S_h;
end
S_between_per_cat = ntrain_per_cat*S_c;

Pr_resp_pat = struct;
Pr_corr_old = S_within_old^gamma / (S_between_per_cat^gamma *(ncat - 1) + S_within_old^gamma);
Pr_corr_pat.old = repmat(Pr_corr_old,[9*3,1]); 
Pr_resp_pat.old = [repmat([Pr_corr_old,(1-Pr_corr_old)/2,(1-Pr_corr_old)/2],[9,1]);repmat([(1-Pr_corr_old)/2,Pr_corr_old,(1-Pr_corr_old)/2],[9,1]);repmat([(1-Pr_corr_old)/2,(1-Pr_corr_old)/2,Pr_corr_old],[9,1])];
Pr_corr_proto = S_within_proto^gamma / (S_between_per_cat^gamma *(ncat - 1) + S_within_proto^gamma);
Pr_corr_pat.proto = repmat(Pr_corr_proto,[3,1]); 
Pr_resp_pat.proto = [[Pr_corr_proto,(1-Pr_corr_proto)/2,(1-Pr_corr_proto)/2];[(1-Pr_corr_proto)/2,Pr_corr_proto,(1-Pr_corr_proto)/2];[(1-Pr_corr_proto)/2,(1-Pr_corr_proto)/2,Pr_corr_proto]];
Pr_corr_newlow= S_within_low^gamma / (S_between_per_cat^gamma *(ncat - 1) + S_within_low^gamma);
Pr_corr_pat.newlow = repmat(Pr_corr_newlow,[3*3,1]); 
Pr_resp_pat.newlow = [repmat([Pr_corr_newlow,(1-Pr_corr_newlow)/2,(1-Pr_corr_newlow)/2],[3,1]);repmat([(1-Pr_corr_newlow)/2,Pr_corr_newlow,(1-Pr_corr_newlow)/2],[3,1]);repmat([(1-Pr_corr_newlow)/2,(1-Pr_corr_newlow)/2,Pr_corr_newlow],[3,1])];
Pr_corr_newmed = S_within_med^gamma / (S_between_per_cat^gamma *(ncat - 1) + S_within_med^gamma);
Pr_corr_pat.newmed = repmat(Pr_corr_newmed,[6*3,1]); 
Pr_resp_pat.newmed = [repmat([Pr_corr_newmed,(1-Pr_corr_newmed)/2,(1-Pr_corr_newmed)/2],[6,1]);repmat([(1-Pr_corr_newmed)/2,Pr_corr_newmed,(1-Pr_corr_newmed)/2],[6,1]);repmat([(1-Pr_corr_newmed)/2,(1-Pr_corr_newmed)/2,Pr_corr_newmed],[6,1])];
Pr_corr_newhigh = S_within_high^gamma / (S_between_per_cat^gamma *(ncat - 1) + S_within_high^gamma);
Pr_corr_pat.newhigh = repmat(Pr_corr_newhigh,[9*3,1]); 
Pr_resp_pat.newhigh = [repmat([Pr_corr_newhigh,(1-Pr_corr_newhigh)/2,(1-Pr_corr_newhigh)/2],[9,1]);repmat([(1-Pr_corr_newhigh)/2,Pr_corr_newhigh,(1-Pr_corr_newhigh)/2],[9,1]);repmat([(1-Pr_corr_newhigh)/2,(1-Pr_corr_newhigh)/2,Pr_corr_newhigh],[9,1])];

Pr_corr = [Pr_corr_old,Pr_corr_proto,Pr_corr_newlow,Pr_corr_newmed,Pr_corr_newhigh];
end