clear;
clc;
% T = readtable('pattern_info_test.csv');
% 
% 
% % read in data files
% observed_data = struct;
% observed_data.old = T(T.itemtype==1,["condition","PrCorr"]);
% observed_data.proto = T(T.itemtype==2,["condition","PrCorr"]);
% observed_data.newlow = T(T.itemtype==3,["condition","PrCorr"]);
% observed_data.newmed = T(T.itemtype==4,["condition","PrCorr"]);
% observed_data.newhigh = T(T.itemtype==5,["condition","PrCorr"]);
observed_data = readmatrix("PrCorr_obs_high90");


init_swarm = [.179,.417,.685,2.057,1.158,1.436];

fun = @(x) calc_error(observed_data,x); % x is a row vector of parameters
lb = [0,0,0,0,0,1];
ub = [10,10,10,10,5,2];
hybridopts = optimoptions('patternsearch','TolMesh',1e-3);
options = optimoptions('particleswarm','FunctionTolerance',1e-4,'MaxStallIterations',60,...%80
                       'InitialSwarmMatrix',init_swarm,'SwarmSize',40,...
                       'Display','iter','DisplayInterval',1,...
                       'HybridFcn',{'patternsearch',hybridopts},...
                       'OutputFcn',@show_params);
nvars = length(lb);
[param,fit,exitflag,output] = particleswarm(fun,nvars,lb,ub,options)  

function stop = show_params(optimValues,state)
stop = false; % This function does not stop the solver
global FinalSwarmMatrix
best_params = optimValues.bestx;
text = {'low','med','high','between','c','gamma';
        best_params(1),best_params(2),best_params(3),best_params(4),best_params(5),best_params(6)};

switch state
    case 'init'
        fprintf('Starting parameters:\n') 
        fprintf('%s = %4.3f;\n',text{:})        
    case 'iter'
        fprintf('Best parameters:\n')       
        fprintf('%s = %4.3f;\n',text{:})  
    case 'done' 
        FinalSwarmMatrix = optimValues.swarm;
        fprintf('Final particle positions:\n')
        disp(FinalSwarmMatrix)   
        fprintf('\n')
end
end

                   



