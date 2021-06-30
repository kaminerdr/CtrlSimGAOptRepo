%% PreSim Function for parallel simulations of SA Sensors:
function inOut =  preSim_GA_SASense(in)
    CtrlSimPreLoad;
    global MEMS
    MEMS = struct();
    MEMS.sensSAPzr1 = in.Variables(1,1).Value;
    MEMS.sensSAPzr3 = in.Variables(1,2).Value;
    MEMS.sensPAPzr1 = in.Variables(1,3).Value;
    MEMS.sensPAPzr3 = in.Variables(1,3).Value;

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