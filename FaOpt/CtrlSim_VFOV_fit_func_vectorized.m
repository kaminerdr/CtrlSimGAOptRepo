%% CtrlSim_VFOV_fit_func
function fError = CtrlSim_VFOV_fit_func_vectorized(x)
    %     global MEMS
    % Fitness function for calculating the RMS error of individual in
    % population compared to reference signal (x over time)
    % vectorized version of function
    % For non vectorized, use: CtrlSim_VFOV_fit_func()
  
    MC_Data = evalin('base','MC_Data');
    [~,fov_exp_inv_func] = getFovExpFunc();
    VFOV_MEAS.full = 2*fov_exp_inv_func(MC_Data.projection.vFOV/2);
    VFOV_MEAS.hedge1 = fov_exp_inv_func(MC_Data.projection.vEdges(1));
    VFOV_MEAS.hedge2 = fov_exp_inv_func(MC_Data.projection.vEdges(2));
    CtrlSimPreLoad;

    if all(size(x)==[1,2])
        pop ={'ind1'};
    else
        for i=1:size(x,1)
            pop{i} =['ind',num2str(i)];
        end
    end
    % model_name = 'CtrlSim';
    temp_results = Simulink.SimulationData.Dataset;

    for jj=1:length(pop)
        %     IS_LEGACY = ~(j-1);
        in(jj) =  Simulink.SimulationInput(model_name);
        %     in(j) = in(j).setVariable('legacy_flag',IS_LEGACY);
        if all(size(x)==[1,3])
            in(jj) = in(jj).setVariable('JFA',x(1));
            in(jj) = in(jj).setVariable('KtFA',x(2));
        else
            in(jj) = in(jj).setVariable('JFA',x(jj,1));
            in(jj) = in(jj).setVariable('KtFA',x(jj,2));

        end
        in(jj) = in(jj).setPreSimFcn(@(x) preSim_GA_thetaFA(x));
    end

    SimOut = parsim(in,'TransferBaseWorkspaceVariables', 'on');

    try
        for j=1:length(pop)
            temp_results(j) = SimOut(j).SimLogsOut;
            temp_results(j).Name = [pop{j},'SimData'];
        end

        %     temp_results = evalin('base','SimLogsOut');
        for j=1:length(pop)
            try
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
            catch
                 fError(j,1) = 2;
            end
        end
    catch
%         f(j,1:2) = [0.5,0.5];
        fError(j,1) = 0.2;
%         fError(j,1:2) = [0.5,0.5];
    end
end






