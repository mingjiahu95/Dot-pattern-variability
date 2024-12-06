clear
clc

params.low = .098;
params.med = .398;
params.high = .824;
% params.within = .491;
params.between = 1.966;
params.sensitivity = .371;
params.response_scaling = 5.000;
rng(1234);
Pr_corr_sim = zeros(4,5,10000);
for isim = 1:10000
    [~,~,Pr_corr_sim(:,:,isim)] = GCM(params,6); % concatenate results from each simulation of the experimental process
end
% pred_results = mean(Pr_corr_sim,3);% average along the simulation dimension
% fprintf('%7.3f%7.3f%7.3f%7.3f%7.3f\n',pred_results');

%% observed data
% T = readtable('pattern_info_test.csv');
% for icond = 1:4
%     obs_old(icond) = mean(T{T.condition==icond & T.itemtype==1,"PrCorr"});    
%     obs_proto(icond) = mean(T{T.condition==icond & T.itemtype==2,"PrCorr"});
%     obs_newlow(icond) = mean(T{T.condition==icond & T.itemtype==3,"PrCorr"});
%     obs_newmed(icond) = mean(T{T.condition==icond & T.itemtype==4,"PrCorr"});
%     obs_newhigh(icond) = mean(T{T.condition==icond & T.itemtype==5,"PrCorr"});
%     obs_special(icond) = mean(T{T.condition==icond & T.itemtype==6,"PrCorr"});
% end
% observed_data = readmatrix("PrCorr_obs_high90");

%% export data
n_type = 5;
n_cond = 4;
n_sim = 10000;
sim_values = repelem(1:n_sim,n_cond*n_type);
cond_values = repmat(1:n_cond,[1 n_sim*n_type]);
itemtype_values = repmat(repelem(1:n_type,n_cond),[1 n_sim]);
% obs_values = [obs_old,obs_proto,obs_newlow,obs_newmed,obs_newhigh];
pred_values = Pr_corr_sim(:)';%%%pred_results
% T = table(itemtype_values',cond_values',obs_values',...
%           'VariableNames',{'itemtype','condition','obs'});
% writetable(T,'obs_data.csv')
T = table(itemtype_values',cond_values',sim_values',pred_values',...
          'VariableNames',{'itemtype','condition','simulation','pred'});
writetable(T,'pred_data_sim.csv')
