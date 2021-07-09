within BrineGrid.Fluid.Absorbers.Examples.Validation;
model MgCl2_Chen_2016_Dehumidification
  "test MgCl2 with configuration of Chen_2016's geometry"
  extends BaseClasses.BaseValidation(
    redeclare final package Medium_b =
    BrineGrid.Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution,
    T_air = 273.15 + 25.6,
    T_abs = 273.15 + 14.9,
    x_a = 0.0162,
    X_s=0.23,
    m_flow_air = 1.85,
    m_flow_abs = 2.61,
    nNodes = 3,
    mNodes = 2,
    sou_air(use_T_in=true),
    abs(redeclare Data.Chen_2016 data,
        flowConf=BrineGrid.Fluid.Absorbers.Choices.FlowConfiguration.CounterCurrent,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
        redeclare model ThermalAir =
          HeatTransfer.Convection.Absorption.RandomPackings_ChenZhangYin,
        redeclare model MoistureAir =
          MoistureTransfer.Convection.Absorption.RandomPackings_ChenZhangYin));

  Modelica.Blocks.Sources.Constant const(k=333.15)
    annotation (Placement(transformation(extent={{-94,44},{-74,64}})));
equation
  connect(const.y, sou_air.T_in) annotation (Line(points={{-73,54},{-62,54}}, color={0,0,127}));
  annotation (experiment(StopTime=100));
end MgCl2_Chen_2016_Dehumidification;
