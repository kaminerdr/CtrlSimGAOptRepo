% CtrlSim_SASense_fit_func_vectorized
function fError = CtrlSim_FASense_fit_func_vectorized(x)
    % Fitness function for calculating the RMS error of individual in
    % population compared to reference signal (x over time)
    % Vectorized version of function
    % For non vectorized, use: CtrlSim_HFOV_fit_func()
    
    % load reference data signal (x over time)
    MC_Data = evalin('base','MC_Data');
    CtrlSimPreLoad;
    
    if all(size(x)==[1,1])
        pop ={'ind1'};
    else
        for i=1:size(x,1)
            pop{i} =['ind',num2str(i)];
        end
    end
    
    for jj=1:length(pop)
        
        in(jj) =  Simulink.SimulationInput(model_name);
        if all(size(x)==[1,1])
            in(jj) = in(jj).setVariable('sensFAPzr2',x(1));
        else
            in(jj) = in(jj).setVariable('sensFAPzr2',x(jj,1));
        end

        in(jj) = in(jj).setPreSimFcn(@(x) preSim_GA_FASense(x));
    end

    SimOut = parsim(in,'TransferBaseWorkspaceVariables', 'on');   
        
    try
        for j=1:length(pop)
            temp_results(j) = SimOut(j).SimLogsOut;
            temp_results(j).Name = [pop{j},'SimData'];
        end

        %     temp_results = evalin('base','SimLogsOut');
        for j=1:length(pop)
            elem = get(temp_results(j),'PZR2');
            PZR2 = elem.Values;
            PZR2_P2P = max(PZR2.Data)-min(PZR2.Data);
            Meas_PZR2_P2P = max(MC_Data.PreFilt.PreFilt.PZR2)-min(MC_Data.PreFilt.PreFilt.PZR2);            
            %%% PZR2 %%%
%             PZR2_MEAS_Data = MC_Data.PreFilt.PreFilt.PZR2;
%             PZR2_MEAS_Time = MC_Data.PreFilt.time.time;
%             PZR2_SIM_Data = PZR2.Data;
%             PZR2_SIM_Time = PZR2.Time;
% 
% %             MEAS_DATA_IDX = find(PZR1_MEAS_Data<=0,1);
% %             moveToIDX = find(PZR1_SIM_Data<PZR1_MEAS_Data(MEAS_DATA_IDX),1);
% %             ShiftOver = PZR1_SIM_Time(moveToIDX)-PZR1_MEAS_Time(MEAS_DATA_IDX);
% %             PZR1_SIM_Time = PZR1_SIM_Time - ShiftOver;
% 
%             % % Make sure synced with plot
%             % figure;
%             % plot(PZR1_MEAS_Data,PZR1_MEAS_Data);
%             % hold on;
%             % plot(PZR1_SIM_Time,PZR1_SIM_Data);
%             % grid on;
% 
%             % Make sure reference and simulation results are of same lengths
%             % and calculate the distance between x's at each timeframe
%             Error.XData = PZR2_SIM_Time;
%             Error.YData = zeros(1,length(PZR2_SIM_Data))';
%             sim_data_int = zeros(1,length(PZR2_SIM_Data))';
%             for i=1:length(Error.YData)
%                 temp = find(PZR2_MEAS_Time > PZR2_SIM_Time(i),1,'first');
%                 if (isempty(temp)) || (temp == 1)
%                     Error.YData(i) = 0;
%                     sim_data_int(i) = PZR2_SIM_Data(i);
%                 else
%                     Error.YData(i) = abs(PZR2_SIM_Data(i)-PZR2_MEAS_Data(temp));
%                     sim_data_int(i) = PZR2_SIM_Data(i);
%                 end
%             end

            % Calculate the RMS error of simulation result
            PZR2_err = abs(PZR2_P2P-Meas_PZR2_P2P);
            
                   
            fError(j,1:2) = [PZR2_err];
        end
    catch
        fError(j,1:2) = [1];
    end

%     pause(0.05);
end
