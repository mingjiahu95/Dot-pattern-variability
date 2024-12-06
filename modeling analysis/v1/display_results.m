clear
clc
cond = 4;
% params.S_p = 0.536;
% params.S_l = 0.503;
% params.S_m = 0.347;
% params.S_h = 0.271;
% params.S_c = 0.195;
% params.gamma = 1.651;
% [pred_resp_baseline_GCM,~,pred_overall_baseline] = GCM_baseline(params,cond);
params.c = .077;
params.gamma = 1.332;
%high:2669.0; mix:2415.1
[pred_resp_coords_GCM,~,pred_overall_coords] = GCM_coords18(params,cond);
params.c = .130;
params.gamma = 1.000;
[pred_resp_act18_GCM,~,pred_overall_act18_GCM] = GCM_activation18(params,cond);
%high:2685.9; mix:2462.4
%%%
params.c = .142;
params.gamma = 1.632;
weights = [.803,.155,.042];
%high:2675.5; mix:2407.9
[pred_resp_actMDS_w,~,pred_overall_actMDS_w] = GCM_activationMDS(params,weights);%make sure the model program match the condition

%% observed data
T = readtable('pattern_info_test.csv');
obs_old_PrCorr = T{T.condition==cond & T.itemtype==1,"PrCorr"};
tmp = T{T.condition==cond & T.itemtype==1,["N_A","N_B","N_C"]};
obs_old_resp = tmp./sum(tmp,2);

obs_proto_PrCorr = T{T.condition==cond & T.itemtype==2,"PrCorr"};
tmp = T{T.condition==cond & T.itemtype==2,["N_A","N_B","N_C"]};
obs_proto_resp = tmp./sum(tmp,2);

obs_newlow_PrCorr = T{T.condition==cond & T.itemtype==3,"PrCorr"};
tmp = T{T.condition==cond & T.itemtype==3,["N_A","N_B","N_C"]};
obs_newlow_resp = tmp./sum(tmp,2);

obs_newmed_PrCorr = T{T.condition==cond & T.itemtype==4,"PrCorr"};
tmp = T{T.condition==cond & T.itemtype==4,["N_A","N_B","N_C"]};
obs_newmed_resp = tmp./sum(tmp,2);

obs_newhigh_PrCorr = T{T.condition==cond & T.itemtype==5,"PrCorr"};
tmp = T{T.condition==cond & T.itemtype==5,["N_A","N_B","N_C"]};
obs_newhigh_resp = tmp./sum(tmp,2);

obs_special_PrCorr = T{T.condition==cond & T.itemtype==6,"PrCorr"};
tmp = T{T.condition==cond & T.itemtype==6,["N_A","N_B","N_C"]};
obs_special_resp = tmp./sum(tmp,2);

%% bar plot
n_model = 3;
itemtype_values = repmat(1:6,[1 n_model]);
obs_overall = [mean(obs_old_PrCorr),mean(obs_proto_PrCorr),mean(obs_newlow_PrCorr),mean(obs_newmed_PrCorr),mean(obs_newhigh_PrCorr),mean(obs_special_PrCorr)];
obs_values = repmat(obs_overall,[1 n_model]);
pred_values = [pred_overall_coords,pred_overall_act18_GCM,pred_overall_actMDS_w];
model_values = repelem(1:n_model,numel(pred_overall_coords));


T = table(model_values',itemtype_values',obs_values',pred_values',...
          'VariableNames',{'model','itemtype','obs','pred'});
writetable(T,'barplot_data.csv')

