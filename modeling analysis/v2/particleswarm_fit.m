clear;
clc;


% read in data files
observed_data = struct;
old_data = readmatrix("test_accuracy_old.csv");
observed_data.old = old_data(2:end,2:end);
proto_data = readmatrix("test_accuracy_proto.csv");
observed_data.proto = proto_data(2:end,2:end);
newlow_data = readmatrix("test_accuracy_newlow.csv");
observed_data.newlow = newlow_data(2:end,2:end);
newmed_data = readmatrix("test_accuracy_newmed.csv");
observed_data.newmed = newmed_data(2:end,2:end);
newhigh_data = readmatrix("test_accuracy_newhigh.csv");
observed_data.newhigh = newhigh_data(2:end,2:end);
newhigh_hard_data = readmatrix("test_accuracy_newhigh_hard.csv");
observed_data.newhigh_hard = newhigh_hard_data(2:end,2:end);



init_swarm = [];

fun = @(x) calc_error(observed_data,x); % x is a row vector of parameters
lb = [.001, 1, .001, .001, .001];
ub = [20,5,1,1,1];
hybridopts = optimoptions('patternsearch','TolMesh',1e-3);
options = optimoptions('particleswarm','FunctionTolerance',1e-4,'MaxStallIterations',30,...
                       'InitialSwarmMatrix',init_swarm,'SwarmSize',50,...
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
text = {'c','gamma','w_color','w_vertline_high','w_height_high';
        best_params(1),best_params(2),best_params(3),best_params(4),best_params(5)};

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

                   



