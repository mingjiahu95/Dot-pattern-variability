
function SSE_total = calc_error(observed_data, x)
n_sim = 10000;


% for icond = 1:4
% %     N_observed(icond,1:3,1:3) = observed_data.old{observed_data.old.condition == icond,["N_A","N_B","N_C"]};
% %     N_observed(icond,3+(1:3),1:3) = observed_data.proto{observed_data.proto.condition == icond,["N_A","N_B","N_C"]};
% %     N_observed(icond,6+(1:3),1:3) = observed_data.newlow{observed_data.newlow.condition == icond,["N_A","N_B","N_C"]};
% %     N_observed(icond,9+(1:3),1:3) = observed_data.newmed{observed_data.newmed.condition == icond,["N_A","N_B","N_C"]};
% %     N_observed(icond,12+(1:3),1:3) = observed_data.newhigh{observed_data.newhigh.condition == icond,["N_A","N_B","N_C"]};
%     Pr_observed(icond,1,:) = observed_data.old{observed_data.old.condition == icond,"PrCorr"};
%     Pr_observed(icond,2,:) = observed_data.proto{observed_data.proto.condition == icond,"PrCorr"};
%     Pr_observed(icond,3,:) = observed_data.newlow{observed_data.newlow.condition == icond,"PrCorr"};
%     Pr_observed(icond,4,:) = observed_data.newmed{observed_data.newmed.condition == icond,"PrCorr"};
%     Pr_observed(icond,5,:) = observed_data.newhigh{observed_data.newhigh.condition == icond,"PrCorr"};
% end
% Pr_observed = mean(Pr_observed,3);
Pr_observed = observed_data;


params = struct;  
% params.within = x(1);
params.low = x(1);
params.med = max(x(1),x(2));
params.high = max(x(2),x(3));
params.between = max(x(3),x(4));
% params.between = x(2);
params.sensitivity = x(5);
% params.response_scaling = x(6);

% Pr_resp_pat = zeros(4,15,3,n_sim);
Pr_corr = zeros(4,5,n_sim);
rng(12345);
for isim = 1:n_sim
  [~,~,Pr_corr(:,:,isim)] = GCM(params); % concatenate results from each simulation of the experimental process
% [~,~,Pr_corr(:,:,isim)] = PM(params);
end
% pred_results = mean(Pr_resp_pat,4);% average along the simulation dimension
pred_results = mean(Pr_corr,3);



%NLL_pat 
% NLL_total = -sum(N_observed .* log(pred_results),[1,2,3]);
SSE_total = sum((Pr_observed - pred_results).^2,[1,2,3]);
end
