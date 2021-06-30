function [state,optnew,changed] = CtrlSim_GA_output_func_VFOV(OutputPlotFcnOptions,state,flag,args)
	TimeStamp = evalin('base','TimeStamp');
    optnew = 0;
    changed = 0;
    
    folder = ['C:\Users\kaminerd\Repo\GA_testing\GA Optimization Results\RES-',TimeStamp];
    baseFileName = 'VFOV.xlsx';
    fullFileName = fullfile(folder, baseFileName);

    if state.Generation == 0
        if ~exist(folder, 'dir')
            mkdir(folder);
        end
        toExcel = {'JFA','KtFA','ThetaH_err'};
        writecell(toExcel,fullFileName,'WriteMode','append')
    end
    
    disp(['Generation ',num2str(state.Generation),' done.']);
    toExcel = [state.Population,state.Score];
    writematrix(toExcel,fullFileName,'WriteMode','append')
    

end