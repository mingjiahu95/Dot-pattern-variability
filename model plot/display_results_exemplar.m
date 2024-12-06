clear
clc
cond = 2;
params.S_p = 0.536;
params.S_l = 0.503;
params.S_m = 0.347;
params.S_h = 0.271;
params.S_c = 0.195;
params.gamma = 1.651;
[~,~,pred_overall_baseline_E] = GCM_baseline(params,cond);
params.c = .103;
params.gamma = 1;
[~,~,pred_overall_coords_E] = GCM_coords18(params,cond);
params.c = .140;
params.gamma = 1;
[~,~,pred_overall_act18_E] = GCM_activation18(params,cond);
params.c = .211;
params.gamma = 1.000;
weights = [.547,.435,.018];
[~,~,pred_overall_actMDS_E] = GCM_activationMDS(params,weights);


params.S_l = 0.909;
params.S_m = 0.592;
params.S_h = 0.327;
params.S_c = 0.190;
params.gamma = 1.000;
[~,~,pred_overall_baseline_P] = PM_baseline(params,cond);
params.c = 0.088;
params.gamma = 1.000;
[~,~,pred_overall_coords_P] = PM_coords18(params,cond);
params.c = 0.091;
params.gamma = 1.000;
[~,~,pred_overall_act18_P] = PM_activation18(params,cond);
params.c = .191;
params.gamma = 1.000;
weights = [.575,.407,.018];
[~,~,pred_overall_actMDS_P] = CM_activationMDS(params,weights);

%% observed data
T = readtable('pattern_info_test.csv');
obs_old = T{T.condition==cond & T.itemtype==1,"PrCorr"};
obs_proto = T{T.condition==cond & T.itemtype==2,"PrCorr"};
obs_newlow = T{T.condition==cond & T.itemtype==3,"PrCorr"};
obs_newmed = T{T.condition==cond & T.itemtype==4,"PrCorr"};
obs_newhigh = T{T.condition==cond & T.itemtype==5,"PrCorr"};
obs_special = T{T.condition==cond & T.itemtype==6,"PrCorr"};

%% bar plot
obs_values = [mean(obs_old),mean(obs_proto),mean(obs_newlow),mean(obs_newmed),mean(obs_newhigh),mean(obs_special)];

n_model = 4;
n_itemtype = 6;
itemtype_vec = 1:6;

itemtype_num_vec = [numel(obs_old);numel(obs_proto);numel(obs_newlow);numel(obs_newmed);numel(obs_newhigh);numel(obs_special)];
pred_values_baseline_E = pred_overall_baseline_E;
pred_values_coords_E = pred_overall_coords_E;
pred_values_act18_E = pred_overall_act18_E;
pred_values_actMDS_E = pred_overall_actMDS_E;
pred_values_baseline_P = pred_overall_baseline_P;
pred_values_coords_P = pred_overall_coords_P;
pred_values_act18_P = pred_overall_act18_P;
pred_values_actMDS_P = pred_overall_actMDS_P;

itemtype_values = repmat(itemtype_vec,[1 n_model*2]);
pred_values = [pred_values_baseline_E,pred_values_coords_E,pred_values_act18_E,pred_values_actMDS_E,pred_values_baseline_P,pred_values_coords_P,pred_values_act18_P,pred_values_actMDS_P];
model_values = repmat(repelem(1:4,n_itemtype),[1 2]);
type_values = repelem(1:2,n_model*n_itemtype);

T1 = table(itemtype_vec',obs_values',...
          'VariableNames',{'itemtype','obs_val'});
T2 = table(itemtype_values',pred_values',model_values',type_values',...
          'VariableNames',{'itemtype','pred_val','model','type'});
writetable(T1,'obs_data.csv')
writetable(T2,'modelpred_data.csv')
%% scatterplot MDS 
% model 1-5: GCM_act18, GCM_actMDS_nw, GCM_actMDS_w, PM_actMDS_w,CM_actMDS_w
% model 1-3: GCM_act18_w,PM_act18_w,CM_actMDS_w
% n_model = 1;
% obs_vec_6type = [obs_old;obs_proto;obs_newlow;obs_newmed;obs_newhigh;obs_special];
% obs_vec_6type = obs_vec_6type(:);
% obs_values = repmat(obs_vec_6type,[n_model 1])';
% itemtype_vec_6type = repelem(1:6,1/3*[numel(obs_old),numel(obs_proto),numel(obs_newlow),numel(obs_newmed),numel(obs_newhigh),numel(obs_special)]);
% itemtype_values = repmat(itemtype_vec_6type,[1 3*n_model]);

% pred_values_baseline_GCM = [pred_resp_baseline_GCM.old;pred_resp_baseline_GCM.proto;pred_resp_baseline_GCM.newlow;pred_resp_baseline_GCM.newmed;pred_resp_baseline_GCM.newhigh;pred_resp_baseline_GCM.newhigh_special];
% pred_values_baseline_GCM = pred_values_baseline_GCM(:);
% pred_values_coords_GCM = [pred_resp_coords_GCM.old;pred_resp_coords_GCM.proto;pred_resp_coords_GCM.newlow;pred_resp_coords_GCM.newmed;pred_resp_coords_GCM.newhigh;pred_resp_coords_GCM.newhigh_special];
% pred_values_coords_GCM = pred_values_coords_GCM(:);
% pred_values_act18_GCM = [pred_resp_act18_GCM.old;pred_resp_act18_GCM.proto;pred_resp_act18_GCM.newlow;pred_resp_act18_GCM.newmed;pred_resp_act18_GCM.newhigh;pred_resp_act18_GCM.newhigh_special];
% pred_values_act18_GCM = pred_values_act18_GCM(:);
% pred_values_actMDS_w = [pred_resp_actMDS_w.old;pred_resp_actMDS_w.proto;pred_resp_actMDS_w.newlow;pred_resp_actMDS_w.newmed;pred_resp_actMDS_w.newhigh;pred_resp_actMDS_w.newhigh_special];
% pred_values_actMDS_w = pred_values_actMDS_w(:);

% pred_values = pred_values_actMDS_w';
% model_values = repelem(1:n_model,numel(pred_values_actMDS_w));
% resp_cat_values = repelem(1:3,numel(itemtype_vec_6type));
% resp_cat_values = repmat(resp_cat_values,[1 n_model]);
% pat_cat_values = arrayfun(@(x) repelem(1:3,[x x x]),1/9*[numel(obs_old),numel(obs_proto),numel(obs_newlow),numel(obs_newmed),numel(obs_newhigh),numel(obs_special)],'UniformOutput',false);
% pat_cat_values = repmat(cell2mat(pat_cat_values),[1 3*n_model]);
% corr_values = pat_cat_values == resp_cat_values;

% T = table(pat_cat_values',resp_cat_values',itemtype_values',obs_values',pred_values',corr_values',model_values',...
%           'VariableNames',{'category_pat','category_resp','itemtype','obs_val','pred_val','corr_values','model'});
% writetable(T,'scatterplot_data_MDS.csv')%'scatterplot_data.csv'
