
function NLL = calc_error(observed_data, x, condition)
epsilon = .000001;

N_old_observed = observed_data.old{observed_data.old.condition == condition,["N_A","N_B","N_C"]};
N_proto_observed = observed_data.proto{observed_data.proto.condition == condition,["N_A","N_B","N_C"]};
N_newlow_observed = observed_data.newlow{observed_data.newlow.condition == condition,["N_A","N_B","N_C"]};
N_newmed_observed = observed_data.newmed{observed_data.newmed.condition == condition,["N_A","N_B","N_C"]};
N_newhigh_observed = observed_data.newhigh{observed_data.newhigh.condition == condition,["N_A","N_B","N_C"]};
N_newhigh_special_observed = observed_data.newhigh_special{observed_data.newhigh_special.condition == condition,["N_A","N_B","N_C"]};

params = struct;  

% params.S_l = x(1);
% params.S_m = x(2);
% params.S_h = x(3);
% params.S_c = x(4);
% params.gamma = 1;
% 
% Pr_resp_pat = PM_baseline(params,condition);

% params.c = x(1);
% params.gamma = 1;
% Pr_resp_pat = PM_activation18(params,condition);


params.c = x(1);
params.gamma = 1;
w1 = x(2);
w2 = min(x(3),1-x(2));
w3 = 1-w1-w2;
weights = [w1,w2,w3];
% weights = [1,1,1];
Pr_resp_pat = CM_activationMDS(params,weights);


%NLL_pat 
NLL_itemtype(1) = -sum(N_old_observed .* log(Pr_resp_pat.old),[1,2]);
NLL_itemtype(2) = -sum(N_proto_observed .* log(Pr_resp_pat.proto),[1,2]);
NLL_itemtype(3) = -sum(N_newlow_observed .* log(Pr_resp_pat.newlow),[1,2]);
NLL_itemtype(4) = -sum(N_newmed_observed .* log(Pr_resp_pat.newmed),[1,2]);
NLL_itemtype(5) = -sum(N_newhigh_observed .* log(Pr_resp_pat.newhigh),[1,2]);
NLL_itemtype(6) = -sum(N_newhigh_special_observed .* log(Pr_resp_pat.newhigh_special),[1,2]);
NLL = sum(NLL_itemtype);


end
