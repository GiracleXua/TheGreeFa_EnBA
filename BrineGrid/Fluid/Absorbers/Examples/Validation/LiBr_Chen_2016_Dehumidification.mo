within BrineGrid.Fluid.Absorbers.Examples.Validation;
model LiBr_Chen_2016_Dehumidification
  "run simulation with LiBr as dessicant using Chen_2016's model"
   extends BaseClasses.BaseValidation(
    redeclare final package Medium_b =
    BrineGrid.Media.LiquidDesiccants.LithiumBromideAqueousSolution_PatekKlomfar,
    T_air=273.15 + 25.6,
    T_abs=273.15 + 14.9,
    x=0.0162,
    X_w=Media.LiquidDesiccants.Functions.totalHumidityToMassFraction(x=x),
    X_s=0.23,
    m_flow_air=1.85,
    m_flow_abs=2.61,
    nNodes = 3,
    mNodes = 2,
    abs(
      redeclare Data.Chen_2016                                          data,
      flowConf=BrineGrid.Fluid.Absorbers.Choices.FlowConfiguration.CounterCurrent,
      redeclare model ThermalAir =
        HeatTransfer.Convection.Absorption.RandomPackings_ChenZhangYin,
      redeclare model MoistureAir =
        MoistureTransfer.Convection.Absorption.RandomPackings_ChenZhangYin),
    sou_air(use_T_in=true, use_X_in=false),
    sin_air(use_T=false, T=323.15));
  Modelica.Blocks.Sources.Constant const(k=333.15)
    annotation (Placement(transformation(extent={{-96,66},{-76,86}})));
equation
  connect(const.y, sou_air.T_in)
    annotation (Line(points={{-75,76},{-68,76},{-68,54},{-62,54}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end LiBr_Chen_2016_Dehumidification;
