function [state,optnew,changed] = CtrlSim_GA_output_func_SASense(OutputPlotFcnOptions,state,flag,args)
	TimeStamp = evalin('base','TimeStamp');
    optnew = 0;
    changed = 0;
    
    folder = ['C:\Users\kaminerd\Repo\GA_testing\GA Optimization Results\SA PZRs\RES-',TimeStamp];
    baseFileName = 'SA_Sense.xlsx';
    fullFileName = fullfile(folder, baseFileName);

    if state.Generation == 0
        if ~exist(folder, 'dir')
            mkdir(folder);
        end
        toExcel = {'sensSAPzr1','sensSAPzr3','sensPAPzr1','sensPAPzr3','PZR1_Err','PZR2_Err'};
        writecell(toExcel,fullFileName,'WriteMode','append')
    end
    
    disp(['Generation ',num2str(state.Generation),' done.']);
    toExcel = [state.Population,state.Score];
    writematrix(toExcel,fullFileName,'WriteMode','append')
    
end