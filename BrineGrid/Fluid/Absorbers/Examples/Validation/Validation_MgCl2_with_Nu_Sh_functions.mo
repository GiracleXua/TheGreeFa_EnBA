within BrineGrid.Fluid.Absorbers.Examples.Validation;
model Validation_MgCl2_with_Nu_Sh_functions
  extends Modelica.Icons.Example;
  // Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution,
  // Media.LiquidDesiccants.MagnesiumChloride_aqueous_solution_MgCl2_H2O,
  extends BaseClasses.BaseValidation(
    redeclare final package Medium_b =
        Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution,
    T_air=273.15 + 24.87,
    T_abs=273.15 + 24.87,
    x_a=0.01246,
    X_s=0.328,
    m_flow_air=0.01885,
    m_flow_abs=0.1027,
    mNodes = 8,
    nNodes = 8,
    abs(
      redeclare Data.Mg_dempav                                         data,
      flowConf=BrineGrid.Fluid.Absorbers.Choices.FlowConfiguration.CounterCurrent,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
      redeclare model ThermalAir =
        HeatTransfer.Convection.Absorption.RandomPackings_ChenZhangYin,
      redeclare model MoistureAir =
        MoistureTransfer.Convection.Absorption.RandomPackings_ChenZhangYin));

  parameter Real simulation_id = 696;
  annotation (experiment(StopTime=1800, __Dymola_Algorithm="Dassl"));
end Validation_MgCl2_with_Nu_Sh_functions;
