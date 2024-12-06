clear;
clc;
T = readtable('pattern_info_test.csv');
cond = 2;


% read in data files
observed_data = struct;
observed_data.old = T(T.itemtype==1,["condition","N_A","N_B","N_C"]);
observed_data.proto = T(T.itemtype==2,["condition","N_A","N_B","N_C"]);
observed_data.newlow = T(T.itemtype==3,["condition","N_A","N_B","N_C"]);
observed_data.newmed = T(T.itemtype==4,["condition","N_A","N_B","N_C"]);
observed_data.newhigh = T(T.itemtype==5,["condition","N_A","N_B","N_C"]);
observed_data.newhigh_special = T(T.itemtype==6,["condition","N_A","N_B","N_C"]);


init_swarm = [.191,.575,.407];

fun = @(x) calc_error(observed_data,x,cond); % x is a row vector of parameters
lb = [.00001,0,0];%[.001,.001,.001,.001];
ub = [5,1,1];%[1,1,1,1];
hybridopts = optimoptions('patternsearch','TolMesh',1e-3);
options = optimoptions('particleswarm','FunctionTolerance',1e-4,'MaxStallIterations',60,...%80
                       'InitialSwarmMatrix',init_swarm,'SwarmSize',80,...
                       'Display','iter','DisplayInterval',1,...
                       'HybridFcn',{'patternsearch',hybridopts},...
                       'OutputFcn',@show_params,...
                       'UseParallel',true);
nvars = length(lb);
[param,fit,exitflag,output] = particleswarm(fun,nvars,lb,ub,options)  

function stop = show_params(optimValues,state)
stop = false; % This function does not stop the solver
global FinalSwarmMatrix
best_params = optimValues.bestx;
% text = {'S_l','S_m','S_h','S_c','gamma';
%         best_params(1),best_params(2),best_params(3),best_params(4),1};
text = {'c','gamma','w1','w2','w3';
        best_params(1),1,best_params(2),best_params(3),1-best_params(2)-best_params(3)};

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

                   



