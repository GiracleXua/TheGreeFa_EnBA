within BrineGrid.Fluid.Absorbers.Examples.Netzwerk.partial_cycle;
model Des_heater
  extends Modelica.Icons.Example;

  package Medium_w =
      Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution;

  parameter Modelica.SIunits.Volume V=2;

  parameter Modelica.SIunits.PressureDifference dp_nominal = 1000;

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 5;

  parameter Modelica.SIunits.Temperature T_w_0 = 293.15;

  parameter Modelica.SIunits.MassFraction X_s=0.23
    "Mass fraction of desiccant";
  final parameter Modelica.SIunits.MassFraction[Medium_w.nX] X_abs={1 - X_s, X_s}
    "Composition of aqueous solution";

  parameter Real[2] sim_config = {3, 2};

  Movers.FlowControlled_m_flow BrinePump(
    redeclare package Medium = Medium_w,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    p_start=Medium_w.reference_p,
    T_start=T_w_0,
    X_start=X_abs,
    m_flow_nominal=m_flow_nominal,
    inputType=BrineGrid.Fluid.Types.InputType.Continuous,
    constantMassFlowRate=m_flow_nominal)
    annotation (Placement(transformation(extent={{-10,-38},{16,-12}})));
  MixingVolumes.MixingVolumeAbsorption DesContainer(
    redeclare package Medium = Medium_w,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p_start=Medium_w.reference_p,
    T_start=T_w_0,
    X_start=X_abs,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=true,
    V=V,
    nPorts=2) annotation (Placement(transformation(extent={{-8,60},{12,80}})));

  Modelica.Blocks.Sources.RealExpression realExpression(y=T_w_0)
    annotation (Placement(transformation(extent={{-56,58},{-36,78}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort THeaOut(
    redeclare package Medium = Medium_w,
    m_flow_nominal=m_flow_nominal,
    T_start=T_w_0)  "Outlet temperature of the heater"
    annotation (Placement(transformation(extent={{40,-36},{60,-16}})));
  Buildings.Fluid.HeatExchangers.Heater_T
           hea(
    redeclare package Medium = Medium_w,
    m_flow_nominal=m_flow_nominal,
    show_T=true,
    dp_nominal=1000,
    linearizeFlowResistance=true,
    T_start=T_w_0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    QMax_flow=50000)          "Heater"
    annotation (Placement(transformation(extent={{-48,-34},{-28,-14}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=303.15)
    annotation (Placement(transformation(extent={{-32,-4},{-46,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort THeaOut1(
    redeclare package Medium = Medium_w,
    m_flow_nominal=m_flow_nominal,
    T_start=T_w_0)  "Outlet temperature of the heater"
    annotation (Placement(transformation(extent={{-8,8},{8,-8}},
        rotation=90,
        origin={-80,22})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=1)
    annotation (Placement(transformation(extent={{26,2},{12,16}})));
equation
  connect(realExpression.y,DesContainer. TWat)
    annotation (Line(points={{-35,68},{-30,68},{-30,74.8},{-10,74.8}}, color={0,0,127}));
  connect(BrinePump.port_b, THeaOut.port_a) annotation (Line(points={{16,-25},{24,
          -25},{24,-26},{40,-26}}, color={0,127,255}));
  connect(THeaOut.port_b, DesContainer.ports[1]) annotation (Line(points={{60,-26},
          {82,-26},{82,60},{0,60}}, color={0,127,255}));
  connect(hea.port_b, BrinePump.port_a) annotation (Line(points={{-28,-24},{-10,
          -24},{-10,-25}}, color={0,127,255}));
  connect(hea.port_a, THeaOut1.port_a) annotation (Line(points={{-48,-24},{-80,-24},
          {-80,14}}, color={0,127,255}));
  connect(THeaOut1.port_b, DesContainer.ports[2]) annotation (Line(points={{-80,30},
          {-80,60},{4,60}},           color={0,127,255}));
  connect(realExpression1.y, hea.TSet) annotation (Line(points={{-46.7,3},{-60,3},
          {-60,-16},{-50,-16}}, color={0,0,127}));
  connect(realExpression2.y, BrinePump.m_flow_in) annotation (Line(points={{11.3,
          9},{2,9},{2,-9.4},{2.74,-9.4}}, color={0,0,127}));
  annotation (experiment(
      StopTime=6000,
      __Dymola_NumberOfIntervals=1000,
      __Dymola_Algorithm="Dassl"));
end Des_heater;
