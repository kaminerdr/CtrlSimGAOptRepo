%% PreSim Function for parallel simulations:
function inOut =  preSim_GA_HFOV(in)
    CtrlSimPreLoad;
    global MEMS
    MEMS = struct();
    MEMS.JSA = in.Variables(1,1).Value;
    MEMS.Jframe = in.Variables(1,2).Value;
    MEMS.Rcoil = in.Variables(1,3).Value;

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