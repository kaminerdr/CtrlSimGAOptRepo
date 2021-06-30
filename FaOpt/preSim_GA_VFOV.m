%% PreSim Function for parallel simulations (thetaFA):
function inOut =  preSim_GA_thetaFA(in)
%     CtrlSimPreLoad;
    global MEMS
    MEMS = struct();
    MEMS.JFA = in.Variables(1,1).Value;
    CtrlSimInitRun;
    
    get_param('CtrlSim/MEMS/MEMS Model/MEMS', 'KtFA');
    set_param('CtrlSim/MEMS/MEMS Model/MEMS', 'KtFA', num2str(in.Variables(1,2).Value));
    
    sim_vars = whos;
    var_names = {sim_vars(:).name};
    inOut = in;
    
    for var_name = var_names
         var_val = eval(cell2mat(var_name));
         if ~isa(var_val,'Simulink.Variant')
            inOut = inOut.setVariable(cell2mat(var_name),var_val);
         end
    end    
end