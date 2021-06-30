%% CtrlSim_VFOV_fit_func
function fError = CtrlSim_VFOV_fit_func_vectorized_serial(x)
    %     global MEMS
    % Fitness function for calculating the RMS error of individual in
    % population compared to reference signal (x over time)
    % vectorized version of function
    % For non vectorized, use: CtrlSim_VFOV_fit_func()
     global MEMS
    
    % assign to base this individual's JFA,KtFA

    MC_Data = evalin('base','MC_Data');
    [~,fov_exp_inv_func] = getFovExpFunc();
    VFOV_MEAS.full = 2*fov_exp_inv_func(MC_Data.projection.vFOV/2);
    VFOV_MEAS.hedge1 = fov_exp_inv_func(MC_Data.projection.vEdges(1));
    VFOV_MEAS.hedge2 = fov_exp_inv_func(MC_Data.projection.vEdges(2));
    
     if all(size(x)==[1,2])
        pop ={'ind1'};
    else
        for i=1:size(x,1)
            pop{i} =['ind',num2str(i)];
        end
     end
    
    MEMS = struct();
    for jj=1:length(pop)
        if all(size(x)==[1,2])
            MEMS.JFA = x(1);
            get_param('CtrlSim/MEMS/MEMS Model/MEMS', 'KtFA');
            set_param('CtrlSim/MEMS/MEMS Model/MEMS', 'KtFA', num2str(x(2)));
        else
            MEMS.JFA = x(jj,1);
            get_param('CtrlSim/MEMS/MEMS Model/MEMS', 'KtFA');
            set_param('CtrlSim/MEMS/MEMS Model/MEMS', 'KtFA', num2str(x(jj,2)));

        end
        assignin('base','MEMS',eval('MEMS'));
        
        Init_and_Run_CtrlSim;
        temp_results(jj) = evalin('base','SimLogsOut');
    end
        
    try
        for j=1:length(pop)
            elem = get(temp_results(j),'ThetaFA');
            ThetaFA = elem.Values;

            V_elem = ThetaFA.Data(length(ThetaFA.Data)-round(0.2*length(ThetaFA.Data)):end);
            VFOV_SIM.full = max(V_elem)-min(V_elem);
            VFOV_SIM.hedge1 = min(V_elem);
            VFOV_SIM.hedge2 = max(V_elem);

            min_err = abs((VFOV_MEAS.hedge1-VFOV_SIM.hedge1)/VFOV_MEAS.hedge1);
            max_err = abs((VFOV_MEAS.hedge2-VFOV_SIM.hedge2)/VFOV_MEAS.hedge2);
            ThetaFA_err = sqrt(min_err^2+max_err^2);

            fError(j,1) = ThetaFA_err;
%             fError(j,1:2) = [min_err,max_err];
        end
    catch
%         f(j,1:2) = [0.5,0.5];
        fError(j,1) = 0.2;
%         fError(j,1:2) = [0.5,0.5];
    end
end






