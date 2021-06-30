%% PreSim Function for parallel simulations (FASense):
function inOut =  preSim_GA_FASense(in)
    CtrlSimPreLoad;
    global MEMS
    MEMS = struct();
    MEMS.sensFAPzr2 = in.Variables(1,1).Value;
    CtrlSimInitRun;

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