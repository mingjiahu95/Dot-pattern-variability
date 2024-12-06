
function SSE = calc_error_coord(observed_data, x, condition)
epsilon = .000001;

Pr_old_observed = observed_data.old(:,condition);
Pr_proto_observed = observed_data.proto(:,condition);
Pr_newlow_observed = observed_data.newlow(:,condition);
Pr_newmed_observed = observed_data.newmed(:,condition);
Pr_newhigh_observed = observed_data.newhigh(:,condition);
Pr_newhigh_hard_observed = observed_data.newhigh_hard(:,condition);

param = struct; 

param.c = x(1);
param.gamma = x(2);
param.condition = 1; %condition: 1 low 2 med 3 high 4 mix

[~,Pr_corr_pat] = GCM_coords(param);


%SSE 
SSE_itemtype = NaN([1,6]);
SSE_itemtype(1) = sum((Pr_old_observed(:) - Pr_corr_pat.old(:)).^2);
SSE_itemtype(2) = sum((Pr_proto_observed(:)- Pr_corr_pat.proto(:)).^2);
SSE_itemtype(3) = sum((Pr_newlow_observed(:)- Pr_corr_pat.newlow(:)).^2);
SSE_itemtype(4) = sum((Pr_newmed_observed(:)- Pr_corr_pat.newmed(:)).^2);
SSE_itemtype(5) = sum((Pr_newhigh_observed(:)- Pr_corr_pat.newhigh(:)).^2);
SSE_itemtype(6) = sum((Pr_newhigh_hard_observed(:)- Pr_corr_pat.newhigh_hard(:)).^2);
SSE = sum(SSE_itemtype);

%-∑f_i ln(p_i) 
%-2∑f_i ln(p_i)   +  kln(N)

end
