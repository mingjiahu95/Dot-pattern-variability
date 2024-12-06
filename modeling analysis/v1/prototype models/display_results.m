clear
clc
cond = 2;
params.S_l = 0.909;
params.S_m = 0.592;
params.S_h = 0.327;
params.S_c = 0.190;
params.gamma = 1.000;
[pred_resp_baseline_PM,~,pred_overall_baseline] = PM_baseline(params,cond);
params.c = 0.088;
params.gamma = 1.000;
[pred_resp_coords_PM,~,pred_overall_coords] = PM_coords18(params,cond);
params.c = 0.091;
params.gamma = 1.000;
[pred_resp_act18_PM,~,pred_overall_act18_PM] = PM_activation18(params,cond);

% params.c = .341;
% params.gamma = 1.000;
% weights = [0,0.636,0.364];
% [pred_resp_actMDS_PM,~,pred_overall_actMDS_PM] = PM_activationMDS(params,weights);
params.c = .191;
params.gamma = 1.000;
weights = [.575,.407,.018];
[pred_resp_actMDS_CM,~,pred_overall_actMDS_CM] = CM_activationMDS(params,weights);
% params.c = .173;
% params.gamma = 1.000;
% weights = [1,1,1];
% [pred_resp_actMDS_PM,~,pred_overall_actMDS_PM] = PM_activationMDS(params,weights);
% params.c = .213;
% params.gamma = 1.000;
% weights = [1,1,1];
% [pred_resp_actMDS_CM,~,pred_overall_actMDS_CM] = CM_activationMDS(params,weights);

%% observed data
T = readtable('pattern_info_test.csv');
obs_old = T{T.condition==cond & T.itemtype==1,["N_A","N_B","N_C"]};
obs_old = obs_old./sum(obs_old,2) ;
obs_proto = T{T.condition==cond & T.itemtype==2,["N_A","N_B","N_C"]};
obs_proto = obs_proto./sum(obs_proto,2) ;
obs_newlow = T{T.condition==cond & T.itemtype==3,["N_A","N_B","N_C"]};
obs_newlow = obs_newlow./sum(obs_newlow,2) ;
obs_newmed = T{T.condition==cond & T.itemtype==4,["N_A","N_B","N_C"]};
obs_newmed = obs_newmed./sum(obs_newmed,2) ;
obs_newhigh = T{T.condition==cond & T.itemtype==5,["N_A","N_B","N_C"]};
obs_newhigh = obs_newhigh./sum(obs_newhigh,2) ;
obs_special = T{T.condition==cond & T.itemtype==6,["N_A","N_B","N_C"]};
obs_special = obs_special./sum(obs_special,2);

%% bar plot
% itemtype_values = 1:6;
% obs_overall = [mean(obs_old),mean(obs_proto),mean(obs_newlow),mean(obs_newmed),mean(obs_newhigh),mean(obs_newhigh_hard)];
% pred_overall_baseline(6) = nan;
% T = table(itemtype_values',obs_overall',pred_overall_baseline',pred_overall_coords',pred_overall_f18',...
%           'VariableNames',{'itemtype','obs','pred_sim','pred_coord','pred_f18'});
% writetable(T,'barplot_data.csv')
% 
% 
% obs_vec_5type = [obs_old;obs_proto;obs_newlow;obs_newmed;obs_newhigh]';
% obs_vec_6type = [obs_old;obs_proto;obs_newlow;obs_newmed;obs_newhigh;obs_newhigh_hard]';
% itemtype_vec_5type = [repmat(1,[1 numel(obs_old)]),repmat(2,[1 numel(obs_proto)]),repmat(3,[1 numel(obs_newlow)]),repmat(4,[1 numel(obs_newmed)]),repmat(5,[1 numel(obs_newhigh)])];
% itemtype_vec_6type = [repmat(1,[1 numel(obs_old)]),repmat(2,[1 numel(obs_proto)]),repmat(3,[1 numel(obs_newlow)]),repmat(4,[1 numel(obs_newmed)]),repmat(5,[1 numel(obs_newhigh)]),repmat(6,[1 numel(obs_newhigh_hard)])];
% obs_values = [obs_vec_5type,obs_vec_6type,obs_vec_6type];
% itemtype_values = [itemtype_vec_5type,itemtype_vec_6type,itemtype_vec_6type];
% 
% pred_values_baseline = repelem(pred_overall_baseline(1:5),[numel(obs_old);numel(obs_proto);numel(obs_newlow);numel(obs_newmed);numel(obs_newhigh)]);
% pred_values_coords = [pred_pat_coords.old;pred_pat_coords.proto;pred_pat_coords.newlow;pred_pat_coords.newmed;pred_pat_coords.newhigh;pred_pat_coords.newhigh_special]';
% pred_values_activation = [pred_pat_act18.old;pred_pat_act18.proto;pred_pat_act18.newlow;pred_pat_act18.newmed;pred_pat_act18.newhigh;pred_pat_act18.newhigh_special]';
% 
% pred_values = [pred_values_baseline,pred_values_coords,pred_values_activation];
% model_values = repelem(1:3,[numel(pred_values_baseline),numel(pred_values_coords),numel(pred_values_activation)]);
% 
% T = table(itemtype_values',obs_values',pred_values',model_values',...
%           'VariableNames',{'itemtype','obs_val','pred_val','model'});
% writetable(T,'scatterplot_data.csv')

