function [Pr_resp_pat,Pr_corr_pat,Pr_corr] = PM(params)

% Input: parameters as a structure array, number of dimensions to represent dot patterns (default to 6); 
% Output: predicted accuracy as an array [expt,cond,itemtype]
% similarity_per_item stores similarity between training items and 3 test
% items in NREP condition, Expt2 as a matrix  [test itemtype, training item]
% crit[i,j] is for experiment i, condition j
% define parameter values
low = params.low; med = params.med; high = params.high; 
% within = params.within; 
between = params.between; c = params.sensitivity;

% specify distortion levels for different itemtypes
% low = within*1.2; med = within*2.8; high = within*4.6;

n_train = 9*10; % number of unique training patterns presented per category
n_cond = 4;
n_cat = 3; 
n_dim = 6;
n_type = 5;
 
% construct the various test patterns to be
% used in this simulation, one pattern per test item type
prototype = between*rand(n_cat,n_dim); % same 3 prototypes across experiments
trainpat = cell(n_cond,n_cat);
for iexem_cat = 1:n_cat
    % the training patterns for each condition and category; same
    % across experiments
    trainpat{1,iexem_cat} = prototype(iexem_cat,:)+ low*randn(n_train,n_dim);
    trainpat{2,iexem_cat} = prototype(iexem_cat,:)+ med*randn(n_train,n_dim);
    trainpat{3,iexem_cat} = prototype(iexem_cat,:)+ high*randn(n_train,n_dim);
    trainpat{4,iexem_cat} = prototype(iexem_cat,:)+ [low*randn(n_train/3,n_dim);med*randn(n_train/3,n_dim);high*randn(n_train/3,n_dim)];
end


%% predict classification transfer

% simulate test pattern classification process
Pr_corr_pat = zeros(n_cond,n_cat*n_type);
Pr_resp_pat = zeros(n_cond,n_cat*n_type,n_cat);
Pr_corr = zeros(n_cond,n_type);
for icond = 1:n_cond
    for itype = 1:n_type
        sim_cats = zeros(1,n_cat);
            testpat(2,:) = prototype(1,:); % proto
            testpat(3,:) = prototype(1,:) + low*randn(1,n_dim); %low
            testpat(4,:) = prototype(1,:) + med*randn(1,n_dim); %med
            testpat(5,:) = prototype(1,:) + high*randn(1,n_dim); %high
            % sum up exemplar similarities
            for iexem_cat = 1:n_cat
                trainpat_catA = trainpat{icond,1};
                testpat(1,:) = trainpat_catA(1,:); %an arbitrary old pattern from the target category
                if icond == 4 && itype == 1
                    testpats_mix = trainpat_catA([1,31,61],:);
                end
                % for each category
%                 train_proto = prototype(iexem_cat,:);
                 train_proto = mean(trainpat{icond,iexem_cat},1);
                if icond == 4 && itype == 1
                    test_items = testpats_mix;
                    sims = exp(-c * sqrt(sum((train_proto - test_items).^2,2)));
                else
                    test_item = testpat(itype,:); % coord of a test pattern as a vector
                    sim = exp(-c * sqrt(sum((train_proto - test_item).^2)));% similarity measure between the two
                end
                % summed similarity for each category + response scaling
                if icond == 4 && itype == 1
                    sim_cats_old(iexem_cat,:) = sims;
                else
                    sim_cats(iexem_cat) = sim;
                end
            end
        
        % compute the classification probablities
        switch itype
            case 1
                if icond == 4
                    Pr_corr_old = mean(sim_cats_old(1,:)./sum(sim_cats_old,1));
                else
                    Pr_corr_old = sim_cats(1)/sum(sim_cats);
                end
%                 Pr_corr_pat(icond,1:3) = diag(tmp);
%                 Pr_corr_old = mean(Pr_corr_pat(icond,1:3));
%                 Pr_resp_pat(icond,1:3,:) = tmp;
            case 2
                Pr_corr_proto = sim_cats(1)/sum(sim_cats);
%                 Pr_corr_pat(icond,3+(1:3)) = diag(tmp);
%                 Pr_corr_proto = mean(Pr_corr_pat(icond,3+(1:3)));
%                 Pr_resp_pat(icond,3+(1:3),:) = tmp;
            case 3
                Pr_corr_newlow = sim_cats(1)/sum(sim_cats);
%                 Pr_corr_pat(icond,6+(1:3)) = diag(tmp);
%                 Pr_corr_newlow = mean(Pr_corr_pat(icond,6+(1:3)));
%                 Pr_resp_pat(icond,6+(1:3),:) = tmp;
            case 4
                Pr_corr_newmed = sim_cats(1)/sum(sim_cats);
%                 Pr_corr_pat(icond,9+(1:3)) = diag(tmp);
%                 Pr_corr_newmed = mean(Pr_corr_pat(icond,9+(1:3)));
%                 Pr_resp_pat(icond,9+(1:3),:) = tmp;
            case 5
                Pr_corr_newhigh = sim_cats(1)/sum(sim_cats);
%                 Pr_corr_pat(icond,12+(1:3)) = diag(tmp);
%                 Pr_corr_newhigh = mean(Pr_corr_pat(icond,12+(1:3)));
%                 Pr_resp_pat(icond,12+(1:3),:) = tmp;
        end
    end
    Pr_corr(icond,:) = [Pr_corr_old,Pr_corr_proto,Pr_corr_newlow,Pr_corr_newmed,Pr_corr_newhigh];
end
end


    

