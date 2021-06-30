% CtrlSim_SASense_fit_func_vectorized
function fError = CtrlSim_SASense_fit_func_vectorized(x)
    % Fitness function for calculating the RMS error of individual in
    % population compared to reference signal (x over time)
    % Vectorized version of function
    % For non vectorized, use: CtrlSim_HFOV_fit_func()
    
    % load reference data signal (x over time)
    MC_Data = evalin('base','MC_Data');
    CtrlSimPreLoad;
    
    if all(size(x)==[1,4])
        pop ={'ind1'};
    else
        for i=1:size(x,1)
            pop{i} =['ind',num2str(i)];
        end
    end
    
    for jj=1:length(pop)
        
        in(jj) =  Simulink.SimulationInput(model_name);
        if all(size(x)==[1,4])
            in(jj) = in(jj).setVariable('sensSAPzr1',x(1));
            in(jj) = in(jj).setVariable('sensSAPzr3',x(2));
            in(jj) = in(jj).setVariable('sensPAPzr1',x(3));
            in(jj) = in(jj).setVariable('sensPAPzr3',x(4));
        else
            in(jj) = in(jj).setVariable('sensSAPzr1',x(jj,1));
            in(jj) = in(jj).setVariable('sensSAPzr3',x(jj,2));
            in(jj) = in(jj).setVariable('sensPAPzr1',x(jj,3));
            in(jj) = in(jj).setVariable('sensPAPzr3',x(jj,4));
        end

        in(jj) = in(jj).setPreSimFcn(@(x) preSim_GA_SASense(x));
    end

    SimOut = parsim(in,'TransferBaseWorkspaceVariables', 'on');   
        
    try
        for j=1:length(pop)
            temp_results(j) = SimOut(j).SimLogsOut;
            temp_results(j).Name = [pop{j},'SimData'];
        end

        %     temp_results = evalin('base','SimLogsOut');
        for j=1:length(pop)
            elem = get(temp_results(j),'PZR1');
            PZR1 = elem.Values;
            elem = get(temp_results(j),'PZR3');
            PZR3 = elem.Values;

           
            %%% PZR1 %%%
            PZR1_MEAS_Data = MC_Data.PreFilt.PreFilt.PZR1;
            PZR1_MEAS_Time = MC_Data.PreFilt.time.time;
            PZR1_SIM_Data = PZR1.Data;
            PZR1_SIM_Time = PZR1.Time;

%             MEAS_DATA_IDX = find(PZR1_MEAS_Data<=0,1);
%             moveToIDX = find(PZR1_SIM_Data<PZR1_MEAS_Data(MEAS_DATA_IDX),1);
%             ShiftOver = PZR1_SIM_Time(moveToIDX)-PZR1_MEAS_Time(MEAS_DATA_IDX);
%             PZR1_SIM_Time = PZR1_SIM_Time - ShiftOver;

            % % Make sure synced with plot
            % figure;
            % plot(PZR1_MEAS_Data,PZR1_MEAS_Data);
            % hold on;
            % plot(PZR1_SIM_Time,PZR1_SIM_Data);
            % grid on;

            % Make sure reference and simulation results are of same lengths
            % and calculate the distance between x's at each timeframe
            Error.XData = PZR1_SIM_Time;
            Error.YData = zeros(1,length(PZR1_SIM_Data))';
            sim_data_int = zeros(1,length(PZR1_SIM_Data))';
            for i=1:length(Error.YData)
                temp = find(PZR1_MEAS_Time > PZR1_SIM_Time(i),1,'first');
                if (isempty(temp)) || (temp == 1)
                    Error.YData(i) = 0;
                    sim_data_int(i) = PZR1_SIM_Data(i);
                else
                    Error.YData(i) = abs(PZR1_SIM_Data(i)-PZR1_MEAS_Data(temp));
                    sim_data_int(i) = PZR1_SIM_Data(i);
                end
            end

            % Calculate the RMS error of simulation result
            PZR1_err = sqrt(sum(abs(Error.YData))/length(PZR1_SIM_Data));
            
            %%% PZR3 %%%
            PZR3_MEAS_Data = MC_Data.PreFilt.PreFilt.PZR3;
            PZR3_MEAS_Time = MC_Data.PreFilt.time.time;
            PZR3_SIM_Data = PZR3.Data;
            PZR3_SIM_Time = PZR3.Time;

%             MEAS_DATA_IDX = find(PZR3_MEAS_Data<=0,1);
%             moveToIDX = find(PZR3_SIM_Data<PZR3_MEAS_Data(MEAS_DATA_IDX),1);
%             ShiftOver = PZR3_SIM_Time(moveToIDX)-PZR3_MEAS_Time(MEAS_DATA_IDX);
%             PZR3_SIM_Time = PZR3_SIM_Time - ShiftOver;

            % % Make sure synced with plot
            % figure;
            % plot(MEAS_Time,MEAS_Data);
            % hold on;
            % plot(SIM_Time,SIM_Data);
            % grid on;

            % Make sure reference and simulation results are of same lengths
            % and calculate the distance between x's at each timeframe
            Error.XData = PZR3_SIM_Time;
            Error.YData = zeros(1,length(PZR3_SIM_Data))';
            sim_data_int = zeros(1,length(PZR3_SIM_Data))';
            for i=1:length(Error.YData)
                temp = find(PZR3_MEAS_Time > PZR3_SIM_Time(i),1,'first');
                if (isempty(temp)) || (temp == 1)
                    Error.YData(i) = 0;
                    sim_data_int(i) = PZR3_SIM_Data(i);
                else
                    Error.YData(i) = abs(PZR3_SIM_Data(i)-PZR3_MEAS_Data(temp));
                    sim_data_int(i) = PZR3_SIM_Data(i);
                end
            end

            % Calculate the RMS error of simulation result
            PZR3_err = sqrt(sum((Error.YData).^2)/length(PZR3_MEAS_Data));
                        
            fError(j,1:2) = [PZR1_err,PZR3_err];
        end
    catch
        fError(j,1:2) = [1,1];
    end

%     pause(0.05);
end
