%% Main Script for GA testing Slow Axis

% % Load reference data
% load('\\ger\ec\proj\ha\RSG\SA_3DCam\DanielleK\McLoggerRec\F1032069\SA_Opened.mat');

% load('C:\Users\kaminerd\Repo\CtrlSimGUIRepo\F1032069\SA_Opened.mat');
% MC_Data = Opening;
% MC_Data.projection = FOV;

%%

problem = struct();
problem.solver = 'gamultiobj';
options = gamultiobj('defaults'); % Default options for GA solver.

problem.fitnessfcn = @CtrlSim_SASense_fit_func_vectorized;
% problem.fitnessfcn = @CtrlSim_HFOV_fit_func_vectorized;
% problem.nonlcon = cons();

%%%%%%%% For HFOV objective %%%%%%%%%
% problem.nvars = 3;% 4; % JSA=0.793e-12;, JFrame=1.05e-12, Rcoil=3.08, NotchFilt1.K
% problem.lb = [0.85*0.793e-12,0.85*1.05e-12,0.85*3.08]; % ,0.05*0.016116072];
% problem.ub = [1.15*0.793e-12,1.15*1.05e-12,1.15*3.08]; % ,1.05*0.016116072];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% For SA Sensitivity objectives %%%
problem.nvars = 4; % sensSAPzr1,sensSAPzr3=(3/2)*180/pi*1e-3,sensPAPzr1,sensPAPzr3=(26/2)*180/pi*1e-3 
problem.lb = [0.85*(3/2)*180/pi*1e-3,0.85*(3/2)*180/pi*1e-3,0.85*(26/2)*180/pi*1e-3,0.85*(26/2)*180/pi*1e-3]; % ,0.05*0.016116072];
problem.ub = [1.15*(3/2)*180/pi*1e-3,1.15*(3/2)*180/pi*1e-3,1.15*(26/2)*180/pi*1e-3,1.15*(26/2)*180/pi*1e-3]; % ,1.05*0.016116072];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

options.Generations = 16;
options.Vectorized = 'on';
options.ParetoFraction = 1;
options.PopulationSize = 16;
options.PopInitRange = [problem.lb;problem.ub];
% options.EliteCount = 20;
options.MutationFcn = @mutationadaptfeasible;
options.CrossoverFraction = 1;
options.SelectionFnc = @selectiontournament;
% options.TolFun = 0;
% options.TolCon = 0;
% options.StallGenLimit = 10;
% options.HybridFcn = @fmincon;
options.PlotFcns = @gaplotpareto;
% options.PlotFcns = @gaplotrange;
options.OutputFcns = @CtrlSim_GA_output_func_SASense;
% options.OutputFcnsArgs = datestr(now,'mm-dd-yyyy HH-MM-SS');
% options.UseParallel = 1;
problem.options = options;
TimeStamp = datestr(now,'mm-dd-yyyy HH-MM-SS');

%%
[x,fval,exitflag,output,pop,scores] = gamultiobj(problem);

% save('C:\Users\kaminerd\Repo\GA_testing\GA Optimization Results\SA_Drive_HFOV_5_21_21.mat','pop','scores');


