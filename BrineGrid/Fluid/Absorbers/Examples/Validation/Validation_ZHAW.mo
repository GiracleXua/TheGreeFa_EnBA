within BrineGrid.Fluid.Absorbers.Examples.Validation;
model Validation_ZHAW
  extends Modelica.Icons.Example;

  extends BaseClasses.BaseValidation(
    redeclare final package Medium_b =
        Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution,
    T_air=273.15 + 24.87,
    T_abs=273.15 + 14.29,
    x_a=0.00946,
    X_s=0.318,
    m_flow_air=0.01885,
    m_flow_abs=0.1027,
    mNodes = 5,
    nNodes = 5,
    abs(
      redeclare Data.HDisNet_ZHAW                                   data,
      flowConf=BrineGrid.Fluid.Absorbers.Choices.FlowConfiguration.CounterCurrent,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
      redeclare model ThermalAir =
          HeatTransfer.Convection.Absorption.ConstantNusseltNumber_Absorption(Nu0=Nu),
      redeclare model MoistureAir =
          MoistureTransfer.Convection.Absorption.ConstantSherwoodNumber(Sh0=Sh)));

  parameter Real simulation_id = 66;
  parameter Modelica.SIunits.NusseltNumber Nu = 10;
  parameter Modelica.SIunits.NusseltNumberOfMassTransfer Sh = 10;
  annotation (experiment(StopTime=1800, __Dymola_Algorithm="Dassl"));

end Validation_ZHAW;
