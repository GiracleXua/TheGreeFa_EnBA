within BrineGrid.Fluid.Absorbers.Examples.Netzwerk.partial_cycle;
model Mixing_Des_circuit

  extends Modelica.Icons.Example;

  import SI = Modelica.SIunits;
  replaceable package Medium_b =
      BrineGrid.Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution;
      //BrineGrid.Media.LiquidDesiccants.LithiumBromideAqueousSolution_PatekKlomfar;
      //BrineGrid.Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution;

  //---- volumen----//
  parameter SI.Temperature T_vol_start = 293.15;
  parameter Real xi_vol_input = 0.3;
  parameter SI.MassFraction[2] xi_vol_start = {1-xi_vol_input, xi_vol_input};
  parameter SI.Volume V_vol = 3;

  //---inflow---//
  parameter SI.Temperature T_inflow = 313.15;
  parameter Real xi_inflow_input = 0.3;
  parameter SI.MassFraction[2] xi_inflow_start = {1-xi_inflow_input, xi_inflow_input};
  parameter SI.MassFlowRate m_inflow_start = 250;
  parameter SI.MassFlowRate m_flow_nominal = 100;
  parameter String solvent = "magnesium chloride";

  MixingVolumes.MixingVolumeAbsorption DesContainer(
    redeclare package Medium = Medium_b,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p_start=Medium_b.reference_p,
    T_start=T_vol_start,
    X_start=xi_vol_start,
    use_C_flow=false,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=true,
    V=V_vol,
    nPorts=3) annotation (Placement(transformation(extent={{-10,52},{10,72}})));

  Movers.FlowControlled_m_flow BrinePump(
    redeclare package Medium = Medium_b,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    p_start=Medium_b.reference_p,
    T_start=T_vol_start,
    X_start=xi_vol_start,
    allowFlowReversal=true,
    m_flow_nominal=m_flow_nominal,
    inputType=BrineGrid.Fluid.Types.InputType.Constant,
    constantMassFlowRate=m_inflow_start)
    annotation (Placement(transformation(extent={{-10,-96},{14,-72}})));
  Sources.MassFlowSource_T                 sou_abs(
    final m_flow=m_inflow_start,
    final T(displayUnit="K") = T_inflow,
    final X=xi_inflow_start,
    redeclare package Medium = Medium_b,
    nPorts=1)
    annotation (Placement(transformation(extent={{-6,-30},{14,-10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort T_container_in(
    redeclare package Medium = Medium_b,
    m_flow_nominal=m_flow_nominal,
    T_start=T_vol_start)  "Outlet temperature of the heater"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={100,-16})));
  Buildings.Fluid.HeatExchangers.Heater_T
           hea(
    redeclare package Medium = Medium_b,
    m_flow_nominal=m_flow_nominal,
    show_T=true,
    dp_nominal=1000,
    linearizeFlowResistance=true,
    T_start=T_vol_start,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    QMax_flow=50000)          "Heater"
    annotation (Placement(transformation(extent={{-48,-94},{-28,-74}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort T_Container_out(
    redeclare package Medium = Medium_b,
    m_flow_nominal=m_flow_nominal,
    T_start=T_vol_start) "Outlet temperature of the heater" annotation (Placement(
        transformation(
        extent={{-8,8},{8,-8}},
        rotation=90,
        origin={-82,-8})));

  Modelica.Blocks.Sources.RealExpression Temp_w(y=293.15)
    annotation (Placement(transformation(extent={{-54,60},{-34,80}})));

  Modelica.Blocks.Sources.RealExpression Temp_set(y=T_inflow)
    annotation (Placement(transformation(extent={{-24,-30},{-50,-10}})));

  Sources.FixedBoundary                 sin_abs(          redeclare package
      Medium = Medium_b, nPorts=1)
    annotation (Placement(transformation(extent={{46,10},{26,30}})));
  Sensors.MassFractionTwoPort conc_container_in(
    redeclare final package Medium = Medium_b,
    m_flow_nominal=m_flow_nominal,
    initType=Modelica.Blocks.Types.Init.SteadyState,
    substanceName=solvent,
    X_start=xi_vol_input)                       annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={100,32})));
  Sensors.MassFractionTwoPort conc_container_out(
    redeclare final package Medium = Medium_b,
    m_flow_nominal=m_flow_nominal,
    initType=Modelica.Blocks.Types.Init.SteadyState,
    substanceName=solvent,
    X_start=xi_vol_input)                       annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-82,28})));
  Sensors.MassFractionTwoPort conc_source(
    redeclare final package Medium = Medium_b,
    m_flow_nominal=m_flow_nominal,
    initType=Modelica.Blocks.Types.Init.SteadyState,
    substanceName=solvent,
    X_start=xi_vol_input) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={40,-20})));
equation
  connect(Temp_w.y, DesContainer.TWat) annotation (Line(points={{-33,70},
          {-26,70},{-26,66.8},{-12,66.8}}, color={0,0,127}));
  connect(hea.port_b,BrinePump. port_a) annotation (Line(points={{-28,-84},{-10,
          -84}},           color={0,127,255}));
  connect(hea.port_a, T_Container_out.port_a) annotation (Line(points={{-48,-84},
          {-82,-84},{-82,-16}}, color={0,127,255}));
  connect(Temp_set.y, hea.TSet) annotation (Line(points={{-51.3,-20},{-60,-20},
          {-60,-76},{-50,-76}},color={0,0,127}));

  connect(BrinePump.port_b, T_container_in.port_a)
    annotation (Line(points={{14,-84},{100,-84},{100,-26}},
                                                          color={0,127,255}));
  connect(T_container_in.port_b, conc_container_in.port_a)
    annotation (Line(points={{100,-6},{100,22}}, color={0,127,255}));
  connect(DesContainer.ports[1], conc_container_in.port_b) annotation (Line(
        points={{-2.66667,52},{100,52},{100,42}},    color={0,127,255}));
  connect(T_Container_out.port_b, conc_container_out.port_a)
    annotation (Line(points={{-82,0},{-82,18}}, color={0,127,255}));
  connect(conc_container_out.port_b, DesContainer.ports[2]) annotation (Line(
        points={{-82,38},{-82,52},{2.22045e-16,52}}, color={0,127,255}));
  connect(sin_abs.ports[1], DesContainer.ports[3]) annotation (Line(points={{26,20},
          {2.66667,20},{2.66667,52}},                     color={0,127,255}));
  connect(sou_abs.ports[1], conc_source.port_b)
    annotation (Line(points={{14,-20},{30,-20}}, color={0,127,255}));
  connect(conc_source.port_a, T_container_in.port_a) annotation (Line(points={{50,-20},
          {58,-20},{58,-84},{100,-84},{100,-26}},      color={0,127,255}));
  annotation (experiment(
      StopTime=500,
      Interval=1,
      __Dymola_Algorithm="Dassl"),
              Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},
            {160,140}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},{160,140}})));
end Mixing_Des_circuit;
