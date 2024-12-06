clear
clc

within_val = .210*[.5,1,1.5]; 
c_val = .475*[.5,1,1.5];
length_within = length(within_val);
length_c = length(c_val);
for i_c = 1:length_c
    for i_wth = 1:length_within        
        params.between = 2.000;
        params.within = within_val(i_wth);
        params.sensitivity = c_val(i_c);
        params.response_scaling = 5.000;
        rng(1234);
        Pr_corr_overall = zeros(4,5,10000);
        for isim = 1:10000
            [~,~,Pr_corr_overall(:,:,isim)] = GCM(params,6); % concatenate results from each simulation of the experimental process
        end
        pred_results(:,:,i_wth,i_c) = mean(Pr_corr_overall,3);% average along the simulation dimension
    end
end

n_type = 5;
n_cond = 4;
cond_values = repmat(1:n_cond,[1,n_type*length_within*length_c]);
itemtype_values = repmat(repelem(1:n_type,n_cond),[1,length_within*length_c]);
pred_values = pred_results(:)';
within_values = repmat(repelem(1:length_within,n_type*n_cond),[1,length_c]);
c_values = repelem(1:length_c,n_type*n_cond*length_within);
T = table(c_values',within_values',itemtype_values',cond_values',pred_values',...
          'VariableNames',{'c','within','itemtype','condition','pred'});
writetable(T,'pred_data_robust.csv')