% n_model = 3;
% obs_vec_6type = [obs_old;obs_proto;obs_newlow;obs_newmed;obs_newhigh;obs_newhigh_hard]';
% itemtype_vec_6type = [repmat(1,[1 numel(obs_old)]),repmat(2,[1 numel(obs_proto)]),repmat(3,[1 numel(obs_newlow)]),repmat(4,[1 numel(obs_newmed)]),repmat(5,[1 numel(obs_newhigh)]),repmat(6,[1 numel(obs_newhigh_hard)])];
% obs_values = repmat(obs_vec_6type,[1 n_model]);
% itemtype_values = repmat(itemtype_vec_6type,[1 n_model]);
% 
% %pred_values_baseline = repelem(pred_overall_baseline(1:5),[numel(obs_old);numel(obs_proto);numel(obs_newlow);numel(obs_newmed);numel(obs_newhigh)]);
% pred_values_coords = [pred_pat_coords.old;pred_pat_coords.proto;pred_pat_coords.newlow;pred_pat_coords.newmed;pred_pat_coords.newhigh;pred_pat_coords.newhigh_special]';
% pred_values_activation = [pred_pat_act18.old;pred_pat_act18.proto;pred_pat_act18.newlow;pred_pat_act18.newmed;pred_pat_act18.newhigh;pred_pat_act18.newhigh_special]';
% pred_values_actMDS = [pred_resp_actMDS_w.old;pred_resp_actMDS_w.proto;pred_resp_actMDS_w.newlow;pred_resp_actMDS_w.newmed;pred_resp_actMDS_w.newhigh;pred_resp_actMDS_w.newhigh_special];
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
n_model = 3;
obs_vec_6type = [obs_old_resp;obs_proto_resp;obs_newlow_resp;obs_newmed_resp;obs_newhigh_resp;obs_special_resp];
obs_vec_6type = obs_vec_6type(:);
obs_values = repmat(obs_vec_6type,[n_model 1])';
itemtype_vec_6type = repelem(1:6,1/3*[numel(obs_old_resp),numel(obs_proto_resp),numel(obs_newlow_resp),numel(obs_newmed_resp),numel(obs_newhigh_resp),numel(obs_special_resp)]);
itemtype_values = repmat(itemtype_vec_6type,[1 3*n_model]);

% pred_values_baseline_GCM = [pred_resp_baseline_GCM.old;pred_resp_baseline_GCM.proto;pred_resp_baseline_GCM.newlow;pred_resp_baseline_GCM.newmed;pred_resp_baseline_GCM.newhigh;pred_resp_baseline_GCM.newhigh_special];
% pred_values_baseline_GCM = pred_values_baseline_GCM(:);
pred_values_coords_GCM = [pred_resp_coords_GCM.old;pred_resp_coords_GCM.proto;pred_resp_coords_GCM.newlow;pred_resp_coords_GCM.newmed;pred_resp_coords_GCM.newhigh;pred_resp_coords_GCM.newhigh_special];
pred_values_coords_GCM = pred_values_coords_GCM(:);
pred_values_act18_GCM = [pred_resp_act18_GCM.old;pred_resp_act18_GCM.proto;pred_resp_act18_GCM.newlow;pred_resp_act18_GCM.newmed;pred_resp_act18_GCM.newhigh;pred_resp_act18_GCM.newhigh_special];
pred_values_act18_GCM = pred_values_act18_GCM(:);
pred_values_actMDS_w = [pred_resp_actMDS_w.old;pred_resp_actMDS_w.proto;pred_resp_actMDS_w.newlow;pred_resp_actMDS_w.newmed;pred_resp_actMDS_w.newhigh;pred_resp_actMDS_w.newhigh_special];
pred_values_actMDS_w = pred_values_actMDS_w(:);

pred_values = [pred_values_coords_GCM;pred_values_act18_GCM;pred_values_actMDS_w]';
model_values = repelem(1:n_model,numel(pred_values_actMDS_w));%assume equal number of predictions per model
resp_cat_values = repelem(1:3,numel(itemtype_vec_6type));
resp_cat_values = repmat(resp_cat_values,[1 n_model]);
pat_cat_values = arrayfun(@(x) repelem(1:3,[x x x]),1/9*[numel(obs_old_resp),numel(obs_proto_resp),numel(obs_newlow_resp),numel(obs_newmed_resp),numel(obs_newhigh_resp),numel(obs_special_resp)],'UniformOutput',false);
pat_cat_values = repmat(cell2mat(pat_cat_values),[1 3*n_model]);
corr_values = pat_cat_values == resp_cat_values;

T = table(pat_cat_values',resp_cat_values',itemtype_values',obs_values',pred_values',corr_values',model_values',...
          'VariableNames',{'category_pat','category_resp','itemtype','obs_val','pred_val','corr_values','model'});
writetable(T,'scatterplot_data.csv')%'scatterplot_data.csv'
