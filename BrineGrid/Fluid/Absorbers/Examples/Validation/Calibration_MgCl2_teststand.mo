within BrineGrid.Fluid.Absorbers.Examples.Validation;
model Calibration_MgCl2_teststand
  extends BaseClasses.BaseValidation(
    redeclare final package Medium_b =
        Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution,
    T_air=273.15 + 36.77,
    T_abs=273.15 + 37.9,
    x_a=0.01034,
    X_s=0.31,
    m_flow_air=0.0197,
    m_flow_abs=0.02666,
    mNodes = 10,
    nNodes = 10,
    abs(
      redeclare Data.Mg_teststand                                    data,
      flowConf=BrineGrid.Fluid.Absorbers.Choices.FlowConfiguration.CounterCurrent,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
      redeclare model ThermalAir =
          HeatTransfer.Convection.Absorption.ConstantNusseltNumber_Absorption (Nu0=Nu),
      redeclare model MoistureAir =
          MoistureTransfer.Convection.Absorption.ConstantSherwoodNumber (Sh0=Sh)));

  parameter Real simulation_id = 6;
  parameter Modelica.SIunits.NusseltNumber Nu = 5;
  parameter Modelica.SIunits.NusseltNumberOfMassTransfer Sh = 5;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end Calibration_MgCl2_teststand;
