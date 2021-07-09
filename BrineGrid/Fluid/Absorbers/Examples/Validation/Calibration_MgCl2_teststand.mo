within BrineGrid.Fluid.Absorbers.Examples.Validation;
model Calibration_MgCl2_teststand
  extends BaseClasses.BaseValidation(
    redeclare final package Medium_b =
        Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution,
    T_air=273.15 + 25.6,
    T_abs=273.15 + 14.9,
    x_a=0.0162,
    X_s=0.18,
    m_flow_air=0.185,
    m_flow_abs=0.261,
    mNodes = 5,
    nNodes = 5,
    abs(
      redeclare Data.Chen_2016                                         data,
      flowConf=BrineGrid.Fluid.Absorbers.Choices.FlowConfiguration.CounterCurrent,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare model ThermalAir =
          HeatTransfer.Convection.Absorption.ConstantNusseltNumber_Absorption (Nu0=Nu),
      redeclare model MoistureAir =
          MoistureTransfer.Convection.Absorption.ConstantSherwoodNumber (Sh0=Sh)));

  parameter Real simulation_id = 6;
  parameter Modelica.SIunits.NusseltNumber Nu = 15;
  parameter Modelica.SIunits.NusseltNumberOfMassTransfer Sh = 15;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end Calibration_MgCl2_teststand;
