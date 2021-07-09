within BrineGrid.Fluid.Absorbers.Examples.Netzwerk.partial_cycle;
model Mixing_Des_Open

  extends Modelica.Icons.Example;

  import SI = Modelica.SIunits;
  replaceable package Medium_b =
      BrineGrid.Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution;

  //---- volumen----//
  parameter SI.Temperature T_vol_start = 293.15;
  parameter Real xi_vol_input = 0.3;
  parameter SI.MassFraction[2] xi_vol_start = {1-xi_vol_input, xi_vol_input};
  parameter SI.Volume V_vol = 3;

  //---inflow---//
  parameter SI.Temperature T_inflow = 313.15;
  parameter Real xi_inflow_input = 0.2;
  parameter SI.MassFraction[2] xi_inflow_start = {1-xi_inflow_input, xi_inflow_input};
  parameter SI.MassFlowRate m_inflow_start = 500;

  MixingVolumes.MixingVolumeAbsorption DesContainer(
    redeclare package Medium = Medium_b,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p_start=Medium_b.reference_p,
    T_start=T_vol_start,
    X_start=xi_vol_start,
    use_C_flow=false,
    m_flow_nominal=m_inflow_start,
    allowFlowReversal=true,
    V=V_vol,
    nPorts=2) annotation (Placement(transformation(extent={{-10,16},{10,36}})));
  Sources.MassFlowSource_T                 sou_abs(
    final m_flow=m_inflow_start,
    final T=T_inflow,
    final X=xi_inflow_start,
    final nPorts=1,
    redeclare package Medium = Medium_b)
    annotation (Placement(transformation(extent={{-66,-20},{-46,0}})));
  Sources.FixedBoundary                 sin_abs(
      nPorts=1, redeclare package Medium = Medium_b)
    annotation (Placement(transformation(extent={{62,-20},{42,0}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=293.15)
    annotation (Placement(transformation(extent={{-52,20},{-32,40}})));
equation
  connect(sou_abs.ports[1], DesContainer.ports[1])
    annotation (Line(points={{-46,-10},{-2,-10},{-2,16}}, color={0,127,255}));
  connect(sin_abs.ports[1], DesContainer.ports[2])
    annotation (Line(points={{42,-10},{2,-10},{2,16}}, color={0,127,255}));
  connect(realExpression.y, DesContainer.TWat) annotation (Line(points={{-31,30},
          {-22,30},{-22,30.8},{-12,30.8}}, color={0,0,127}));
  annotation (experiment(StopTime=500, __Dymola_Algorithm="Dassl"));
end Mixing_Des_Open;
