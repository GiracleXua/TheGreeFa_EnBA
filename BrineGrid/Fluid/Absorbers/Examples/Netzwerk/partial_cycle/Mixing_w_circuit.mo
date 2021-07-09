within BrineGrid.Fluid.Absorbers.Examples.Netzwerk.partial_cycle;
model Mixing_w_circuit

  extends Modelica.Icons.Example;

  import SI = Modelica.SIunits;
  replaceable package Medium_b =
      BrineGrid.Media.Water;
      //BrineGrid.Media.LiquidDesiccants.LithiumBromideAqueousSolution_PatekKlomfar;
      //BrineGrid.Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution;

  //---- volumen----//
  parameter SI.Temperature T_vol_start = 293.15;
  //parameter Real xi_vol_input = 0.3;
  //parameter SI.MassFraction[2] xi_vol_start = {1-xi_vol_input, xi_vol_input};
  parameter SI.Volume V_vol = 3;

  //---inflow---//
  parameter SI.Temperature T_inflow = 313.15;
  //parameter Real xi_inflow_input = 0.2;
  //parameter SI.MassFraction[2] xi_inflow_start = {1-xi_inflow_input, xi_inflow_input};
  parameter SI.MassFlowRate m_inflow_start = 100;
  parameter SI.MassFlowRate m_flow_nominal = 300;

  MixingVolumes.MixingVolume DesContainer(
    redeclare package Medium = Medium_b,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p_start=Medium_b.reference_p,
    T_start=T_vol_start,
    use_C_flow=false,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=true,
    V=V_vol,
    nPorts=3) annotation (Placement(transformation(extent={{-6,56},{14,76}})));
  Movers.FlowControlled_m_flow BrinePump(
    redeclare package Medium = Medium_b,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    p_start=Medium_b.reference_p,
    T_start=T_vol_start,
    allowFlowReversal=true,
    m_flow_nominal=m_flow_nominal,
    inputType=BrineGrid.Fluid.Types.InputType.Constant,
    constantMassFlowRate=m_inflow_start)
    annotation (Placement(transformation(extent={{4,-64},{30,-38}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort T_container_in(
    redeclare package Medium = Medium_b,
    m_flow_nominal=m_flow_nominal,
    T_start=T_vol_start) "Outlet temperature of the heater"
    annotation (Placement(transformation(extent={{54,-60},{70,-42}})));
  Buildings.Fluid.HeatExchangers.Heater_T
           hea(
    redeclare package Medium = Medium_b,
    m_flow_nominal=m_flow_nominal,
    show_T=true,
    dp_nominal=1000,
    linearizeFlowResistance=true,
    T_start=T_inflow,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
                                                             "Heater"
    annotation (Placement(transformation(extent={{-58,-62},{-36,-40}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort T_Container_out(
    redeclare package Medium = Medium_b,
    m_flow_nominal=m_flow_nominal,
    T_start=T_vol_start) "Outlet temperature of the heater" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-80,-2})));
  Modelica.Blocks.Sources.RealExpression Temp_set(y=313.15)
    annotation (Placement(transformation(extent={{-44,-32},{-58,-18}})));
  Sources.FixedBoundary                 sin_abs(          redeclare package
      Medium = Medium_b, nPorts=1)
    annotation (Placement(transformation(extent={{72,22},{54,40}})));
  Sources.MassFlowSource_T boundary(
  redeclare package Medium = Medium_b,
    m_flow=m_inflow_start,
    T(displayUnit="K") = 333.15,
  nPorts = 1) annotation (Placement(transformation(extent={{-2,-22},{18,-2}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort T_after_heater(
    redeclare package Medium = Medium_b,
    m_flow_nominal=m_flow_nominal,
    T_start=T_vol_start) "Outlet temperature of the heater"
    annotation (Placement(transformation(extent={{-26,-60},{-10,-42}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort T_container_in1(
    redeclare package Medium = Medium_b,
    m_flow_nominal=m_flow_nominal,
    T_start=T_vol_start) "Outlet temperature of the heater"
    annotation (Placement(transformation(extent={{12,20},{32,42}})));
equation
  connect(hea.port_a,T_Container_out. port_a) annotation (Line(points={{-58,-51},
          {-80,-51},{-80,-12}}, color={0,127,255}));
  connect(T_Container_out.port_b,DesContainer. ports[1])
    annotation (Line(points={{-80,8},{-80,56},{1.33333,56}},
                                                        color={0,127,255}));
  connect(BrinePump.port_b,T_container_in. port_a) annotation (Line(points={{30,-51},
          {54,-51}},                        color={0,127,255}));
  connect(T_container_in.port_b,DesContainer. ports[2]) annotation (Line(points={{70,-51},
          {80,-51},{80,56},{4,56}},          color={0,127,255}));
  connect(boundary.ports[1], T_container_in.port_a) annotation (Line(points={{18,-12},
          {42,-12},{42,-51},{54,-51}},      color={0,127,255}));
  connect(hea.port_b, T_after_heater.port_a)
    annotation (Line(points={{-36,-51},{-26,-51}}, color={0,127,255}));
  connect(T_after_heater.port_b, BrinePump.port_a) annotation (Line(points={{
          -10,-51},{-4,-51},{-4,-51},{4,-51}}, color={0,127,255}));
  connect(T_container_in1.port_b, sin_abs.ports[1])
    annotation (Line(points={{32,31},{54,31}}, color={0,127,255}));
  connect(T_container_in1.port_a, DesContainer.ports[3]) annotation (Line(
        points={{12,31},{6.66667,31},{6.66667,56}}, color={0,127,255}));
  connect(Temp_set.y, hea.TSet) annotation (Line(points={{-58.7,-25},{-78,-25},
          {-78,-42.2},{-60.2,-42.2}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Mixing_w_circuit;
