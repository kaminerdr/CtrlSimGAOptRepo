%% CtrlSim_HFOV_fit_func 
function f = CtrlSim_HFOV_fit_func(x)
    global MEMS
    % Fitness function for calculating the RMS error of individual in
    % population compared to reference signal (x over time)
    % Non vectorized version of function
    % For vectorized, use: CtrlSim_HFOV_fit_func_vectorized()
    
    % load reference data signal (x over time)
%     load('C:\Users\kaminerd\Repo\GA_testing\reference_data','reference_data');
    
    % assign to base this individual's JSA,JFrame,Rcoil    
    SA_OL_NotchFilt_K = x(4);
    MEMS = struct();
    MEMS.JSA = x(1);
    MEMS.Jframe = x(2);
    MEMS.Rcoil = x(3);
    
    assignin('base','SA_OL_NotchFilt_K',eval('SA_OL_NotchFilt_K'));
    assignin('base','MEMS',eval('MEMS'));
    % Run simulation and collect results
%     Init_and_Run_CtrlSim;
    
    temp_results = evalin('base','SimLogsOut');
    
    elem = get(temp_results,'SA_Drive');
    SA_Drive = elem.Values;
    elem = get(temp_results,'ThetaH');
    ThetaH = elem.Values;
    
    MC_Data = evalin('base','MC_Data');

    [~,fov_exp_inv_func] = getFovExpFunc();
    HFOV_MEAS.full = 2*fov_exp_inv_func(MC_Data.projection.hFOV/2);
    HFOV_MEAS.hedge1 = fov_exp_inv_func(MC_Data.projection.hEdges(1));
    HFOV_MEAS.hedge2 = fov_exp_inv_func(MC_Data.projection.hEdges(2));

    H_elem = ThetaH.Data(length(ThetaH.Data)-round(0.2*length(ThetaH.Data)):end);
    HFOV_SIM.full = max(H_elem)-min(H_elem);
    HFOV_SIM.hedge1 = min(H_elem);
    HFOV_SIM.hedge2 = max(H_elem);

    min_err = abs((HFOV_MEAS.hedge1-HFOV_SIM.hedge1)/HFOV_MEAS.hedge1);
    max_err = abs((HFOV_MEAS.hedge2-HFOV_SIM.hedge2)/HFOV_MEAS.hedge2);
    ThetaH_err = sqrt(min_err^2+max_err^2);

    % Make Sure SA_Drive Measurement & Sim results are Synced
    try
        MEAS_Data = MC_Data.SA.SA.Vcmd;
        MEAS_Time = MC_Data.SA.time.time;
        SIM_Data = SA_Drive.Data;
        SIM_Time = SA_Drive.Time;
        
        MEAS_DATA_IDX = find(MEAS_Data<=0,1);
        moveToIDX = find(SIM_Data<MEAS_Data(MEAS_DATA_IDX),1);
        ShiftOver = SIM_Time(moveToIDX)-MEAS_Time(MEAS_DATA_IDX);
        SIM_Time = SIM_Time - ShiftOver;
        
        % % Make sure synced with plot
        % figure;
        % plot(MEAS_Time,MEAS_Data);
        % hold on;
        % plot(SIM_Time,SIM_Data);
        % grid on;
        
        % Make sure reference and simulation results are of same lengths
        % and calculate the distance between x's at each timeframe
        Error.XData = SIM_Time;
        Error.YData = zeros(1,length(SIM_Data))';
        sim_data_int = zeros(1,length(SIM_Data))';
        for i=1:length(Error.YData)
            temp = find(MEAS_Time > SIM_Time(i),1,'first');
            if (isempty(temp)) || (temp == 1)
                Error.YData(i) = 0;
                sim_data_int(i) = SIM_Data(i);
            else
                Error.YData(i) = abs(SIM_Data(i)-MEAS_Data(temp));
                sim_data_int(i) = SIM_Data(i);
            end
        end
        
        % Calculate the RMS error of simulation result
        SA_Drive_err = sqrt(sum(abs(Error.YData))/length(SIM_Data));
    catch
        SA_Drive_err = 2;
    end
    f = [ThetaH_err,SA_Drive_err];
    pause(0.05);
end












