function [state,optnew,changed] = CtrlSim_GA_output_func_FASense(OutputPlotFcnOptions,state,flag,args)
	TimeStamp = evalin('base','TimeStamp');
    optnew = 0;
    changed = 0;
    
    folder = ['C:\Users\kaminerd\Repo\GA_testing\GA Optimization Results\SA PZRs\RES-',TimeStamp];
    baseFileName = 'FA_Sense.xlsx';
    fullFileName = fullfile(folder, baseFileName);

    if state.Generation == 0
        if ~exist(folder, 'dir')
            mkdir(folder);
        end
        toExcel = {'sensSAPzr2','PZR2_Err'};
        writecell(toExcel,fullFileName,'WriteMode','append')
    end
    
    disp(['Generation ',num2str(state.Generation),' done.']);
    toExcel = [state.Population,state.Score];
    writematrix(toExcel,fullFileName,'WriteMode','append')
    
end