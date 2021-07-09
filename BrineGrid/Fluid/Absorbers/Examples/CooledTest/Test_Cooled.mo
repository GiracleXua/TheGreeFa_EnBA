within BrineGrid.Fluid.Absorbers.Examples.CooledTest;
model Test_Cooled
  extends Modelica.Icons.Example;
  replaceable package Medium_b =
    BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar
    "Medium model for absorbent";
  replaceable package Medium_a =
    BrineGrid.Media.LiquidDesiccants.Air
                       "Medium model for moist air";
  replaceable package Medium_c =
    BrineGrid.Media.Water
                      "Medium model for moist air";

  parameter Modelica.SIunits.AbsolutePressure p=101325;
  parameter Modelica.SIunits.Diameter diameter=0.1524;
  parameter Modelica.SIunits.Height height=0.41;
  parameter Real a(unit="m2/m3")=223;
  parameter Real epsilon=0.8 "Void area";
  parameter Modelica.SIunits.Diameter deq=0.0107 "Hydraulic diameter";
  parameter Modelica.SIunits.Length coolingLength=2.0
    "Length of cooling fluid flow channel";
  parameter Modelica.SIunits.Temperature T_air=273.15+21.8;
  parameter Modelica.SIunits.Temperature T_abs=273.15+16.8;
  parameter Modelica.SIunits.Temperature T_cool=273.15+10;
  parameter Modelica.SIunits.MassFraction X_wat=BrineGrid.Media.LiquidDesiccants.Functions.totalHumidityToMassFraction(
                                                                                            x=0.0112);
  parameter Modelica.SIunits.MassFraction[Medium_a.nX] X_air={X_wat, 1 - X_wat};
  parameter Modelica.SIunits.MassFraction X_s=0.31;
  parameter Modelica.SIunits.MassFraction[Medium_b.nX] X_abs={1 - X_s, X_s};
  parameter Modelica.SIunits.MassFraction[Medium_c.nX] X_cool=Medium_c.reference_X;
  parameter Modelica.SIunits.MassFlowRate m_flow_air=0.0231;
  parameter Modelica.SIunits.MassFlowRate m_flow_abs=0.3071;
  parameter Modelica.SIunits.MassFlowRate m_flow_cool=0.3071;
  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal_air=m_flow_air;
  parameter Modelica.SIunits.AbsolutePressure dp_nominal_air=50;
  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal_abs=m_flow_abs;
  parameter Modelica.SIunits.AbsolutePressure dp_nominal_abs=50;
  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal_cool=m_flow_cool;
  parameter Modelica.SIunits.AbsolutePressure dp_nominal_cool=50;
  parameter Integer nNodes=2;
  parameter Integer mNodes=2;
  Cooled.CooledAbsorber cooAbs(
    redeclare package Medium_b = Medium_b,
    redeclare package Medium_a = Medium_a,
    redeclare package Medium_c = Medium_c,
    nSeg=nNodes,
    flowConf=Choices.FlowConfiguration.CrossCurrent,
    m_flow_nominal_abs=m_flow_nominal_abs,
    m_flow_nominal_air=m_flow_nominal_air,
    dp_nominal_abs=dp_nominal_abs,
    dp_nominal_air=dp_nominal_air,
    T_start_abs=T_abs,
    T_start_air=T_air,
    X_start_abs=X_abs,
    X_start_air=X_air,
    m_flow_start_abs=m_flow_abs,
    m_flow_start_air=m_flow_air,
    T_start_cool=T_cool,
    X_start_cool=X_cool,
    m_flow_start_cool=m_flow_cool,
    m_flow_nominal_cool=m_flow_nominal_cool,
    dp_nominal_cool=dp_nominal_cool,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    coolingLength=coolingLength,
    flowConfCool=Choices.FlowConfigurationCooling.CounterCurrent,
    redeclare Data.Chen_2016 data,
    mSeg=mNodes,
    redeclare model ThermalAir =
        HeatTransfer.Convection.Absorption.RandomPackings_ChenZhangYin,
    redeclare model MoistureAir =
        MoistureTransfer.Convection.Absorption.RandomPackings_ChenZhangYin)
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));

  BrineGrid.Fluid.Sources.MassFlowSource_T sou_air(
    redeclare package Medium = Medium_a,
    m_flow=m_flow_air,
    T=T_air,
    X=X_air,
    nPorts=1) annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  BrineGrid.Fluid.Sources.MassFlowSource_T sou_abs(
    redeclare package Medium = Medium_b,
    m_flow=m_flow_abs,
    T=T_abs,
    X=X_abs,
    nPorts=1) annotation (Placement(transformation(extent={{60,40},{40,60}})));
  BrineGrid.Fluid.Sources.FixedBoundary sin_air(redeclare package Medium =
        Medium_a, nPorts=1)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  BrineGrid.Fluid.Sources.FixedBoundary sin_abs(redeclare package Medium =
        Medium_b, nPorts=1)
    annotation (Placement(transformation(extent={{60,-60},{40,-40}})));
  BrineGrid.Fluid.Sources.MassFlowSource_T sou_cool(
    redeclare package Medium = Medium_c,
    m_flow=m_flow_cool,
    T=T_cool,
    X=X_cool,
    nPorts=1) annotation (Placement(transformation(extent={{80,-22},{60,-2}})));
  BrineGrid.Fluid.Sources.FixedBoundary sin_cool(
    redeclare package Medium = Medium_c,
    nPorts=1,
    p=p) annotation (Placement(transformation(extent={{-80,-6},{-60,14}})));
equation
  connect(sou_air.ports[1], cooAbs.port_a_in)
    annotation (Line(points={{-40,50},{-12,50},{-12,20}}, color={0,127,255}));
  connect(sin_air.ports[1], cooAbs.port_a_out) annotation (Line(points={{-40,-50},
          {-28,-50},{-12,-50},{-12,-20}}, color={0,127,255}));
  connect(sin_abs.ports[1],cooAbs.port_b_out)  annotation (Line(points={{40,-50},
          {32,-50},{12,-50},{12,-20}}, color={0,127,255}));
  connect(cooAbs.port_b_in, sou_abs.ports[1]) annotation (Line(points={{12,20},{
          12,20},{12,46},{12,50},{40,50}}, color={0,127,255}));
  connect(cooAbs.port_c_in, sou_cool.ports[1])
    annotation (Line(points={{20,-12},{60,-12}},    color={0,127,255}));
  connect(sin_cool.ports[1], cooAbs.port_c_out)
    annotation (Line(points={{-60,4},{-20,4}},         color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=3600),
    __Dymola_experimentSetupOutput,
    Documentation(revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end Test_Cooled;