%% scatterplot MDS 
% model 1-5: GCM_act18, GCM_actMDS_nw, GCM_actMDS_w, PM_actMDS_w,CM_actMDS_w
% model 1-3: GCM_act18_w,PM_act18_w,CM_actMDS_w
n_model = 4;
obs_vec_6type = [obs_old;obs_proto;obs_newlow;obs_newmed;obs_newhigh;obs_special];
obs_vec_6type = obs_vec_6type(:);
obs_values = repmat(obs_vec_6type,[n_model 1])';
itemtype_vec_6type = repelem(1:6,1/3*[numel(obs_old),numel(obs_proto),numel(obs_newlow),numel(obs_newmed),numel(obs_newhigh),numel(obs_special)]);
itemtype_values = repmat(itemtype_vec_6type,[1 3*n_model]);

pred_values_baseline_PM = [pred_resp_baseline_PM.old;pred_resp_baseline_PM.proto;pred_resp_baseline_PM.newlow;pred_resp_baseline_PM.newmed;pred_resp_baseline_PM.newhigh;pred_resp_baseline_PM.newhigh_special];
pred_values_baseline_PM = pred_values_baseline_PM(:);
pred_values_coords_PM = [pred_resp_coords_PM.old;pred_resp_coords_PM.proto;pred_resp_coords_PM.newlow;pred_resp_coords_PM.newmed;pred_resp_coords_PM.newhigh;pred_resp_coords_PM.newhigh_special];
pred_values_coords_PM = pred_values_coords_PM(:);
pred_values_act18_PM = [pred_resp_act18_PM.old;pred_resp_act18_PM.proto;pred_resp_act18_PM.newlow;pred_resp_act18_PM.newmed;pred_resp_act18_PM.newhigh;pred_resp_act18_PM.newhigh_special];
pred_values_act18_PM = pred_values_act18_PM(:);
% pred_values_actMDS_PM = [pred_resp_actMDS_PM.old;pred_resp_actMDS_PM.proto;pred_resp_actMDS_PM.newlow;pred_resp_actMDS_PM.newmed;pred_resp_actMDS_PM.newhigh;pred_resp_actMDS_PM.newhigh_special];
% pred_values_actMDS_PM = pred_values_actMDS_PM(:);
pred_values_actMDS_CM = [pred_resp_actMDS_CM.old;pred_resp_actMDS_CM.proto;pred_resp_actMDS_CM.newlow;pred_resp_actMDS_CM.newmed;pred_resp_actMDS_CM.newhigh;pred_resp_actMDS_CM.newhigh_special];
pred_values_actMDS_CM = pred_values_actMDS_CM(:);


pred_values = [pred_values_baseline_PM;pred_values_coords_PM;pred_values_act18_PM;pred_values_actMDS_CM]';
model_values = repelem(1:n_model,numel(pred_values_actMDS_CM));%assume the same number of predictions per model
resp_cat_values = repelem(1:3,numel(itemtype_vec_6type));
resp_cat_values = repmat(resp_cat_values,[1 n_model]);
pat_cat_values = arrayfun(@(x) repelem(1:3,[x x x]),1/9*[numel(obs_old),numel(obs_proto),numel(obs_newlow),numel(obs_newmed),numel(obs_newhigh),numel(obs_special)],'UniformOutput',false);
pat_cat_values = repmat(cell2mat(pat_cat_values),[1 3*n_model]);
corr_values = pat_cat_values == resp_cat_values;

T = table(pat_cat_values',resp_cat_values',itemtype_values',obs_values',pred_values',corr_values',model_values',...
          'VariableNames',{'category_pat','category_resp','itemtype','obs_val','pred_val','corr_values','model'});
writetable(T,'scatterplot_data_med.csv')%'scatterplot_data.csv'
