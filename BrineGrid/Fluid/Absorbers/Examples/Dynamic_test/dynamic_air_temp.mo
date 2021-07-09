within BrineGrid.Fluid.Absorbers.Examples.Dynamic_test;
model dynamic_air_temp

  extends Modelica.Icons.Example;
  // Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution,
  // Media.LiquidDesiccants.MagnesiumChloride_aqueous_solution_MgCl2_H2O,
  extends BrineGrid.Fluid.Absorbers.Examples.Validation.BaseClasses.BaseValidation(
    redeclare final package Medium_b =
        Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution,
    T_air=273.15 + 24.87,
    T_abs=273.15 + 15,
    x_a=0.01246,
    X_s=0.328,
    m_flow_air=0.01885,
    m_flow_abs=0.1027,
    mNodes = 5,
    nNodes = 5,
    abs(
      redeclare Data.Mg_dempav                                         data,
      flowConf=BrineGrid.Fluid.Absorbers.Choices.FlowConfiguration.CounterCurrent,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
      redeclare model ThermalAir =
          HeatTransfer.Convection.Absorption.ConstantNusseltNumber_Absorption(Nu0 = Nu),
      redeclare model MoistureAir =
          MoistureTransfer.Convection.Absorption.ConstantSherwoodNumber(Sh0 = Sh)),
    sou_abs(use_T_in=true),
    sou_air(use_T_in=false));

  parameter Real simulation_id = 66;
  parameter Modelica.SIunits.NusseltNumber Nu = 5.1;
  parameter Modelica.SIunits.NusseltNumberOfMassTransfer Sh = 6.7;
  Modelica.Blocks.Sources.Step step(
    height=15,
    offset=T_abs,
    startTime=1000)
    annotation (Placement(transformation(extent={{-96,76},{-78,94}})));
equation
  connect(step.y, sou_abs.T_in) annotation (Line(points={{-77.1,85},{89.45,85},
          {89.45,54},{62,54}}, color={0,0,127}));
  annotation (experiment(
      StopTime=20000,
      Interval=10,
      __Dymola_Algorithm="Dassl"));
end dynamic_air_temp;
