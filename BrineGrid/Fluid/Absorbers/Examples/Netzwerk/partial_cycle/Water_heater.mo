within BrineGrid.Fluid.Absorbers.Examples.Netzwerk.partial_cycle;
model Water_heater

  extends Modelica.Icons.Example;
  package Medium_w = Buildings.Media.Water;
  //Buildings.Media.Water;
  //Modelica.Media.Water.StandardWater;

  String model_description = "M1.2 + B1.1";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 5;

  parameter Modelica.SIunits.Temperature T_w_0 = 293.15;

  parameter Modelica.SIunits.Volume V = 2;

  Modelica.Blocks.Sources.RealExpression realExpression(y=1)
    annotation (Placement(transformation(extent={{-46,-8},{-26,12}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol1(
    V=V,
    redeclare package Medium = Medium_w,
    T_start=T_w_0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal,
    mSenFac=2,
    nPorts=2)
         annotation (Placement(transformation(extent={{-10,64},{10,84}})));
  Buildings.Fluid.HeatExchangers.Heater_T
           hea(
    redeclare package Medium = Buildings.Media.Water,
    m_flow_nominal=m_flow_nominal,
    show_T=true,
    dp_nominal=1000,
    linearizeFlowResistance=true,
    T_start=T_w_0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    QMax_flow=50000)          "Heater"
    annotation (Placement(transformation(extent={{-84,-48},{-64,-28}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=303.15)
    annotation (Placement(transformation(extent={{-122,-10},{-102,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort THeaOut(
    redeclare package Medium = Medium_w,
    m_flow_nominal=m_flow_nominal,
    T_start=T_w_0)  "Outlet temperature of the heater"
    annotation (Placement(transformation(extent={{56,-48},{76,-28}})));
  Movers.FlowControlled_m_flow fan(
    redeclare package Medium = Medium_w,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=T_w_0,
    m_flow_nominal=m_flow_nominal,
    inputType=BrineGrid.Fluid.Types.InputType.Continuous,
    addPowerToMedium=false)
    annotation (Placement(transformation(extent={{-12,-50},{12,-26}})));
  Buildings.Fluid.FixedResistances.PressureDrop res3(
    redeclare package Medium = Medium_w,
    m_flow_nominal=m_flow_nominal,
    show_T=true,
    dp_nominal=100,
    linearized=true) "Flow resistance to decouple pressure state from boundary"
    annotation (Placement(transformation(extent={{48,28},{68,48}})));
  Buildings.Fluid.Sources.Boundary_pT bou3(
    redeclare package Medium = Medium_w,
    T=T_w_0,
    nPorts=1)
    "Fixed pressure boundary condition, required to set a reference pressure"
    annotation (Placement(transformation(extent={{98,28},{78,48}})));
equation
  connect(realExpression1.y, hea.TSet)
    annotation (Line(points={{-101,0},{-94,0},{-94,-30},{-86,-30}}, color={0,0,127}));
  connect(fan.port_b, THeaOut.port_a)
    annotation (Line(points={{12,-38},{56,-38}}, color={0,127,255}));
  connect(realExpression.y, fan.m_flow_in) annotation (Line(points={{-25,2},{0,
          2},{0,-2},{-0.24,-2},{-0.24,-23.6}},
                                            color={0,0,127}));
  connect(hea.port_a, vol1.ports[1]) annotation (Line(points={{-84,-38},{-126,
          -38},{-126,64},{-2,64}}, color={0,127,255}));
  connect(THeaOut.port_b, vol1.ports[2]) annotation (Line(points={{76,-38},{130,
          -38},{130,64},{2,64}}, color={0,127,255}));
  connect(hea.port_b, fan.port_a)
    annotation (Line(points={{-64,-38},{-12,-38}}, color={0,127,255}));
  connect(res3.port_b,bou3. ports[1])
    annotation (Line(points={{68,38},{78,38}}, color={0,127,255}));
  connect(res3.port_a, vol1.ports[3])
    annotation (Line(points={{48,38},{0,38},{0,64}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{140,100}})),
                                                                 Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-140,-100},{140,100}})),
    experiment(
      StopTime=1000,
      __Dymola_NumberOfIntervals=1000,
      __Dymola_Algorithm="Dassl"));
end Water_heater;
