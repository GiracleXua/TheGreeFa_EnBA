within BrineGrid.Fluid.Absorbers.Examples.Validation;
model Validation_MgCl2_teststand_chtc
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
    mNodes = 5,
    nNodes = 5,
    abs(
      redeclare Data.Mg_teststand                                      data,
      flowConf=BrineGrid.Fluid.Absorbers.Choices.FlowConfiguration.CounterCurrent,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
      redeclare model ThermalAir =
          HeatTransfer.Convection.Absorption.ConstantHeatTransferCoefficient(alpha0 = alpha),
      redeclare model MoistureAir =
          MoistureTransfer.Convection.Absorption.ConstantMassTransferCoefficient2
          (                                                                       beta0 = beta)));

  parameter Real simulation_id = 66;
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha = 3;
  parameter BrineGrid.SIunits.CoefficientOfMassTransfer2 beta=0.03;
end Validation_MgCl2_teststand_chtc;
