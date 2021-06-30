%% Main Script for GA testing Fast Axis

% % Load reference data
% load('C:\Users\kaminerd\Repo\CtrlSimGUIRepo\F1032069\FA_Opened.mat');
% MC_Data = Opening;
% MC_Data.projection = FOV;

%%

problem = struct();
problem.solver = 'gamultiobj';
options = gamultiobj('defaults'); % Default options for GA solver.

problem.fitnessfcn = @CtrlSim_FASense_fit_func_vectorized;
% problem.nonlcon = cons();

%%%%%%%% For VFOV objective %%%%%%%%%
% problem.nvars = 2;% 4; % JFA=0.793e-12, KtFA=1.5
% problem.lb = [0.9*1.47e-14,0.6*1.5]; 
% problem.ub = [1.1*1.47e-14,1.1*1.5]; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% For SA Sensitivity objectives %%%
problem.nvars = 1; % MEMS.sensFAPzr2 = 7.0*180/pi*1e-3]
problem.lb = [0.85*7.0*180/pi*1e-3];
problem.ub = [1.15*7.0*180/pi*1e-3];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

options.Generations = 10;
options.Vectorized = 'on';
options.ParetoFraction = 1;
options.PopulationSize = 8;
options.PopInitRange = [problem.lb;problem.ub];
% options.EliteCount = 20;
options.MutationFcn = @mutationadaptfeasible;
options.CrossoverFraction = 1;
options.SelectionFnc = @selectiontournament;
% options.TolFun = 0;
% options.TolCon = 0;
% options.StallGenLimit = 10;
% options.HybridFcn = @fmincon;
% options.PlotFcns = @gaplotpareto;
options.PlotFcns = @gaplotrange;
options.OutputFcns = @CtrlSim_GA_output_func_FASense;
% options.OutputFcnsArgs = datestr(now,'mm-dd-yyyy HH-MM-SS');
% options.UseParallel = 1;
problem.options = options;
TimeStamp = datestr(now,'mm-dd-yyyy HH-MM-SS');

%%
[x,fval,exitflag,output,pop,scores] = gamultiobj(problem);

% save('C:\Users\kaminerd\Repo\GA_testing\GA Optimization Results\SA_Drive_HFOV_5_21_21.mat','pop','scores');


